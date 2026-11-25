import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';
import 'package:myportofolio_mobile/screens/login_screen.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';

Future<bool> ensureLoggedIn(BuildContext context) async {
  if (context.read<AuthState>().isLoggedIn) return true;
  return await Navigator.push<bool>(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      ) ??
      false;
}

Future<void> logoutWithFeedback(BuildContext context) async {
  final auth = context.read<AuthState>();
  if (!auth.isLoggedIn) {
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Kamu belum login.')));
    return;
  }
  String message = 'Berhasil logout.';
  try {
    await auth.logout();
  } catch (_) {
    message = 'Sesi lokal ditutup. Server belum berhasil mencabut token.';
  }
  if (!context.mounted) return;
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));
}
