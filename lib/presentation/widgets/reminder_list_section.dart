import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maaya/presentation/controllers/reminder_controller.dart';
import 'package:maaya/presentation/widgets/alarm_card.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class ReminderListSection extends StatelessWidget {
  final ReminderController controller;

  const ReminderListSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.reminders.isEmpty) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 40),
            child: Directionality(
              textDirection: Directionality.of(context),
              child: Text(
                "no_reminders".tr,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Roboto',
                ),
              ),
            ),
          ),
        );
      }

      return Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Directionality(
          textDirection: Directionality.of(context),
          child: StaggeredGrid.count(
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            children:
                controller.reminders.map((reminder) {
                  return ReminderCard(
                    reminder: reminder,
                    onToggle: (value) {
                      controller.toggleReminder(reminder.id, value);
                    },
                    onDelete: () {
                      controller.deleteReminder(reminder.id);
                    },
                  );
                }).toList(),
          ),
        ),
      );
    });
  }
}
