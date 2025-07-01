import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maaya/core/services/local_db_service.dart';

class Reminder {
  final int id;
  final int hour;
  final int minute;
  final List<String> days;
  final bool isActive;

  Reminder({
    required this.id,
    required this.hour,
    required this.minute,
    required this.days,
    required this.isActive,
  });

  factory Reminder.fromMap(Map<String, dynamic> map) {
    return Reminder(
      id: map['id'],
      hour: map['hour'],
      minute: map['minute'],
      days: LocalDBService.daysFromJson(map['days']),
      isActive: map['isActive'] == 1,
    );
  }

  String get timeFormatted {
    final time = TimeOfDay(hour: hour, minute: minute);
    return time.format(Get.context!);
  }
}
