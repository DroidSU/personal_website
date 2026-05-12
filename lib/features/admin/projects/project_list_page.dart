import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/models/project_model.dart';
import '../../projects/providers/projects_provider.dart';
import '../providers/admin_provider.dart';
import '../widgets/admin_common_widgets.dart';

class ProjectListPage extends ConsumerWidget {
  const ProjectListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projectsAsync = ref.watch(adminProjectsProvider);

    return Column(
      children: [
        AdminSectionTitle(
          title: 'Projects',
          actions: [
            ElevatedButton.icon(
              onPressed: () => context.go('/admin/projects/new'),
              icon: const Icon(Icons.add),
              label: const Text('Add Project'),
            ),
          ],
        ),
        Expanded(
          child: projectsAsync.when(
            data: (projects) => ListView.builder(
              itemCount: projects.length,
              itemBuilder: (context, index) {
                final project = projects[index];
                return _ProjectListItem(project: project);
              },
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, s) => Center(child: Text('Error: $e', style: const TextStyle(color: Colors.red))),
          ),
        ),
      ],
    );
  }
}

class _ProjectListItem extends ConsumerWidget {
  final ProjectModel project;

  const _ProjectListItem({required this.project});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      color: const Color(0xFF1E1E1E),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.white.withOpacity(0.05)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: Container(
          width: 80,
          height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            image: DecorationImage(
              image: NetworkImage(project.coverImage),
              fit: BoxFit.cover,
            ),
          ),
        ),
        title: Text(project.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(project.platform, style: TextStyle(color: Colors.white.withOpacity(0.5))),
            const SizedBox(height: 4),
            Row(
              children: [
                if (project.featured)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(color: Colors.amber.withOpacity(0.2), borderRadius: BorderRadius.circular(4)),
                    child: const Text('Featured', style: TextStyle(color: Colors.amber, fontSize: 10)),
                  ),
                const SizedBox(width: 8),
                Text(project.status, style: const TextStyle(color: Colors.blue, fontSize: 10)),
              ],
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.grey),
              onPressed: () => context.go('/admin/projects/edit/${project.slug}'),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.redAccent),
              onPressed: () async {
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (context) => const ConfirmDeleteDialog(
                    title: 'Delete Project',
                    content: 'Are you sure you want to delete this project? This action cannot be undone.',
                  ),
                );

                if (confirmed == true) {
                  try {
                    await ref.read(projectRepositoryProvider).deleteProject(project.id);
                    ref.invalidate(adminProjectsProvider);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Project deleted successfully')));
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red));
                    }
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
