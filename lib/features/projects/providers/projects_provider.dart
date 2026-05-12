import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/firebase_service.dart';
import '../../../shared/models/project_model.dart';
import '../repository/project_repository.dart';

final projectRepositoryProvider = Provider<ProjectRepository>((ref) {
  return ProjectRepository(FirebaseService().firestore);
});

final allProjectsProvider = FutureProvider<List<ProjectModel>>((ref) async {
  final repository = ref.watch(projectRepositoryProvider);
  return repository.getAllProjects();
});

final featuredProjectsProvider = FutureProvider<List<ProjectModel>>((ref) async {
  final repository = ref.watch(projectRepositoryProvider);
  return repository.getFeaturedProjects();
});

final projectBySlugProvider = FutureProvider.family<ProjectModel?, String>((ref, slug) async {
  final repository = ref.watch(projectRepositoryProvider);
  return repository.getProjectBySlug(slug);
});
