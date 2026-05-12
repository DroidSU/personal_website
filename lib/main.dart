import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'core/services/firebase_service.dart';
import 'core/theme/app_theme.dart';
import 'features/admin/admin_dashboard.dart';
import 'features/admin/admin_home_page.dart';
import 'features/admin/diary/add_edit_diary_page.dart';
import 'features/admin/diary/diary_list_page.dart';
import 'features/admin/projects/add_edit_project_page.dart';
import 'features/admin/projects/project_list_page.dart';
import 'features/admin/treks/add_edit_trek_page.dart';
import 'features/admin/treks/trek_list_page.dart';
import 'features/home/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await FirebaseService().initialize();

  runApp(const ProviderScope(child: MyApp()));
}

final _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomePage(),
    ),
    ShellRoute(
      builder: (context, state, child) => AdminDashboard(child: child),
      routes: [
        GoRoute(
          path: '/admin',
          builder: (context, state) => const AdminHomePage(),
        ),
        GoRoute(
          path: '/admin/projects',
          builder: (context, state) => const ProjectListPage(),
          routes: [
            GoRoute(
              path: 'new',
              builder: (context, state) => const AddEditProjectPage(),
            ),
            GoRoute(
              path: 'edit/:slug',
              builder: (context, state) => AddEditProjectPage(slug: state.pathParameters['slug']),
            ),
          ],
        ),
        GoRoute(
          path: '/admin/treks',
          builder: (context, state) => const TrekListPage(),
          routes: [
            GoRoute(
              path: 'new',
              builder: (context, state) => const AddEditTrekPage(),
            ),
            GoRoute(
              path: 'edit/:slug',
              builder: (context, state) => AddEditTrekPage(slug: state.pathParameters['slug']),
            ),
          ],
        ),
        GoRoute(
          path: '/admin/diary',
          builder: (context, state) => const DiaryListPage(),
          routes: [
            GoRoute(
              path: 'new',
              builder: (context, state) => const AddEditDiaryPage(),
            ),
            GoRoute(
              path: 'edit/:slug',
              builder: (context, state) => AddEditDiaryPage(slug: state.pathParameters['slug']),
            ),
          ],
        ),
      ],
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Sujoy Dutta | The Mobile Explorer',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      routerConfig: _router,
    );
  }
}
