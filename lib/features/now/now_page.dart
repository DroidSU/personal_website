import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/app_state.dart';
import '../../core/firestore_providers.dart';
import '../../features/now/now_status_model.dart';
import '../../shared/widgets/section_page.dart';

class NowPage extends ConsumerStatefulWidget {
  const NowPage({super.key});

  @override
  ConsumerState<NowPage> createState() => _NowPageState();
}

class _NowPageState extends ConsumerState<NowPage> {
  int _hoveredIndex = -1;

  @override
  Widget build(BuildContext context) {
    final nowState = ref.watch(nowStatusesProvider);
    final selected = ref.read(selectedSectionProvider);
    if (selected != AppSection.now) {
      Future.microtask(
        () => ref.read(selectedSectionProvider.notifier).state = AppSection.now,
      );
    }

    return SectionPage(
      title: 'What is happening now',
      subtitle:
          'Current focus areas, experiments, and the next things being built.',
      children: [
        nowState.when(
          data: (items) => _buildStatusGrid(context, items),
          loading: () => SizedBox(
            height: 260,
            child: Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          error: (error, stack) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Text(
              'Unable to load current status. Please refresh the page.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusGrid(BuildContext context, List<NowStatus> items) {
    final latestUpdate = items
        .map((item) => item.updatedAt)
        .whereType<DateTime>()
        .fold<DateTime?>(null, (latest, current) {
          if (latest == null) return current;
          return current.isAfter(latest) ? current : latest;
        });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 20,
          runSpacing: 20,
          children: items.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            final hovered = _hoveredIndex == index;
            return SizedBox(
              width: 340,
              child: MouseRegion(
                onEnter: (_) => setState(() => _hoveredIndex = index),
                onExit: (_) => setState(() => _hoveredIndex = -1),
                child: AnimatedScale(
                  scale: hovered ? 1.02 : 1.0,
                  duration: const Duration(milliseconds: 220),
                  child:
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.title,
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                item.details,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ],
                          ),
                        ),
                      ).animate().fadeIn(
                        duration: 520.ms,
                        delay: Duration(milliseconds: 80 * index),
                      ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 28),
        Text(
          latestUpdate != null
              ? 'Last updated ${_formatDate(latestUpdate)}'
              : 'Last updated April 14, 2026',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}/${date.year}';
  }
}
