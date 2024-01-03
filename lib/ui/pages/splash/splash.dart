import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/route_manager.dart';
import 'package:capital_tours_mobile/widgets/colors.dart';
import 'package:localstore/localstore.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () => validationLogin(context));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryAppColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 50),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: Image.asset(
                "assets/images/logo.png",
                width: 100,
              ),
            ),
            const SpinKitChasingDots(
              color: Colors.white,
              size: 25,
            ),
          ],
        ),
      ),
    );
  }
}

validationLogin(BuildContext context) async {
  var db = Localstore.instance;
  final dbStorage = await db.collection("session").doc("init").get();
  final idUser = dbStorage?["user"]["id_user"];

  if (idUser == null) {
    Get.offAllNamed('/login');
  } else {
    Get.offAllNamed('/home');
  }
}
