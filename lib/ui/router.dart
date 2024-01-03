import 'package:get/get.dart';
import 'package:capital_tours_mobile/ui/pages/home/home_page.dart';
import 'package:capital_tours_mobile/ui/pages/login/login_page.dart';
import 'package:capital_tours_mobile/ui/pages/passenger/passenger.dart';
import 'package:capital_tours_mobile/ui/pages/splash/splash.dart';
import 'package:capital_tours_mobile/ui/pages/welcome/welcome_page.dart';

class Routes {
  static List<GetPage<dynamic>>? get() {
    return [
      GetPage(name: '/', page: () => const SplashScreen()),
      GetPage(
        name: '/login',
        page: () => const LoginPage(),
        transition: Transition.fadeIn,
      ),
      GetPage(
        name: '/welcome',
        page: () => const WelcomePage(),
        transition: Transition.fadeIn,
      ),
      GetPage(
        name: '/home',
        page: () => const HomePage(),
        transition: Transition.fadeIn,
      ),
      // GetPage(name: '/home/history', page: () => const HistorialPage()),
      GetPage(name: '/home/pasajeros-map', page: () => const PasajerosMapPage())
    ];
  }
}
