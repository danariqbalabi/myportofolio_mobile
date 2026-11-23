import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';

class GalleryFormPage extends StatefulWidget {
  const GalleryFormPage({super.key});

  @override
  State<GalleryFormPage> createState() => _GalleryFormPageState();
}

class _GalleryFormPageState extends State<GalleryFormPage> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _year = '';
  String _image = '';
  String _caption = '';
  String _category = '';
  String _location = '';
  bool _featured = false;

  String? _validateImage(String? value) {
    final image = value?.trim() ?? '';
    if (image.isEmpty) return 'Gambar wajib diisi.';
    if (image.length > 500) return 'Gambar maksimal 500 karakter.';
    final uri = Uri.tryParse(image);
    if (uri == null || RegExp(r'\s').hasMatch(image)) {
      return 'Gunakan URL http/https atau path /static/img/.';
    }
    final isUrl =
        (uri.scheme == 'http' || uri.scheme == 'https') &&
        uri.host.isNotEmpty &&
        uri.userInfo.isEmpty;
    final isStaticPath =
        !uri.hasScheme &&
        !uri.hasAuthority &&
        uri.path.startsWith('/static/img/') &&
        uri.path.substring('/static/img/'.length).isNotEmpty &&
        !uri.pathSegments.any((segment) => segment == '.' || segment == '..');
    if (!isUrl && !isStaticPath) {
      return 'Gunakan URL http/https atau path /static/img/.';
    }
    return null;
  }

  void _submitForm() {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    FocusScope.of(context).unfocus();
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        scrollable: true,
        title: const Text('Ringkasan Foto Gallery'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Judul: $_title'),
              Text('Tahun: $_year'),
              Text('Gambar: $_image'),
              Text('Caption: ${_caption.isEmpty ? '-' : _caption}'),
              Text('Kategori: ${_category.isEmpty ? '-' : _category}'),
              Text('Lokasi: ${_location.isEmpty ? '-' : _location}'),
              Text('Featured: ${_featured ? 'Ya' : 'Tidak'}'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Foto Gallery'),
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
                    labelText: 'Judul',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    final title = value?.trim() ?? '';
                    if (title.isEmpty) return 'Judul wajib diisi.';
                    if (title.length > 255) {
                      return 'Judul maksimal 255 karakter.';
                    }
                    return null;
                  },
                  onSaved: (value) => _title = value!.trim(),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Tahun',
                    hintText: '2000 sampai 2100',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    final text = value?.trim() ?? '';
                    if (text.isEmpty) return 'Tahun wajib diisi.';
                    if (!RegExp(r'^\d+$').hasMatch(text)) {
                      return 'Tahun harus berupa angka bulat.';
                    }
                    final year = int.tryParse(text);
                    if (year == null || year < 2000 || year > 2100) {
                      return 'Tahun harus antara 2000 dan 2100.';
                    }
                    return null;
                  },
                  onSaved: (value) => _year = value!.trim(),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  keyboardType: TextInputType.url,
                  decoration: const InputDecoration(
                    labelText: 'Gambar',
                    hintText: 'https://example.com/foto.jpg',
                    helperText: 'URL http/https atau path /static/img/foto.jpg',
                    helperMaxLines: 2,
                    errorMaxLines: 2,
                    border: OutlineInputBorder(),
                  ),
                  validator: _validateImage,
                  onSaved: (value) => _image = value!.trim(),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Caption (opsional)',
                    border: OutlineInputBorder(),
                  ),
                  onSaved: (value) => _caption = value?.trim() ?? '',
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Kategori (opsional)',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if ((value?.trim().length ?? 0) > 100) {
                      return 'Kategori maksimal 100 karakter.';
                    }
                    return null;
                  },
                  onSaved: (value) => _category = value?.trim() ?? '',
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Lokasi (opsional)',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if ((value?.trim().length ?? 0) > 255) {
                      return 'Lokasi maksimal 255 karakter.';
                    }
                    return null;
                  },
                  onSaved: (value) => _location = value?.trim() ?? '',
                ),
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Tampilkan sebagai Featured'),
                  value: _featured,
                  onChanged: (value) {
                    setState(() => _featured = value ?? false);
                  },
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: _submitForm,
                  child: const Text('Simpan'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
