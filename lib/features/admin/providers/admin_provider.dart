import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/firebase_service.dart';
import '../../diary/providers/diary_provider.dart';
import '../../projects/providers/projects_provider.dart';
import '../../treks/providers/treks_provider.dart';
import '../services/upload_service.dart';

final uploadServiceProvider = Provider<UploadService>((ref) {
  return UploadService(FirebaseService().storage);
});

final adminLoadingProvider = StateProvider<bool>((ref) => false);

final adminProjectsProvider = FutureProvider((ref) async {
  final repository = ref.watch(projectRepositoryProvider);
  return repository.getAllProjects();
});

final adminTreksProvider = FutureProvider((ref) async {
  final repository = ref.watch(trekRepositoryProvider);
  return repository.getAllTreks();
});

final adminDiaryPostsProvider = FutureProvider((ref) async {
  final repository = ref.watch(diaryRepositoryProvider);
  return repository.getAllPosts();
});
