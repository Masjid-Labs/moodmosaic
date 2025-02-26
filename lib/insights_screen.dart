import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class InsightsScreen extends StatelessWidget {
  const InsightsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Weekly Insights')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: PieChart(
          PieChartData(
            sections: [
              PieChartSectionData(value: 40, color: Colors.yellow),
              PieChartSectionData(value: 25, color: Colors.green),
              PieChartSectionData(value: 15, color: Colors.blue),
              PieChartSectionData(value: 10, color: Colors.red),
              PieChartSectionData(value: 10, color: Colors.purple),
            ],
          ),
        ),
      ),
    );
  }
}