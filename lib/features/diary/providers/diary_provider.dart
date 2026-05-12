import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/firebase_service.dart';
import '../../../shared/models/diary_post_model.dart';
import '../repository/diary_repository.dart';

final diaryRepositoryProvider = Provider<DiaryRepository>((ref) {
  return DiaryRepository(FirebaseService().firestore);
});

final allDiaryPostsProvider = FutureProvider<List<DiaryPostModel>>((ref) async {
  final repository = ref.watch(diaryRepositoryProvider);
  return repository.getPublishedPosts();
});

final featuredDiaryPostsProvider = FutureProvider<List<DiaryPostModel>>((ref) async {
  final repository = ref.watch(diaryRepositoryProvider);
  return repository.getFeaturedPosts();
});

final diaryPostBySlugProvider = FutureProvider.family<DiaryPostModel?, String>((ref, slug) async {
  final repository = ref.watch(diaryRepositoryProvider);
  return repository.getPostBySlug(slug);
});
