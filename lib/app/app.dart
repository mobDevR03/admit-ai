import 'package:flutter/material.dart';
import '../features/universities/presentation/saved_universities_screen.dart';
import '../core/models/user_profile.dart';
import '../features/onboarding/presentation/onboarding_flow.dart';
import '../features/home/presentation/home_screen.dart';
import '../features/chat/presentation/chat_screen.dart';
import '../features/universities/presentation/universities_screen.dart';
import '../features/profile/presentation/profile_screen.dart';
import '../core/theme/app_theme.dart';

class AdmitAIApp extends StatelessWidget {
  const AdmitAIApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AdmitAI',
      theme: AppTheme.light,
      home: const OnboardingFlow(),
    );
  }
}

class MainNavigation extends StatefulWidget {
  final UserProfile userProfile;

  const MainNavigation({
    super.key,
    required this.userProfile,
  });

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();

    _screens = [
      HomeScreen(userProfile: widget.userProfile),
      const SavedUniversitiesScreen(),
      ChatScreen(userProfile: widget.userProfile),
      UniversitiesScreen(userProfile: widget.userProfile),
      ProfileScreen(
        userProfile: widget.userProfile,
        onOpenPlan: () {
          setState(() {
            _currentIndex = 1;
          });
        },
        onOpenChat: () {
          setState(() {
            _currentIndex = 2;
          });
        },
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Plan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Unis',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}