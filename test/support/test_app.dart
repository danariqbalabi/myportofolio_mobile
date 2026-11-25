import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';
import 'package:myportofolio_mobile/screens/menu.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';

Widget testApp({
  Widget home = const MyHomePage(),
  String? token = 'test-token',
  ApiClient? api,
}) {
  final client =
      api ??
      ApiClient(
        client: MockClient((request) async {
          if (request.url.path.endsWith('/auth/token/')) {
            return http.Response('{"token":"test-token"}', 200);
          }
          if (request.url.path.endsWith('/auth/logout/')) {
            return http.Response('', 204);
          }
          if (request.method == 'POST') {
            return http.Response(
              jsonEncode({
                ...jsonDecode(request.body) as Map<String, dynamic>,
                'id': 'project-id',
              }),
              201,
            );
          }
          return http.Response('[]', 200);
        }),
      );
  return MultiProvider(
    providers: [
      Provider<ApiClient>.value(value: client),
      ChangeNotifierProvider(
        create: (_) => AuthState(client, initialToken: token),
      ),
    ],
    child: MaterialApp(home: home),
  );
}
