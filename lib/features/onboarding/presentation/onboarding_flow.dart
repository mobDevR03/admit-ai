import 'package:flutter/material.dart';

import '../../../app/app.dart';
import '../../../core/models/user_profile.dart';
import 'screens/welcome_screen.dart';
import 'screens/country_screen.dart';
import 'screens/goal_screen.dart';
import 'screens/level_screen.dart';
import 'screens/exams_screen.dart';

class OnboardingFlow extends StatefulWidget {
  final UserProfile? existingProfile;

  const OnboardingFlow({super.key, this.existingProfile});

  @override
  State<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<OnboardingFlow> {
  late UserProfile _userProfile;

  @override
  void initState() {
    super.initState();

    _userProfile = widget.existingProfile ?? UserProfile();
  }

  void _startOnboarding() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CountryScreen(
          stepNumber: 1,
          totalSteps: 4,
          onNext: (selectedCountry) {
            _userProfile.country = selectedCountry;
            _goToGoalScreen();
          },
        ),
      ),
    );
  }

  void _goToGoalScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => GoalScreen(
          stepNumber: 2,
          totalSteps: 4,
          onNext: (selectedGoal) {
            _userProfile.goal = selectedGoal;
            _goToLevelScreen();
          },
        ),
      ),
    );
  }

  void _goToLevelScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => LevelScreen(
          stepNumber: 3,
          totalSteps: 4,
          onNext: (selectedLevel) {
            _userProfile.level = selectedLevel;
            _goToExamsScreen();
          },
        ),
      ),
    );
  }

  void _goToExamsScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ExamsScreen(
          stepNumber: 4,
          totalSteps: 4,
          selectedCountry: _userProfile.country!,
          onFinish: (selectedExams) {
            _userProfile.exams = selectedExams;
            _finishOnboarding();
          },
        ),
      ),
    );
  }

  void _finishOnboarding() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => MainNavigation(userProfile: _userProfile),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return WelcomeScreen(onStart: _startOnboarding);
  }
}
