import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

import '../../core/constants/image_constants.dart';

class ProjectModel extends Equatable {
  final String id;
  final String title;
  final String slug;
  final String shortDescription;
  final String fullDescription;
  final String coverImage;
  final List<String> galleryImages;
  final List<String> techStack;
  final String platform;
  final String githubUrl;
  final String playStoreUrl;
  final bool featured;
  final String status;
  final List<String> highlights;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ProjectModel({
    required this.id,
    required this.title,
    required this.slug,
    required this.shortDescription,
    required this.fullDescription,
    required this.coverImage,
    required this.galleryImages,
    required this.techStack,
    required this.platform,
    required this.githubUrl,
    required this.playStoreUrl,
    required this.featured,
    required this.status,
    required this.highlights,
    required this.createdAt,
    required this.updatedAt,
  });

  ProjectModel copyWith({
    String? id,
    String? title,
    String? slug,
    String? shortDescription,
    String? fullDescription,
    String? coverImage,
    List<String>? galleryImages,
    List<String>? techStack,
    String? platform,
    String? githubUrl,
    String? playStoreUrl,
    bool? featured,
    String? status,
    List<String>? highlights,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ProjectModel(
      id: id ?? this.id,
      title: title ?? this.title,
      slug: slug ?? this.slug,
      shortDescription: shortDescription ?? this.shortDescription,
      fullDescription: fullDescription ?? this.fullDescription,
      coverImage: coverImage ?? this.coverImage,
      galleryImages: galleryImages ?? this.galleryImages,
      techStack: techStack ?? this.techStack,
      platform: platform ?? this.platform,
      githubUrl: githubUrl ?? this.githubUrl,
      playStoreUrl: playStoreUrl ?? this.playStoreUrl,
      featured: featured ?? this.featured,
      status: status ?? this.status,
      highlights: highlights ?? this.highlights,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'slug': slug,
      'shortDescription': shortDescription,
      'fullDescription': fullDescription,
      'coverImage': coverImage,
      'galleryImages': galleryImages,
      'techStack': techStack,
      'platform': platform,
      'githubUrl': githubUrl,
      'playStoreUrl': playStoreUrl,
      'featured': featured,
      'status': status,
      'highlights': highlights,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  factory ProjectModel.fromMap(Map<String, dynamic> map, String id) {
    return ProjectModel(
      id: id,
      title: map['title'] ?? '',
      slug: map['slug'] ?? '',
      shortDescription: map['shortDescription'] ?? '',
      fullDescription: map['fullDescription'] ?? '',
      coverImage: map['coverImage'] ?? ImageConstants.placeholderProject,
      galleryImages: List<String>.from(map['galleryImages'] ?? []),
      techStack: List<String>.from(map['techStack'] ?? []),
      platform: map['platform'] ?? '',
      githubUrl: map['githubUrl'] ?? '',
      playStoreUrl: map['playStoreUrl'] ?? '',
      featured: map['featured'] ?? false,
      status: map['status'] ?? '',
      highlights: List<String>.from(map['highlights'] ?? []),
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (map['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  factory ProjectModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ProjectModel.fromMap(data, doc.id);
  }

  factory ProjectModel.empty() {
    return ProjectModel(
      id: '',
      title: '',
      slug: '',
      shortDescription: '',
      fullDescription: '',
      coverImage: ImageConstants.placeholderProject,
      galleryImages: const [],
      techStack: const [],
      platform: '',
      githubUrl: '',
      playStoreUrl: '',
      featured: false,
      status: '',
      highlights: const [],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        slug,
        shortDescription,
        fullDescription,
        coverImage,
        galleryImages,
        techStack,
        platform,
        githubUrl,
        playStoreUrl,
        featured,
        status,
        highlights,
        createdAt,
        updatedAt,
      ];
}
