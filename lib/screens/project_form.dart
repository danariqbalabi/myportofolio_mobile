import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';
import 'package:myportofolio_mobile/models/project.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:myportofolio_mobile/widgets/auth_guard.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';

class ProjectFormPage extends StatefulWidget {
  const ProjectFormPage({super.key});
  @override
  State<ProjectFormPage> createState() => _ProjectFormPageState();
}

class _ProjectFormPageState extends State<ProjectFormPage> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _description = '';
  String _techStack = '';
  String _projectUrl = '';
  String _imageUrl = '';
  bool _isSubmitting = false;

  String? _validateUrl(String? value, {bool optional = false}) {
    final text = value?.trim() ?? '';
    if (optional && text.isEmpty) return null;
    final uri = Uri.tryParse(text);
    if (uri == null ||
        !['http', 'https'].contains(uri.scheme) ||
        uri.host.isEmpty ||
        RegExp(r'\s').hasMatch(text)) {
      return 'Masukkan URL http/https yang valid.';
    }
    if (text.length > 200) return 'URL maksimal 200 karakter.';
    return null;
  }

  Future<void> _submitForm() async {
    if (_isSubmitting || !_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    setState(() => _isSubmitting = true);
    try {
      if (!await ensureLoggedIn(context) || !mounted) return;
      final auth = context.read<AuthState>();
      final token = auth.token;
      if (token == null) return;
      final saved = await context.read<ApiClient>().createProject(
        Project(
          title: _title,
          description: _description,
          techStack: _techStack,
          projectUrl: _projectUrl,
          projectImageUrl: _imageUrl,
        ),
        token: token,
      );
      if (!mounted) return;
      FocusScope.of(context).unfocus();
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          scrollable: true,
          title: const Text('Proyek berhasil ditambahkan!'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Title: ${saved.title}'),
              Text('Description: ${saved.description}'),
              Text('Tech Stack: ${saved.techStack}'),
              Text('Project URL: ${saved.projectUrl}'),
              Text('Project Image URL: ${saved.projectImageUrl}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      if (mounted && confirmed == true) _formKey.currentState!.reset();
    } on ApiException catch (error) {
      if (!mounted) return;
      if (error.statusCode == 401) {
        context.read<AuthState>().clearSession();
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(error.userMessage)));
        await ensureLoggedIn(context);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(error.userMessage)));
      }
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text(
              'Proyek gagal dikirim. Periksa koneksi lalu coba lagi.',
            ),
          ),
        );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Add Project Form'),
      backgroundColor: Theme.of(context).colorScheme.primary,
      foregroundColor: Colors.white,
    ),
    drawer: const LeftDrawer(),
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
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Title wajib diisi.';
                  }
                  if (value.trim().length > 255) {
                    return 'Title maksimal 255 karakter.';
                  }
                  return null;
                },
                onSaved: (value) => _title = value!.trim(),
              ),
              const SizedBox(height: 16),
              TextFormField(
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Description wajib diisi.'
                    : null,
                onSaved: (value) => _description = value!.trim(),
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Tech Stack',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Tech Stack wajib diisi.';
                  }
                  if (value.trim().length > 255) {
                    return 'Tech Stack maksimal 255 karakter.';
                  }
                  return null;
                },
                onSaved: (value) => _techStack = value!.trim(),
              ),
              const SizedBox(height: 16),
              TextFormField(
                keyboardType: TextInputType.url,
                decoration: const InputDecoration(
                  labelText: 'Project URL',
                  border: OutlineInputBorder(),
                ),
                validator: _validateUrl,
                onSaved: (value) => _projectUrl = value!.trim(),
              ),
              const SizedBox(height: 16),
              TextFormField(
                keyboardType: TextInputType.url,
                decoration: const InputDecoration(
                  labelText: 'Project Image URL (Optional)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => _validateUrl(value, optional: true),
                onSaved: (value) => _imageUrl = value?.trim() ?? '',
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _isSubmitting ? null : _submitForm,
                child: Text(_isSubmitting ? 'Mengirim...' : 'Save'),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
