import 'package:maaya/presentation/screens/home/home_screen.dart';
import 'package:maaya/presentation/screens/onboarding/onboarding_screen.dart';
import 'package:maaya/presentation/screens/splash/splash_screen.dart';
import 'package:get/get.dart';

import 'app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(name: Routes.SPLASH, page: () => const SplashScreen()),
    GetPage(name: Routes.HOME, page: () => const HomeScreen()),
    GetPage(name: Routes.ONBOARDING, page: () => const OnboardingScreen()),
  ];
}
