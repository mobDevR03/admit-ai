import 'package:flutter/material.dart';

import 'package:admit_ai/core/models/admission_task.dart';
import 'package:admit_ai/core/models/user_profile.dart';
import 'package:admit_ai/core/services/user_profile_service.dart';
import 'package:admit_ai/core/utils/admission_task_generator.dart';
import 'package:admit_ai/features/onboarding/presentation/onboarding_flow.dart';

class ProfileScreen extends StatefulWidget {
  final UserProfile userProfile;
  final VoidCallback onOpenPlan;
  final VoidCallback onOpenChat;

  const ProfileScreen({
    super.key,
    required this.userProfile,
    required this.onOpenPlan,
    required this.onOpenChat,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final UserProfileService _profileService = UserProfileService();
  final String _userId = 'test_user';

  List<AdmissionTask> _tasks = [];

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  @override
  void didUpdateWidget(covariant ProfileScreen oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.userProfile != widget.userProfile) {
      _loadTasks();
    }
  }

  Future<void> _loadTasks() async {
    final generatedTasks = AdmissionTaskGenerator.generate(widget.userProfile);

    final completedTasks = await _profileService.loadCompletedTasks(
      userId: _userId,
    );

    if (!mounted) return;

    setState(() {
      _tasks = generatedTasks.map((task) {
        return AdmissionTask(
          title: task.title,
          description: task.description,
          isCompleted: completedTasks.contains(task.title),
        );
      }).toList();
    });
  }

  double _calculateProgress() {
    final completed = _tasks.where((task) => task.isCompleted).length;
    return _tasks.isEmpty ? 0.0 : completed / _tasks.length;
  }

  @override
  Widget build(BuildContext context) {
    final progress = _calculateProgress();
    final percent = (progress * 100).toInt();

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: ListView(
          children: [
            Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.blue.shade100,
                  child: const Icon(
                    Icons.person,
                    size: 40,
                    color: Colors.blue,
                  ),
                ),

                const SizedBox(height: 12),

                Text(
                  '${widget.userProfile.country ?? 'No country'} • ${widget.userProfile.goal ?? 'No goal'}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 4),

                const Text(
                  'Your personalized admission journey',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),

                const SizedBox(height: 16),

                LinearProgressIndicator(value: progress),

                const SizedBox(height: 6),

                Text(
                  '$percent% completed',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 2,
              child: Column(
                children: [
                  _ProfileInfoTile(
                    icon: Icons.public,
                    title: 'Target Country',
                    value: widget.userProfile.country ?? 'Not selected',
                  ),
                  _ProfileInfoTile(
                    icon: Icons.flag,
                    title: 'Goal',
                    value: widget.userProfile.goal ?? 'Not selected',
                  ),
                  _ProfileInfoTile(
                    icon: Icons.school,
                    title: 'Academic Level',
                    value: widget.userProfile.academicLevel ?? 'Not selected',
                  ),
                  _ProfileInfoTile(
                    icon: Icons.assignment,
                    title: 'Exams',
                    value: widget.userProfile.exams.isEmpty
                        ? 'Not selected'
                        : widget.userProfile.exams.join(', '),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 2,
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.edit),
                    title: const Text('Edit Profile'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => OnboardingFlow(
                            existingProfile: widget.userProfile,
                          ),
                        ),
                      );

                      await _loadTasks();
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.auto_awesome),
                    title: const Text('My Plan'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: widget.onOpenPlan,
                  ),
                  ListTile(
                    leading: const Icon(Icons.smart_toy),
                    title: const Text('Ask AI Advisor'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: widget.onOpenChat,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileInfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _ProfileInfoTile({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(value),
    );
  }
}