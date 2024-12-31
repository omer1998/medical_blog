import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:medical_blog_app/features/algorithms/models/dka_reading.dart';

class VitalSignTrendChart extends StatelessWidget {
  final List<DKAReading> readings;

  const VitalSignTrendChart({
    Key? key, 
    required this.readings
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (readings.isEmpty) {
      return const Center(
        child: Text('No vital signs data available'),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Vital Signs Trend',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            AspectRatio(
              aspectRatio: 1.5,
              child: _buildMultiLineChart(),
            ),
            const SizedBox(height: 16),
            _buildLegend(),
          ],
        ),
      ),
    );
  }

  Widget _buildMultiLineChart() {
    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          // horizontalInterval: 1,
          // verticalInterval: 1,
          getDrawingHorizontalLine: (value) => FlLine(
            color: Colors.grey.withOpacity(0.2),
            strokeWidth: 1,
            dashArray: [10, 5],
          ),
          getDrawingVerticalLine: (value) => FlLine(
            color: Colors.grey.withOpacity(0.2),
            strokeWidth: 1,
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: _bottomTitleWidgets,
              interval: 1,
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: _leftTitleWidgets,
              interval: 20,
              reservedSize: 30,
            ),
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: Colors.grey.withOpacity(0.3)),
        ),
        minX: 0,
        maxX: (readings.length - 1).toDouble(),
        minY: 40,
        maxY: 220,
        lineBarsData: [
          // _buildLineBarData(
          //   color: Colors.blue,
          //   getYValue: (reading) => reading.glucoseLevel.toDouble(),
          //   label: 'Glucose',
          // ),
          _buildLineBarData(
            color: Colors.red,
            getYValue: (reading) => reading.pulseRate.toDouble(),
            label: 'Pulse Rate',
          ),
          _buildLineBarData(
            color: Colors.green,
            getYValue: (reading) => reading.systolicBP.toDouble(),
            label: 'Systolic BP',
          ),
          _buildLineBarData(
            color: Colors.orange,
            getYValue: (reading) => reading.diastolicBP.toDouble(),
            label: 'Diastolic BP',
          ),
        ],
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            fitInsideHorizontally: true,
            tooltipMargin: 10,
            maxContentWidth: 180,
            getTooltipItems: _getTooltipItems,
          ),
        ),
      ),
    );
  }

  LineChartBarData _buildLineBarData({
    required Color color,
    required double Function(DKAReading) getYValue,
    required String label,
  }) {
    return LineChartBarData(
      isCurved: true,
      color: color,
      barWidth: 3,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: true,
        getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
          radius: 4,
          color: color,
          strokeWidth: 2,
          strokeColor: Colors.white,
        ),
      ),
      belowBarData: BarAreaData(
        show: true,
        color: color.withOpacity(0.2),
      ),
      spots: readings.asMap().entries.map((entry) {
        return FlSpot(
          entry.key.toDouble(), 
          getYValue(entry.value)
        );
      }).toList(),
    );
  }

  Widget _bottomTitleWidgets(double value, TitleMeta meta) {
    if (value.toInt() >= readings.length) return Container();
    
    final reading = readings[value.toInt()];
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(
        _formatTime(reading.timestamp),
        style: const TextStyle(
          fontSize: 10, 
          fontWeight: FontWeight.w500,
        
        ),
      ),
    );
  }

  Widget _leftTitleWidgets(double value, TitleMeta meta) {
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(
        value.toInt().toString(),
        style: const TextStyle(
          fontSize: 10, 
          fontWeight: FontWeight.w500,
          
        ),
      ),
    );
  }

  List<LineTooltipItem?> _getTooltipItems(List<LineBarSpot> touchedSpots) {
    return touchedSpots.map((spot) {
      final reading = readings[spot.x.toInt()];
      String label = '';
      
      switch (spot.barIndex) {
        case 0:
          label = 'Glucose: ${reading.glucoseLevel} mg/dL';
          break;
        case 1:
          label = 'Pulse Rate: ${reading.pulseRate} bpm';
          break;
        case 2:
          label = 'Systolic BP: ${reading.systolicBP} mmHg';
          break;
        case 3:
          label = 'pH: ${reading.pH}';
          break;
      }

      return LineTooltipItem(
        '$label\nTime: ${_formatTime(reading.timestamp)}',
        const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
      );
    }).toList();
  }

  Widget _buildLegend() {
    return Wrap(
      spacing: 10,
      runSpacing: 5,
      children: [
        _buildLegendItem(Colors.red, 'Pulse Rate'),
        _buildLegendItem(Colors.green, 'Systolic BP'),
        _buildLegendItem(Colors.orange, 'Diastolic BP'),
      ],
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          color: color,
        ),
        const SizedBox(width: 5),
        Text(label),
      ],
    );
  }

  double _calculateMinY() {
    final values = readings.expand((r) => [
      r.glucoseLevel.toDouble(),
      r.pulseRate.toDouble(),
      r.systolicBP.toDouble(),
      r.pH,
    ]);
    return values.reduce((a, b) => a < b ? a : b) * 0.8;
  }

  double _calculateMaxY() {
    final values = readings.expand((r) => [
      r.glucoseLevel.toDouble(),
      r.pulseRate.toDouble(),
      r.systolicBP.toDouble(),
      r.pH,
    ]);
    return values.reduce((a, b) => a > b ? a : b) * 1.2;
  }

  String _formatTime(DateTime timestamp) {
    return '${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}';
  }
}