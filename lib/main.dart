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
import 'features/auth/login_page.dart';
import 'features/auth/providers/auth_provider.dart';
import 'features/home/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await FirebaseService().initialize();

  runApp(const ProviderScope(child: MyApp()));
}

final _routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);
  final userModel = ref.watch(userModelProvider);

  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final isLoggingIn = state.matchedLocation == '/login';
      final isAdminRoute = state.matchedLocation.startsWith('/admin');

      // If user is not logged in and trying to access admin
      if (isAdminRoute && authState.value == null) {
        return '/login';
      }

      // If user is logged in but not an admin (wait for userModel to load)
      if (isAdminRoute && userModel.hasValue && !userModel.value!.isAdmin) {
        return '/';
      }

      // If user is logged in and trying to access login page
      if (isLoggingIn && authState.value != null) {
        return '/admin';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
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
});

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(_routerProvider);
    
    return MaterialApp.router(
      title: 'Sujoy Dutta | The Mobile Explorer',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      routerConfig: router,
    );
  }
}
