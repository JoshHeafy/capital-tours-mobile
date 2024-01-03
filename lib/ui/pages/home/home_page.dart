import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:capital_tours_mobile/widgets/colors.dart';

import '../login/widgets/sidebar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Sidebar(),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white, size: 30),
        backgroundColor: primaryAppColor,
        elevation: 0,
      ),
      backgroundColor: primaryAppColor,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Image.asset(
                  'assets/images/carLogo.png',
                  width: 300,
                ),
              ),
              Text(
                'Hola, ${obtenerSaludo()} encantado de conocerte!',
                style: const TextStyle(fontSize: 30, color: Colors.white),
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 70),
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryAppColor,
                    side: const BorderSide(
                      width: 2,
                      color: primaryColor,
                    ),
                  ),
                  onPressed: () => Get.toNamed('/home/pasajeros-map'),
                  icon: const Icon(
                    Icons.place,
                    color: primaryColor,
                  ),
                  label: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    child: Text(
                      'Ver pasajeros cercanos',
                      style: TextStyle(color: primaryColor, fontSize: 18),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //Funcion para obtener saludo
  String obtenerSaludo() {
    DateTime ahora = DateTime.now();
    int hora = ahora.hour;

    String saludo;

    if (hora >= 6 && hora < 12) {
      saludo = 'Buenos días!';
    } else if (hora >= 12 && hora < 18) {
      saludo = 'Buenas tardes!';
    } else {
      saludo = 'Buenas noches!';
    }

    return saludo;
  }
}
