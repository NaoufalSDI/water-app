import 'dart:ui';
import 'package:flutter/material.dart';

class CustomGlassContainer extends StatelessWidget {
  final Widget child;
  final BorderRadius borderRadius;
  final EdgeInsetsGeometry? padding;

  const CustomGlassContainer({
    super.key,
    required this.child,
    this.borderRadius = BorderRadius.zero,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ClipRRect(
      borderRadius: borderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            color:
                isDark
                    ? const Color.fromARGB(255, 153, 153, 153).withOpacity(0.1)
                    : Colors.black.withOpacity(0.05),
            border: Border.all(
              color:
                  isDark
                      ? Colors.white.withOpacity(0.1)
                      : const Color.fromARGB(124, 0, 0, 0).withOpacity(0.05),
            ),
            boxShadow: [
              BoxShadow(
                color:
                    isDark
                        ? Color.fromARGB(255, 57, 57, 57).withOpacity(0.3)
                        : Colors.grey.withOpacity(0.2),
                blurRadius: 20,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}
