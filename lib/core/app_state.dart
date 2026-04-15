import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AppSection { home, explore, build, think, timeline, now }

extension AppSectionLabel on AppSection {
  String get title {
    switch (this) {
      case AppSection.home:
        return 'Home';
      case AppSection.explore:
        return 'Explore';
      case AppSection.build:
        return 'Build';
      case AppSection.think:
        return 'Think';
      case AppSection.timeline:
        return 'Timeline';
      case AppSection.now:
        return 'Now';
    }
  }

  String get path {
    switch (this) {
      case AppSection.home:
        return '/';
      case AppSection.explore:
        return '/explore';
      case AppSection.build:
        return '/build';
      case AppSection.think:
        return '/think';
      case AppSection.timeline:
        return '/timeline';
      case AppSection.now:
        return '/now';
    }
  }

  IconData get icon {
    switch (this) {
      case AppSection.home:
        return Icons.home;
      case AppSection.explore:
        return Icons.explore;
      case AppSection.build:
        return Icons.construction;
      case AppSection.think:
        return Icons.lightbulb;
      case AppSection.timeline:
        return Icons.timeline;
      case AppSection.now:
        return Icons.access_time;
    }
  }
}

final selectedSectionProvider = StateProvider<AppSection>(
  (ref) => AppSection.home,
);
final sectionsProvider = Provider<List<AppSection>>((ref) => AppSection.values);
