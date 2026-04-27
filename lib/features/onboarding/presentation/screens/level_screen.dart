import 'package:flutter/material.dart';

class LevelScreen extends StatefulWidget {
  final int stepNumber;
  final int totalSteps;
  final ValueChanged<String> onNext;

  const LevelScreen({
    super.key,
    required this.stepNumber,
    required this.totalSteps,
    required this.onNext,
  });

  @override
  State<LevelScreen> createState() => _LevelScreenState();
}

class _LevelScreenState extends State<LevelScreen> {
  String? _selectedLevel;

  final List<String> _levels = [
    'High School Student',
    'Gap Year Student',
    'College Student',
    'Graduate Applicant',
  ];

  @override
  Widget build(BuildContext context) {
    final double progress = widget.stepNumber / widget.totalSteps;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose Academic Level'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Step ${widget.stepNumber} of ${widget.totalSteps}',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(value: progress),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.builder(
                itemCount: _levels.length,
                itemBuilder: (context, index) {
                  final level = _levels[index];
                  return RadioListTile<String>(
                    title: Text(level),
                    value: level,
                    groupValue: _selectedLevel,
                    onChanged: (value) {
                      setState(() {
                        _selectedLevel = value;
                      });
                    },
                  );
                },
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _selectedLevel == null
                    ? null
                    : () => widget.onNext(_selectedLevel!),
                child: const Text('Next'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}