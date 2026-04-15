import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/app_state.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage>
    with SingleTickerProviderStateMixin {
  late final ScrollController _scrollController;
  late final ScrollController _storyScrollController;
  late final AnimationController _heroFadeController;
  double _scrollOffset = 0;
  int _hoveredPillar = -1;
  int _hoveredStory = -1;

  final _heroImage = const NetworkImage(
    'https://images.unsplash.com/photo-1497294815431-9365093b7331?auto=format&fit=crop&w=1600&q=80',
  );

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
    _storyScrollController = ScrollController();
    _heroFadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _heroFadeController.forward();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _storyScrollController.dispose();
    _heroFadeController.dispose();
    super.dispose();
  }

  void _onScroll() {
    setState(() {
      _scrollOffset = _scrollController.offset;
    });
  }

  @override
  Widget build(BuildContext context) {
    final selected = ref.read(selectedSectionProvider);
    if (selected != AppSection.home) {
      Future.microtask(
        () =>
            ref.read(selectedSectionProvider.notifier).state = AppSection.home,
      );
    }

    return SingleChildScrollView(
      controller: _scrollController,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHero(context),
          const SizedBox(height: 40),
          _buildPillars(context),
          const SizedBox(height: 40),
          _buildFeaturedStories(context),
          const SizedBox(height: 40),
          _buildTimelinePreview(context),
          const SizedBox(height: 60),
        ],
      ),
    );
  }

  Widget _buildHero(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final opacity = Curves.easeOut.transform(
      (_heroFadeController.value).clamp(0.0, 1.0),
    );
    final alignmentY = (_scrollOffset / 500).clamp(-0.25, 0.25);

    return SizedBox(
      height: screenHeight,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Transform.translate(
            offset: Offset(0, alignmentY * 60),
            child: Image(
              image: _heroImage,
              fit: BoxFit.cover,
              alignment: Alignment(0, alignmentY),
            ),
          ),
          Container(color: const Color.fromRGBO(0, 0, 0, 0.45)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
            child: Align(
              alignment: Alignment.centerLeft,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 860),
                child: AnimatedBuilder(
                  animation: _heroFadeController,
                  builder: (context, child) {
                    return Opacity(
                      opacity: opacity,
                      child: Transform.translate(
                        offset: Offset(0, 30 * (1 - opacity)),
                        child: child,
                      ),
                    );
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'I build, explore, and document my journey',
                        style: Theme.of(context).textTheme.displayLarge
                            ?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                            ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'A personal storytelling website for ideas, projects, and the rhythms that shape each chapter.',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: const Color.fromRGBO(255, 255, 255, 0.92),
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPillars(BuildContext context) {
    final pillars = [
      {
        'title': 'Explore',
        'subtitle': 'Understand the context and shape new directions.',
      },
      {
        'title': 'Build',
        'subtitle': 'Ship polished experiences with strong architecture.',
      },
      {
        'title': 'Think',
        'subtitle': 'Document reflections, frameworks, and learnings.',
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Pillars', style: Theme.of(context).textTheme.displayMedium),
          const SizedBox(height: 18),
          LayoutBuilder(
            builder: (context, constraints) {
              final isNarrow = constraints.maxWidth < 880;
              return Wrap(
                spacing: 20,
                runSpacing: 20,
                children: List.generate(pillars.length, (index) {
                  final item = pillars[index];
                  final hovered = _hoveredPillar == index;
                  return MouseRegion(
                    onEnter: (_) => setState(() => _hoveredPillar = index),
                    onExit: (_) => setState(() => _hoveredPillar = -1),
                    child: AnimatedScale(
                      scale: hovered ? 1.02 : 1.0,
                      duration: const Duration(milliseconds: 220),
                      child:
                          Container(
                                width: isNarrow ? constraints.maxWidth : 280,
                                padding: const EdgeInsets.all(24),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.surface,
                                  borderRadius: BorderRadius.circular(24),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color.fromRGBO(
                                        0,
                                        0,
                                        0,
                                        0.08,
                                      ),
                                      blurRadius: hovered ? 28 : 16,
                                      offset: const Offset(0, 12),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item['title']!,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.titleLarge,
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      item['subtitle']!,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodyMedium,
                                    ),
                                  ],
                                ),
                              )
                              .animate(
                                onPlay: (controller) => controller.forward(),
                              )
                              .fadeIn(
                                duration: 500.ms,
                                delay: Duration(milliseconds: 120 * index),
                              )
                              .moveY(
                                begin: 16,
                                duration: 500.ms,
                                delay: Duration(milliseconds: 120 * index),
                              ),
                    ),
                  );
                }),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedStories(BuildContext context) {
    final stories = [
      {
        'title': 'Launching the modern system',
        'image':
            'https://images.unsplash.com/photo-1515378791036-0648a3ef77b2?auto=format&fit=crop&w=1200&q=80',
      },
      {
        'title': 'Designing for calm digital spaces',
        'image':
            'https://images.unsplash.com/photo-1522202176988-66273c2fd55f?auto=format&fit=crop&w=1200&q=80',
      },
      {
        'title': 'Writing through process and meaning',
        'image':
            'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=1200&q=80',
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Featured stories',
            style: Theme.of(context).textTheme.displayMedium,
          ),
          const SizedBox(height: 18),
          SizedBox(
            height: 300,
            child: Scrollbar(
              controller: _storyScrollController,
              trackVisibility: true,
              thumbVisibility: true,
              child: ListView.builder(
                controller: _storyScrollController,
                scrollDirection: Axis.horizontal,
                itemCount: stories.length,
                itemBuilder: (context, index) {
                  final story = stories[index];
                  final hovered = _hoveredStory == index;
                  return MouseRegion(
                    onEnter: (_) => setState(() => _hoveredStory = index),
                    onExit: (_) => setState(() => _hoveredStory = -1),
                    child:
                        AnimatedContainer(
                              duration: const Duration(milliseconds: 220),
                              margin: EdgeInsets.only(
                                right: index == stories.length - 1 ? 0 : 20,
                              ),
                              width: 320,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(24),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color.fromRGBO(
                                      0,
                                      0,
                                      0,
                                      hovered ? 0.22 : 0.14,
                                    ),
                                    blurRadius: hovered ? 28 : 18,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(24),
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    Image.network(
                                      story['image']!,
                                      fit: BoxFit.cover,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            const Color.fromRGBO(0, 0, 0, 0.15),
                                            const Color.fromRGBO(0, 0, 0, 0.7),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      left: 20,
                                      right: 20,
                                      bottom: 22,
                                      child: Text(
                                        story['title']!,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge
                                            ?.copyWith(
                                              color: Colors.white,
                                              fontSize: 22,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                            .animate()
                            .fadeIn(
                              duration: 520.ms,
                              delay: Duration(milliseconds: 100 * index),
                            )
                            .moveY(
                              begin: 14,
                              duration: 520.ms,
                              delay: Duration(milliseconds: 100 * index),
                            ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelinePreview(BuildContext context) {
    final events = [
      {'year': '2024', 'label': 'Launch creative system'},
      {'year': '2025', 'label': 'Refine storytelling flow'},
      {'year': 'Now', 'label': 'Share ongoing research and builds'},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Timeline preview',
            style: Theme.of(context).textTheme.displayMedium,
          ),
          const SizedBox(height: 18),
          SizedBox(
            height: 170,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: events.length,
              separatorBuilder: (context, index) => const SizedBox(width: 18),
              itemBuilder: (context, index) {
                final event = events[index];
                return Container(
                  width: 220,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: Theme.of(
                        context,
                      ).colorScheme.outline.withAlpha((0.3 * 255).round()),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        event['year']!,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        event['label']!,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const Spacer(),
                      Container(
                        height: 4,
                        width: 56,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
