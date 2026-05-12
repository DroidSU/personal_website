import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'providers/admin_provider.dart';
import 'widgets/admin_common_widgets.dart';

class AdminHomePage extends ConsumerWidget {
  const AdminHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projectsAsync = ref.watch(adminProjectsProvider);
    final treksAsync = ref.watch(adminTreksProvider);
    final postsAsync = ref.watch(adminDiaryPostsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AdminSectionTitle(title: 'Dashboard Overview'),
        const SizedBox(height: 24),
        GridView.count(
          crossAxisCount: MediaQuery.of(context).size.width > 1200 ? 3 : (MediaQuery.of(context).size.width > 800 ? 2 : 1),
          crossAxisSpacing: 24,
          mainAxisSpacing: 24,
          childAspectRatio: 2.5,
          shrinkWrap: true,
          children: [
            _StatCard(
              title: 'Total Projects',
              count: projectsAsync.when(data: (d) => d.length.toString(), loading: () => '...', error: (_, __) => '0'),
              icon: Icons.code,
              color: Colors.blue,
            ),
            _StatCard(
              title: 'Total Treks',
              count: treksAsync.when(data: (d) => d.length.toString(), loading: () => '...', error: (_, __) => '0'),
              icon: Icons.landscape,
              color: Colors.green,
            ),
            _StatCard(
              title: 'Diary Posts',
              count: postsAsync.when(data: (d) => d.length.toString(), loading: () => '...', error: (_, __) => '0'),
              icon: Icons.book,
              color: Colors.orange,
            ),
          ],
        ),
        const SizedBox(height: 48),
        const Text(
          'Quick Actions',
          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            _QuickActionBtn(
              label: 'Add New Project',
              icon: Icons.add_circle_outline,
              onPressed: () => context.go('/admin/projects/new'),
            ),
            _QuickActionBtn(
              label: 'Add New Trek',
              icon: Icons.add_circle_outline,
              onPressed: () => context.go('/admin/treks/new'),
            ),
            _QuickActionBtn(
              label: 'New Diary Post',
              icon: Icons.add_circle_outline,
              onPressed: () => context.go('/admin/diary/new'),
            ),
          ],
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String count;
  final IconData icon;
  final Color color;

  const _StatCard({required this.title, required this.count, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, color: color, size: 32),
          ),
          const SizedBox(width: 20),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: Colors.grey, fontSize: 14)),
              const SizedBox(height: 4),
              Text(count, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }
}

class _QuickActionBtn extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  const _QuickActionBtn({required this.label, required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white.withOpacity(0.05),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        side: BorderSide(color: Colors.white.withOpacity(0.1)),
      ),
    );
  }
}
