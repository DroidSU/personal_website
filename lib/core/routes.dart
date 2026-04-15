import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/build/build_page.dart';
import '../features/build/case_study_page.dart';
import '../features/explore/explore_page.dart';
import '../features/explore/story_detail_page.dart';
import '../features/home/home_page.dart';
import '../features/now/now_page.dart';
import '../features/think/think_page.dart';
import '../features/timeline/timeline_page.dart';
import '../features/not_found/not_found_page.dart';
import '../shared/widgets/app_shell.dart';

GoRouter get appRouter => GoRouter(
  initialLocation: '/',
  routes: [
    ShellRoute(
      builder: (context, state, child) => AppShell(child: child),
      routes: [
        GoRoute(
          path: '/',
          name: 'home',
          pageBuilder: (context, state) =>
              _fadeTransition(state, const HomePage()),
        ),
        GoRoute(
          path: '/explore',
          name: 'explore',
          pageBuilder: (context, state) =>
              _fadeTransition(state, const ExplorePage()),
          routes: [
            GoRoute(
              path: 'story/:storyId',
              name: 'storyDetail',
              pageBuilder: (context, state) {
                final storyId = state.pathParameters['storyId']!;
                return _fadeTransition(
                  state,
                  StoryDetailPage(storyId: storyId),
                );
              },
            ),
          ],
        ),
        GoRoute(
          path: '/build',
          name: 'build',
          pageBuilder: (context, state) =>
              _fadeTransition(state, const BuildPage()),
          routes: [
            GoRoute(
              path: 'case-study/:projectId',
              name: 'caseStudy',
              pageBuilder: (context, state) {
                final projectId = state.pathParameters['projectId']!;
                return _fadeTransition(
                  state,
                  CaseStudyPage(projectId: projectId),
                );
              },
            ),
          ],
        ),
        GoRoute(
          path: '/think',
          name: 'think',
          pageBuilder: (context, state) =>
              _fadeTransition(state, const ThinkPage()),
        ),
        GoRoute(
          path: '/timeline',
          name: 'timeline',
          pageBuilder: (context, state) =>
              _fadeTransition(state, const TimelinePage()),
        ),
        GoRoute(
          path: '/now',
          name: 'now',
          pageBuilder: (context, state) =>
              _fadeTransition(state, const NowPage()),
        ),
      ],
    ),
  ],
  errorPageBuilder: (context, state) =>
      _fadeTransition(state, const NotFoundPage()),
);

CustomTransitionPage _fadeTransition(GoRouterState state, Widget child) {
  return CustomTransitionPage(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(parent: animation, curve: Curves.easeOut);
      return FadeTransition(
        opacity: curved,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.03),
            end: Offset.zero,
          ).animate(curved),
          child: child,
        ),
      );
    },
  );
}
