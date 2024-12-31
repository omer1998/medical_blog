// import 'package:flutter/material.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:medical_blog_app/features/algorithms/models/dka_reading.dart';

// class GlucoseTrendChart extends StatelessWidget {
//   final List<DKAReading> readings;

//   GlucoseTrendChart({required this.readings});

//   @override
//   Widget build(BuildContext context) {
//     return LineChart(
//       LineChartData(
//         lineBarsData: [
//           LineChartBarData(
//             spots: readings
//                 .map((reading) => FlSpot(
//                       reading.timestamp
//                           .difference(readings.first.timestamp)
//                           .inHours
//                           .toDouble(),
//                       reading.glucoseLevel.toDouble(),
//                     ))
//                 .toList(),
//             isCurved: true,
//             barWidth: 4,
//             isStrokeCapRound: true,
//             belowBarData: BarAreaData(
//               show: true,
//             ),
//             dotData: FlDotData(show: false),
//           ),
//         ],
//         // titlesData: FlTitlesData(
//         //   leftTitles: AxisTitles(
//         //       sideTitles: SideTitles(
//         //     showTitles: true,
//         //     getTitlesWidget: (value, meta) {
//         //       return Text(value.toInt().toString());
//         //     },
//         //     reservedSize: 40,
//         //   )),
//         //   bottomTitles: AxisTitles(
//         //       sideTitles: SideTitles(
//         //     showTitles: true,
//         //     getTitlesWidget: (value, meta) {
//         //       return Text(value.toInt().toString());
//         //     },
//         //     reservedSize: 40,
//         //   )),
//         // ),
//         borderData: FlBorderData(show: true),
//         gridData: FlGridData(show: true),
//         // minY: readings
//         //     .map((e) => e.glucoseLevel)
//         //     .reduce((a, b) => a < b ? a : b)
//         //     .toDouble(),
//         // maxY: readings
//         //     .map((e) => e.glucoseLevel)
//         //     .reduce((a, b) => a > b ? a : b)
//         //     .toDouble(),
//       ),
//     );
//   }
// }


import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:medical_blog_app/features/algorithms/models/dka_reading.dart';

class GlucoseTrendChart extends StatelessWidget {
  final List<DKAReading> readings;

  const GlucoseTrendChart({
    Key? key, 
    required this.readings
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (readings.isEmpty) {
      return const Center(
        child: Text('No glucose data available'),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Glucose Trend',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            // AspectRatio(
            //   aspectRatio: 1.5,
            //   child: SingleChildScrollView(
            //     scrollDirection: Axis.horizontal,
            //     child: SizedBox(
            //       width: 400,
            //       height: 350,
            //       child: _buildLineChart())
            //       ),
            // ),
            AspectRatio(
              aspectRatio: 1.5,
              child: _buildLineChart()),
          ],
        ),
      ),
    );
  }

  LineChart _buildLineChart() {
    return LineChart(
      LineChartData(
        gridData: FlGridData(show: true),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            axisNameWidget:  const Text('Time'),
            sideTitles: SideTitles(
              // reservedSize: 25,
              showTitles: true,
              getTitlesWidget: _bottomTitleWidgets,
              interval: 1,
            ),
          ),
          leftTitles: AxisTitles(
            axisNameWidget: const Text('Glucose Level'),
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 35,
              getTitlesWidget: _leftTitleWidgets,
              interval: 50,
            ),
          ),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        minX: 0,
        maxX: (readings.length - 1).toDouble(),
        minY: _calculateMinY(),
        maxY: _calculateMaxY(),
        lineBarsData: [
          LineChartBarData(
            spots: _generateSpots(),
            isCurved: true,
            color: Colors.blue,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(show: true),
          ),
        ],
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            // : Colors.blue.withOpacity(0.8),
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((spot) {
                final reading = readings[spot.x.toInt()];
                return LineTooltipItem(
                  '${reading.glucoseLevel} mg/dL\n${_formatTime(reading.timestamp)}', 
                  const TextStyle(color: Colors.white)
                );
              }).toList();
            },
          ),
        ),
      ),
    );
  }

  List<FlSpot> _generateSpots() {
    return readings.asMap().entries.map((entry) {
      final index = entry.key;
      final reading = entry.value;
      return FlSpot(
        index.toDouble(), 
        reading.glucoseLevel.toDouble()
      );
    }).toList();
  }

  double _calculateMinY() {
    final minGlucose = readings.map((r) => r.glucoseLevel).reduce((a, b) => a < b ? a : b);
    return (minGlucose * 0.8).floorToDouble(); // 20% buffer
  }

  double _calculateMaxY() {
    final maxGlucose = readings.map((r) => r.glucoseLevel).reduce((a, b) => a > b ? a : b);
    return (maxGlucose * 1.2).ceilToDouble(); // 20% buffer
  }

  Widget _bottomTitleWidgets(double value, TitleMeta meta) {
    if (value.toInt() >= readings.length) return Container();
    
    final reading = readings[value.toInt()];
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(
        _formatTime(reading.timestamp),
        style: const TextStyle(fontSize: 10),
      ),
    );
  }

  Widget _leftTitleWidgets(double value, TitleMeta meta) {
    if(value % 50 != 0) return Container();
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(
        value.toInt().toString(),
        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
      ),
    );
  }

  String _formatTime(DateTime timestamp) {
    return '${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}';
  }
}