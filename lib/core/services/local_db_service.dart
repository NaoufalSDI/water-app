import 'dart:convert';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class LocalDBService {
  static Database? _db;

  static Future<void> init() async {
    if (_db != null) return;
    final path = join(await getDatabasesPath(), 'maaya_water.db');

    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
        CREATE TABLE water_intake(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          amount REAL,
          timestamp TEXT
        )
      ''');

        await db.execute('''
        CREATE TABLE reminders(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          hour INTEGER,
          minute INTEGER,
          days TEXT,
          isActive INTEGER
        )
      ''');
      },
    );
  }

  static Future<void> insertWater(double amount) async {
    final db = _db!;
    await db.insert('water_intake', {
      'amount': amount,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  static Future<double> getTodayTotal() async {
    final db = _db!;
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, now.day);
    final end = start.add(const Duration(days: 1));

    final result = await db.rawQuery(
      '''
      SELECT SUM(amount) as total FROM water_intake
      WHERE timestamp >= ? AND timestamp < ?
    ''',
      [start.toIso8601String(), end.toIso8601String()],
    );

    return result.first['total'] as double? ?? 0;
  }

  static Future<List<double>> getWeeklyTotals() async {
    final db = _db!;
    final now = DateTime.now();

    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));

    List<double> dailyTotals = [];

    for (int i = 0; i < 7; i++) {
      final dayStart = DateTime(
        startOfWeek.year,
        startOfWeek.month,
        startOfWeek.day + i,
      );
      final dayEnd = dayStart.add(const Duration(days: 1));

      final result = await db.rawQuery(
        '''
      SELECT SUM(amount) as total FROM water_intake
      WHERE timestamp >= ? AND timestamp < ?
      ''',
        [dayStart.toIso8601String(), dayEnd.toIso8601String()],
      );

      dailyTotals.add(result.first['total'] as double? ?? 0);
    }

    return dailyTotals;
  }

  static Future<int> insertReminder(
    int hour,
    int minute,
    List<String> days,
  ) async {
    final db = _db!;
    return await db.insert('reminders', {
      'hour': hour,
      'minute': minute,
      'days': daysToJson(days),
      'isActive': 1,
    });
  }

  static Future<List<Map<String, dynamic>>> getAllReminders() async {
    final db = _db!;
    return await db.query('reminders', orderBy: 'id DESC');
  }

  static Future<void> updateReminderStatus(int id, bool isActive) async {
    final db = _db!;
    await db.update(
      'reminders',
      {'isActive': isActive ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<void> deleteReminder(int id) async {
    final db = _db!;
    await db.delete('reminders', where: 'id = ?', whereArgs: [id]);
  }

  static String daysToJson(List<String> days) => jsonEncode(days);
  static List<String> daysFromJson(String jsonStr) =>
      List<String>.from(jsonDecode(jsonStr));
}
