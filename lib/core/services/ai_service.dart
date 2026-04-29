import 'dart:convert';

import 'package:http/http.dart' as http;

class AiService {
  static const String _apiKey = String.fromEnvironment('OPENROUTER_API_KEY');

  Future<String> sendMessage(String message) async {
    if (_apiKey.isEmpty) {
      return 'OpenRouter API key is missing. Run app with --dart-define=OPENROUTER_API_KEY=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';
    }

    final uri = Uri.parse('https://openrouter.ai/api/v1/chat/completions');

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
                    'content':
                        'You are AdmitAI, an admissions assistant. Help students with university admission, exams, motivation letters, recommendation letters, volunteering, projects, and application planning. Answer clearly and practically.',
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

        return 'AI error: ${response.statusCode}';
      } catch (_) {
        await Future.delayed(Duration(seconds: attempt * 2));
      }
    }

    return 'AI is temporarily unavailable. Please try again in a few seconds.';
  }
}