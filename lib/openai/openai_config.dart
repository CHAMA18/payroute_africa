import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class OpenAiConfig {
  static const apiKey = String.fromEnvironment(
    'OPENAI_PROXY_API_KEY',
    defaultValue: 'WHUA3VBMbBy9wsO8BBTh7N1osKzQ0D12',
  );
  static const endpoint = String.fromEnvironment(
    'OPENAI_PROXY_ENDPOINT',
    defaultValue: 'https://ypbhcuyjdaxqtvo2dwfjjsys.agents.do-ai.run/api/v1/chat/completions',
  );

  static Future<String> getChatResponse({
    required String systemPrompt,
    required List<Map<String, String>> chatHistory,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final resolvedEndpoint = endpoint.isNotEmpty
        ? endpoint
        : prefs.getString('openai_proxy_endpoint') ??
            prefs.getString('digitalocean_ai_endpoint') ??
            prefs.getString('agent_endpoint') ??
            '';
    final resolvedApiKey = apiKey.isNotEmpty
        ? apiKey
        : prefs.getString('openai_proxy_api_key') ??
            prefs.getString('digitalocean_ai_api_key') ??
            prefs.getString('agent_api_key') ??
            '';

    if (resolvedEndpoint.isEmpty) {
      throw Exception('AI endpoint is missing.');
    }

    final messages = [
      {'role': 'system', 'content': systemPrompt},
      ...chatHistory,
    ];

    final isDigitalOceanAgentEndpoint =
        resolvedEndpoint.contains('do-ai.run') ||
        resolvedEndpoint.contains('/api/v1/chat/completions');

    final headers = <String, String>{
      'Content-Type': 'application/json',
    };

    if (resolvedApiKey.isNotEmpty) {
      headers['Authorization'] = 'Bearer $resolvedApiKey';
    }

    final body = isDigitalOceanAgentEndpoint
        ? {
            'messages': messages,
            'stream': false,
          }
        : {
            'model': 'gpt-4o',
            'messages': messages,
          };

    final response = await http.post(
      Uri.parse(resolvedEndpoint),
      headers: headers,
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      final content = data['choices']?[0]?['message']?['content'];
      if (content is String && content.isNotEmpty) {
        return content;
      }
      throw Exception('AI response was successful but empty.');
    } else {
      throw Exception('Failed to get AI response: ${response.statusCode} - ${response.body}');
    }
  }
}
