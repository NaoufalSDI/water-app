import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maaya/core/services/locale_service.dart';

void showLanguageBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withOpacity(0.2),
    builder: (_) => const LanguageSelectorBottomSheet(),
  );
}

class LanguageSelectorBottomSheet extends StatelessWidget {
  const LanguageSelectorBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(30),
              ),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors:
                    isDark
                        ? [
                          Colors.black.withOpacity(0.6),
                          Colors.black.withOpacity(0.3),
                        ]
                        : [
                          Colors.white.withOpacity(0.6),
                          Colors.white.withOpacity(0.3),
                        ],
              ),
              border: Border.all(
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Handle
                Container(
                  width: 40,
                  height: 5,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white24 : Colors.black26,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                // Title
                Text(
                  'Choose Language',
                  style: textTheme.titleMedium?.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 24),
                // Languages
                _buildLanguageTile(
                  context,
                  locale: const Locale('en'),
                  label: 'English',
                  emoji: '🇺🇸',
                ),
                _buildLanguageTile(
                  context,
                  locale: const Locale('fr'),
                  label: 'Français',
                  emoji: '🇫🇷',
                ),
                _buildLanguageTile(
                  context,
                  locale: const Locale('ar'),
                  label: 'العربية',
                  emoji: '🇲🇦',
                ),
                _buildLanguageTile(
                  context,
                  locale: const Locale('es'),
                  label: 'Español',
                  emoji: '🇪🇸',
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageTile(
    BuildContext context, {
    required Locale locale,
    required String label,
    required String emoji,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
      leading: Text(emoji, style: const TextStyle(fontSize: 24)),
      title: Text(
        label,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          fontFamily: 'Nunito',
          color: isDark ? Colors.white70 : Colors.black87,
        ),
      ),
      onTap: () async {
        await LocaleService.saveLocale(locale);
        Get.updateLocale(locale);
        Navigator.of(context).pop();
      },
    );
  }
}
