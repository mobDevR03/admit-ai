import '../../../core/utils/admission_task_generator.dart';
import 'package:flutter/material.dart';
import '../../roadmap/presentation/roadmap_screen.dart';
import '../../../core/models/user_profile.dart';
import '../../../core/models/admission_task.dart';

class HomeScreen extends StatelessWidget {
  final UserProfile userProfile;

  const HomeScreen({
    super.key,
    required this.userProfile,
  });

  @override
  Widget build(BuildContext context) {

    final tasks = AdmissionTaskGenerator.generate(userProfile);
    final completedTasks = tasks.where((task) => task.isCompleted).length;
    final progress = completedTasks / tasks.length;
    final progressPercent = (progress * 100).toInt();

    return Scaffold(
      appBar: AppBar(
        title: const Text('AdmitAI'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Welcome back 👋',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),

          _TargetCard(userProfile: userProfile),

          const SizedBox(height: 20),

          _ProgressCard(
            progress: progress,
            percent: progressPercent,
          ),

          const SizedBox(height: 20),

          const Text(
            'Next steps',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          ...tasks.take(2).map((task) => _TaskTile(task: task)),

          const SizedBox(height: 10),

          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => RoadmapScreen(userProfile: userProfile),
                ),
              );
            },
            child: const Text('See full plan'),
          ),
        ],
      ),
    );
  }
}

class _TargetCard extends StatelessWidget {
  final UserProfile userProfile;

  const _TargetCard({
    required this.userProfile,
  });

  @override
  Widget build(BuildContext context) {
    final exams = userProfile.exams.isEmpty
        ? 'Not selected'
        : userProfile.exams.join(', ');

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _RowItem(Icons.public, 'Country', userProfile.country ?? '-'),
            const SizedBox(height: 10),
            _RowItem(Icons.flag, 'Goal', userProfile.goal ?? '-'),
            const SizedBox(height: 10),
            _RowItem(Icons.school, 'Level', userProfile.academicLevel ?? '-'),
            const SizedBox(height: 10),
            _RowItem(Icons.assignment, 'Exams', exams),
          ],
        ),
      ),
    );
  }
}

class _ProgressCard extends StatelessWidget {
  final double progress;
  final int percent;

  const _ProgressCard({
    required this.progress,
    required this.percent,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Admission progress',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            LinearProgressIndicator(value: progress),
            const SizedBox(height: 6),
            Text('$percent% completed'),
          ],
        ),
      ),
    );
  }
}

class _TaskTile extends StatelessWidget {
  final AdmissionTask task;

  const _TaskTile({required this.task});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: Icon(
          task.isCompleted
              ? Icons.check_circle
              : Icons.radio_button_unchecked,
        ),
        title: Text(task.title),
        subtitle: Text(task.description),
      ),
    );
  }
}

class _RowItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _RowItem(this.icon, this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20),
        const SizedBox(width: 10),
        Text(label),
        const Spacer(),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}