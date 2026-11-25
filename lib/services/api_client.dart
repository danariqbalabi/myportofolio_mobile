import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:myportofolio_mobile/config.dart';
import 'package:myportofolio_mobile/models/project.dart';

class ApiException implements Exception {
  const ApiException(this.statusCode, this.message);
  final int statusCode;
  final String message;

  String get userMessage => switch (statusCode) {
    400 => 'Periksa kembali isian yang dikirim.',
    401 => 'Sesi berakhir. Silakan login lagi.',
    403 => 'Akun ini tidak memiliki izin untuk mengubah proyek.',
    _ => 'Permintaan gagal ($statusCode). Coba lagi nanti.',
  };

  @override
  String toString() => 'ApiException($statusCode)';
}

class ApiClient {
  ApiClient({http.Client? client, this.baseUrl = apiBaseUrl})
    : _client = client ?? http.Client();

  final http.Client _client;
  final String baseUrl;
  static const _jsonHeaders = {
    'Accept': 'application/json',
    'Content-Type': 'application/json; charset=UTF-8',
  };

  Uri _uri(String path) =>
      Uri.parse('${baseUrl.replaceFirst(RegExp(r'/+$'), '')}$path');

  Future<List<Project>> getProjects() async {
    final response = await _client
        .get(
          _uri('/api/v1/projects/'),
          headers: const {'Accept': 'application/json'},
        )
        .timeout(const Duration(seconds: 20));
    _ensureSuccess(response);
    final decoded =
        jsonDecode(utf8.decode(response.bodyBytes)) as List<dynamic>;
    return decoded
        .map((item) => Project.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<Project> createProject(
    Project project, {
    required String token,
  }) async {
    final response = await _client
        .post(
          _uri('/api/v1/projects/'),
          headers: {..._jsonHeaders, 'Authorization': 'Token $token'},
          body: jsonEncode(project.toJson()),
        )
        .timeout(const Duration(seconds: 20));
    _ensureSuccess(response);
    return Project.fromJson(
      jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>,
    );
  }

  Future<String> obtainToken(String username, String password) async {
    final response = await _client
        .post(
          _uri('/api/v1/auth/token/'),
          headers: _jsonHeaders,
          body: jsonEncode({'username': username, 'password': password}),
        )
        .timeout(const Duration(seconds: 20));
    _ensureSuccess(response);
    final token =
        (jsonDecode(response.body) as Map<String, dynamic>)['token'] as String;
    if (token.isEmpty) throw const FormatException('Token kosong');
    return token;
  }

  Future<void> logout({required String token}) async {
    final response = await _client
        .post(
          _uri('/api/v1/auth/logout/'),
          headers: {..._jsonHeaders, 'Authorization': 'Token $token'},
        )
        .timeout(const Duration(seconds: 20));
    _ensureSuccess(response);
  }

  void _ensureSuccess(http.Response response) {
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ApiException(response.statusCode, response.body);
    }
  }

  void close() => _client.close();
}
