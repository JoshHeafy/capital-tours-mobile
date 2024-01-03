import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:capital_tours_mobile/ui/router.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: '/',
      getPages: Routes.get(),
      debugShowCheckedModeBanner: false,
    );
  }
}
