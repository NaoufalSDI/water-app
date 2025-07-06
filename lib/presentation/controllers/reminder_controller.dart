import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maaya/core/services/local_db_service.dart';
import 'package:maaya/core/services/notification_service.dart';
import 'package:maaya/domain/entities/reminder_model.dart';
import 'package:maaya/presentation/widgets/overlay_alert.dart';

class ReminderController extends GetxController {
  var selectedTime = TimeOfDay.now().obs;
  var selectedDays = <String>[].obs;
  final RxBool isGrid = true.obs;

  var reminders = <Reminder>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadReminders();
  }

  Future<void> addReminder(BuildContext context) async {
    if (selectedDays.isEmpty) {
      showOverlayAlert(
        context: context,
        message: 'error_days_required'.tr,
        isError: true,
      );
      return;
    }

    final id = await LocalDBService.insertReminder(
      selectedTime.value.hour,
      selectedTime.value.minute,
      selectedDays.toList(),
    );

    await NotificationService().scheduleReminderNotification(
      id: id,
      hour: selectedTime.value.hour,
      minute: selectedTime.value.minute,
      days: selectedDays,
      title: 'notification_title'.tr,
      body: 'notification_body'.tr,
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
  }

  Future<void> loadReminders() async {
    final data = await LocalDBService.getAllReminders();
    reminders.value = data.map((e) => Reminder.fromMap(e)).toList();
  }

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

  Future<void> deleteReminder(int id) async {
    await LocalDBService.deleteReminder(id);
    reminders.removeWhere((r) => r.id == id);
  }
}
