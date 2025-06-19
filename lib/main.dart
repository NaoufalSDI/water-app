import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:maaya/config/app_pages.dart';
import 'package:maaya/config/app_routes.dart';
import 'package:get/get.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Maaya',
      initialRoute: Routes.SPLASH,
      getPages: AppPages.pages,
    );
  }
}
