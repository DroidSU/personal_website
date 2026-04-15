import 'package:cloud_firestore/cloud_firestore.dart';

class Story {
  final String id;
  final String title;
  final String image;
  final String summary;

  Story({
    required this.id,
    required this.title,
    required this.image,
    required this.summary,
  });

  factory Story.fromFirestore(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    return Story(
      id: doc.id,
      title: data['title'] as String? ?? 'Untitled Story',
      image: data['image'] as String? ?? '',
      summary: data['summary'] as String? ?? '',
    );
  }
}
