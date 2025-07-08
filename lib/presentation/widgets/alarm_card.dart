import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maaya/core/theme/app_colors.dart';
import 'package:maaya/domain/entities/reminder_model.dart';
import 'package:maaya/presentation/widgets/custom_switch.dart';

class ReminderCard extends StatelessWidget {
  final Reminder reminder;
  final Function(bool) onToggle;
  final VoidCallback onDelete;

  const ReminderCard({
    super.key,
    required this.reminder,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textDirection = Directionality.of(context);

    final orderedDays = [
      'monday',
      'tuesday',
      'wednesday',
      'thursday',
      'friday',
      'saturday',
      'sunday',
    ];
    final sortedDays = [...reminder.days];
    sortedDays.sort(
      (a, b) => orderedDays.indexOf(a).compareTo(orderedDays.indexOf(b)),
    );

    return Directionality(
      textDirection: textDirection,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color:
                  isDark
                      ? Colors.grey[900]!.withOpacity(0.7)
                      : const Color.fromARGB(
                        255,
                        248,
                        253,
                        254,
                      ).withOpacity(0.8),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color:
                    isDark
                        ? AppColors.primary.withOpacity(0.2)
                        : AppColors.primaryDark.withOpacity(0.2),
                width: 0.6,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // === Time & Delete Icon ===
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children:
                      textDirection == TextDirection.ltr
                          ? [_buildTimeText(isDark), _buildDeleteIcon()]
                          : [_buildDeleteIcon(), _buildTimeText(isDark)],
                ),

                const SizedBox(height: 12),

                // === Days chips ===
                if (sortedDays.isNotEmpty)
                  Wrap(
                    spacing: 5,
                    runSpacing: 5,
                    children:
                        sortedDays.map((day) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  isDark
                                      ? Colors.white12
                                      : Colors.blueGrey.shade50.withOpacity(
                                        0.6,
                                      ),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color:
                                    isDark
                                        ? AppColors.primary
                                        : AppColors.primaryDark,
                                width: 0.5,
                              ),
                            ),
                            child: Text(
                              day.tr,
                              style: TextStyle(
                                fontSize: 13,
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.w500,
                                color:
                                    isDark
                                        ? AppColors.primary
                                        : AppColors.primaryDark,
                              ),
                            ),
                          );
                        }).toList(),
                  ),

                const SizedBox(height: 10),

                // === Toggle Switch ===
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CustomToggleSwitch(
                      value: reminder.isActive,
                      onChanged: onToggle,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTimeText(bool isDark) {
    return Text(
      reminder.timeFormatted,
      style: TextStyle(
        fontFamily: 'Nunito',
        fontSize: 26,
        fontWeight: FontWeight.w700,
        color: isDark ? Colors.white : Colors.black87,
      ),
    );
  }

  Widget _buildDeleteIcon() {
    return GestureDetector(
      onTap: onDelete,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.redAccent.withOpacity(0.1),
        ),
        child: Icon(
          Icons.delete,
          color: AppColors.error.withOpacity(0.9),
          size: 24,
        ),
      ),
    );
  }
}
