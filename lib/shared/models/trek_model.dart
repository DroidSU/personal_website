import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

import '../../core/constants/image_constants.dart';

class TrekModel extends Equatable {
  final String id;
  final String title;
  final String slug;
  final String location;
  final String coverImage;
  final List<String> galleryImages;
  final String description;
  final String difficulty;
  final String duration;
  final String altitude;
  final DateTime completedOn;
  final bool featured;
  final List<String> tags;
  final DateTime createdAt;

  const TrekModel({
    required this.id,
    required this.title,
    required this.slug,
    required this.location,
    required this.coverImage,
    required this.galleryImages,
    required this.description,
    required this.difficulty,
    required this.duration,
    required this.altitude,
    required this.completedOn,
    required this.featured,
    required this.tags,
    required this.createdAt,
  });

  TrekModel copyWith({
    String? id,
    String? title,
    String? slug,
    String? location,
    String? coverImage,
    List<String>? galleryImages,
    String? description,
    String? difficulty,
    String? duration,
    String? altitude,
    DateTime? completedOn,
    bool? featured,
    List<String>? tags,
    DateTime? createdAt,
  }) {
    return TrekModel(
      id: id ?? this.id,
      title: title ?? this.title,
      slug: slug ?? this.slug,
      location: location ?? this.location,
      coverImage: coverImage ?? this.coverImage,
      galleryImages: galleryImages ?? this.galleryImages,
      description: description ?? this.description,
      difficulty: difficulty ?? this.difficulty,
      duration: duration ?? this.duration,
      altitude: altitude ?? this.altitude,
      completedOn: completedOn ?? this.completedOn,
      featured: featured ?? this.featured,
      tags: tags ?? this.tags,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'slug': slug,
      'location': location,
      'coverImage': coverImage,
      'galleryImages': galleryImages,
      'description': description,
      'difficulty': difficulty,
      'duration': duration,
      'altitude': altitude,
      'completedOn': Timestamp.fromDate(completedOn),
      'featured': featured,
      'tags': tags,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory TrekModel.fromMap(Map<String, dynamic> map, String id) {
    return TrekModel(
      id: id,
      title: map['title'] ?? '',
      slug: map['slug'] ?? '',
      location: map['location'] ?? '',
      coverImage: map['coverImage'] ?? ImageConstants.placeholderTrek,
      galleryImages: List<String>.from(map['galleryImages'] ?? []),
      description: map['description'] ?? '',
      difficulty: map['difficulty'] ?? '',
      duration: map['duration'] ?? '',
      altitude: map['altitude'] ?? '',
      completedOn: (map['completedOn'] as Timestamp?)?.toDate() ?? DateTime.now(),
      featured: map['featured'] ?? false,
      tags: List<String>.from(map['tags'] ?? []),
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  factory TrekModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return TrekModel.fromMap(data, doc.id);
  }

  factory TrekModel.empty() {
    return TrekModel(
      id: '',
      title: '',
      slug: '',
      location: '',
      coverImage: ImageConstants.placeholderTrek,
      galleryImages: const [],
      description: '',
      difficulty: '',
      duration: '',
      altitude: '',
      completedOn: DateTime.now(),
      featured: false,
      tags: const [],
      createdAt: DateTime.now(),
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        slug,
        location,
        coverImage,
        galleryImages,
        description,
        difficulty,
        duration,
        altitude,
        completedOn,
        featured,
        tags,
        createdAt,
      ];
}
