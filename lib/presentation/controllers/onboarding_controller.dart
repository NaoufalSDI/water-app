import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingController extends GetxController {
  var currentPage = 0.obs;

  Future<void> nextPageOrFinish() async {
    if (currentPage.value < 1) {
      currentPage.value++;
    } else {
      await setSeenOnboarding();
      Get.offAllNamed('/home');
    }
  }

  Future<void> skip() async {
    await setSeenOnboarding();
    Get.offAllNamed('/home');
  }

  Future<void> setSeenOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seenOnboarding', true);
  }
}
