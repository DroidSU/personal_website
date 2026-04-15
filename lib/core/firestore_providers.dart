import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'firestore_service.dart';
import '../firebase_options.dart';
import '../features/explore/story_model.dart';
import '../features/timeline/timeline_event_model.dart';
import '../features/now/now_status_model.dart';

final firebaseInitializationProvider = FutureProvider<FirebaseApp>((ref) async {
  if (Firebase.apps.isEmpty) {
    return Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
  return Firebase.app();
});

final firestoreServiceProvider = Provider<FirestoreService>(
  (ref) => FirestoreService(FirebaseFirestore.instance),
);

final storiesProvider = FutureProvider<List<Story>>((ref) async {
  await ref.watch(firebaseInitializationProvider.future);
  final service = ref.watch(firestoreServiceProvider);
  return service.fetchStories();
});

final timelineEventsProvider = FutureProvider<List<TimelineEventModel>>((
  ref,
) async {
  await ref.watch(firebaseInitializationProvider.future);
  final service = ref.watch(firestoreServiceProvider);
  return service.fetchTimelineEvents();
});

final nowStatusesProvider = FutureProvider<List<NowStatus>>((ref) async {
  await ref.watch(firebaseInitializationProvider.future);
  final service = ref.watch(firestoreServiceProvider);
  return service.fetchNowStatuses();
});
