import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maaya/core/services/locale_service.dart';

class LanguageSelector extends StatelessWidget {
  const LanguageSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return PopupMenuButton<Locale>(
      icon: const Icon(Icons.language, size: 30, color: Colors.blueAccent),
      color: theme.cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 8,
      offset: const Offset(0, 50),

      // ✅ تخزين وتغيير اللغة
      onSelected: (Locale locale) async {
        await LocaleService.saveLocale(locale);
        Get.updateLocale(locale);
      },

      itemBuilder:
          (BuildContext context) => <PopupMenuEntry<Locale>>[
            _buildLanguageItem(locale: const Locale('en'), label: 'En  🇺🇸'),
            _buildLanguageItem(locale: const Locale('fr'), label: 'Fr  🇫🇷'),
            _buildLanguageItem(locale: const Locale('ar'), label: 'Ar  🇲🇦'),
          ],
    );
  }

  PopupMenuItem<Locale> _buildLanguageItem({
    required Locale locale,
    required String label,
  }) {
    return PopupMenuItem<Locale>(
      value: locale,
      child: Center(
        child: Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
