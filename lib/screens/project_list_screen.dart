import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';
import 'package:myportofolio_mobile/models/project.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/screens/project_detail_screen.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';

class ProjectListScreen extends StatefulWidget {
  const ProjectListScreen({super.key});
  @override
  State<ProjectListScreen> createState() => _ProjectListScreenState();
}

class _ProjectListScreenState extends State<ProjectListScreen> {
  late Future<List<Project>> _projectsFuture;
  @override
  void initState() {
    super.initState();
    _projectsFuture = context.read<ApiClient>().getProjects();
  }

  Future<void> _reload() async {
    final future = context.read<ApiClient>().getProjects();
    setState(() {
      _projectsFuture = future;
    });
    try {
      await future;
    } catch (_) {
      // FutureBuilder renders request failures, including refresh failures.
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Daftar Proyek')),
    drawer: const LeftDrawer(),
    body: FutureBuilder<List<Project>>(
      future: _projectsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Proyek belum dapat dimuat. Periksa koneksi ke server.',
                  ),
                  ElevatedButton.icon(
                    onPressed: _reload,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Coba Lagi'),
                  ),
                ],
              ),
            ),
          );
        }
        final projects = snapshot.data ?? const <Project>[];
        return RefreshIndicator(
          onRefresh: _reload,
          child: projects.isEmpty
              ? ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: const [
                    Padding(
                      padding: EdgeInsets.all(24),
                      child: Center(child: Text('Belum ada proyek.')),
                    ),
                  ],
                )
              : ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: projects.length,
                  itemBuilder: (context, index) {
                    final project = projects[index];
                    return Card(
                      child: ListTile(
                        title: Text(project.title),
                        subtitle: Text(
                          '${project.techStack}\n${project.description}',
                        ),
                        isThreeLine: true,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ProjectDetailScreen(project: project),
                          ),
                        ),
                      ),
                    );
                  },
                ),
        );
      },
    ),
  );
}
