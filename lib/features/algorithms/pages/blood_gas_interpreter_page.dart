import 'package:flutter/material.dart';

class BloodGasInterpreterPage extends StatefulWidget {
  const BloodGasInterpreterPage({super.key});

  @override
  State<BloodGasInterpreterPage> createState() => _BloodGasInterpreterPageState();
}

class _BloodGasInterpreterPageState extends State<BloodGasInterpreterPage> {
  final _formKey = GlobalKey<FormState>();
  
  // Controllers for input fields
  final TextEditingController _phController = TextEditingController();
  final TextEditingController _pco2Controller = TextEditingController();
  final TextEditingController _hco3Controller = TextEditingController();
  final TextEditingController _naController = TextEditingController();
  final TextEditingController _clController = TextEditingController();
  final TextEditingController _glucoseController = TextEditingController();
  final TextEditingController _bunController = TextEditingController();
  final TextEditingController _creatinineController = TextEditingController();
  final TextEditingController _lactateController = TextEditingController();
  final TextEditingController _albuminController = TextEditingController();
  final TextEditingController _measuredOsmolarityController = TextEditingController();
  final TextEditingController _po2Controller = TextEditingController();

  String _interpretationResult = '';
  double? _anionGap;
  double? _deltaGap;
  double? _deltaRatio;
  bool showBunField = false;
  
  @override
  void dispose() {
    _phController.dispose();
    _pco2Controller.dispose();
    _hco3Controller.dispose();
    _naController.dispose();
    _clController.dispose();
    _glucoseController.dispose();
    _bunController.dispose();
    _creatinineController.dispose();
    _lactateController.dispose();
    _albuminController.dispose();
    _measuredOsmolarityController.dispose();
    _po2Controller.dispose();

    super.dispose();
  }

  void _interpretBloodGas() {
    if (!_formKey.currentState!.validate()) return;

    final double ph = double.parse(_phController.text);
    final double pco2 = double.parse(_pco2Controller.text);
    final double hco3 = double.parse(_hco3Controller.text);
    final double na = double.parse(_naController.text);
    final double cl = double.parse(_clController.text);
    final double glucose = double.parse(_glucoseController.text);
    final double? lactate = _lactateController.text.isNotEmpty 
        ? double.parse(_lactateController.text) 
        : null;
    final double? measuredOsm = _measuredOsmolarityController.text.isNotEmpty ? double.parse(_measuredOsmolarityController.text) : null;
    final double po2 = double.parse(_po2Controller.text);
    // Calculate Anion Gap
    _anionGap = na - (cl + hco3);
    
    // Calculate Delta Gap and Delta Ratio
    const normalHCO3 = 24.0;
    const normalAnionGap = 12.0;
    
    _deltaGap = _anionGap! - normalAnionGap;
    final deltaHCO3 = normalHCO3 - hco3;
    _deltaRatio = _deltaGap! / deltaHCO3;

    // Build interpretation
    List<String> interpretations = [];

    // check validation

    // check whether it is venous or arterial blood gas analysis

    // Step 1: Evaluate pH
    if (ph < 7.35) {
      interpretations.add("• Acidemia (pH < 7.35)");
    } else if (ph > 7.45) {
      interpretations.add("• Alkalemia (pH > 7.45)");
    } else {
      interpretations.add("• Normal pH (7.35-7.45)");
    }

    // Step 2: Evaluate Primary Disorder
    if (hco3 < 22) {
      interpretations.add("• Metabolic Acidosis (HCO3 < 22)");
      
      // Evaluate compensation
      double expectedPCO2 = 1.5 * hco3 + 8;
      double pco2Tolerance = 2;
      
      if ((pco2 >= expectedPCO2 - pco2Tolerance) && 
          (pco2 <= expectedPCO2 + pco2Tolerance)) {
        interpretations.add("• Appropriate respiratory compensation");
      } else if (pco2 > expectedPCO2 + pco2Tolerance) {
        interpretations.add("• Additional respiratory acidosis");
      } else {
        interpretations.add("• Additional respiratory alkalosis");
      }
    } else if (hco3 > 26) {
      interpretations.add("• Metabolic Alkalosis (HCO3 > 26)");
    }

    if (pco2 > 45) {
      interpretations.add("• Respiratory Acidosis (PCO2 > 45)");
    } else if (pco2 < 35) {
      interpretations.add("• Respiratory Alkalosis (PCO2 < 35)");
    }

    // Step 3: Evaluate Anion Gap
    if (_anionGap! > 12) {
      interpretations.add("\nAnion Gap Analysis:");
      interpretations.add("• High Anion Gap: ${_anionGap!.toStringAsFixed(1)}");
      interpretations.add("• Delta Gap: ${_deltaGap!.toStringAsFixed(1)}");
      interpretations.add("• Delta Ratio: ${_deltaRatio!.toStringAsFixed(2)}");

      if (_deltaRatio! > 2) {
        interpretations.add("• Suggests concurrent metabolic alkalosis");
      } else if (_deltaRatio! < 1) {
        interpretations.add("• Suggests concurrent non-anion gap metabolic acidosis");
      } else {
        interpretations.add("• Pure anion gap metabolic acidosis");
      }

      // If albumin is provided
      // check the osmolar gap if the case is high anion gap metabolic acidosis (HAGMA)
      if (ph < 7.35 ){ // high anion gap metaolic acidosis
        if (measuredOsm != null) {
          final bun =double.parse(_bunController.text) ;
          final calculatedOsm = (na*1.86) + (glucose/18) + (bun/2.8) + 9 ;
          final osmGap = measuredOsm - calculatedOsm;
          if (osmGap > 10) {
          interpretations.add("\nOsmolar Gap Analysis:");
          interpretations.add("• Osmolar Gap: ${osmGap.toStringAsFixed(1)} (normal osmolar gap < 10)");
          interpretations.add("• Suggest toxin ingesion either ethylene glycol or methanol posining (extremely toxic; early diagnosis is essential)");
          interpretations.add("• Treatment: parenteral alcohol, fomipezol, thiamine, and dialysis");
          }else {
            interpretations.add("\nOsmolar Gap Analysis:");
            interpretations.add("• Normal osmolar gap");
            interpretations.add("• Ketoacidosis, lactic acidosis, renal failure, salicylate ingesion, D-lactic acidosis (episodic severe anion gap metabolic acidosis and signs of neuropsychiatric disturbance )");
          }
        }

      }

      // If lactate is provided
      if (lactate != null) {
        if (lactate > 2) {
          interpretations.add("\nLactic Acidosis:");
          interpretations.add("• Elevated lactate (${lactate.toStringAsFixed(1)} mmol/L)");
          
          double nonLactateGap = _anionGap! - lactate;
          interpretations.add("• Non-lactate anion gap: ${nonLactateGap.toStringAsFixed(1)}");
          
          if (nonLactateGap > 12) {
            interpretations.add("• Additional anion gap process present");
          }
        }
      }
    } else if (_anionGap! <= 12 && ph < 7.35 && hco3 < 24){
      // this mean metabolic acidosis with normal anion gap 
      // so in the situation we need to calculate the urinary anion gap 
      // to assess whether hco3 loss is from renal or from git
      // calculateUrinaryAnionGap();
      interpretations.add("\nUrinary anion gap analysis need to bee done in order to know the cause of hco3 loss (GIT OR RENAL)");
    }

    // evaluate respiratory function status 
    interpretations.add("\nRespiratory Function Status:");
    interpretations.add("• PO2: ${po2.toStringAsFixed(1)} mmHg (normal po2 80-100 mmgh on room air)");
    interpretations.add("• PCO2: ${pco2.toStringAsFixed(1)} mmHg");
    if (po2 < 75 && po2 > 60 ){
      interpretations.add("• hypoxemia (po2 < 75 mmHg)");
    } else if (po2 <= 60) {
      interpretations.add("• severe hypoxemia, respiratory failure (po2 < 60 mmHg)");
      if (pco2 <= 45) {
        interpretations.add("• respiratory failure type 1 (pco2 < 45 mmHg)");
        interpretations.add("• pathophysiology of hypoxemia; low inspired O2 content, Alveolar hypoventialtion, V/Q mistmatch, Shunt (anatomical and pysiological) not corrected by O2, Impaired diffusion of O2, Diffusion limitation ");
      }else {
        interpretations.add("• respiratory failure type 2 (pco2 > 45 mmHg)");
        interpretations.add("• Assessign A-a gradient to determine the cause of hypoxia in view of hypercapnia (high Pco2 indicate hypoventilation --> hypoventilation cause both hypoxia and hypercapina --> NOW how to know if there is another pathophysiological process responisble for hypoxia other than hypoventilation --> A-a gradient)");
        // add alert dialogue or bottom sheet to explain theis concept more 
         final PAo2  = (0.21 * (760-47) - (pco2 / 0.8)) ; 
         final AaGradient = PAo2 - po2;
         interpretations.add("• PAo2: ${PAo2.toStringAsFixed(1)} mmHg");
         interpretations.add("• A-a gradient: ${AaGradient.toStringAsFixed(1)} mmHg");
         if (AaGradient < 20) {
           interpretations.add("• Normal A-a gradient (A-a gradient < 20 mmHg) --> hypoxia due to hypoventilation");
         }else {
           interpretations.add("• High A-a gradient (A-a gradient > 20 mmHg) --> hypoxia due to other pathophysiological process; impaied O2 diffusion, V/Q mismatch, shunt, etc");
         }
      }
    }
    // add link to bottom sheet or alert dialogue to correlate o2 aturation and po2
    

    setState(() {
      _interpretationResult = interpretations.join('\n');
    });
  }

  Widget _buildInputField(String label, TextEditingController controller, String suffix, {bool validate= true, Function(String)? onFieldChanged}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        onChanged: onFieldChanged,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(
          labelText: label,
          suffixText: suffix,
          border: const OutlineInputBorder(),
        ),
        validator: (value) {
          if (validate){
            if (value == null || value.isEmpty) {
            return 'Please enter a value';
          }
          if (double.tryParse(value) == null) {
            return 'Please enter a valid number';
          }
          return null;
          }
          else {
            return null;
          }
          
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blood Gas Interpreter'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Blood Gas Values',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),
                      _buildInputField('pH', _phController, ''),
                      _buildInputField('Pco2', _pco2Controller, 'mmHg'),
                      _buildInputField('HCO3', _hco3Controller, 'mEq/L'),
                      _buildInputField('Po2', _po2Controller, 'mmHg'),

                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Electrolytes',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),
                      _buildInputField('Sodium (Na+)', _naController, 'mEq/L'),
                      _buildInputField('Chloride (Cl-)', _clController, 'mEq/L'),
                      _buildInputField('Lactate', _lactateController, 'mmol/L'),
                      _buildInputField('Measured Osmolarity', _measuredOsmolarityController, 'mOsm/L', validate: false, onFieldChanged: (value){
                        print(value);
                        if (value.isNotEmpty) {
                          setState(() {
                        showBunField = true;
                      });
                        }else{
                          setState(() {
                        showBunField = false;
                      });
                        }
                      } ),
                      showBunField ? _buildInputField('BUN; urea (mmol/L) x 2.8', _bunController, 'mg/dL') : Container(),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Glucose',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),
                      _buildInputField('Glucose', _glucoseController, 'mg/dL'),
                      ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _interpretBloodGas,
                child: const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('Interpret Blood Gas'),
                ),
              ),
              if (_interpretationResult.isNotEmpty) ...[
                const SizedBox(height: 24),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Interpretation',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _interpretationResult,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
