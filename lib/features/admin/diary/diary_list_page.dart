import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../shared/models/diary_post_model.dart';
import '../../diary/providers/diary_provider.dart';
import '../providers/admin_provider.dart';
import '../widgets/admin_common_widgets.dart';

class DiaryListPage extends ConsumerWidget {
  const DiaryListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postsAsync = ref.watch(adminDiaryPostsProvider);

    return Column(
      children: [
        AdminSectionTitle(
          title: 'Diary Posts',
          actions: [
            ElevatedButton.icon(
              onPressed: () => context.go('/admin/diary/new'),
              icon: const Icon(Icons.add),
              label: const Text('New Post'),
            ),
          ],
        ),
        Expanded(
          child: postsAsync.when(
            data: (posts) => ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];
                return _DiaryListItem(post: post);
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

class _DiaryListItem extends ConsumerWidget {
  final DiaryPostModel post;

  const _DiaryListItem({required this.post});

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
        title: Text(post.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Row(
              children: [
                Text(post.category, style: const TextStyle(color: Colors.blue, fontSize: 12)),
                const SizedBox(width: 12),
                Text(
                  DateFormat('MMM dd, yyyy').format(post.publishedAt),
                  style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _StatusChip(label: post.published ? 'Published' : 'Draft', isSuccess: post.published),
                if (post.featured) ...[
                  const SizedBox(width: 8),
                  const _StatusChip(label: 'Featured', isSuccess: true, color: Colors.amber),
                ],
              ],
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.grey),
              onPressed: () => context.go('/admin/diary/edit/${post.slug}'),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.redAccent),
              onPressed: () async {
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (context) => const ConfirmDeleteDialog(
                    title: 'Delete Post',
                    content: 'Are you sure you want to delete this diary post?',
                  ),
                );

                if (confirmed == true) {
                  try {
                    await ref.read(diaryRepositoryProvider).deletePost(post.id);
                    ref.invalidate(adminDiaryPostsProvider);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Post deleted successfully')));
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

class _StatusChip extends StatelessWidget {
  final String label;
  final bool isSuccess;
  final Color? color;

  const _StatusChip({required this.label, required this.isSuccess, this.color});

  @override
  Widget build(BuildContext context) {
    final baseColor = color ?? (isSuccess ? Colors.green : Colors.grey);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: baseColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: baseColor.withOpacity(0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(color: baseColor, fontSize: 10, fontWeight: FontWeight.bold),
      ),
    );
  }
}
