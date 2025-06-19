import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ChartPage extends StatefulWidget {
  const ChartPage({super.key});

  @override
  State<ChartPage> createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> {
  final List<BarChartGroupData> _barGroups = [
    BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: 8, color: Colors.amber)]),
    BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 10, color: Colors.lightBlue)]),
    BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 14, color: Colors.greenAccent)]),
    BarChartGroupData(x: 3, barRods: [BarChartRodData(toY: 15, color: Colors.pinkAccent)]),
    BarChartGroupData(x: 4, barRods: [BarChartRodData(toY: 9, color: Colors.deepOrange)]),
  ];

  final List<FlSpot> _lineSpots = const [
    FlSpot(0, 3),
    FlSpot(1, 5),
    FlSpot(2, 4),
    FlSpot(3, 7),
    FlSpot(4, 6),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Charts'),
        backgroundColor: const Color(0xFF1E1E1E),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Bar Chart Example:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 300,
              child: BarChart(
                BarChartData(
                  barGroups: _barGroups,
                  borderData: FlBorderData(
                    show: true,
                    border: const Border(
                      bottom: BorderSide(color: Colors.white30, width: 1),
                      left: BorderSide(color: Colors.white30, width: 1),
                    ),
                  ),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          return Text(value.toInt().toString(), style: const TextStyle(color: Colors.white70));
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          const titles = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri'];
                          return SideTitleWidget(
                            axisSide: meta.axisSide,
                            space: 8,
                            child: Text(titles[value.toInt()], style: const TextStyle(color: Colors.white70)),
                          );
                        },
                      ),
                    ),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  gridData: const FlGridData(show: true, drawVerticalLine: false, horizontalInterval: 2),
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 20,
                ),
              ),
            ),
            const SizedBox(height: 40),
            const Text(
              'Line Chart Example:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 300,
              child: LineChart(
                LineChartData(
                  minX: 0,
                  maxX: 4,
                  minY: 0,
                  maxY: 8,
                  lineBarsData: [
                    LineChartBarData(
                      spots: _lineSpots,
                      isCurved: true,
                      color: Colors.lightGreenAccent,
                      barWidth: 4,
                      dotData: const FlDotData(show: true),
                      belowBarData: BarAreaData(show: true, color: Colors.lightGreenAccent.withOpacity(0.3)),
                    ),
                  ],
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          return Text(value.toInt().toString(), style: const TextStyle(color: Colors.white70));
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          const titles = ['Jan', 'Feb', 'Mar', 'Apr', 'May'];
                          return SideTitleWidget(
                            axisSide: meta.axisSide,
                            space: 8,
                            child: Text(titles[value.toInt()], style: const TextStyle(color: Colors.white70)),
                          );
                        },
                      ),
                    ),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  gridData: const FlGridData(show: true, drawVerticalLine: false),
                  borderData: FlBorderData(
                    show: true,
                    border: const Border(
                      bottom: BorderSide(color: Colors.white30, width: 1),
                      left: BorderSide(color: Colors.white30, width: 1),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}