import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'moodStorage.dart';
import 'mosaicMoods.dart';

class HistoryScreen extends StatefulWidget {
  final List<Map<String, dynamic>> logs;

  const HistoryScreen({super.key, required this.logs});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  bool _showChart = true;
  bool _showAdvancedStats = false;
  final Map<String, double> _moodDistribution = {
    'Very Sad': 0,
    'Could be Better': 0,
    'Okay': 0,
    'Happy': 0,
    'Life is Good': 0,
  };

  List<FlSpot> _prepareChartData() {
    return widget.logs.map((log) {
      final date = DateTime.parse(log['timestamp'] as String);
      return FlSpot(
        date.millisecondsSinceEpoch.toDouble(),
        (log['value'] as double) * 10, // Scale to 1-10 for better visualization
      );
    }).toList();
  }

  LineTouchData _getLineTouchData() {
    return LineTouchData(
      touchTooltipData: LineTouchTooltipData(
        // tooltipBgColor: Colors.grey[850]!,
        getTooltipItems: (List<LineBarSpot> spots) {
          return spots.map((spot) {
            final date = DateTime.fromMillisecondsSinceEpoch(spot.x.toInt());
            return LineTooltipItem(
              '${MoodStorage.formatDate(date.toIso8601String())}\n${_getMoodText(spot.y / 10)}',
              GoogleFonts.montserrat(
                color: Colors.white70,
                fontSize: 12,
              ),
            );
          }).toList();
        },
      ),
    );
  }

  SideTitles _getBottomTitles() {
    return SideTitles(
      showTitles: true,
      interval: 86400000 * 7, // 1 week interval
      getTitlesWidget: (value, meta) {
        final date = DateTime.fromMillisecondsSinceEpoch(value.toInt());
        return Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            DateFormat('d MMM').format(date),
            style: GoogleFonts.montserrat(
              color: Colors.white54,
              fontSize: 10,
            ),
          ),
        );
      },
    );
  }

  SideTitles _getLeftTitles() {
    return SideTitles(
      showTitles: true,
      interval: 2,
      getTitlesWidget: (value, meta) {
        return Text(
          '${value.toInt()}',
          style: GoogleFonts.montserrat(
            color: Colors.white54,
            fontSize: 12,
          ),
        );
      },
    );
  }

  double _getMinX() {
    return widget.logs.map((log) => DateTime.parse(log['timestamp'] as String).millisecondsSinceEpoch).reduce((a, b) => a < b ? a : b).toDouble();
  }

  double _getMaxX() {
    return widget.logs.map((log) => DateTime.parse(log['timestamp'] as String).millisecondsSinceEpoch).reduce((a, b) => a > b ? a : b).toDouble();
  }

  @override
  void initState() {
    super.initState();
    _calculateAdvancedStats();
  }

  void _calculateAdvancedStats() {
    // Mood Distribution
    widget.logs.forEach((log) {
      final value = log['value'] as double;
      if (value < 0.25) {
        _moodDistribution['Very Sad'] = _moodDistribution['Very Sad']! + 1;
      } else if (value < 0.5) {
        _moodDistribution['Could be Better'] = _moodDistribution['Could be Better']! + 1;
      } else if (value < 0.75) {
        _moodDistribution['Okay'] = _moodDistribution['Okay']! + 1;
      } else if (value < 0.9) {
        _moodDistribution['Happy'] = _moodDistribution['Happy']! + 1;
      } else {
        _moodDistribution['Life is Good'] = _moodDistribution['Life is Good']! + 1;
      }
    });

    // Convert counts to percentages
    _moodDistribution.forEach((key, value) {
      _moodDistribution[key] = (value / widget.logs.length) * 100;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: Text('Mood History', style: GoogleFonts.montserrat(color: Colors.white70)),
        backgroundColor: Colors.grey[900],
        elevation: 10,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.grey[900],
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.2),
                    offset: Offset(-2, -2),
                    blurRadius: 5,
                  ),
                  BoxShadow(
                    color: Colors.black.withOpacity(0.6),
                    offset: Offset(2, 2),
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Icon(
                Icons.arrow_back_ios_sharp,
                color: Colors.white70,
              ),
            ),
          ),
        ),
        shadowColor: Colors.white38,
        actions: [
          if (_showChart)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.grey[900],
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.2),
                      offset: Offset(-2, -2),
                      blurRadius: 5,
                    ),
                    BoxShadow(
                      color: Colors.black.withOpacity(0.6),
                      offset: Offset(2, 2),
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: IconButton(
                  icon: Icon(
                    _showAdvancedStats ? Icons.insights : Icons.show_chart,
                    color: Colors.white70,
                  ),
                  onPressed: () => setState(() => _showAdvancedStats = !_showAdvancedStats),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.grey[900],
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.2),
                    offset: Offset(-2, -2),
                    blurRadius: 5,
                  ),
                  BoxShadow(
                    color: Colors.black.withOpacity(0.6),
                    offset: Offset(2, 2),
                    blurRadius: 5,
                  ),
                ],
              ),
              child: IconButton(
                icon: Icon(
                  _showChart ? Icons.list : Icons.show_chart,
                  color: Colors.white70,
                ),
                onPressed: () => setState(() => _showChart = !_showChart),
              ),
            ),
          ),
        ],
      ),
      body: widget.logs.isEmpty
          ? Center(child: Text('No entries yet!', style: GoogleFonts.montserrat(color: Colors.white70)))
          :
          // Column(
          //         children: [
          //           if (_showChart)
          //             ...[Container(
          //               height: 300,
          //               padding: EdgeInsets.all(16),
          //               child: LineChart(
          //                 LineChartData(
          //                   lineTouchData: _getLineTouchData(),
          //                   gridData: FlGridData(show: false),
          //                   titlesData: FlTitlesData(
          //                     bottomTitles: AxisTitles(sideTitles: _getBottomTitles()),
          //                     leftTitles: AxisTitles(sideTitles: _getLeftTitles()),
          //                     rightTitles: AxisTitles(),
          //                     topTitles: AxisTitles(),
          //                   ),
          //                   borderData: FlBorderData(
          //                     show: true,
          //                     border: Border.all(color: Colors.white10),
          //                   ),
          //                   minX: _getMinX(),
          //                   maxX: _getMaxX(),
          //                   minY: 0,
          //                   maxY: 10,
          //                   lineBarsData: [
          //                     LineChartBarData(
          //                       spots: _prepareChartData(),
          //                       isCurved: true,
          //                       curveSmoothness: 0.15,
          //                       color: Colors.deepPurple,
          //                       barWidth: 3,
          //                       isStrokeCapRound: true,
          //                       dotData: FlDotData(show: true),
          //                       belowBarData: BarAreaData(show: false),
          //                     ),
          //                   ],
          //                 ),
          //               ),
          //             ),
          //           _buildStatistics(), // Add stats below chart
          //           ],
          //           Expanded(
          //             child: _showChart
          //                 ? SizedBox.shrink()
          //                 : ListView.builder(
          //                     padding: EdgeInsets.all(16),
          //                     itemCount: widget.logs.length,
          //                     itemBuilder: (context, index) {
          //                       final log = widget.logs[index];
          //                       final date = DateTime.parse(log['timestamp'] as String);
          //                       return Padding(
          //                         padding: const EdgeInsets.all(8.0),
          //                         child: Container(
          //                             decoration: BoxDecoration(
          //                               borderRadius: BorderRadius.circular(15),
          //                               color: Colors.grey[900],
          //                               boxShadow: [
          //                                 BoxShadow(
          //                                   color: Colors.white.withOpacity(0.1),
          //                                   offset: Offset(-4, -4),
          //                                   blurRadius: 10,
          //                                 ),
          //                                 BoxShadow(
          //                                   color: Colors.black.withOpacity(0.5),
          //                                   offset: Offset(4, 4),
          //                                   blurRadius: 10,
          //                                 ),
          //                               ],
          //                             ),
          //                             padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
          //                             child: Row(
          //                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //                               children: [
          //                                 Text(
          //                                   MoodStorage.formatDate(date.toIso8601String()),
          //                                   style: GoogleFonts.montserrat(color: Colors.white70),
          //                                 ),
          //                                 Card(
          //                                   color: Colors.black,
          //                                   child: Padding(
          //                                     padding: const EdgeInsets.symmetric(
          //                                       horizontal: 8.0,
          //                                     ),
          //                                     child: Text(
          //                                       _getMoodText(log['value'] as double),
          //                                       style: GoogleFonts.montserrat(
          //                                         color: _getMoodColor(log['value'] as double),
          //                                         fontWeight: FontWeight.bold,
          //                                       ),
          //                                     ),
          //                                   ),
          //                                 ),
          //                               ],
          //                             )),
          //                       );
          //                     },
          //                   ),
          //           ),
          //         ],
          //       ),
          SingleChildScrollView(
              child: Column(
                children: [
                  if (!_showChart) ...[
                    ListView.builder(
                      padding: EdgeInsets.all(16),
                      itemCount: widget.logs.length,
                      itemBuilder: (context, index) {
                        final log = widget.logs[index];
                        final date = DateTime.parse(log['timestamp'] as String);
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.grey[900],
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.white.withOpacity(0.1),
                                    offset: Offset(-4, -4),
                                    blurRadius: 10,
                                  ),
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.5),
                                    offset: Offset(4, 4),
                                    blurRadius: 10,
                                  ),
                                ],
                              ),
                              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    MoodStorage.formatDate(date.toIso8601String()),
                                    style: GoogleFonts.montserrat(color: Colors.white70),
                                  ),
                                  Card(
                                    color: Colors.black,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0,
                                      ),
                                      child: Text(
                                        _getMoodText(log['value'] as double),
                                        style: GoogleFonts.montserrat(
                                          color: _getMoodColor(log['value'] as double),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )),
                        );
                      },
                      shrinkWrap: true,
                    )
                  ] else ...[
                    if (_showAdvancedStats) ...[
                      _buildMoodDistributionChart(),
                      _buildWeeklyAverages(),
                      _buildStreakInfo(),
                      SizedBox(height: 20),
                    ] else ...[
                      if (_showChart) ...[
                        MoodMosaic(logs: widget.logs),

                        Container(
                          height: 300,
                          padding: EdgeInsets.all(16),
                          child: LineChart(
                            LineChartData(
                              lineTouchData: _getLineTouchData(),
                              gridData: FlGridData(show: false),
                              titlesData: FlTitlesData(
                                bottomTitles: AxisTitles(sideTitles: _getBottomTitles()),
                                leftTitles: AxisTitles(sideTitles: _getLeftTitles()),
                                rightTitles: AxisTitles(),
                                topTitles: AxisTitles(),
                              ),
                              borderData: FlBorderData(
                                show: true,
                                border: Border.all(color: Colors.white10),
                              ),
                              minX: _getMinX(),
                              maxX: _getMaxX(),
                              minY: 0,
                              maxY: 10,
                              lineBarsData: [
                                LineChartBarData(
                                  spots: _prepareChartData(),
                                  isCurved: true,
                                  curveSmoothness: 0.15,
                                  color: Colors.deepPurple,
                                  barWidth: 3,
                                  isStrokeCapRound: true,
                                  dotData: FlDotData(show: true),
                                  belowBarData: BarAreaData(show: false),
                                ),
                              ],
                            ),
                          ),
                        ),
                        _buildStatistics(), // Add stats below chart
                      ],
                    ],
                  ],
                  // _buildBestWorstDays(),
                 const SizedBox(height: 20),
                ],
              ),
            ),
    );
  }


  Widget _buildStatistics() {
    final logs = widget.logs;
    final average = logs.isEmpty ? 0.0 : logs.map((l) => l['value'] as double).reduce((a, b) => a + b) / logs.length;

    final firstMood = logs.isNotEmpty ? logs.first['value'] as double : 0.0;
    final lastMood = logs.isNotEmpty ? logs.last['value'] as double : 0.0;
    final trend = lastMood - firstMood;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatCard(
            title: 'Average Mood',
            value: average.toStringAsFixed(1),
            color: _getMoodColor(average),
          ),
          _buildStatCard(
            title: '30 Day Trend',
            value: trend.toStringAsFixed(1),
            color: trend > 0
                ? Colors.green
                : trend < 0
                ? Colors.red
                : Colors.grey,
            icon: trend > 0
                ? Icons.trending_up
                : trend < 0
                ? Icons.trending_down
                : Icons.trending_flat,
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required Color color,
    IconData? icon,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.grey[900],
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.2),
            offset: Offset(-4, -4),
            blurRadius: 10,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.7),
            offset: Offset(4, 4),
            blurRadius: 10,
          ),
        ],
      ),
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            title,
            style: GoogleFonts.montserrat(
              color: Colors.white54,
              fontSize: 12,
            ),
          ),
          SizedBox(height: 8),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) Icon(icon, color: color, size: 20),
              SizedBox(width: 4),
              Text(
                value,
                style: GoogleFonts.montserrat(
                  color: color,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMoodDistributionChart() {
    return SizedBox(
      height: 300,
      child: PieChart(
        PieChartData(
          sectionsSpace: 2,
          centerSpaceRadius: 80,
          sections: [
            _buildPieSection('Very Sad', Colors.blueGrey, _moodDistribution['Very Sad']!),
            _buildPieSection('Could be Better', Colors.cyan, _moodDistribution['Could be Better']!),
            _buildPieSection('Okay', Colors.deepPurple[300]!, _moodDistribution['Okay']!),
            _buildPieSection('Happy', Colors.deepPurple, _moodDistribution['Happy']!),
            _buildPieSection('Life is Good', Colors.deepPurple[800]!, _moodDistribution['Life is Good']!),
          ],
          pieTouchData: PieTouchData(
            touchCallback: (FlTouchEvent event, pieTouchResponse) {
      if (event is FlTapUpEvent && pieTouchResponse != null) {
        final section = pieTouchResponse.touchedSection;
        if (section != null) {
          final moodCategory = _moodDistribution.keys.elementAt(section.touchedSectionIndex);
          final percentage = _moodDistribution[moodCategory]!;

          // Get.snackbar(moodCategory, '$moodCategory: ${percentage.toStringAsFixed(1)}%');

          // Get.showSnackbar(
          //   GetSnackBar(
          //         // content: Text('$moodCategory: ${percentage.toStringAsFixed(1)}%'),
          //         backgroundColor:Colors.black,
          //         duration: Duration(seconds: 1),
          //       ),);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('$moodCategory: ${percentage.toStringAsFixed(1)}%'),
              backgroundColor:Colors.grey[900],
              duration: Duration(seconds: 2),
              elevation: 10,
              padding: EdgeInsets.all(20),
              margin:  EdgeInsets.all(20),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }}}
          ),
        ),
      ),
    );
  }

  PieChartSectionData _buildPieSection(String title, Color color, double value) {
    return PieChartSectionData(
      color: color,
      value: value,
      title: '${value.toStringAsFixed(1)}%',
      radius: 22,
      titleStyle: GoogleFonts.montserrat(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildWeeklyAverages() {
    final weeklyAverages = <String, double>{};
    final weekFormatter = DateFormat('w');

    widget.logs.forEach((log) {
      final date = DateTime.parse(log['timestamp'] as String);
      final week = 'Week ${weekFormatter.format(date)}';
      weeklyAverages.update(
        week,
        (value) => (value + (log['value'] as double)) / 2,
        ifAbsent: () => log['value'] as double,
      );
    });

    return SizedBox(
      height: 150,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          barTouchData: BarTouchData(enabled: false),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      weeklyAverages.keys.elementAt(value.toInt()),
                      style: GoogleFonts.montserrat(
                        color: Colors.white54,
                        fontSize: 10,
                      ),
                    ),
                  );
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toInt().toString(),
                    style: GoogleFonts.montserrat(
                      color: Colors.white54,
                      fontSize: 10,
                    ),
                  );
                },
              ),
            ),
          ),
          gridData: FlGridData(show: false),
          borderData: FlBorderData(show: false),
          barGroups: weeklyAverages.entries.map((entry) {
            return BarChartGroupData(
              x: weeklyAverages.keys.toList().indexOf(entry.key),
              barRods: [
                BarChartRodData(
                  toY: entry.value,
                  color: _getMoodColor(entry.value),
                  width: 16,
                  borderRadius: BorderRadius.circular(4),
                )
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildStreakInfo() {
    int positiveStreak = 0;
    int negativeStreak = 0;
    double previousValue = widget.logs.first['value'] as double;

    for (var log in widget.logs) {
      final value = log['value'] as double;
      if (value > previousValue) {
        positiveStreak++;
        negativeStreak = 0;
      } else if (value < previousValue) {
        negativeStreak++;
        positiveStreak = 0;
      }
      previousValue = value;
    }

    return Padding(
      padding: const EdgeInsets.all(28.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStatCard(
            title: 'Positive Streak',
            value: '$positiveStreak days',
            color: Colors.green,
            icon: Icons.arrow_upward,
          ),
          SizedBox(width: 30),
          _buildStatCard(
            title: 'Negative Streak',
            value: '$negativeStreak days',
            color: Colors.red,
            icon: Icons.arrow_downward,
          ),
        ],
      ),
    );
  }

  Widget _buildBestWorstDays() {
    var bestDay = widget.logs.reduce((a, b) => (a['value'] as double) > (b['value'] as double) ? a : b);
    var worstDay = widget.logs.reduce((a, b) => (a['value'] as double) < (b['value'] as double) ? a : b);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              title: 'Best Day',
              value: MoodStorage.formatDate(DateTime.parse(bestDay['timestamp'] as String).toIso8601String()),
              color: Colors.deepPurple,
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: _buildStatCard(
              title: 'Worst Day',
              value: MoodStorage.formatDate(DateTime.parse(worstDay['timestamp'] as String).toIso8601String()),
              color: Colors.blueGrey,
            ),
          ),
        ],
      ),
    );
  }

  // Replicate these methods from HomeScreen or move them to a shared utility class
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
