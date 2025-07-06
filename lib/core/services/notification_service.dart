import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:permission_handler/permission_handler.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    print('[NotificationService] Initializing notification plugin...');

    const AndroidInitializationSettings android = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const DarwinInitializationSettings ios = DarwinInitializationSettings();

    const InitializationSettings settings = InitializationSettings(
      android: android,
      iOS: ios,
    );

    await flutterLocalNotificationsPlugin.initialize(settings);
    print('[NotificationService] Plugin initialized.');

    final permissionStatus = await Permission.notification.request();
    print('[NotificationService] Notification permission: $permissionStatus');

    AndroidNotificationChannel channel = AndroidNotificationChannel(
      'reminder_channel_v5',
      'Reminder Notifications',
      description: 'Used for reminder notifications',
      importance: Importance.max,
      playSound: true,
      sound: RawResourceAndroidNotificationSound('alarm_sound_first'),
      showBadge: true,
    );

    final result = flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);

    print(
      '[NotificationService] Notification channel created: ${result != null ? 'success' : 'failed'}',
    );
  }

  Future<void> scheduleReminderNotification({
    required int id,
    required int hour,
    required int minute,
    required List<String> days,
    required String title,
    required String body,
  }) async {
    print('[NotificationService] Scheduling notifications...');
    for (final day in days) {
      final scheduledDate = _nextInstanceOfWeekday(day, hour, minute);
      final dayId = id + _dayOffset(day);

      print(
        '⏰ Scheduling notification: id=$dayId day=$day '
        'time=${scheduledDate.toLocal()} title="$title"',
      );

      try {
        await flutterLocalNotificationsPlugin.zonedSchedule(
          dayId,
          title,
          body,
          scheduledDate,
          NotificationDetails(
            android: AndroidNotificationDetails(
              'reminder_channel_v5',
              'Reminder',
              channelDescription: 'Reminder notifications',
              importance: Importance.max,
              priority: Priority.high,
              playSound: true,
              styleInformation: BigTextStyleInformation(body),
              sound: RawResourceAndroidNotificationSound('alarm_sound_first'),
            ),
            iOS: DarwinNotificationDetails(
              sound: 'alarm_sound_first.mp3',
              presentSound: true,
            ),
          ),
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
        );
        print('✅ Notification scheduled successfully.');
      } catch (e) {
        print('❌ Failed to schedule notification for $day: $e');
      }
    }
  }

  tz.TZDateTime _nextInstanceOfWeekday(String weekday, int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    int weekdayNumber = _weekdayToInt(weekday);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    while (scheduledDate.weekday != weekdayNumber ||
        scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    print('📅 Next instance for $weekday is: ${scheduledDate.toLocal()}');
    return scheduledDate;
  }

  int _weekdayToInt(String weekday) {
    switch (weekday.toLowerCase()) {
      case 'monday':
        return DateTime.monday;
      case 'tuesday':
        return DateTime.tuesday;
      case 'wednesday':
        return DateTime.wednesday;
      case 'thursday':
        return DateTime.thursday;
      case 'friday':
        return DateTime.friday;
      case 'saturday':
        return DateTime.saturday;
      case 'sunday':
        return DateTime.sunday;
      default:
        print('[NotificationService] Invalid weekday: $weekday');
        return DateTime.monday;
    }
  }

  int _dayOffset(String day) {
    switch (day.toLowerCase()) {
      case 'monday':
        return 1;
      case 'tuesday':
        return 2;
      case 'wednesday':
        return 3;
      case 'thursday':
        return 4;
      case 'friday':
        return 5;
      case 'saturday':
        return 6;
      case 'sunday':
        return 7;
      default:
        return 0;
    }
  }
}
