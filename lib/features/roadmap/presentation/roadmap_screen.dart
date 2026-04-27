import 'package:flutter/material.dart';

import '../../../core/models/user_profile.dart';
import '../../../core/models/admission_task.dart';
import '../../../core/utils/admission_task_generator.dart';

class RoadmapScreen extends StatefulWidget {
  final UserProfile userProfile;

  const RoadmapScreen({
    super.key,
    required this.userProfile,
  });

  @override
  State<RoadmapScreen> createState() => _RoadmapScreenState();
}

class _RoadmapScreenState extends State<RoadmapScreen> {
  late List<AdmissionTask> _tasks;

  @override
  void initState() {
    super.initState();
    _tasks = AdmissionTaskGenerator.generate(widget.userProfile);
  }

  void _toggleTask(int index) {
    setState(() {
      final task = _tasks[index];

      _tasks[index] = AdmissionTask(
        title: task.title,
        description: task.description,
        isCompleted: !task.isCompleted,
      );
    });
  }

  double get _progress {
    final completed = _tasks.where((t) => t.isCompleted).length;
    return completed / _tasks.length;
  }

  @override
  Widget build(BuildContext context) {
    final percent = (_progress * 100).toInt();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Plan'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            'Your roadmap for ${widget.userProfile.country ?? 'study abroad'}',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),

          LinearProgressIndicator(value: _progress),

          const SizedBox(height: 6),

          Text('$percent% completed'),

          const SizedBox(height: 20),

          ..._tasks.asMap().entries.map((entry) {
            final index = entry.key;
            final task = entry.value;

            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                onTap: () => _toggleTask(index),
                leading: Icon(
                  task.isCompleted
                      ? Icons.check_circle
                      : Icons.radio_button_unchecked,
                ),
                title: Text(task.title),
                subtitle: Text(task.description),
              ),
            );
          }),
        ],
      ),
    );
  }
}