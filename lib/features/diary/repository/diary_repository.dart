import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/constants/firebase_constants.dart';
import '../../../core/constants/image_constants.dart';
import '../../../core/utils/logger.dart';
import '../../../shared/models/diary_post_model.dart';

class DiaryRepository {
  final FirebaseFirestore _firestore;

  DiaryRepository(this._firestore);

  CollectionReference get _collection => _firestore.collection(FirebaseCollections.diaryPosts);

  Future<List<DiaryPostModel>> getAllPosts() async {
    try {
      final snapshot = await _collection
          .orderBy('publishedAt', descending: true)
          .get();
      if (snapshot.docs.isEmpty) return _dummyPosts;
      return snapshot.docs.map((doc) => DiaryPostModel.fromFirestore(doc)).toList();
    } catch (e) {
      AppLogger.error('Error fetching diary posts: $e');
      return _dummyPosts;
    }
  }

  Future<List<DiaryPostModel>> getPublishedPosts() async {
    try {
      final snapshot = await _collection
          .where('published', isEqualTo: true)
          .orderBy('publishedAt', descending: true)
          .get();
      if (snapshot.docs.isEmpty) return _dummyPosts.where((p) => p.published).toList();
      return snapshot.docs.map((doc) => DiaryPostModel.fromFirestore(doc)).toList();
    } catch (e) {
      AppLogger.error('Error fetching published diary posts: $e');
      return _dummyPosts.where((p) => p.published).toList();
    }
  }

  Future<List<DiaryPostModel>> getFeaturedPosts() async {
    try {
      final snapshot = await _collection
          .where('featured', isEqualTo: true)
          .where('published', isEqualTo: true)
          .orderBy('publishedAt', descending: true)
          .get();
      if (snapshot.docs.isEmpty) {
        return _dummyPosts.where((p) => p.featured && p.published).toList();
      }
      return snapshot.docs.map((doc) => DiaryPostModel.fromFirestore(doc)).toList();
    } catch (e) {
      AppLogger.error('Error fetching featured posts: $e');
      return _dummyPosts.where((p) => p.featured && p.published).toList();
    }
  }

  Future<DiaryPostModel?> getPostBySlug(String slug) async {
    try {
      final snapshot = await _collection.where('slug', isEqualTo: slug).limit(1).get();
      if (snapshot.docs.isEmpty) {
        try {
          return _dummyPosts.firstWhere((p) => p.slug == slug);
        } catch (_) {
          return null;
        }
      }
      return DiaryPostModel.fromFirestore(snapshot.docs.first);
    } catch (e) {
      AppLogger.error('Error fetching post by slug: $e');
      return null;
    }
  }

  Future<void> addPost(DiaryPostModel post) async {
    try {
      await _collection.doc(post.id.isEmpty ? null : post.id).set(post.toMap());
    } catch (e) {
      AppLogger.error('Error adding post: $e');
      rethrow;
    }
  }

  Future<void> updatePost(DiaryPostModel post) async {
    try {
      await _collection.doc(post.id).update(post.toMap());
    } catch (e) {
      AppLogger.error('Error updating post: $e');
      rethrow;
    }
  }

  Future<void> deletePost(String id) async {
    try {
      await _collection.doc(id).delete();
    } catch (e) {
      AppLogger.error('Error deleting post: $e');
      rethrow;
    }
  }

  final List<DiaryPostModel> _dummyPosts = [
    DiaryPostModel(
      id: '1',
      title: 'Why Flutter is my first choice for 2024',
      slug: 'why-flutter-2024',
      excerpt: 'Exploring the evolution of Flutter and why it remains top-tier for cross-platform development.',
      content: '# Why Flutter?\n\nFlutter has changed the way we build apps. With its **fast development**, **expressive UI**, and **native performance**, it is hard to beat.\n\n## Key Benefits\n- Single Codebase\n- Hot Reload\n- Rich Widgets',
      coverImage: ImageConstants.placeholderDiary,
      category: 'Tech',
      tags: const ['Flutter', 'Mobile Dev'],
      readTime: 5,
      published: true,
      featured: true,
      publishedAt: DateTime.now().subtract(const Duration(days: 5)),
      createdAt: DateTime.now(),
    ),
    DiaryPostModel(
      id: '2',
      title: 'Lessons from the Mountains',
      slug: 'lessons-mountains',
      excerpt: 'What trekking taught me about perseverance and problem-solving in engineering.',
      content: '# Mountain Lessons\n\nTrekking is not just about the destination; it is about the journey and the challenges you face along the way. Much like a complex software project, a long trek requires careful planning and persistence.',
      coverImage: ImageConstants.placeholderDiary,
      category: 'Life',
      tags: const ['Trekking', 'Personal Growth'],
      readTime: 8,
      published: true,
      featured: true,
      publishedAt: DateTime.now().subtract(const Duration(days: 15)),
      createdAt: DateTime.now(),
    ),
    DiaryPostModel(
      id: '3',
      title: 'Clean Architecture in Flutter',
      slug: 'clean-architecture-flutter',
      excerpt: 'A deep dive into organizing your Flutter projects for scalability and testability.',
      content: '# Clean Architecture\n\nSeparation of concerns is key. By dividing your app into layers—Data, Domain, and Presentation—you make it easier to maintain.',
      coverImage: ImageConstants.placeholderDiary,
      category: 'Engineering',
      tags: const ['Architecture', 'Best Practices'],
      readTime: 12,
      published: true,
      featured: false,
      publishedAt: DateTime.now().subtract(const Duration(days: 25)),
      createdAt: DateTime.now(),
    ),
  ];
}
