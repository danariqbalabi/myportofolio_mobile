import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';

class ProjectFormPage extends StatefulWidget {
  const ProjectFormPage({super.key});

  @override
  State<ProjectFormPage> createState() => _ProjectFormPageState();
}

class _ProjectFormPageState extends State<ProjectFormPage> {
  final _formKey = GlobalKey<FormState>();
  String _projectName = '';
  String _description = '';
  String _category = 'Web Development';
  String _technologies = '';
  String _projectLink = '';

  static const _categories = [
    'Web Development',
    'Mobile Development',
    'Machine Learning',
    'Data Science',
    'Other',
  ];

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Proyek berhasil ditambahkan!'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Nama Proyek: $_projectName'),
              Text('Deskripsi: $_description'),
              Text('Kategori: $_category'),
              Text('Teknologi: $_technologies'),
              Text('Tautan: $_projectLink'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('OK'),
          ),
        ],
      ),
    );

    if (!mounted || confirmed != true) return;
    // Reset input fields and their backing values together for the next entry.
    _formKey.currentState!.reset();
    _projectName = '';
    _description = '';
    _category = 'Web Development';
    _technologies = '';
    _projectLink = '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Nama Proyek',
                      hintText: 'Nama Proyek',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) => _projectName = value.trim(),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Nama proyek tidak boleh kosong!';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: TextFormField(
                    maxLines: 5,
                    decoration: const InputDecoration(
                      labelText: 'Deskripsi Proyek',
                      hintText: 'Deskripsi Proyek',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) => _description = value.trim(),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Deskripsi proyek tidak boleh kosong!';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: DropdownButtonFormField<String>(
                    initialValue: 'Web Development',
                    isExpanded: true,
                    decoration: const InputDecoration(
                      labelText: 'Kategori Proyek',
                      border: OutlineInputBorder(),
                    ),
                    items: _categories
                        .map(
                          (category) => DropdownMenuItem(
                            value: category,
                            child: Text(category),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      _category = value ?? 'Web Development';
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Teknologi yang Digunakan',
                      hintText: 'Contoh: Flutter, Django, Figma',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) => _technologies = value.trim(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: TextFormField(
                    keyboardType: TextInputType.url,
                    decoration: const InputDecoration(
                      labelText: 'Tautan Proyek',
                      hintText: 'URL Proyek (opsional)',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) => _projectLink = value.trim(),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: _submitForm,
                      child: const Text('Save'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
