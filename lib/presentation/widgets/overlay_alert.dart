import 'package:flutter/material.dart';
import 'package:maaya/core/theme/app_colors.dart';

void showOverlayAlert({
  required BuildContext context,
  required String message,
  bool isError = false,
}) {
  final overlay = Overlay.of(context);
  final isDark = Theme.of(context).brightness == Brightness.dark;

  final entry = OverlayEntry(
    builder:
        (_) => Positioned(
          bottom: 50,
          left: 20,
          right: 20,
          child: _Alert(message: message, isError: isError, isDark: isDark),
        ),
  );

  overlay.insert(entry);

  Future.delayed(const Duration(seconds: 2), () {
    entry.remove();
  });
}

class _Alert extends StatefulWidget {
  final String message;
  final bool isError;
  final bool isDark;

  const _Alert({
    required this.message,
    required this.isError,
    required this.isDark,
  });

  @override
  State<_Alert> createState() => _AlertState();
}

class _AlertState extends State<_Alert> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..forward();

    _scale = CurvedAnimation(parent: _controller, curve: Curves.bounceOut);
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scale,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color:
              widget.isError
                  ? AppColors.error
                  : const Color.fromARGB(255, 76, 191, 44),
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 14,
              offset: Offset(0, 6),
            ),
          ],
        ),

        child: Row(
          children: [
            Icon(
              widget.isError
                  ? Icons.error_rounded
                  : Icons.emoji_emotions_rounded,
              color: Colors.white,
              size: 28,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.message,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      decoration: TextDecoration.none,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
