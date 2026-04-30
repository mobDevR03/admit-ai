import 'package:flutter/material.dart';
import 'package:admit_ai/core/models/user_profile.dart';
import 'package:admit_ai/core/models/admission_task.dart';
import 'package:admit_ai/core/services/user_profile_service.dart';
import 'package:admit_ai/features/roadmap/presentation/roadmap_screen.dart';
import 'package:admit_ai/features/chat/presentation/chat_screen.dart';
import 'package:admit_ai/core/utils/admission_task_generator.dart';
import '../../../level_test/level_test_screen.dart';

class HomeScreen extends StatefulWidget {
  final UserProfile userProfile;

  const HomeScreen({super.key, required this.userProfile});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final UserProfileService _profileService = UserProfileService();
  final String _userId = 'test_user';

  List<AdmissionTask> _tasks = [];

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final generatedTasks = AdmissionTaskGenerator.generate(widget.userProfile);

    final completed = await _profileService.loadCompletedTasks(userId: _userId);

    if (!mounted) return;

    setState(() {
      _tasks = generatedTasks.map((task) {
        return AdmissionTask(
          title: task.title,
          description: task.description,
          isCompleted: completed.contains(task.title),
        );
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final completed = _tasks.where((t) => t.isCompleted).length;
    final progress = _tasks.isEmpty ? 0.0 : completed / _tasks.length;
    final percent = (progress * 100).toInt();

    return Scaffold(
      appBar: AppBar(title: const Text('AdmitAI')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Welcome back 👋',
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 20),

          _TargetCard(userProfile: widget.userProfile),

          const SizedBox(height: 20),

          _ProgressCard(progress: progress, percent: percent),

          const SizedBox(height: 20),

          const Text(
            'Next steps',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 12),

          ..._tasks.take(4).map((t) => _TaskTile(task: t)),

          TextButton(
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      RoadmapScreen(userProfile: widget.userProfile),
                ),
              );
              _loadTasks();
            },
            child: const Text('See full plan'),
          ),

          const SizedBox(height: 20),

          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ChatScreen(userProfile: widget.userProfile),
                ),
              );
            },
            icon: const Icon(Icons.auto_awesome),
            label: const Text('Ask AI about my plan'),
          ),
        ],
      ),
    );
  }
}

class _TargetCard extends StatefulWidget {
  final UserProfile userProfile;

  const _TargetCard({required this.userProfile});

  @override
  State<_TargetCard> createState() => _TargetCardState();
}

class _TargetCardState extends State<_TargetCard> {
  String? _academicLevel;

  @override
  void initState() {
    super.initState();
    _academicLevel = widget.userProfile.academicLevel;
  }

  Future<void> _openLevelTest() async {
    final result = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (_) => const LevelTestScreen(),
      ),
    );

    if (result == null) return;

    setState(() {
      _academicLevel = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    final exams = widget.userProfile.exams.isEmpty
        ? 'Not selected'
        : widget.userProfile.exams.join(', ');

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _RowItem(Icons.public, 'Country', widget.userProfile.country ?? '-'),
            _RowItem(Icons.flag, 'Goal', widget.userProfile.goal ?? '-'),
            _RowItem(
              Icons.school,
              'Level',
              _academicLevel ?? 'Take test',
              onTap: _academicLevel == null ? _openLevelTest : null,
            ),
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

  const _ProgressCard({required this.progress, required this.percent});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Admission progress',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            LinearProgressIndicator(value: progress),
            const SizedBox(height: 6),
            Text('$percent%'),
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
          task.isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
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
  final VoidCallback? onTap;

  const _RowItem(
    this.icon,
    this.label,
    this.value, {
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final valueWidget = Text(
      value,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        color: onTap != null ? Colors.deepPurple : Colors.black,
        fontWeight: onTap != null ? FontWeight.w600 : FontWeight.normal,
      ),
    );

    return Row(
      children: [
        Icon(icon, size: 20),
        const SizedBox(width: 10),
        Text(label),
        const Spacer(),
        onTap == null
            ? valueWidget
            : GestureDetector(
                onTap: onTap,
                child: valueWidget,
              ),
      ],
    );
  }
}
