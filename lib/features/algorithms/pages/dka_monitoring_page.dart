import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:medical_blog_app/core/utils/extensions.dart';
import 'package:medical_blog_app/features/algorithms/models/dka_reading.dart';
import 'package:medical_blog_app/features/algorithms/models/dka_patient.dart';
import 'package:medical_blog_app/features/algorithms/pages/widgets/glucose_trend_chart.dart';
import 'package:medical_blog_app/features/algorithms/pages/widgets/vital_sign_trend_chart.dart';
import 'package:medical_blog_app/features/algorithms/utils/dka_guidelines.dart';
import 'package:medical_blog_app/features/algorithms/pages/add_patient_dialog.dart';
import 'package:medical_blog_app/features/algorithms/pages/blood_gas_interpreter_page.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:csv/csv.dart';

class DKAMonitoringPage extends StatefulWidget {
  const DKAMonitoringPage({super.key});

  @override
  State<DKAMonitoringPage> createState() => _DKAMonitoringPageState();
}

class _DKAMonitoringPageState extends State<DKAMonitoringPage> {
  final List<DKAPatient> patients = [];
  DKAPatient? selectedPatient;
  final _formKey = GlobalKey<FormState>();
  final GlobalKey _chartsKey = GlobalKey();

  // Form controllers
  final TextEditingController _glucoseController = TextEditingController();
  final TextEditingController _fluidController = TextEditingController();
  final TextEditingController _insulinController = TextEditingController();
  final TextEditingController _urineController = TextEditingController();
  final TextEditingController _potassiumController = TextEditingController();
  final TextEditingController _bicarbonatController = TextEditingController();
  final TextEditingController _phController = TextEditingController();
  final TextEditingController _pulseController = TextEditingController();
  final TextEditingController _systolicBPController = TextEditingController();
  final TextEditingController _diastolicBPController = TextEditingController();
  final TextEditingController _capillaryRefillController =
      TextEditingController();
  final TextEditingController _potassiumInFluidsController =
      TextEditingController();

  String _selectedConsciousness = DKAReading.consciousnessLevels.first;
  String _selectedFluidType = DKAReading.fluidTypes.first;
  HydrationStatus _selectedHydrationStatus = HydrationStatus.mild;

  DKAReading? lastReading;

  @override
  void dispose() {
    _glucoseController.dispose();
    _fluidController.dispose();
    _insulinController.dispose();
    _urineController.dispose();
    _potassiumController.dispose();
    _bicarbonatController.dispose();
    _phController.dispose();
    _pulseController.dispose();
    _systolicBPController.dispose();
    _diastolicBPController.dispose();
    _capillaryRefillController.dispose();
    _potassiumInFluidsController.dispose();
    super.dispose();
  }

  void _addPatient() async {
    await showDialog<DKAPatient>(
      context: context,
      builder: (context) => AddPatientDialog(
        onAdd: (patient) {
          setState(() {
            patients.add(patient);
            selectedPatient = patient;
          });
        },
      ),
    );

    // if (patient != null) {
    //   setState(() {
    //     patients.add(patient);
    //     selectedPatient = patient;
    //   });
    // }
  }

  double _calculatePotassiumInFluids(
      double potassiumLevel, double urineOutput) {
    if (urineOutput < 50 || potassiumLevel >= 5.3) return 0;
    if (potassiumLevel < 3.3) return 40;
    return 30;
  }

  String _determineFluidType(double glucoseLevel) {
    return glucoseLevel > 200
        ? 'Normal Saline'
        : '0.45% Normal Saline + 5% Dextrose';
  }

  void _addReading() {
    if (selectedPatient == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please select a patient first'),
            backgroundColor: Colors.red),
      );
      return;
    }

    if (_formKey.currentState?.validate() ?? false) {
      try {
        final reading = DKAReading(
          timestamp: DateTime.now(),
          glucoseLevel: double.parse(_glucoseController.text),
          fluidGiven: double.parse(_fluidController.text),
          fluidType: _selectedFluidType,
          insulinDose: double.parse(_insulinController.text),
          urineOutput: double.parse(_urineController.text),
          consciousnessLevel: _selectedConsciousness,
          potassiumLevel: double.parse(_potassiumController.text),
          bicarbonateLevel: double.parse(_bicarbonatController.text),
          pH: double.parse(_phController.text),
          pulseRate: int.parse(_pulseController.text),
          systolicBP: double.parse(_systolicBPController.text),
          diastolicBP: double.parse(_diastolicBPController.text),
          capillaryRefillTime: int.parse(_capillaryRefillController.text),
          hydrationStatus: _selectedHydrationStatus,
          potassiumInFluids: double.parse(_potassiumInFluidsController.text),
        );

        final index = patients.indexWhere((p) => p.id == selectedPatient!.id);
        if (index != -1) {
          setState(() {
            final updatedReadings = [...patients[index].readings, reading];
            patients[index] =
                patients[index].copyWith(readings: updatedReadings);
            selectedPatient = patients[index];
            // update the last reading value
            lastReading = selectedPatient!.readings.isNotEmpty
                ? selectedPatient!.readings.last
                : null;
          });

          _clearForm();
          updateSomeFieldToTheLastReading();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Reading added successfully'),
                backgroundColor: Colors.green),
          );

          // Show guidelines after successful addition
          final guidelines = DKAGuidelines.evaluateReading(
            reading,
            selectedPatient!.readings.length > 1
                ? selectedPatient!
                    .readings[selectedPatient!.readings.length - 2]
                : null,
          );

          if (guidelines.isNotEmpty) {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Clinical Guidelines'),
                content: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: guidelines
                        .map((g) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Text(g),
                            ))
                        .toList(),
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('OK'),
                  ),
                ],
              ),
            );
          }
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Error: ${e.toString()}'),
              backgroundColor: Colors.red),
        );
      }
    }
  }

  _buildGuidelines() {
    if (selectedPatient != null && selectedPatient!.readings.isNotEmpty) {
      final guidelines = DKAGuidelines.evaluateReading(
          selectedPatient!.readings.last,
          selectedPatient!.readings.length > 1
              ? selectedPatient!.readings[selectedPatient!.readings.length - 2]
              : null);
      return Padding(
        padding: const EdgeInsets.only(top: 8.0, bottom: 15, left: 8, right: 8),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Clinical Guidelines',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            ...guidelines
                .map((g) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Text(g),
                    ))
                .toList()
          ],
        ),
      );
    } else {
      return Container();
    }
  }

  void _clearForm() {
    _glucoseController.clear();
    _fluidController.clear();
    _insulinController.clear();
    _urineController.clear();
    _potassiumController.clear();
    _bicarbonatController.clear();
    _phController.clear();
    _pulseController.clear();
    _systolicBPController.clear();
    _diastolicBPController.clear();
    _capillaryRefillController.clear();
    _potassiumInFluidsController.clear();
    setState(() {
      _selectedConsciousness = DKAReading.consciousnessLevels.first;
      _selectedFluidType = DKAReading.fluidTypes.first;
      _selectedHydrationStatus = HydrationStatus.mild;
    });
  }

  Color _getGlucoseColor(double glucoseLevel) {
    if (glucoseLevel < 70) return Colors.red;
    if (glucoseLevel < 140) return Colors.green;
    return Colors.red;
  }

  Color _getPotassiumColor(double potassiumLevel) {
    if (potassiumLevel < 3.5) return Colors.red;
    if (potassiumLevel < 5.5) return Colors.green;
    return Colors.red;
  }

  Color _getPHColor(double pH) {
    if (pH < 7.1) return Colors.red;
    if (pH < 7.3) return Colors.green;
    return Colors.red;
  }

  Widget _buildReadingsTable() {
    if (selectedPatient == null || selectedPatient!.readings.isEmpty) {
      return const Center(child: Text('No readings yet'));
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: const Text(
            'Readings',
            style: TextStyle(fontSize: 20),
          ),
        ),
        Card(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: const [
                DataColumn(label: Text('Time')),
                DataColumn(label: Text('Glucose')),
                DataColumn(label: Text('pH')),
                DataColumn(label: Text('Potassium')),
                DataColumn(label: Text('Bicarbonate')),
                DataColumn(label: Text('BP')),
                DataColumn(label: Text('Pulse')),
              ],
              rows: selectedPatient!.readings.map((reading) {
                return DataRow(
                  cells: [
                    DataCell(Text(
                        '${reading.timestamp.hour}:${reading.timestamp.minute.toString().padLeft(2, '0')}')),
                    DataCell(Text('${reading.glucoseLevel}')),
                    DataCell(Text('${reading.pH}')),
                    DataCell(Text('${reading.potassiumLevel}')),
                    DataCell(Text('${reading.bicarbonateLevel}')),
                    DataCell(
                        Text('${reading.systolicBP}/${reading.diastolicBP}')),
                    DataCell(Text('${reading.pulseRate}')),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCharts() {
    // if (selectedPatient == null || selectedPatient!.readings.isEmpty) {
    //   return const Center(
    //     child: Text('No readings available'),
    //   );
    // }

    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          width: constraints.maxWidth,
          color: Colors.grey[500],
          child: Column(
            children: [
              // SizedBox(
              //   height: 300,
              //   child: Padding(
              //     padding: const EdgeInsets.all(16.0),
              //     child: _buildGlucoseChart(),
              //   ),
              // ),
              // GlucoseTrendChart(readings: readings,),
              const SizedBox(height: 24),
              // SizedBox(
              //   height: 300,
              //   child: Padding(
              //     padding: const EdgeInsets.all(16.0),
              //     child: _buildVitalsChart(),
              //   ),
              // ),
            ],
          ),
        );
      },
    );
  }

  final List<DKAReading> readings = [
    DKAReading(
      timestamp: DateTime.now(),
      glucoseLevel: 600,
      fluidGiven: 0.5,
      fluidType: 'Normal Saline',
      insulinDose: 0,
      urineOutput: 0.5,
      consciousnessLevel: 'Coma',
      potassiumLevel: 4.5,
      bicarbonateLevel: 20,
      pH: 7.2,
      pulseRate: 110,
      systolicBP: 90,
      diastolicBP: 60,
      capillaryRefillTime: 2,
      hydrationStatus: HydrationStatus.mild,
      potassiumInFluids: 0,
    ),
    DKAReading(
      timestamp: DateTime.now().add(Duration(hours: 1)),
      glucoseLevel: 560,
      fluidGiven: 0.5,
      fluidType: 'Normal Saline',
      insulinDose: 0,
      urineOutput: 0.5,
      consciousnessLevel: 'Coma',
      potassiumLevel: 4.5,
      bicarbonateLevel: 20,
      pH: 7.2,
      pulseRate: 90,
      systolicBP: 110,
      diastolicBP: 65,
      capillaryRefillTime: 2,
      hydrationStatus: HydrationStatus.mild,
      potassiumInFluids: 0,
    ),
    DKAReading(
      timestamp: DateTime.now().add(Duration(hours: 2)),
      glucoseLevel: 500,
      fluidGiven: 0.5,
      fluidType: 'Normal Saline',
      insulinDose: 0,
      urineOutput: 0.5,
      consciousnessLevel: 'Coma',
      potassiumLevel: 4.5,
      bicarbonateLevel: 20,
      pH: 7.2,
      pulseRate: 88,
      systolicBP: 135,
      diastolicBP: 50,
      capillaryRefillTime: 2,
      hydrationStatus: HydrationStatus.mild,
      potassiumInFluids: 0,
    ),
    DKAReading(
      timestamp: DateTime.now().add(Duration(hours: 3)),
      glucoseLevel: 430,
      fluidGiven: 0.5,
      fluidType: 'Normal Saline',
      insulinDose: 0,
      urineOutput: 0.5,
      consciousnessLevel: 'Coma',
      potassiumLevel: 4.5,
      bicarbonateLevel: 20,
      pH: 7.2,
      pulseRate: 80,
      systolicBP: 120,
      diastolicBP: 80,
      capillaryRefillTime: 2,
      hydrationStatus: HydrationStatus.mild,
      potassiumInFluids: 0,
    ),
    DKAReading(
      timestamp: DateTime.now().add(Duration(hours: 4)),
      glucoseLevel: 400,
      fluidGiven: 0.5,
      fluidType: 'Normal Saline',
      insulinDose: 0,
      urineOutput: 0.5,
      consciousnessLevel: 'Coma',
      potassiumLevel: 4.5,
      bicarbonateLevel: 20,
      pH: 7.2,
      pulseRate: 70,
      systolicBP: 120,
      diastolicBP: 80,
      capillaryRefillTime: 2,
      hydrationStatus: HydrationStatus.mild,
      potassiumInFluids: 0,
    ),
    DKAReading(
      timestamp: DateTime.now().add(Duration(hours: 5)),
      glucoseLevel: 350,
      fluidGiven: 0.5,
      fluidType: 'Normal Saline',
      insulinDose: 0,
      urineOutput: 0.5,
      consciousnessLevel: 'Coma',
      potassiumLevel: 4.5,
      bicarbonateLevel: 20,
      pH: 7.2,
      pulseRate: 77,
      systolicBP: 120,
      diastolicBP: 80,
      capillaryRefillTime: 2,
      hydrationStatus: HydrationStatus.mild,
      potassiumInFluids: 0,
    ),
  ];

  Widget _buildGlucoseChart() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Glucose Trends',
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                SizedBox(height: 8),
                Row(mainAxisSize: MainAxisSize.min, children: [
                  _buildLegendItem('Glucose', Colors.red),
                  const SizedBox(width: 16),
                ]),
              ],
            ),
            const SizedBox(height: 24),
            AspectRatio(
              aspectRatio: 16 / 9,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: false),
                  minX: 0,
                  minY: 0,
                  lineTouchData: LineTouchData(
                    enabled: true,
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(
                          getTitlesWidget: (value, meta) {
                            return Text(
                              value.toString(),
                              style: const TextStyle(
                                color: Colors.grey,
                              ),
                            );
                          },
                          showTitles: true,
                          reservedSize: 30,
                          interval: 50),
                    ),
                    bottomTitles: AxisTitles(
                      axisNameWidget: Text('Time'),
                      axisNameSize: 20,
                      sideTitles: SideTitles(
                          getTitlesWidget: (value, meta) {
                            final index = value.toInt();
                            final reading = readings[index];
                            return Text(
                              '${reading.timestamp.hour}:${reading.timestamp.minute.toString().padLeft(2, '0')}',
                              style: const TextStyle(
                                color: Colors.grey,
                              ),
                            );
                          },
                          showTitles: false,
                          interval: 1.0),
                    ),
                    leftTitles: AxisTitles(
                      axisNameSize: 20,
                      axisNameWidget: Text('Glucose Level'),
                      sideTitles: SideTitles(
                        showTitles: false,
                      ),
                    ),
                  ),
                  lineBarsData: [
                    // Glucose Line
                    LineChartBarData(
                      spots: readings
                          .map((reading) => FlSpot(
                              readings.indexOf(reading).toDouble(),
                              reading.glucoseLevel))
                          .toList(),
                      isCurved: true,
                      color: Colors.red,
                      barWidth: 3,
                      preventCurveOverShooting: true,
                      isStrokeCapRound: true,
                      dotData: FlDotData(show: true),
                      belowBarData: BarAreaData(
                        show: true,
                        color: Colors.red.withOpacity(0.1),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVitalsChart() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Vital Signs',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Row(
                  children: [
                    _buildLegendItem('pH', Colors.blue),
                    const SizedBox(width: 16),
                    _buildLegendItem('Blood Pressure', Colors.purple),
                    const SizedBox(width: 16),
                    _buildLegendItem('Pulse', Colors.pink),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 300,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: true,
                    horizontalInterval: 20,
                    verticalInterval: 1,
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        interval: 1,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() >= 0 &&
                              value.toInt() <
                                  selectedPatient!.readings.length) {
                            final reading =
                                selectedPatient!.readings[value.toInt()];
                            return Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                '${reading.timestamp.hour}:${reading.timestamp.minute.toString().padLeft(2, '0')}',
                                style: const TextStyle(fontSize: 10),
                              ),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      axisNameWidget: const Text('Values'),
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 20,
                        reservedSize: 45,
                      ),
                    ),
                    rightTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: true),
                  lineBarsData: [
                    // pH Line
                    LineChartBarData(
                      spots: selectedPatient!.readings
                          .asMap()
                          .entries
                          .map((e) => FlSpot(e.key.toDouble(), e.value.pH * 20))
                          .toList(),
                      isCurved: true,
                      color: Colors.blue,
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: FlDotData(show: true),
                      belowBarData: BarAreaData(
                        show: true,
                        color: Colors.blue.withOpacity(0.1),
                      ),
                    ),
                    // Blood Pressure Line
                    LineChartBarData(
                      spots: selectedPatient!.readings
                          .asMap()
                          .entries
                          .map((e) =>
                              FlSpot(e.key.toDouble(), e.value.systolicBP))
                          .toList(),
                      isCurved: true,
                      color: Colors.purple,
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: FlDotData(show: true),
                    ),
                    // Pulse Line
                    LineChartBarData(
                      spots: selectedPatient!.readings
                          .asMap()
                          .entries
                          .map((e) => FlSpot(
                              e.key.toDouble(), e.value.pulseRate.toDouble()))
                          .toList(),
                      isCurved: true,
                      color: Colors.pink,
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: FlDotData(show: true),
                    ),
                  ],
                  lineTouchData: LineTouchData(
                    touchTooltipData: LineTouchTooltipData(
                      getTooltipItems: (touchedSpots) {
                        return touchedSpots.map((LineBarSpot touchedSpot) {
                          final reading =
                              selectedPatient!.readings[touchedSpot.x.toInt()];
                          String value = '';
                          if (touchedSpot.barIndex == 0) {
                            value = 'pH: ${reading.pH.toStringAsFixed(2)}';
                          } else if (touchedSpot.barIndex == 1) {
                            value =
                                'BP: ${reading.systolicBP.toInt()}/${reading.diastolicBP.toInt()}';
                          } else {
                            value = 'Pulse: ${reading.pulseRate} bpm';
                          }
                          return LineTooltipItem(
                            value,
                            const TextStyle(color: Colors.white, fontSize: 12),
                          );
                        }).toList();
                      },
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

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'DKA Management',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.person_add),
            title: const Text('Add New Patient'),
            onTap: () {
              _addPatient();
              // Navigator.pop(context);
            },
          ),
          ...patients.isNotEmpty
              ? patients.map((patient) {
                  bool isSelected = selectedPatient?.id == patient.id;
                  return Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: ListTile(
                      title: Text(patient.name.capitalize()),
                      leading: Icon(
                        Icons.person,
                        color: isSelected ? Colors.blue : null,
                      ),
                      onTap: () {
                        setState(() {
                          selectedPatient = patient;
                        });
                      },
                    ),
                  );
                }).toList()
              : [],
          ListTile(
            leading: const Icon(Icons.science),
            title: const Text('Blood Gas Interpreter'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const BloodGasInterpreterPage(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> _exportData() async {
    if (selectedPatient == null || selectedPatient!.readings.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No data available to export')),
      );
      return;
    }

    try {
      // Create CSV data
      List<List<dynamic>> csvData = [
        // Header
        [
          'Time',
          'Glucose (mg/dL)',
          'pH',
          'Potassium (mEq/L)',
          'Bicarbonate (mEq/L)',
          'Blood Pressure',
          'Pulse (bpm)',
          'Fluid Given (mL)',
          'Fluid Type',
          'Insulin (units/hr)',
          'Urine Output (mL/kg/hr)',
          'Consciousness',
          'Hydration Status'
        ],
        // Data rows
        ...selectedPatient!.readings.map((reading) => [
              '${reading.timestamp.hour}:${reading.timestamp.minute.toString().padLeft(2, '0')}',
              reading.glucoseLevel,
              reading.pH,
              reading.potassiumLevel,
              reading.bicarbonateLevel,
              '${reading.systolicBP}/${reading.diastolicBP}',
              reading.pulseRate,
              reading.fluidGiven,
              reading.fluidType,
              reading.insulinDose,
              reading.urineOutput,
              reading.consciousnessLevel,
              reading.hydrationStatus.toString().split('.').last,
            ]),
      ];

      final String csv = const ListToCsvConverter().convert(csvData);

      // Capture screenshot of charts
      final RenderRepaintBoundary boundary = _chartsKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary;
      final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      final ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      final Uint8List chartImage = byteData!.buffer.asUint8List();

      // Save files temporarily
      final directory = await getApplicationDocumentsDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;

      final csvFile = File('${directory.path}/dka_data_$timestamp.csv');
      await csvFile.writeAsString(csv);

      final imageFile = File('${directory.path}/dka_charts_$timestamp.png');
      await imageFile.writeAsBytes(chartImage);

      // Share both files
      await Share.shareXFiles(
        [XFile(csvFile.path), XFile(imageFile.path)],
        subject: '${selectedPatient!.name} - DKA Monitoring Data',
        text:
            'DKA Monitoring Report for ${selectedPatient!.name}\nGenerated on ${DateTime.now()}',
      );

      // Clean up temporary files
      await Future.wait([
        csvFile.delete(),
        imageFile.delete(),
      ]);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error exporting data: $e')),
      );
    }
  }

  Widget _buildPatientInfo() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              selectedPatient!.name,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Age: ${selectedPatient!.age} | Weight: ${selectedPatient!.weight} kg',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'History: ${selectedPatient!.briefHistory}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  updateSomeFieldToTheLastReading() {
    setState(() {
      _glucoseController.text =
          lastReading != null ? lastReading!.glucoseLevel.toString() : "";
      _phController.text =
          lastReading != null ? lastReading!.pH.toString() : "";
      _bicarbonatController.text =
          lastReading != null ? lastReading!.bicarbonateLevel.toString() : "";
      _potassiumController.text =
          lastReading != null ? lastReading!.potassiumLevel.toString() : "";
    });
  }

  Widget _buildDataEntryForm() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Add New Reading',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  // Clinical Parameters
                  SizedBox(
                    width: 300,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Clinical Parameters',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _glucoseController,
                          decoration: const InputDecoration(
                            labelText: 'Glucose Level (mg/dL)',
                            prefixIcon: Icon(Icons.trending_up),
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter glucose level';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _phController,
                          decoration: const InputDecoration(
                            labelText: 'pH',
                            prefixIcon: Icon(Icons.science),
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter pH level';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _bicarbonatController,
                          decoration: const InputDecoration(
                            labelText: 'Bicarbonate Level (mEq/L)',
                            prefixIcon: Icon(Icons.monitor_heart),
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter pH level';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _potassiumController,
                          decoration: const InputDecoration(
                            labelText: 'Potassium Level (mEq/L)',
                            prefixIcon: Icon(Icons.monitor_heart),
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter potassium level';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  // Fluid Management
                  SizedBox(
                    width: 300,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Fluid Management',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _fluidController,
                          decoration: const InputDecoration(
                            labelText: 'Fluid Given (mL)',
                            prefixIcon: Icon(Icons.water_drop),
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter fluid amount';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _insulinController,
                          decoration: const InputDecoration(
                            labelText: 'Insulin Given (units/hr)',
                            prefixIcon: Icon(Icons.insights),
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter insulin amount';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _urineController,
                          decoration: const InputDecoration(
                            labelText: 'Urine Output (mL/kg/hr)',
                            prefixIcon: Icon(Icons.water),
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter urine output';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          isExpanded: true,
                          value: _selectedFluidType,
                          decoration: const InputDecoration(
                            labelText: 'Fluid Type',
                            prefixIcon: Icon(Icons.water),
                            border: OutlineInputBorder(),
                          ),
                          items: DKAReading.fluidTypes
                              .map((type) => DropdownMenuItem(
                                    value: type,
                                    child: Text(type),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                _selectedFluidType = value;
                              });
                            }
                          },
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<HydrationStatus>(
                          value: _selectedHydrationStatus,
                          decoration: const InputDecoration(
                            labelText: 'Hydration Status',
                            prefixIcon: Icon(Icons.opacity),
                            border: OutlineInputBorder(),
                          ),
                          items: HydrationStatus.values
                              .map((status) => DropdownMenuItem(
                                    value: status,
                                    child:
                                        Text(status.toString().split('.').last),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                _selectedHydrationStatus = value;
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  // Vital Signs
                  SizedBox(
                    width: 300,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Vital Signs',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _pulseController,
                          decoration: const InputDecoration(
                            labelText: 'Pulse Rate (bpm)',
                            prefixIcon: Icon(Icons.favorite),
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter pulse rate';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _systolicBPController,
                                decoration: const InputDecoration(
                                  labelText: 'Systolic BP',
                                  prefixIcon: Icon(Icons.arrow_upward),
                                  border: OutlineInputBorder(),
                                ),
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Required';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextFormField(
                                controller: _diastolicBPController,
                                decoration: const InputDecoration(
                                  labelText: 'Diastolic BP',
                                  prefixIcon: Icon(Icons.arrow_downward),
                                  border: OutlineInputBorder(),
                                ),
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Required';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _capillaryRefillController,
                          decoration: const InputDecoration(
                            labelText: 'Capillary Refill Time (s)',
                            prefixIcon: Icon(Icons.timer),
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter capillary refill time';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          value: _selectedConsciousness,
                          decoration: const InputDecoration(
                            labelText: 'Consciousness Level',
                            prefixIcon: Icon(Icons.psychology),
                            border: OutlineInputBorder(),
                          ),
                          items: DKAReading.consciousnessLevels
                              .map((level) => DropdownMenuItem(
                                    value: level,
                                    child: Text(level),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                _selectedConsciousness = value;
                              });
                            }
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _potassiumInFluidsController,
                          decoration: const InputDecoration(
                            labelText: 'K+ in Fluids (mEq/L)',
                            prefixIcon: Icon(Icons.medication),
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter K+ in fluids';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _addReading,
                  icon: const Icon(Icons.add_circle_outline),
                  label: const Text('Add Reading'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(selectedPatient?.name ?? 'DKA Monitoring'),
        actions: [
          if (selectedPatient != null) ...[
            IconButton(
              icon: const Icon(Icons.share),
              onPressed: _exportData,
              tooltip: 'Export Data',
            ),
          ],
        ],
      ),
      drawer: _buildDrawer(),
      body: selectedPatient == null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.person_search,
                      size: 64, color: Theme.of(context).colorScheme.primary),
                  const SizedBox(height: 16),
                  Text('Select a Patient',
                      style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                        'Choose a patient from the menu or add a new one',
                        style: Theme.of(context).textTheme.bodyLarge),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildPatientInfo(),
                  const SizedBox(height: 24),
                  _buildDataEntryForm(),
                  const SizedBox(height: 24),
                  _buildReadingsTable(),
                  const SizedBox(height: 24),
                  _buildGuidelines(),
                  GlucoseTrendChart(
                    readings: selectedPatient != null
                        ? selectedPatient!.readings
                        : [],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  VitalSignTrendChart(
                      readings: selectedPatient != null
                          ? selectedPatient!.readings
                          : []),
                  // RepaintBoundary(
                  //   key: _chartsKey,
                  //   child: LayoutBuilder(
                  //     builder: (context, constraints) {
                  //       return Container(
                  //         width: constraints.maxWidth,
                  //         color: Colors.white,
                  //         padding: const EdgeInsets.all(16.0),
                  //         child: Column(
                  //           crossAxisAlignment: CrossAxisAlignment.start,
                  //           children: [
                  //             Text(
                  //               '${selectedPatient!.name} - DKA Monitoring Charts',
                  //               style: Theme.of(context).textTheme.titleLarge,
                  //             ),
                  //             const SizedBox(height: 16),
                  //             _buildCharts(),
                  //           ],
                  //         ),
                  //       );
                  //     },
                  //   ),
                  // ),
                ],
              ),
            ),
    );
  }
}
