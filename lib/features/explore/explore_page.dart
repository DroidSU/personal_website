import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/app_state.dart';
import '../../core/firestore_providers.dart';
import '../../features/explore/story_model.dart';
import '../../shared/widgets/section_page.dart';

class ExplorePage extends ConsumerStatefulWidget {
  const ExplorePage({super.key});

  @override
  ConsumerState<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends ConsumerState<ExplorePage> {
  int _hoveredIndex = -1;

  @override
  Widget build(BuildContext context) {
    final storiesState = ref.watch(storiesProvider);
    final selected = ref.read(selectedSectionProvider);
    if (selected != AppSection.explore) {
      Future.microtask(
        () => ref.read(selectedSectionProvider.notifier).state =
            AppSection.explore,
      );
    }

    return SectionPage(
      title: 'Travel and trekking stories',
      subtitle:
          'A collection of journeys, campsites, and reflections from the trail.',
      children: [
        storiesState.when(
          data: (stories) => _buildGrid(context, stories),
          loading: () => SizedBox(
            height: 320,
            child: Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          error: (error, stack) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Text(
              'Unable to load stories. Please try again later.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGrid(BuildContext context, List<Story> stories) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth >= 1100
            ? 3
            : constraints.maxWidth >= 720
            ? 2
            : 1;

        return GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: stories.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            childAspectRatio: 1.1,
          ),
          itemBuilder: (context, index) {
            final item = stories[index];
            final hovered = _hoveredIndex == index;
            return MouseRegion(
              onEnter: (_) => setState(() => _hoveredIndex = index),
              onExit: (_) => setState(() => _hoveredIndex = -1),
              child: GestureDetector(
                onTap: () => context.go('/explore/story/${item.id}'),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 280),
                  curve: Curves.easeOut,
                  transform:
                      Matrix4.translationValues(0, hovered ? -6.0 : 0.0, 0)
                        ..multiply(
                          Matrix4.diagonal3Values(
                            hovered ? 1.02 : 1.0,
                            hovered ? 1.02 : 1.0,
                            1,
                          ),
                        ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, hovered ? 0.22 : 0.14),
                        blurRadius: hovered ? 26 : 18,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child:
                      ClipRRect(
                            borderRadius: BorderRadius.circular(24),
                            child: Stack(
                              children: [
                                Positioned.fill(
                                  child: Image.network(
                                    item.image,
                                    fit: BoxFit.cover,
                                    loadingBuilder: (context, child, progress) {
                                      if (progress == null) return child;
                                      return Container(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.surface,
                                        child: const Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 280),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        const Color.fromRGBO(0, 0, 0, 0.18),
                                        const Color.fromRGBO(0, 0, 0, 0.55),
                                      ],
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: 20,
                                  right: 20,
                                  bottom: 20,
                                  child: Text(
                                    item.title,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(
                                          color: Colors.white,
                                          shadows: [
                                            const Shadow(
                                              color: Colors.black54,
                                              blurRadius: 18,
                                              offset: Offset(0, 4),
                                            ),
                                          ],
                                        ),
                                  ),
                                ),
                              ],
                            ),
                          )
                          .animate()
                          .fadeIn(
                            duration: 520.ms,
                            delay: Duration(milliseconds: 80 * index),
                          )
                          .moveY(
                            begin: 14,
                            duration: 520.ms,
                            delay: Duration(milliseconds: 80 * index),
                          ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
