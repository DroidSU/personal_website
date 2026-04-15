import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/app_state.dart';
import '../../core/firestore_providers.dart';
import '../../features/timeline/timeline_event_model.dart';

class TimelinePage extends ConsumerStatefulWidget {
  const TimelinePage({super.key});

  @override
  ConsumerState<TimelinePage> createState() => _TimelinePageState();
}

class _TimelinePageState extends ConsumerState<TimelinePage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_updateScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_updateScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _updateScroll() {
    if (!mounted) return;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final timelineState = ref.watch(timelineEventsProvider);
    final selected = ref.read(selectedSectionProvider);
    if (selected != AppSection.timeline) {
      Future.microtask(
        () => ref.read(selectedSectionProvider.notifier).state =
            AppSection.timeline,
      );
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: timelineState.when(
          data: (events) => _buildTimeline(context, events),
          loading: () => Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          error: (error, stack) => Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                'Unable to load timeline events. Please try again later.',
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTimeline(BuildContext context, List<TimelineEventModel> events) {
    return SingleChildScrollView(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Timeline of progress',
                style: Theme.of(context).textTheme.displayMedium,
              ),
              const SizedBox(height: 12),
              Text(
                'A centered timeline with milestones arranged as a minimal narrative flow.',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 50),
              Stack(
                children: [
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.center,
                      child: Container(
                        width: 4,
                        decoration: BoxDecoration(
                          color: Theme.of(
                            context,
                          ).colorScheme.primary.withValues(alpha: 0.2),
                        ),
                      ),
                    ),
                  ),
                  Column(
                    children: List.generate(events.length, (index) {
                      final event = events[index];
                      return _TimelineEvent(
                        event: event,
                        isLeft: index.isEven,
                        controller: _scrollController,
                      );
                    }),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TimelineEvent extends StatefulWidget {
  final TimelineEventModel event;
  final bool isLeft;
  final ScrollController controller;

  const _TimelineEvent({
    required this.event,
    required this.isLeft,
    required this.controller,
  });

  @override
  State<_TimelineEvent> createState() => _TimelineEventState();
}

class _TimelineEventState extends State<_TimelineEvent> {
  final GlobalKey _key = GlobalKey();
  bool _visible = false;
  bool _hovered = false;

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
    final spacerFlex = widget.isLeft ? 3 : 1;
    final contentFlex = 4;
    final offset = widget.isLeft
        ? const Offset(-0.15, 0)
        : const Offset(0.15, 0);

    return Padding(
      key: _key,
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: AnimatedOpacity(
        opacity: _visible ? 1 : 0,
        duration: const Duration(milliseconds: 520),
        curve: Curves.easeOut,
        child: AnimatedSlide(
          offset: _visible ? Offset.zero : offset,
          duration: const Duration(milliseconds: 520),
          curve: Curves.easeOut,
          child: Row(
            children: [
              if (widget.isLeft)
                Expanded(flex: contentFlex, child: _eventCard(context)),
              Expanded(flex: spacerFlex, child: const SizedBox()),
              Column(
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                  Container(
                    width: 4,
                    height: 100,
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.2),
                  ),
                ],
              ),
              Expanded(
                flex: widget.isLeft ? spacerFlex : contentFlex,
                child: widget.isLeft ? const SizedBox() : _eventCard(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _eventCard(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: Align(
        alignment: widget.isLeft ? Alignment.centerRight : Alignment.centerLeft,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: AnimatedScale(
            scale: _hovered ? 1.02 : 1.0,
            duration: const Duration(milliseconds: 220),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.event.year,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.event.title,
                      style: Theme.of(
                        context,
                      ).textTheme.displaySmall?.copyWith(fontSize: 20),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      widget.event.description,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
            ).animate().fadeIn(duration: 520.ms),
          ),
        ),
      ),
    );
  }
}
