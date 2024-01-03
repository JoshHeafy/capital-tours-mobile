import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:capital_tours_mobile/widgets/colors.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryAppColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Image.asset(
                'assets/images/SolicitarViaje.png',
                width: 250,
              ),
              const Text(
                'Solicitar Conductores',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30, color: Colors.white),
              ),
              const Text(
                '¿Ya estas con un pasajero?\nSolicite al conductor más cercano con un solo click',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
              ),
              SizedBox(
                height: 40,
                width: 250,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                  ),
                  onPressed: () => Get.toNamed('/home'),
                  child: const Text('Continuar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
