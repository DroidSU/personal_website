import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/firebase_service.dart';
import '../../../shared/models/trek_model.dart';
import '../repository/trek_repository.dart';

final trekRepositoryProvider = Provider<TrekRepository>((ref) {
  return TrekRepository(FirebaseService().firestore);
});

final allTreksProvider = FutureProvider<List<TrekModel>>((ref) async {
  final repository = ref.watch(trekRepositoryProvider);
  return repository.getAllTreks();
});

final featuredTreksProvider = FutureProvider<List<TrekModel>>((ref) async {
  final repository = ref.watch(trekRepositoryProvider);
  return repository.getFeaturedTreks();
});

final trekBySlugProvider = FutureProvider.family<TrekModel?, String>((ref, slug) async {
  final repository = ref.watch(trekRepositoryProvider);
  return repository.getTrekBySlug(slug);
});
