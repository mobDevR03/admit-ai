import 'package:flutter/material.dart';

import '../../../../core/models/country_requirements.dart';

class ExamsScreen extends StatefulWidget {
  final int stepNumber;
  final int totalSteps;
  final String selectedCountry;
  final ValueChanged<List<String>> onFinish;

  const ExamsScreen({
    super.key,
    required this.stepNumber,
    required this.totalSteps,
    required this.selectedCountry,
    required this.onFinish,
  });

  @override
  State<ExamsScreen> createState() => _ExamsScreenState();
}

class _ExamsScreenState extends State<ExamsScreen> {
  CountryRequirements? requirements;

  String? selectedEnglishTest;
  String? selectedHskLevel;
  bool plansToTakeSat = false;

  @override
  void initState() {
    super.initState();
    requirements = getCountryRequirements(widget.selectedCountry);
  }

  List<String> _buildSelectedExams() {
    final exams = <String>[];

    if (selectedEnglishTest != null) {
      exams.add(selectedEnglishTest!);
    }

    if (selectedHskLevel != null) {
      exams.add(selectedHskLevel!);
    }

    if (plansToTakeSat) {
      exams.add('SAT');
    }

    return exams;
  }

  bool get _canContinue {
    if (requirements == null) return false;

    if (requirements!.englishTestRequired && selectedEnglishTest == null) {
      return false;
    }

    if (requirements!.hskRequired && selectedHskLevel == null) {
      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    final double progress = widget.stepNumber / widget.totalSteps;

    if (requirements == null) {
      return const Scaffold(
        body: Center(
          child: Text('Requirements for this country were not found.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose Exams'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Step ${widget.stepNumber} of ${widget.totalSteps}',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(value: progress),
            const SizedBox(height: 24),

            Text(
              'Requirements for ${widget.selectedCountry}',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 16),

            if (requirements!.englishTestRequired) ...[
              const Text(
                'English proficiency test',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Choose one test. Most universities accept IELTS, TOEFL, or Duolingo, so you usually do not need all of them.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 8),

              ...requirements!.englishTestOptions.map((exam) {
                return RadioListTile<String>(
                  title: Text(exam),
                  value: exam,
                  groupValue: selectedEnglishTest,
                  onChanged: (value) {
                    setState(() {
                      selectedEnglishTest = value;
                    });
                  },
                );
              }),

              const SizedBox(height: 16),
            ],

            if (requirements!.satOptional) ...[
              const Text(
                'SAT',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'SAT is optional for many US universities, but it can improve your competitiveness for selective universities and scholarships.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
              SwitchListTile(
                title: const Text('I plan to take SAT'),
                value: plansToTakeSat,
                onChanged: (value) {
                  setState(() {
                    plansToTakeSat = value;
                  });
                },
              ),
              const SizedBox(height: 16),
            ],

            if (requirements!.hskRequired) ...[
              const Text(
                'Chinese language test',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Choose your target HSK level for Chinese university admission.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 8),

              ...requirements!.hskOptions.map((exam) {
                return RadioListTile<String>(
                  title: Text(exam),
                  value: exam,
                  groupValue: selectedHskLevel,
                  onChanged: (value) {
                    setState(() {
                      selectedHskLevel = value;
                    });
                  },
                );
              }),
            ],

            const Spacer(),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _canContinue
                    ? () {
                        widget.onFinish(_buildSelectedExams());
                      }
                    : null,
                child: const Text('Finish'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}