import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maaya/core/services/local_db_service.dart';
import 'package:maaya/domain/entities/reminder_model.dart';

class ReminderController extends GetxController {
  var selectedTime = TimeOfDay.now().obs;
  var selectedDays = <String>[].obs;

  var reminders = <Reminder>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadReminders();
  }

  /// Add a new reminder
  Future<void> addReminder() async {
    if (selectedDays.isEmpty) {
      Get.snackbar("Error", "Please select at least one day");
      return;
    }

    final id = await LocalDBService.insertReminder(
      selectedTime.value.hour,
      selectedTime.value.minute,
      selectedDays.toList(),
    );

    reminders.insert(
      0,
      Reminder(
        id: id,
        hour: selectedTime.value.hour,
        minute: selectedTime.value.minute,
        days: selectedDays.toList(),
        isActive: true,
      ),
    );

    selectedDays.clear();

    Get.snackbar("Success", "Reminder added");
  }

  Future<void> loadReminders() async {
    final data = await LocalDBService.getAllReminders();
    reminders.value = data.map((e) => Reminder.fromMap(e)).toList();
  }

  /// Update reminder status (active/inactive)
  Future<void> toggleReminder(int id, bool value) async {
    await LocalDBService.updateReminderStatus(id, value);
    final index = reminders.indexWhere((r) => r.id == id);
    if (index != -1) {
      reminders[index] = Reminder(
        id: reminders[index].id,
        hour: reminders[index].hour,
        minute: reminders[index].minute,
        days: reminders[index].days,
        isActive: value,
      );
      reminders.refresh();
    }
  }

  /// Delete a reminder
  Future<void> deleteReminder(int id) async {
    await LocalDBService.deleteReminder(id);
    reminders.removeWhere((r) => r.id == id);
  }
}
