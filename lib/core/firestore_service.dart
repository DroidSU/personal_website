import 'package:cloud_firestore/cloud_firestore.dart';

import '../features/explore/story_model.dart';
import '../features/timeline/timeline_event_model.dart';
import '../features/now/now_status_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore;

  FirestoreService(this._firestore);

  Future<List<Story>> fetchStories() async {
    final snapshot = await _firestore
        .collection('stories')
        .orderBy('order', descending: false)
        .get();

    return snapshot.docs.map(Story.fromFirestore).toList();
  }

  Future<List<TimelineEventModel>> fetchTimelineEvents() async {
    final snapshot = await _firestore
        .collection('timeline')
        .orderBy('order', descending: false)
        .get();

    return snapshot.docs.map(TimelineEventModel.fromFirestore).toList();
  }

  Future<List<NowStatus>> fetchNowStatuses() async {
    final snapshot = await _firestore
        .collection('now')
        .orderBy('order', descending: false)
        .get();

    return snapshot.docs.map(NowStatus.fromFirestore).toList();
  }
}
