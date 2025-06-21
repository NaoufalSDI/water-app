import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:maaya/core/services/local_db_service.dart';
import 'package:maaya/core/theme/app_colors.dart';
import 'package:maaya/config/app_pages.dart';
import 'package:maaya/config/app_routes.dart';
import 'package:maaya/core/theme/app_themes.dart';
import 'package:maaya/config/app_translations.dart';
import 'package:maaya/core/services/locale_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final savedLocale = await LocaleService.getSavedLocale();
  await LocalDBService.init();
  runApp(MyApp(savedLocale: savedLocale));
}

class MyApp extends StatelessWidget {
  final Locale? savedLocale;
  const MyApp({super.key, this.savedLocale});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,

      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,

      translations: AppTranslations(),
      locale: savedLocale ?? const Locale('en'),
      fallbackLocale: const Locale('en'),

      initialRoute: Routes.SPLASH,
      getPages: AppPages.pages,

      builder: (context, child) {
        final brightness = MediaQuery.of(context).platformBrightness;
        final isDark = brightness == Brightness.dark;

        final Color navBarColor = isDark ? AppColors.grayDark : AppColors.white;

        SystemChrome.setSystemUIOverlayStyle(
          SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            systemNavigationBarColor: navBarColor,
            systemNavigationBarDividerColor: navBarColor,
            statusBarIconBrightness:
                isDark ? Brightness.light : Brightness.dark,
            systemNavigationBarIconBrightness:
                isDark ? Brightness.light : Brightness.dark,
            systemNavigationBarContrastEnforced: false,
          ),
        );

        return child!;
      },
    );
  }
}
