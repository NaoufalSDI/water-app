import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:get/get.dart';
import 'package:maaya/core/services/local_db_service.dart';
import 'package:maaya/core/services/locale_service.dart';
import 'package:maaya/core/services/notification_service.dart';
import 'package:maaya/core/theme/app_colors.dart';
import 'package:maaya/config/app_pages.dart';
import 'package:maaya/config/app_routes.dart';
import 'package:maaya/core/theme/app_themes.dart';
import 'package:maaya/config/app_translations.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupTimezone();
  await LocalDBService.init();
  await NotificationService().initialize();

  // Handle locale
  final savedLocale = await LocaleService.getSavedLocale();
  final supportedLangs = AppTranslations().keys.keys.toSet();
  final deviceLocale = Get.deviceLocale;
  final deviceLangCode = deviceLocale?.languageCode;

  late Locale finalLocale;
  if (savedLocale != null) {
    finalLocale = savedLocale;
  } else if (deviceLangCode != null &&
      supportedLangs.contains(deviceLangCode)) {
    finalLocale = Locale(deviceLangCode);
  } else {
    finalLocale = const Locale('en');
  }

  runApp(MyApp(initialLocale: finalLocale));
}

Future<void> setupTimezone() async {
  tz.initializeTimeZones();
  final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
  tz.setLocalLocation(tz.getLocation(currentTimeZone));
}

class MyApp extends StatelessWidget {
  final Locale initialLocale;
  const MyApp({super.key, required this.initialLocale});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,

      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,

      translations: AppTranslations(),
      locale: initialLocale,
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
