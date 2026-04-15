import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/app_state.dart';
import '../../shared/widgets/section_page.dart';

class ThinkPage extends ConsumerWidget {
  const ThinkPage({super.key});

  static const reflections = [
    {
      'title': 'Design with conversation in mind',
      'summary':
          'A strong concept often starts from a clear question. The best answers come from observing how users naturally describe their needs.',
    },
    {
      'title': 'Small constraints, bold clarity',
      'summary':
          'Limiting scope early helps a design feel purposeful. A focused idea is easier to shape and easier for others to understand.',
    },
    {
      'title': 'Measure the quiet improvements',
      'summary':
          'Not every win is dramatic. Tracking small shifts in clarity and flow reveals the cumulative value of thoughtful iteration.',
    },
    {
      'title': 'Write the process, not just the product',
      'summary':
          'Documenting how a decision was made preserves context. It makes future work easier to continue and learn from.',
    },
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.read(selectedSectionProvider);
    if (selected != AppSection.think) {
      Future.microtask(
        () =>
            ref.read(selectedSectionProvider.notifier).state = AppSection.think,
      );
    }

    return SectionPage(
      title: 'Short reflections',
      subtitle:
          'Minimal thinking notes for process, perspective, and quiet clarity.',
      children: reflections
          .asMap()
          .entries
          .map(
            (entry) =>
                _reflectionItem(
                  context,
                  entry.value['title']!,
                  entry.value['summary']!,
                ).animate().fadeIn(
                  duration: 520.ms,
                  delay: Duration(milliseconds: 80 * entry.key),
                ),
          )
          .toList(),
    );
  }

  Widget _reflectionItem(BuildContext context, String title, String summary) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(summary, style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 14),
          Divider(color: const Color.fromRGBO(203, 213, 225, 0.4)),
        ],
      ),
    );
  }
}
