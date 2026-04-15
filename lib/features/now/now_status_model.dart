import 'package:cloud_firestore/cloud_firestore.dart';

class NowStatus {
  final String title;
  final String details;
  final DateTime? updatedAt;

  NowStatus({required this.title, required this.details, this.updatedAt});

  factory NowStatus.fromFirestore(
    QueryDocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data();
    final timestamp = data['updatedAt'];
    DateTime? updated;
    if (timestamp is Timestamp) {
      updated = timestamp.toDate();
    }

    return NowStatus(
      title: data['title'] as String? ?? 'Current focus',
      details: data['details'] as String? ?? '',
      updatedAt: updated,
    );
  }
}
