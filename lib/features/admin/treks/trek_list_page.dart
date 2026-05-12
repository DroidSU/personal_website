import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/models/trek_model.dart';
import '../../treks/providers/treks_provider.dart';
import '../providers/admin_provider.dart';
import '../widgets/admin_common_widgets.dart';

class TrekListPage extends ConsumerWidget {
  const TrekListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final treksAsync = ref.watch(adminTreksProvider);

    return Column(
      children: [
        AdminSectionTitle(
          title: 'Treks',
          actions: [
            ElevatedButton.icon(
              onPressed: () => context.go('/admin/treks/new'),
              icon: const Icon(Icons.add),
              label: const Text('Add Trek'),
            ),
          ],
        ),
        Expanded(
          child: treksAsync.when(
            data: (treks) => ListView.builder(
              itemCount: treks.length,
              itemBuilder: (context, index) {
                final trek = treks[index];
                return _TrekListItem(trek: trek);
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

class _TrekListItem extends ConsumerWidget {
  final TrekModel trek;

  const _TrekListItem({required this.trek});

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
              image: NetworkImage(trek.coverImage),
              fit: BoxFit.cover,
            ),
          ),
        ),
        title: Text(trek.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(trek.location, style: TextStyle(color: Colors.white.withOpacity(0.5))),
            const SizedBox(height: 4),
            Row(
              children: [
                if (trek.featured)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(color: Colors.amber.withOpacity(0.2), borderRadius: BorderRadius.circular(4)),
                    child: const Text('Featured', style: TextStyle(color: Colors.amber, fontSize: 10)),
                  ),
                const SizedBox(width: 8),
                Text(trek.difficulty, style: const TextStyle(color: Colors.green, fontSize: 10)),
              ],
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.grey),
              onPressed: () => context.go('/admin/treks/edit/${trek.slug}'),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.redAccent),
              onPressed: () async {
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (context) => const ConfirmDeleteDialog(
                    title: 'Delete Trek',
                    content: 'Are you sure you want to delete this trek record?',
                  ),
                );

                if (confirmed == true) {
                  try {
                    await ref.read(trekRepositoryProvider).deleteTrek(trek.id);
                    ref.invalidate(adminTreksProvider);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Trek deleted successfully')));
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
