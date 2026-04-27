import '../models/user_profile.dart';

class FakeAIService {
  static String getResponse(String message, UserProfile userProfile) {
    final lower = message.toLowerCase();

    if (lower.contains('plan')) {
      return _generatePlan(userProfile);
    }

    if (lower.contains('exam')) {
      return _getExams(userProfile);
    }

    return _defaultResponse();
  }

  static String _generatePlan(UserProfile userProfile) {
    final country = userProfile.country ?? 'your target country';

    return '''
Here is your personalized admission plan for $country:

1. Research universities
2. Prepare required exams
3. Build strong application profile
4. Submit applications before deadlines
5. Prepare for interviews

Stay consistent and follow your roadmap 🚀
''';
  }

  static String _getExams(UserProfile userProfile) {
    final country = userProfile.country ?? '';

    if (country == 'USA') {
      return 'For USA you usually need: IELTS/TOEFL + SAT/ACT.';
    }

    if (country == 'China') {
      return 'For China you usually need: HSK + sometimes IELTS.';
    }

    return 'You usually need an English proficiency exam like IELTS or TOEFL.';
  }

  static String _defaultResponse() {
    return 'I can help you with your admission plan, exams, and universities.';
  }
}