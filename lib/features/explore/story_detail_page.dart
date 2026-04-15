import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class StoryDetailPage extends StatefulWidget {
  final String storyId;

  const StoryDetailPage({super.key, required this.storyId});

  static const stories = [
    {
      'id': 'summit-path',
      'title': 'Summit path through cloud forests',
      'location': 'Cameron Highlands, Malaysia',
      'date': 'June 2024',
      'heroImage':
          'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=1600&q=80',
      'summary':
          'A high-altitude trek through mossy trails, mist-covered peaks, and unexpected campsites.',
    },
    {
      'id': 'coastal-trek',
      'title': 'Coastal trek and hidden camping spots',
      'location': 'California coast',
      'date': 'September 2023',
      'heroImage':
          'https://images.unsplash.com/photo-1519817650390-64a93db511aa?auto=format&fit=crop&w=1600&q=80',
      'summary':
          'Walking along cliffs, beach coves, and quiet nights beside the surf.',
    },
    {
      'id': 'desert-night',
      'title': 'Desert nights under falling stars',
      'location': 'Atacama Desert, Chile',
      'date': 'February 2024',
      'heroImage':
          'https://images.unsplash.com/photo-1500534314209-a25ddb2bd429?auto=format&fit=crop&w=1600&q=80',
      'summary':
          'A story of wide dunes, open skies, and the stillness between dunes.',
    },
    {
      'id': 'river-route',
      'title': 'River route and waterfall camps',
      'location': 'Icelandic highlands',
      'date': 'May 2024',
      'heroImage':
          'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=1600&q=80',
      'summary':
          'Following riverbanks, setting camp beneath waterfalls, and finding quiet pools.',
    },
    {
      'id': 'alpine-walk',
      'title': 'Alpine walk through wildflower valleys',
      'location': 'Swiss Alps',
      'date': 'August 2024',
      'heroImage':
          'https://images.unsplash.com/photo-1491553895911-0055eca6402d?auto=format&fit=crop&w=1600&q=80',
      'summary':
          'High ridges, bright meadows, and a journey through alpine calm.',
    },
  ];

  Map<String, String>?
  get story => stories.cast<Map<String, String>>().firstWhere(
    (item) => item['id'] == storyId,
    orElse: () => {
      'id': storyId,
      'title': 'Story not found',
      'location': 'Unknown',
      'date': 'Unknown',
      'heroImage':
          'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?auto=format&fit=crop&w=1600&q=80',
      'summary':
          'This story could not be found. Head back to explore more journeys.',
    },
  );

  @override
  State<StoryDetailPage> createState() => _StoryDetailPageState();
}

class _StoryDetailPageState extends State<StoryDetailPage> {
  final ScrollController _scrollController = ScrollController();
  double _scrollOffset = 0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!mounted) return;
    setState(() {
      _scrollOffset = _scrollController.offset;
    });
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.story!;
    final theme = Theme.of(context);
    final heroOffset = (_scrollOffset * 0.15).clamp(0.0, 80.0);
    final screenWidth = MediaQuery.of(context).size.width;

    final sections = [
      {
        'title': 'Trail entry',
        'body':
            'The first day opened with damp fog and a narrow path that rose slowly through giant ferns. It felt like stepping into another world, one shaped by rain, moss, and quiet. Each stop was measured, intentional, and framed by the movement of the light.',
        'image':
            'https://images.unsplash.com/photo-1526779259212-8f6a7f0f0b2e?auto=format&fit=crop&w=1600&q=80',
        'layout': 'left',
      },
      {
        'title': 'Camp beneath the trees',
        'body':
            'By evening, the camp settled on a ridge with a view of the valley below. The gear was simple, the meal warm, and the conversation quiet. Layers of mist moved through the trees as the fire cracked and stars began to appear.',
        'image':
            'https://images.unsplash.com/photo-1496307042754-b4aa456c4a2d?auto=format&fit=crop&w=1600&q=80',
        'layout': 'full',
      },
      {
        'title': 'Summit approach',
        'body':
            'The ascent the next morning was crisp and attentive. Each step grew lighter as the trail climbed above the cloud line, and the air carried a cool stillness. The summit itself offered a calm pause and a new perspective on the path taken.',
        'image':
            'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=1600&q=80',
        'layout': 'right',
      },
      {
        'title': 'Reflections on the journey',
        'body':
            'The final section of the story turned inward. The details that mattered were weather, fire, and the rhythm of steps through changing terrain. It became clear that the strongest memories lived in the quiet moments between movement.',
        'image':
            'https://images.unsplash.com/photo-1500534314209-a25ddb2bd429?auto=format&fit=crop&w=1600&q=80',
        'layout': 'full',
      },
    ];

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverToBoxAdapter(
              child: Stack(
                children: [
                  SizedBox(
                    height: 420,
                    width: double.infinity,
                    child: Transform.translate(
                      offset: Offset(0, heroOffset),
                      child: Image.network(
                        item['heroImage']!,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, progress) {
                          if (progress == null) return child;
                          return Container(
                            color: theme.colorScheme.surface,
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Container(
                    height: 420,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          const Color.fromRGBO(0, 0, 0, 0.24),
                          const Color.fromRGBO(0, 0, 0, 0.64),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 18,
                    left: 18,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => context.pop(),
                    ),
                  ),
                  Positioned(
                    left: 24,
                    right: 24,
                    bottom: 24,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['title']!,
                          style: theme.textTheme.displayLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Wrap(
                          spacing: 16,
                          runSpacing: 8,
                          children: [
                            _MetadataChip(
                              icon: Icons.location_on,
                              label: item['location']!,
                            ),
                            _MetadataChip(
                              icon: Icons.calendar_month,
                              label: item['date']!,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final section = sections[index];
                  final type = section['layout'] as String;
                  final widget = type == 'full'
                      ? _buildFullWidthImageSection(
                          context,
                          section['image'] as String,
                          section['title'] as String,
                        )
                      : _buildTextImageSection(
                          context,
                          section['title'] as String,
                          section['body'] as String,
                          section['image'] as String,
                          section['layout'] as String,
                          screenWidth,
                        );
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 30),
                    child: _RevealOnScroll(
                      controller: _scrollController,
                      child: widget,
                    ),
                  );
                }, childCount: sections.length),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextImageSection(
    BuildContext context,
    String title,
    String body,
    String image,
    String layout,
    double width,
  ) {
    final isReverse = layout == 'right';
    final child = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 18),
        Text(body, style: Theme.of(context).textTheme.bodyLarge),
      ],
    );

    final imageWidget = _ParallaxImage(
      controller: _scrollController,
      imageUrl: image,
      height: 320,
    );

    if (width < 780) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [imageWidget, const SizedBox(height: 22), child],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isReverse) Expanded(child: child),
        Expanded(child: imageWidget),
        const SizedBox(width: 24),
        if (!isReverse) Expanded(child: child),
      ],
    );
  }

  Widget _buildFullWidthImageSection(
    BuildContext context,
    String image,
    String caption,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ParallaxImage(
          controller: _scrollController,
          imageUrl: image,
          height: 260,
        ),
        const SizedBox(height: 18),
        Text(caption, style: Theme.of(context).textTheme.titleLarge),
      ],
    );
  }
}

class _MetadataChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _MetadataChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(255, 255, 255, 0.12),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.white70),
          const SizedBox(width: 8),
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.white70),
          ),
        ],
      ),
    );
  }
}

class _RevealOnScroll extends StatefulWidget {
  final ScrollController controller;
  final Widget child;

  const _RevealOnScroll({required this.controller, required this.child});

  @override
  State<_RevealOnScroll> createState() => _RevealOnScrollState();
}

class _RevealOnScrollState extends State<_RevealOnScroll> {
  final GlobalKey _key = GlobalKey();
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_updateVisibility);
    WidgetsBinding.instance.addPostFrameCallback((_) => _updateVisibility());
  }

  @override
  void dispose() {
    widget.controller.removeListener(_updateVisibility);
    super.dispose();
  }

  void _updateVisibility() {
    final context = _key.currentContext;
    if (context == null) return;
    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null) return;
    final position = renderBox.localToGlobal(Offset.zero).dy;
    final screenHeight = MediaQuery.of(context).size.height;
    final shouldShow = position < screenHeight * 0.85;
    if (shouldShow != _visible) {
      setState(() => _visible = shouldShow);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      key: _key,
      duration: const Duration(milliseconds: 520),
      opacity: _visible ? 1 : 0,
      curve: Curves.easeOut,
      child: AnimatedSlide(
        offset: _visible ? Offset.zero : const Offset(0, 0.06),
        duration: const Duration(milliseconds: 520),
        curve: Curves.easeOut,
        child: widget.child,
      ),
    );
  }
}

class _ParallaxImage extends StatefulWidget {
  final ScrollController controller;
  final String imageUrl;
  final double height;

  const _ParallaxImage({
    required this.controller,
    required this.imageUrl,
    required this.height,
  });

  @override
  State<_ParallaxImage> createState() => _ParallaxImageState();
}

class _ParallaxImageState extends State<_ParallaxImage> {
  final GlobalKey _key = GlobalKey();
  double _offset = 0;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_updateOffset);
    WidgetsBinding.instance.addPostFrameCallback((_) => _updateOffset());
  }

  @override
  void dispose() {
    widget.controller.removeListener(_updateOffset);
    super.dispose();
  }

  void _updateOffset() {
    final context = _key.currentContext;
    if (context == null) return;
    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null) return;
    final position = renderBox.localToGlobal(Offset.zero).dy;
    final screenHeight = MediaQuery.of(context).size.height;
    final progress = ((position / screenHeight) - 0.5).clamp(-1.0, 1.0);
    setState(() {
      _offset = progress * 22;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      key: _key,
      borderRadius: BorderRadius.circular(24),
      child: SizedBox(
        height: widget.height,
        width: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Transform.translate(
              offset: Offset(0, _offset),
              child: Image.network(
                widget.imageUrl,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return Container(
                    color: Theme.of(context).colorScheme.surface,
                    child: const Center(child: CircularProgressIndicator()),
                  );
                },
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color.fromRGBO(0, 0, 0, 0.08),
                    const Color.fromRGBO(0, 0, 0, 0.22),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
