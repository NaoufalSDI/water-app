import 'dart:ui';
import 'package:get/get.dart';
import 'package:maaya/config/app_routes.dart';

class SplashController extends GetxController {
  Future<void> initSplash(VoidCallback onAnimationDone) async {
    await Future.delayed(const Duration(milliseconds: 2200));
    onAnimationDone();
    await Future.delayed(const Duration(milliseconds: 1200));
    Get.offNamed(Routes.HOME);
  }
}
