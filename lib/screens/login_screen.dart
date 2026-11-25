import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String _username = '';
  String _password = '';
  bool _isSubmitting = false;

  Future<void> _submit() async {
    if (_isSubmitting || !_formKey.currentState!.validate()) return;
    setState(() => _isSubmitting = true);
    try {
      await context.read<AuthState>().login(_username.trim(), _password);
      if (!mounted) return;
      Navigator.pop(context, true);
    } on ApiException catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(
              error.statusCode == 400
                  ? 'Username atau password salah (400).'
                  : error.userMessage,
            ),
          ),
        );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text('Tidak dapat terhubung ke server. Coba lagi.'),
          ),
        );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Login')),
    body: SafeArea(
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) => _username = value,
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Username wajib diisi.'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) => _password = value,
                validator: (value) => value == null || value.isEmpty
                    ? 'Password wajib diisi.'
                    : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isSubmitting ? null : _submit,
                child: Text(_isSubmitting ? 'Memproses...' : 'Login'),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
