import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/app_state.dart';
import '../../shared/widgets/section_page.dart';

class BuildPage extends ConsumerStatefulWidget {
  const BuildPage({super.key});

  @override
  ConsumerState<BuildPage> createState() => _BuildPageState();

  static final projects = [
    {
      'id': 'platform-launch',
      'title': 'Platform launch toolkit',
      'description':
          'A scalable release system for collaborative product teams.',
      'tags': ['Design System', 'Web', 'Collaboration'],
    },
    {
      'id': 'dashboard-suite',
      'title': 'Analytics dashboard suite',
      'description':
          'Real-time insights for customer behavior and retention trends.',
      'tags': ['Data', 'UX', 'Performance'],
    },
    {
      'id': 'builder-studio',
      'title': 'Creator workflow studio',
      'description':
          'A polished workspace that simplifies content creation and review.',
      'tags': ['Workflow', 'Mobile', 'Accessibility'],
    },
  ];
}

class _BuildPageState extends ConsumerState<BuildPage> {
  int _hoveredIndex = -1;

  @override
  Widget build(BuildContext context) {
    final selected = ref.read(selectedSectionProvider);
    if (selected != AppSection.build) {
      Future.microtask(
        () =>
            ref.read(selectedSectionProvider.notifier).state = AppSection.build,
      );
    }

    return SectionPage(
      title: 'Projects and case studies',
      subtitle:
          'Professional product work with clean execution, clarity, and measurable outcomes.',
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            final columns = constraints.maxWidth >= 1000
                ? 3
                : constraints.maxWidth >= 700
                ? 2
                : 1;
            return GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: BuildPage.projects.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: columns,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                childAspectRatio: 1.05,
              ),
              itemBuilder: (context, index) {
                final project = BuildPage.projects[index];
                return _projectCard(context, project, index);
              },
            );
          },
        ),
      ],
    );
  }

  Widget _projectCard(
    BuildContext context,
    Map<String, Object> project,
    int index,
  ) {
    final hovered = _hoveredIndex == index;
    return MouseRegion(
      onEnter: (_) => setState(() => _hoveredIndex = index),
      onExit: (_) => setState(() => _hoveredIndex = -1),
      child: AnimatedScale(
        scale: hovered ? 1.02 : 1.0,
        duration: const Duration(milliseconds: 220),
        child: InkWell(
          onTap: () => context.go('/build/case-study/${project['id']}'),
          borderRadius: BorderRadius.circular(24),
          child:
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        project['title'] as String,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        project['description'] as String,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const Spacer(),
                      Wrap(
                        spacing: 10,
                        runSpacing: 8,
                        children: (project['tags'] as List<String>).map((tag) {
                          return Chip(
                            label: Text(tag),
                            visualDensity: VisualDensity.compact,
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                          );
                        }).toList(),
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
  }
}
