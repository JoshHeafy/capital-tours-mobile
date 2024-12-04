import 'package:capital_tours_mobile/extensions/string.extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import 'package:localstore/localstore.dart';

import '../../../../widgets/colors.dart';

class Sidebar extends StatefulWidget {
  const Sidebar({super.key});

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  Map<String, dynamic> dataPropietario = {
    "email": "",
    "nombre_propietario": "",
  };
  Map<String, dynamic> dataUser = {
    "numero_placa": "",
  };

  created() async {
    var db = Localstore.instance;
    var result = await db.collection("session").doc("init").get();
    if (result != null) {
      setState(() {
        dataPropietario = result["propietario"];
        dataUser = result["user"];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    created();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: primaryAppColor,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Container(
              width: MediaQuery.of(context).size.width - 120,
              height: 100,
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: primaryAppColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Bienvenido(a)',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(Icons.account_circle, color: Colors.white),
                      Text(
                        dataPropietario["nombre_propietario"]
                            .toString()
                            .toCapitalize(),
                        style:
                            const TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            accountEmail: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Wrap(
                  alignment: WrapAlignment.start,
                  spacing: 10,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.email, color: Colors.white),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Text(
                            dataPropietario["email"].toString().toLowerCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 5),
                          child: Icon(Icons.directions_car_filled,
                              color: Colors.white),
                        ),
                        Padding(
                          padding: EdgeInsets.zero,
                          child: Text(
                            dataUser["numero_placa"].toString().toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            decoration: const BoxDecoration(
              color: primaryColor,
            ),
          ),
          // ListTile(
          //   leading: const Icon(Icons.settings, color: Colors.white),
          //   title: const Text('Configuración',
          //       style: TextStyle(color: Colors.white)),
          //   onTap: () => {},
          // ),
          // const Divider(color: Colors.grey),
          ListTile(
            leading: const Icon(Icons.exit_to_app, color: Colors.white),
            title: const Text('Cerrar sesión',
                style: TextStyle(color: Colors.white)),
            onTap: () {
              var db = Localstore.instance;
              Get.offAllNamed('/login');
              db.collection("session").delete();
            },
          ),
        ],
      ),
    );
  }
}
