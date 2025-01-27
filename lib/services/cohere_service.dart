import 'dart:convert';
import 'package:http/http.dart' as http;

class CohereService {
  static const String _baseUrl = 'https://api.cohere.ai/v1/generate';
  final String _apiKey =
      '7DNoJE0QGQI0roKdN4shT9JW0SU7FNUldPcYyr0V'; // Replace with your actual API key

  Future<Map<String, dynamic>> generateRecommendations(String prompt) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'model': 'command',
          'prompt': prompt,
          'max_tokens': 1000,
          'temperature': 0.7,
          'format': 'json',
        }),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final generatedText = jsonResponse['generations'][0]['text'];
        return jsonDecode(generatedText);
      } else {
        throw Exception(
            'Failed to generate recommendations: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error generating recommendations: $e');
    }
  }
}
