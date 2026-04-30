import 'dart:convert';

import 'package:admit_ai/core/models/user_profile.dart';
import 'package:http/http.dart' as http;

class AiService {
  static const String _apiKey = String.fromEnvironment('OPENROUTER_API_KEY');

  Future<String> sendMessage(String message, UserProfile profile) async {
    if (_apiKey.isEmpty) {
      return 'OpenRouter API key is missing. Run app with --dart-define=OPENROUTER_API_KEY=your_key';
    }

    final uri = Uri.parse('https://openrouter.ai/api/v1/chat/completions');

    final userContext = 
    '''
      User profile:
      - Target country: ${profile.country ?? 'Not selected'}
      - Goal: ${profile.goal ?? 'Not selected'}
      - Academic level: ${profile.academicLevel ?? 'Not selected'}
      - Exams: ${profile.exams.isEmpty ? 'None' : profile.exams.join(', ')}
    ''';

    for (int attempt = 1; attempt <= 3; attempt++) {
      try {
        final response = await http   
            .post(
              uri,
              headers: {
                'Content-Type': 'application/json',
                'Authorization': 'Bearer $_apiKey',
                'HTTP-Referer': 'https://admitai.app',
                'X-Title': 'AdmitAI',
              },
              body: jsonEncode({
                'model': 'openrouter/free',
                'messages': [
                  {
                    'role': 'system',
                    'content': '''
              You are AdmitAI, a university admissions advisor.

              Student:
              - Country: ${profile.country ?? 'Unknown'}
              - Goal: ${profile.goal ?? 'Unknown'}
              - Level: ${profile.academicLevel ?? 'Unknown'}
              - Exams: ${profile.exams.isEmpty ? 'None' : profile.exams.join(', ')}

              Give specific, practical, step-by-step advice.
              '''
                  },
                  {
                    'role': 'user',
                    'content': message,
                  },
                ],
              }),
            )
            .timeout(const Duration(seconds: 25));

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);

          return data['choices']?[0]?['message']?['content'] ??
              'No response from AI.';
        }

        if (response.statusCode == 429 ||
            response.statusCode == 500 ||
            response.statusCode == 502 ||
            response.statusCode == 503) {
          await Future.delayed(Duration(seconds: attempt * 2));
          continue;
        }

        if (response.statusCode == 401) {
          return 'AI authorization failed. Check your OpenRouter API key.';
        }

        if (response.statusCode == 402) {
          return 'OpenRouter balance or free limit issue. Check your OpenRouter account.';
        }

        if (response.statusCode == 404) {
          return 'AI model not found. Check selected OpenRouter model.';
        }

        return 'AI error: ${response.statusCode}';
      } catch (e) {
        await Future.delayed(Duration(seconds: attempt * 2));
      }
    }

    return 'AI is temporarily unavailable. Please try again in a few seconds.';
  }
}