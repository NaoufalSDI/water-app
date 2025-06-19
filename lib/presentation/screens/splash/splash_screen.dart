import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter/services.dart';
import 'package:maaya/presentation/controllers/splash_controller.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final SplashController _controller = Get.put(SplashController());
  bool showText = false;

  @override
  void initState() {
    super.initState();
    _controller.initSplash(() {
      setState(() {
        showText = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Center(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          transitionBuilder:
              (child, animation) => FadeTransition(
                opacity: animation,
                child: ScaleTransition(scale: animation, child: child),
              ),
          child:
              showText
                  ? Text(
                    'maaya'.tr,
                    key: const ValueKey('text'),
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontSize: 35,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w900,
                      color: theme.primaryColor,
                      letterSpacing: 2,
                    ),
                  )
                  : Lottie.asset(
                    'assets/animations/splash_animation.json',
                    key: const ValueKey('animation'),
                    width: 200,
                    height: 200,
                    fit: BoxFit.contain,
                  ),
        ),
      ),
    );
  }
}
