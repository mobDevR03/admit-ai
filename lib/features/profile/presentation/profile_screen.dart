import 'package:flutter/material.dart';
import '../../onboarding/presentation/onboarding_flow.dart';
import '../../../core/models/user_profile.dart';

class ProfileScreen extends StatelessWidget {
  final UserProfile userProfile;
  final VoidCallback onOpenPlan;
  final VoidCallback onOpenChat;

  const ProfileScreen({
    super.key,
    required this.userProfile,
    required this.onOpenChat,
    required this.onOpenPlan,
  });

  double _calculateProgress() {
    int total = 4;
    int completed = 0;

    bool isFilled(String? value) {
      return value != null &&
        value.trim().isNotEmpty &&
        value != 'Not selected';
    }

    if (isFilled(userProfile.country)) completed++;
    if (isFilled(userProfile.goal)) completed++;
    if (isFilled(userProfile.academicLevel)) completed++;
    if (userProfile.exams.isNotEmpty) completed++;

    return completed / total;
  }

  @override
  Widget build(BuildContext context) {
    final progress = _calculateProgress();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
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
                  '${userProfile.country ?? 'No country'} • ${userProfile.goal ?? 'No goal'}',
                  
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
              ],
            ),
            const SizedBox(height: 24),

            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  children: [
                    _ProfileInfoTile(
                      icon: Icons.public,
                      title: 'Target Country',
                      value: userProfile.country ?? 'Not selected',
                    ),
                    _ProfileInfoTile(
                      icon: Icons.flag,
                      title: 'Goal',
                      value: userProfile.goal ?? 'Not selected',
                    ),
                    _ProfileInfoTile(
                      icon: Icons.school,
                      title: 'Academic Level',
                      value: userProfile.academicLevel ?? 'Not selected',
                    ),
                    _ProfileInfoTile(
                      icon: Icons.assignment,
                      title: 'Exams',
                      value: userProfile.exams.isEmpty
                          ? 'Not selected'
                          : userProfile.exams.join(', '),
                    ),
                  ],
                ),
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
                          builder: (_) => OnboardingFlow(existingProfile: userProfile),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.auto_awesome),
                    title: const Text('Added unis'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: onOpenPlan,
                  ),
                  ListTile(
                    leading: const Icon(Icons.smart_toy),
                    title: const Text('Ask AI Advisor'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: onOpenChat,
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

