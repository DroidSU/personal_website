import 'package:cloud_firestore/cloud_firestore.dart';

class TimelineEventModel {
  final String year;
  final String title;
  final String description;

  TimelineEventModel({
    required this.year,
    required this.title,
    required this.description,
  });

  factory TimelineEventModel.fromFirestore(
    QueryDocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data();
    return TimelineEventModel(
      year: data['year'] as String? ?? '',
      title: data['title'] as String? ?? '',
      description: data['description'] as String? ?? '',
    );
  }
}
