import 'package:flutter/material.dart';

class GoalScreen extends StatefulWidget {
  final int stepNumber;
  final int totalSteps;
  final ValueChanged<String> onNext;

  const GoalScreen({
    super.key,
    required this.stepNumber,
    required this.totalSteps,
    required this.onNext,
  });

  @override
  State<GoalScreen> createState() => _GoalScreenState();
}

class _GoalScreenState extends State<GoalScreen> {
  String? _selectedGoal;

  final List<String> _goals = [
    'CS',
    'Business',
    'Medicine',
    'Engineering',
    'Design',
    'Law',
  ];

  @override
  Widget build(BuildContext context) {
    final double progress = widget.stepNumber / widget.totalSteps;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose Goal'),
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
                itemCount: _goals.length,
                itemBuilder: (context, index) {
                  final goal = _goals[index];
                  return RadioListTile<String>(
                    title: Text(goal),
                    value: goal,
                    groupValue: _selectedGoal,
                    onChanged: (value) {
                      setState(() {
                        _selectedGoal = value;
                      });
                    },
                  );
                },
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _selectedGoal == null
                    ? null
                    : () => widget.onNext(_selectedGoal!),
                child: const Text('Next'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}