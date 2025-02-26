import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class MoodStorage {
  static const String _key = 'moodLogs';

  static Future<void> saveMood(double value) async {
    final prefs = await SharedPreferences.getInstance();
    final List<Map<String, dynamic>> logs = await getMoods(); // Explicit type

    // Create entry with explicit types
    final Map<String, Object> newEntry = {
      'timestamp': DateTime.now().toIso8601String(),
      'value': value,
    };

    logs.add(newEntry);

    await prefs.setStringList(_key,
        logs.map((log) => jsonEncode(log)).toList()
    );
  }

  static Future<List<Map<String, dynamic>>> getMoods() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> logs = prefs.getStringList(_key) ?? [];

    return logs.map((e) {
      final Map<String, dynamic> decoded = jsonDecode(e);
      return {
        'timestamp': decoded['timestamp'] as String,
        'value': (decoded['value'] as num).toDouble(),
      };
    }).toList();
  }

  static Future<List<Map<String, dynamic>>> getLast30DaysMoods() async {
    final cutoff = DateTime.now().subtract(const Duration(days: 30));
    return (await getMoods()).where((log) {
      final date = DateTime.parse(log['timestamp'] as String);
      return date.isAfter(cutoff);
    }).toList();
  }

  static String formatDate(String isoDate) {
    return DateFormat('MMM dd, yyyy - HH:mm')
        .format(DateTime.parse(isoDate));
  }

}