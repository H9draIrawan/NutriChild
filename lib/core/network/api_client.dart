import 'dart:convert';
import 'package:http/http.dart' as http;
import '../error/exceptions.dart';

class ApiClient {
  final http.Client client;
  final String baseUrl;

  ApiClient({
    required this.client,
    required this.baseUrl,
  });

  Future<dynamic> get(
    String endpoint, {
    Map<String, String>? headers,
  }) async {
    try {
      final response = await client.get(
        Uri.parse('$baseUrl$endpoint'),
        headers: headers ?? {'Content-Type': 'application/json'},
      );

      return _handleResponse(response);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  Future<dynamic> post(
    String endpoint, {
    Map<String, String>? headers,
    dynamic body,
  }) async {
    try {
      final response = await client.post(
        Uri.parse('$baseUrl$endpoint'),
        headers: headers ?? {'Content-Type': 'application/json'},
        body: json.encode(body),
      );

      return _handleResponse(response);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return json.decode(response.body);
    } else {
      throw ServerException(
        message: 'Error ${response.statusCode}: ${response.body}',
      );
    }
  }
} 