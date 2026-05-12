import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

import '../../core/constants/image_constants.dart';

class DiaryPostModel extends Equatable {
  final String id;
  final String title;
  final String slug;
  final String excerpt;
  final String content;
  final String coverImage;
  final String category;
  final List<String> tags;
  final int readTime;
  final bool published;
  final bool featured;
  final DateTime publishedAt;
  final DateTime createdAt;

  const DiaryPostModel({
    required this.id,
    required this.title,
    required this.slug,
    required this.excerpt,
    required this.content,
    required this.coverImage,
    required this.category,
    required this.tags,
    required this.readTime,
    required this.published,
    required this.featured,
    required this.publishedAt,
    required this.createdAt,
  });

  DiaryPostModel copyWith({
    String? id,
    String? title,
    String? slug,
    String? excerpt,
    String? content,
    String? coverImage,
    String? category,
    List<String>? tags,
    int? readTime,
    bool? published,
    bool? featured,
    DateTime? publishedAt,
    DateTime? createdAt,
  }) {
    return DiaryPostModel(
      id: id ?? this.id,
      title: title ?? this.title,
      slug: slug ?? this.slug,
      excerpt: excerpt ?? this.excerpt,
      content: content ?? this.content,
      coverImage: coverImage ?? this.coverImage,
      category: category ?? this.category,
      tags: tags ?? this.tags,
      readTime: readTime ?? this.readTime,
      published: published ?? this.published,
      featured: featured ?? this.featured,
      publishedAt: publishedAt ?? this.publishedAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'slug': slug,
      'excerpt': excerpt,
      'content': content,
      'coverImage': coverImage,
      'category': category,
      'tags': tags,
      'readTime': readTime,
      'published': published,
      'featured': featured,
      'publishedAt': Timestamp.fromDate(publishedAt),
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory DiaryPostModel.fromMap(Map<String, dynamic> map, String id) {
    return DiaryPostModel(
      id: id,
      title: map['title'] ?? '',
      slug: map['slug'] ?? '',
      excerpt: map['excerpt'] ?? '',
      content: map['content'] ?? '',
      coverImage: map['coverImage'] ?? ImageConstants.placeholderDiary,
      category: map['category'] ?? '',
      tags: List<String>.from(map['tags'] ?? []),
      readTime: map['readTime'] ?? 0,
      published: map['published'] ?? false,
      featured: map['featured'] ?? false,
      publishedAt: (map['publishedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  factory DiaryPostModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return DiaryPostModel.fromMap(data, doc.id);
  }

  factory DiaryPostModel.empty() {
    return DiaryPostModel(
      id: '',
      title: '',
      slug: '',
      excerpt: '',
      content: '',
      coverImage: ImageConstants.placeholderDiary,
      category: '',
      tags: const [],
      readTime: 0,
      published: false,
      featured: false,
      publishedAt: DateTime.now(),
      createdAt: DateTime.now(),
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        slug,
        excerpt,
        content,
        coverImage,
        category,
        tags,
        readTime,
        published,
        featured,
        publishedAt,
        createdAt,
      ];
}
