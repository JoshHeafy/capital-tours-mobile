import 'dart:convert';

import 'package:capital_tours_mobile/extensions/string.extension.dart';
import 'package:capital_tours_mobile/library/calculate.distance.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:capital_tours_mobile/ui/pages/maps/models/marker.dart';
import 'package:localstore/localstore.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:web_socket_channel/io.dart';

import '../../../widgets/colors.dart';
import '../../../widgets/constants.dart';

class PageMap extends StatefulWidget {
  const PageMap({Key? key}) : super(key: key);

  @override
  State<PageMap> createState() => _PageMapState();
}

class _PageMapState extends State<PageMap> with TickerProviderStateMixin {
  final channel = IOWebSocketChannel.connect(
      'wss://websocket-chatbot.onrender.com/location');
  List<MapMarker> conductoresList = [];

  final pageController = PageController();
  int selectedIndex = 0;
  bool markReady = false;

  late final MapController mapController;
  LatLng point = const LatLng(-12.06513, -75.20486);
  LatLng currentPosition = const LatLng(0, 0);

  var location = [];

  initializeSocket() {
    channel.stream.listen(
      (message) async {
        if (message.toString().isNotEmpty) {
          List<dynamic> conductoresTmp = jsonDecode(message);
          if (conductoresTmp[0]["msg"] == null) {
            List<MapMarker> conductores = [];
            String numeroPlaca = "";
            var db = Localstore.instance;
            var sessionInit = await db.collection("session").doc("init").get();
            if (sessionInit != null) {
              numeroPlaca = sessionInit["user"]["numero_placa"];
            }

            for (var cond in conductoresTmp) {
              conductores.add(
                MapMarker(
                  idLocation: cond["id_location"],
                  image: "assets/images/person.jpeg",
                  driver: cond["nombre"],
                  location: LatLng(cond["latitud"], cond["longitud"]),
                  numeroFlota: cond["numero_flota"],
                  numeroPlaca: cond["numero_placa"],
                ),
              );
              if (numeroPlaca == cond["numero_placa"]) {
                setState(() {
                  markReady = true;
                });
              } else {
                setState(() {
                  markReady = false;
                });
              }
            }
            setState(() {
              conductoresList = conductores;
              point = conductoresList[0].location!;
            });
            Fluttertoast.showToast(
              msg: "Se registraron ${conductores.length} PINGS",
              backgroundColor: greencolor,
              fontSize: 18,
              textColor: primaryAppColor,
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.TOP,
            );
          } else {
            Fluttertoast.showToast(
              msg: "No se encontraron PINGS",
              backgroundColor: primaryColor,
              fontSize: 18,
              textColor: primaryAppColor,
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.TOP,
            );

            setState(() {
              conductoresList = [];
            });
          }
        }
      },
      onError: (error) {
        Fluttertoast.showToast(
          msg: error,
          backgroundColor: greencolor,
          fontSize: 18,
          textColor: primaryAppColor,
          toastLength: Toast.LENGTH_LONG,
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    initializeSocket();
    mapController = MapController();
    _requestLocationPermission();
  }

  Future<void> _requestLocationPermission() async {
    final PermissionStatus status = await Permission.location.request();
    if (status == PermissionStatus.denied) {
      Fluttertoast.showToast(
        msg: 'Permission denied',
        backgroundColor: Colors.orange,
        textColor: Colors.white,
      );
    } else {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation,
      );
      double lat = double.parse(position.latitude.toStringAsFixed(6));
      double lon = double.parse(position.longitude.toStringAsFixed(6));

      setState(() {
        currentPosition = LatLng(lat, lon);
        mapController.move(currentPosition, mapController.zoom);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: primaryAppColor,
        title: const Text(
          'Pasajeros cercanos',
          style: TextStyle(color: secondarycolor),
        ),
        leading: IconButton(
          onPressed: () {
            channel.sink.close();
            Get.back();
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: secondarycolor,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await _requestLocationPermission();
              _animatedMapMove(currentPosition, mapController.zoom);
            },
            icon: const Icon(
              Icons.my_location,
              color: secondarycolor,
            ),
            tooltip: "Ver mi ubicación",
          )
        ],
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: mapController,
            options: MapOptions(
              minZoom: 5,
              maxZoom: 18,
              zoom: 16,
              center: currentPosition,
            ),
            children: [
              TileLayer(
                urlTemplate:
                    "https://api.mapbox.com/styles/v1/brayandevs/{mapStyleId}/tiles/256/{z}/{x}/{y}@2x?access_token={accessToken}",
                additionalOptions: const {
                  'mapStyleId': AppConstants.mapBoxStyleId,
                  'accessToken': AppConstants.mapBoxAccessToken,
                },
              ),
              MarkerLayer(
                markers: [
                  for (int i = 0; i < conductoresList.length; i++)
                    Marker(
                      height: 40,
                      width: 40,
                      point: conductoresList[i].location!,
                      builder: (_) {
                        return GestureDetector(
                          onTap: () {
                            pickUpPassenger(conductoresList[i]);
                            print(point);
                            pageController.animateToPage(
                              i,
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeInOut,
                            );
                            selectedIndex = i;
                            _animatedMapMove(
                              conductoresList[i].location!,
                              mapController.zoom,
                            ); // Cambio aquí
                            setState(() {});
                          },
                          child: AnimatedScale(
                            duration: const Duration(milliseconds: 500),
                            scale: selectedIndex == i ? 1 : 0.7,
                            child: AnimatedOpacity(
                              duration: const Duration(milliseconds: 500),
                              opacity: selectedIndex == i ? 1 : 0.5,
                              child: SvgPicture.asset(
                                'assets/icons/map-marker.svg',
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  Marker(
                    point: currentPosition,
                    builder: (_) {
                      return GestureDetector(
                        onTap: () {
                          _animatedMapMove(
                            currentPosition,
                            mapController.zoom,
                          );
                          setState(() {});
                        },
                        child: AnimatedScale(
                          duration: const Duration(milliseconds: 500),
                          scale: 1.3,
                          child: AnimatedOpacity(
                            duration: const Duration(milliseconds: 500),
                            opacity: 1,
                            child: SvgPicture.asset(
                              'assets/icons/current-marker.svg',
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
          Visibility(
            visible: conductoresList.isNotEmpty,
            child: Positioned(
              left: 0,
              right: 0,
              bottom: 60,
              height: MediaQuery.of(context).size.height * 0.25,
              child: PageView.builder(
                controller: pageController,
                onPageChanged: (value) {
                  selectedIndex = value;
                  point = conductoresList[value].location!;
                  _animatedMapMove(point, 11.5);
                  setState(() {});
                },
                itemCount: conductoresList.length,
                itemBuilder: (_, index) {
                  final item = conductoresList[index];
                  return GestureDetector(
                    onTap: () {
                      _animatedMapMove(point, 11.5);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        color: const Color.fromARGB(255, 255, 255, 255),
                        child: Row(
                          children: [
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.only(
                                          right: 10,
                                        ),
                                        child: Text("Flota"),
                                      ),
                                      Container(
                                        width: 35,
                                        height: 35,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: primaryColor,
                                        ),
                                        child: Center(
                                          child: Text(
                                            item.numeroFlota.toString(),
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 24.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          item.driver.toString().toCapitalize(),
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        const SizedBox(height: 10),
                                        Text(
                                          item.numeroPlaca
                                              .toString()
                                              .toUpperCase(),
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.asset(
                                    item.image ?? '',
                                    width: 10,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Visibility(
            visible: markReady,
            child: FloatingActionButton(
              heroTag: "BtnCancelPing",
              backgroundColor: primaryColor,
              onPressed: () => cancelPing(),
              child: const Icon(
                Icons.location_off,
                color: secondarycolor,
              ),
            ),
          ),
          const SizedBox(width: 10),
          FloatingActionButton(
            heroTag: "BtnGeneratePing",
            backgroundColor: primaryColor,
            onPressed: () => generatePing(),
            child: const Icon(
              Icons.location_on,
              color: secondarycolor,
            ),
          ),
        ],
      ),
    );
  }

  generatePing() {
    Get.defaultDialog(
      title: "¿Solicitar a un conductor?",
      content: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton.icon(
                onPressed: () async {
                  var db = Localstore.instance;
                  var sessionInit =
                      await db.collection("session").doc("init").get();

                  Map<String, dynamic> propietario =
                      sessionInit?["propietario"];
                  Map<String, dynamic> user = sessionInit?["user"];

                  for (var cond in conductoresList) {
                    if (cond.numeroPlaca == user["numero_placa"]) {
                      Fluttertoast.showToast(
                        msg: "Ya haz generado un ping",
                        backgroundColor: warningColor,
                        textColor: primaryAppColor,
                      );
                      Get.back();
                      return;
                    }
                  }

                  Map<String, dynamic> dataPing = {
                    "typeSend": "insert",
                    "data": {
                      "nombre": propietario["nombre_propietario"].toString(),
                      "latitud": currentPosition.latitude,
                      "longitud": currentPosition.longitude,
                      "numero_placa": user["numero_placa"],
                      "numero_flota": user["numero_flota"],
                    },
                  };
                  channel.sink.add(jsonEncode(dataPing));
                  setState(() {
                    markReady = true;
                  });
                  Get.back();
                },
                style: TextButton.styleFrom(
                  backgroundColor: primaryColor,
                ),
                icon: const Icon(Icons.check_circle, color: lightColor),
                label: const Text("SI", style: TextStyle(color: lightColor)),
              ),
              TextButton.icon(
                onPressed: () => Get.back(),
                style: TextButton.styleFrom(
                  backgroundColor: primaryAppColor,
                ),
                icon: const Icon(Icons.close, color: lightColor),
                label: const Text("NO", style: TextStyle(color: lightColor)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  pickUpPassenger(MapMarker dataConductor) {
    _requestLocationPermission();
    double lat1 = currentPosition.latitude;
    double lon1 = currentPosition.longitude;
    double lat2 = dataConductor.location!.latitude;
    double lon2 = dataConductor.location!.longitude;
    double distance = LocationUtils.calculateDistance(lat1, lon1, lat2, lon2);

    if (distance > 500) {
      Fluttertoast.showToast(
        msg: 'Estas muy lejos del pasajero',
        backgroundColor: Colors.orange,
        textColor: Colors.white,
      );
    } else {
      Get.defaultDialog(
        title: "¿Desea recoger a este pasajero?",
        content: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton.icon(
                  onPressed: () {
                    if (dataConductor.idLocation!.isNotEmpty) {
                      Map<String, dynamic> dataSend = {
                        "typeSend": "delete",
                        "data": {
                          "id_location": dataConductor.idLocation,
                        },
                      };
                      channel.sink.add(jsonEncode(dataSend));
                      pageController.jumpTo(conductoresList.length - 1);
                      Get.back();
                    } else {
                      Fluttertoast.showToast(
                        msg: "Ocurrio un error al obtener el ping",
                        backgroundColor: warningColor,
                        textColor: primaryAppColor,
                      );
                    }
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: primaryColor,
                  ),
                  icon: const Icon(Icons.check_circle, color: lightColor),
                  label: const Text("SI", style: TextStyle(color: lightColor)),
                ),
                TextButton.icon(
                  onPressed: () => Get.back(),
                  style: TextButton.styleFrom(
                    backgroundColor: primaryAppColor,
                  ),
                  icon: const Icon(Icons.close, color: lightColor),
                  label: const Text("NO", style: TextStyle(color: lightColor)),
                ),
              ],
            ),
          ],
        ),
      );
    }
  }

  cancelPing() {
    Get.defaultDialog(
      title: "¿Cancelar PING?",
      content: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton.icon(
                onPressed: () async {
                  var db = Localstore.instance;
                  var sessionInit =
                      await db.collection("session").doc("init").get();
                  String numeroPlaca = sessionInit?["user"]["numero_placa"];
                  String idLocation = "";

                  for (var cond in conductoresList) {
                    if (cond.numeroPlaca == numeroPlaca) {
                      idLocation = cond.idLocation!;
                      Map<String, dynamic> dataSend = {
                        "typeSend": "delete",
                        "data": {
                          "id_location": idLocation,
                        },
                      };
                      channel.sink.add(jsonEncode(dataSend));
                      pageController.jumpTo(conductoresList.length - 1);
                      setState(() {
                        markReady = false;
                      });
                      Get.back();
                    }
                  }
                },
                style: TextButton.styleFrom(
                  backgroundColor: primaryColor,
                ),
                icon: const Icon(Icons.check_circle, color: lightColor),
                label: const Text("SI", style: TextStyle(color: lightColor)),
              ),
              TextButton.icon(
                onPressed: () => Get.back(),
                style: TextButton.styleFrom(
                  backgroundColor: primaryAppColor,
                ),
                icon: const Icon(Icons.close, color: lightColor),
                label: const Text("NO", style: TextStyle(color: lightColor)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _animatedMapMove(LatLng destLocation, double destZoom) {
    final latTween = Tween<double>(
        begin: mapController.center.latitude, end: destLocation.latitude);
    final lngTween = Tween<double>(
        begin: mapController.center.longitude, end: destLocation.longitude);

    // Solo animamos el centro del mapa, no el zoom.
    var controller = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    Animation<double> animation =
        CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);

    controller.addListener(() {
      mapController.move(
        LatLng(latTween.evaluate(animation), lngTween.evaluate(animation)),
        mapController.zoom, // Mantenemos el zoom constante
      );
    });

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.dispose();
      } else if (status == AnimationStatus.dismissed) {
        controller.dispose();
      }
    });

    controller.forward();
  }
}
