import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/constants/firebase_constants.dart';
import '../../../core/constants/image_constants.dart';
import '../../../core/utils/logger.dart';
import '../../../shared/models/trek_model.dart';

class TrekRepository {
  final FirebaseFirestore _firestore;

  TrekRepository(this._firestore);

  CollectionReference get _collection => _firestore.collection(FirebaseCollections.treks);

  Future<List<TrekModel>> getAllTreks() async {
    try {
      final snapshot = await _collection.orderBy('completedOn', descending: true).get();
      if (snapshot.docs.isEmpty) return _dummyTreks;
      return snapshot.docs.map((doc) => TrekModel.fromFirestore(doc)).toList();
    } catch (e) {
      AppLogger.error('Error fetching treks: $e');
      return _dummyTreks;
    }
  }

  Future<List<TrekModel>> getFeaturedTreks() async {
    try {
      final snapshot = await _collection
          .where('featured', isEqualTo: true)
          .orderBy('completedOn', descending: true)
          .get();
      if (snapshot.docs.isEmpty) {
        return _dummyTreks.where((t) => t.featured).toList();
      }
      return snapshot.docs.map((doc) => TrekModel.fromFirestore(doc)).toList();
    } catch (e) {
      AppLogger.error('Error fetching featured treks: $e');
      return _dummyTreks.where((t) => t.featured).toList();
    }
  }

  Future<TrekModel?> getTrekBySlug(String slug) async {
    try {
      final snapshot = await _collection.where('slug', isEqualTo: slug).limit(1).get();
      if (snapshot.docs.isEmpty) {
        try {
          return _dummyTreks.firstWhere((t) => t.slug == slug);
        } catch (_) {
          return null;
        }
      }
      return TrekModel.fromFirestore(snapshot.docs.first);
    } catch (e) {
      AppLogger.error('Error fetching trek by slug: $e');
      return null;
    }
  }

  Future<void> addTrek(TrekModel trek) async {
    try {
      await _collection.doc(trek.id.isEmpty ? null : trek.id).set(trek.toMap());
    } catch (e) {
      AppLogger.error('Error adding trek: $e');
      rethrow;
    }
  }

  Future<void> updateTrek(TrekModel trek) async {
    try {
      await _collection.doc(trek.id).update(trek.toMap());
    } catch (e) {
      AppLogger.error('Error updating trek: $e');
      rethrow;
    }
  }

  Future<void> deleteTrek(String id) async {
    try {
      await _collection.doc(id).delete();
    } catch (e) {
      AppLogger.error('Error deleting trek: $e');
      rethrow;
    }
  }

  final List<TrekModel> _dummyTreks = [
    TrekModel(
      id: '1',
      title: 'Roopkund Trek',
      slug: 'roopkund-trek',
      location: 'Uttarakhand, India',
      coverImage: ImageConstants.placeholderTrek,
      galleryImages: const [],
      description: 'The Mystery Lake trek through beautiful meadows.',
      difficulty: 'Hard',
      duration: '8 Days',
      altitude: '16,470 ft',
      completedOn: DateTime(2022, 6, 15),
      featured: true,
      tags: const ['Glacial Lake', 'Himalayas', 'Adventure'],
      createdAt: DateTime.now(),
    ),
    TrekModel(
      id: '2',
      title: 'Hampta Pass',
      slug: 'hampta-pass',
      location: 'Himachal Pradesh, India',
      coverImage: ImageConstants.placeholderTrek,
      galleryImages: const [],
      description: 'A dramatic shift in scenery from lush green to desert cold.',
      difficulty: 'Moderate',
      duration: '5 Days',
      altitude: '14,100 ft',
      completedOn: DateTime(2023, 7, 20),
      featured: true,
      tags: const ['Pass Crossing', 'Crossover Trek'],
      createdAt: DateTime.now(),
    ),
    TrekModel(
      id: '3',
      title: 'Sandakphu Trek',
      slug: 'sandakphu-trek',
      location: 'West Bengal, India',
      coverImage: ImageConstants.placeholderTrek,
      galleryImages: const [],
      description: 'The highest point of West Bengal offering views of 4 of the 5 highest peaks.',
      difficulty: 'Moderate',
      duration: '6 Days',
      altitude: '11,930 ft',
      completedOn: DateTime(2021, 11, 10),
      featured: false,
      tags: const ['Everest View', 'Kanchenjunga'],
      createdAt: DateTime.now(),
    ),
  ];
}
