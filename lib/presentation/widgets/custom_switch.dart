import 'package:flutter/material.dart';
import 'package:maaya/core/theme/app_colors.dart';

class CustomToggleSwitch extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const CustomToggleSwitch({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  State<CustomToggleSwitch> createState() => _CustomToggleSwitchState();
}

class _CustomToggleSwitchState extends State<CustomToggleSwitch>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _circleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
      value: widget.value ? 1 : 0,
    );

    _circleAnimation = Tween<double>(
      begin: 0,
      end: 24,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void didUpdateWidget(covariant CustomToggleSwitch oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  void _handleTap() {
    widget.onChanged(!widget.value);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: _handleTap,
      child: SizedBox(
        width: 50,
        height: 28,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: Color.lerp(
                  isDark ? Colors.grey[700] : Colors.grey[300],
                  isDark ? AppColors.primary : AppColors.primaryDark,
                  _controller.value,
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 3),
              child: Stack(
                children: [
                  Positioned(
                    left: _circleAnimation.value,
                    top: 2,
                    bottom: 2,
                    child: Container(
                      width: 22,
                      decoration: BoxDecoration(
                        color: isDark ? Colors.grey[200] : Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 3,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
