import 'level_test_result.dart';

class LevelTestService {
  LevelTestResult evaluate({
    required int correctAnswers,
    required int totalQuestions,
  }) {
    final percentage = (correctAnswers / totalQuestions) * 100;

    if (percentage < 20) {
      return const LevelTestResult(
        level: 'A1',
        score: 15,
        description: 'Beginner',
      );
    } else if (percentage < 40) {
      return const LevelTestResult(
        level: 'A2',
        score: 35,
        description: 'Elementary',
      );
    } else if (percentage < 55) {
      return const LevelTestResult(
        level: 'B1',
        score: 50,
        description: 'Intermediate',
      );
    } else if (percentage < 70) {
      return const LevelTestResult(
        level: 'B2',
        score: 65,
        description: 'Upper-Intermediate',
      );
    } else if (percentage < 85) {
      return const LevelTestResult(
        level: 'C1',
        score: 80,
        description: 'Advanced',
      );
    } else {
      return const LevelTestResult(
        level: 'C2',
        score: 95,
        description: 'Proficient',
      );
    }
  }
}