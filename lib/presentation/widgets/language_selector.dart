import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:maaya/presentation/widgets/language_selector_bottom_sheet.dart';

class LanguageSelector extends StatelessWidget {
  const LanguageSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return IconButton(
      icon: SvgPicture.asset(
        'assets/images/local_icon.svg',
        height: 25,
        width: 25,
        color: isDark ? Colors.white : Colors.blueAccent,
      ),
      tooltip: 'Change Language',
      onPressed: () {
        showLanguageBottomSheet(context);
      },
    );
  }
}
