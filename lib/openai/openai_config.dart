import 'dart:convert';
import 'package:http/http.dart' as http;

class OpenAiConfig {
  static const apiKey = String.fromEnvironment('OPENAI_PROXY_API_KEY', defaultValue: 'dummy_key');
  static const endpoint = String.fromEnvironment('OPENAI_PROXY_ENDPOINT');

  static Future<String> getChatResponse({
    required String systemPrompt,
    required List<Map<String, String>> chatHistory,
  }) async {
    if (apiKey.isEmpty || endpoint.isEmpty) {
      throw Exception('OpenAI API key or endpoint is missing.');
    }

    final messages = [
      {'role': 'system', 'content': systemPrompt},
      ...chatHistory,
    ];

    final response = await http.post(
      Uri.parse(endpoint),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode({
        'model': 'gpt-4o',
        'messages': messages,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      return data['choices'][0]['message']['content'];
    } else {
      throw Exception('Failed to get response from OpenAI: ${response.statusCode} - ${response.body}');
    }
  }
}
