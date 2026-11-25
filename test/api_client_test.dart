import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:myportofolio_mobile/models/project.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';

void main() {
  const project = Project(
    title: 'Proyek',
    description: 'Deskripsi',
    techStack: 'Flutter',
    projectUrl: 'https://example.com',
  );
  test('Model memakai snake case dan mengabaikan id saat POST', () {
    final parsed = Project.fromJson({
      ...project.toJson(),
      'id': 'uuid',
      'project_image_url': null,
    });
    expect(parsed.id, 'uuid');
    expect(parsed.projectImageUrl, '');
    expect(parsed.toJson().containsKey('id'), isFalse);
    expect(parsed.toJson()['tech_stack'], 'Flutter');
  });
  test('GET publik dan POST mengirim JSON serta header token', () async {
    final api = ApiClient(
      baseUrl: 'http://localhost:8000/',
      client: MockClient((request) async {
        expect(request.url.path, '/api/v1/projects/');
        if (request.method == 'GET') {
          expect(request.headers.containsKey('Authorization'), isFalse);
          return http.Response(jsonEncode([project.toJson()]), 200);
        }
        expect(request.headers['Authorization'], 'Token token-test');
        expect(request.headers['Content-Type'], contains('application/json'));
        expect(jsonDecode(request.body), project.toJson());
        return http.Response(
          jsonEncode({...project.toJson(), 'id': 'uuid'}),
          201,
        );
      }),
    );
    expect((await api.getProjects()).single.title, 'Proyek');
    expect((await api.createProject(project, token: 'token-test')).id, 'uuid');
  });
  test(
    'Login menyimpan token dan logout menghapusnya walau server gagal',
    () async {
      final api = ApiClient(
        client: MockClient((request) async {
          if (request.url.path.endsWith('token/')) {
            expect(jsonDecode(request.body), {
              'username': 'owner',
              'password': 'password',
            });
            return http.Response('{"token":"token-test"}', 200);
          }
          expect(request.headers['Authorization'], 'Token token-test');
          return http.Response('server error', 500);
        }),
      );
      final auth = AuthState(api);
      await auth.login('owner', 'password');
      expect(auth.isLoggedIn, isTrue);
      await expectLater(auth.logout(), throwsA(isA<ApiException>()));
      expect(auth.token, isNull);
    },
  );
}
