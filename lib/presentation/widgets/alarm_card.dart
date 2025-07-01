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

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 2),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color:
            isDark
                ? Colors.grey[900]
                : const Color.fromARGB(255, 248, 253, 254),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black54 : Colors.grey.withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(1, 2),
          ),
        ],
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
          // Time and delete icon
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                reminder.timeFormatted,
                style: TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              GestureDetector(
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
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Days chips
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
                            isDark ? Colors.white12 : Colors.blueGrey.shade50,
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

          const SizedBox(height: 5),

          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CustomToggleSwitch(value: reminder.isActive, onChanged: onToggle),
            ],
          ),
        ],
      ),
    );
  }
}
