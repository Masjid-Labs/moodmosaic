import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class MoodMosaic extends StatelessWidget {
  final List<Map<String, dynamic>> logs;

  const MoodMosaic({super.key, required this.logs});

  @override
  Widget build(BuildContext context) {
    final dateMap = _createDateMoodMap();
    final firstDate = _getFirstDate();
    final today = DateTime.now();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('Mood Mosaic',
              style: GoogleFonts.montserrat(
                  color: Colors.white70, fontSize: 18)),
        ),
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey[850],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              _buildDayHeaders(),
              SizedBox(height: 4),
              _buildMonthGrid(firstDate, today, dateMap),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDayHeaders() {
    return Row(
      children: ['S', 'M', 'T', 'W', 'T', 'F', 'S']
          .map((day) => Expanded(
        child: Center(
          child: Text(day,
              style: GoogleFonts.montserrat(
                  color: Colors.white54, fontSize: 12)),
        ),
      ))
          .toList(),
    );
  }

  Widget _buildMonthGrid(DateTime firstDate, DateTime today, Map<String, double> dateMap) {
    final days = _generateDays(firstDate, today);

    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        mainAxisSpacing: 2,
        crossAxisSpacing: 2,
      ),
      itemCount: days.length,
      itemBuilder: (context, index) {
        final date = days[index];
        final moodValue = dateMap[_dateKey(date)] ?? 0.0;

        return Tooltip(
          message: '${DateFormat('MMM dd').format(date)}\n${_getMoodText(moodValue)}',
          child: Container(
            decoration: BoxDecoration(
              color: _getMoodColor(moodValue),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        );
      },
    );
  }

  Map<String, double> _createDateMoodMap() {
    final map = <String, double>{};
    for (var log in logs) {
      final date = DateTime.parse(log['timestamp'] as String);
      map[_dateKey(date)] = log['value'] as double;
    }
    return map;
  }

  String _dateKey(DateTime date) =>
      '${date.year}-${date.month}-${date.day}';

  DateTime _getFirstDate() {
    if (logs.isEmpty) return DateTime.now().subtract(Duration(days: 30));
    final sorted = logs.map((l) => DateTime.parse(l['timestamp'] as String)).toList()
      ..sort();
    return sorted.first;
  }

  List<DateTime> _generateDays(DateTime startDate, DateTime endDate) {
    final days = <DateTime>[];
    DateTime current = startDate;

    // Align to start of week
    current = current.subtract(Duration(days: current.weekday % 7));

    while (current.isBefore(endDate.add(Duration(days: 7)))) {
      days.add(current);
      current = current.add(Duration(days: 1));
    }

    return days;
  }

  // Reuse existing color/text methods
  String _getMoodText(double value) {
    if (value < 0.25) return 'I am very sad';
    if (value < 0.5) return 'Could be better';
    if (value < 0.75) return 'I am okay';
    if (value < 0.9) return 'I am happy';
    return 'Life is good.';
  }

  Color _getMoodColor(double value) {
    return Color.lerp(Colors.grey[900]!, Colors.deepPurple, value)!;
  }
}