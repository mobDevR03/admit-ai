import '../../../core/utils/admission_task_generator.dart';
import 'package:flutter/material.dart';
import '../../roadmap/presentation/roadmap_screen.dart';
import '../../../core/models/user_profile.dart';
import '../../../core/models/admission_task.dart';
import '/level_test/level_test_screen.dart';
import '/level_test/level_test_result.dart';
import '/core/services/user_profile_service.dart';
import '../../chat/presentation/chat_screen.dart';

class HomeScreen extends StatefulWidget {
  final UserProfile userProfile;

  const HomeScreen({
    super.key,
    required this.userProfile,
  });

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

    final completedTaskTitles = await _profileService.loadCompletedTasks(
      userId: _userId,
    );

    if (!mounted) return;

    setState(() {
      _tasks = generatedTasks.map((task) {
        return AdmissionTask(
          title: task.title,
          description: task.description,
          isCompleted: completedTaskTitles.contains(task.title),
        );
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {

    final completedTasks = _tasks.where((task) => task.isCompleted).length;
    final progress = _tasks.isEmpty ? 0.0 : completedTasks / _tasks.length;
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
          
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Icon(Icons.auto_awesome, size: 32),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Your AI-powered admission plan is personalized by your level, goal, and exams.',
                      style: TextStyle(
                        color: Colors.grey.shade800,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          _TargetCard(userProfile: widget.userProfile),

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

          const SizedBox(height: 20),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Need help with your plan?',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Ask AI to explain your roadmap, recommend universities, or improve your application strategy.',
                    style: TextStyle(
                      color: Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
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
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 6),

          Text(
            'Based on your level ${widget.userProfile.academicLevel ?? 'not determined'} and goal ${widget.userProfile.goal ?? 'study abroad'}',
            style: TextStyle(
              color: Colors.grey.shade700,
            ),
          ),

          const SizedBox(height: 12),

          ..._tasks.take(4).map((task) => _TaskTile(task: task)),

          const SizedBox(height: 10),

          TextButton(
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => RoadmapScreen(userProfile: widget.userProfile),
                ),
              );

              await _loadTasks();
            },
            child: const Text('See full plan'),
          ),
        ],
      ),
    );
  }
}

class _TargetCard extends StatefulWidget {
  final UserProfile userProfile;

  const _TargetCard({
    required this.userProfile,
  });

  @override
  State<_TargetCard> createState() => _TargetCardState();
}

class _TargetCardState extends State<_TargetCard> {
  String? _level;

  @override
  void initState() {
    super.initState();
    _level = widget.userProfile.academicLevel;
  }

  Future<void> _openLevelTest(BuildContext context) async {
    final result = await Navigator.push<LevelTestResult>(
      context,
      MaterialPageRoute(
        builder: (_) => const LevelTestScreen(),
      ),
    );

    if (result == null) return;

    final userId = 'test_user';

    await UserProfileService().updateLevel(
      userId: userId,
      level: result.level,
    );

    if (!mounted) return;

    setState(() {
      _level = result.level;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Level saved: ${result.level}'),
      ),
    );
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
            const SizedBox(height: 10),
            _RowItem(Icons.flag, 'Goal', widget.userProfile.goal ?? '-'),
            const SizedBox(height: 10),
            _level == null || _level!.isEmpty
                ? _ActionRowItem(
                    icon: Icons.school,
                    label: 'Level',
                    actionText: 'Take test',
                    onTap: () => _openLevelTest(context),
                  )
                : _RowItem(Icons.school, 'Level', _level!),
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
            Text(
              percent == 0
                  ? 'Start your journey 🚀'
                  : percent < 50
                      ? 'You’re making progress 💪 ($percent%)'
                      : percent < 100
                          ? 'Almost there 🔥 ($percent%)'
                          : 'Ready to apply 🎯',
            ),
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

class _ActionRowItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String actionText;
  final VoidCallback onTap;

  const _ActionRowItem({
    required this.icon,
    required this.label,
    required this.actionText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20),
        const SizedBox(width: 10),
        Text(label),
        const Spacer(),
        TextButton(
          onPressed: onTap,
          child: Text(actionText),
        ),
      ],
    );
  }
}