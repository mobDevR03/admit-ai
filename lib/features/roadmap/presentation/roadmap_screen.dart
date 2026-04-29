import 'package:flutter/material.dart';
import '../../../core/services/user_profile_service.dart';
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
  List<AdmissionTask> _tasks = [];
  final UserProfileService _profileService = UserProfileService();
  final String _userId = 'test_user';

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

  Future<void> _toggleTask(int index) async {
    final task = _tasks[index];

    setState(() {
      _tasks[index] = AdmissionTask(
        title: task.title,
        description: task.description,
        isCompleted: !task.isCompleted,
      );
    });

    final completedTasks = _tasks
        .where((task) => task.isCompleted)
        .map((task) => task.title)
        .toList();

    await _profileService.saveCompletedTasks(
      userId: _userId,
      completedTasks: completedTasks,
    );
  }

  double get _progress {
    if (_tasks.isEmpty) return 0;

    final completed = _tasks.where((task) => task.isCompleted).length;
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

          const SizedBox(height: 8),

          Text(
            'Personalized by your level and exams',
            style: TextStyle(
              color: Colors.grey.shade700,
            ),
          ),

          const SizedBox(height: 20),

          LinearProgressIndicator(value: _progress),

          const SizedBox(height: 8),

          Text('$percent% completed'),

          const SizedBox(height: 20),

          ..._tasks.asMap().entries.map((entry) {
            final index = entry.key;
            final task = entry.value;

            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => _toggleTask(index),
                child: ListTile(
                  leading: Icon(
                    task.isCompleted
                        ? Icons.check_circle
                        : Icons.radio_button_unchecked,
                  ),
                  title: Text(
                    task.title,
                    style: TextStyle(
                      decoration: task.isCompleted
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                  subtitle: Text(task.description),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

