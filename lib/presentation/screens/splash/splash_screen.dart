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
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        systemNavigationBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
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
                  ? const Text(
                    'Maaya',
                    key: ValueKey('text'),
                    style: TextStyle(
                      fontSize: 30,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w800,
                      color: Colors.blueAccent,
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
