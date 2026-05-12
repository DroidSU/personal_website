import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/constants/firebase_constants.dart';
import '../../../core/constants/image_constants.dart';
import '../../../core/utils/logger.dart';
import '../../../shared/models/project_model.dart';

class ProjectRepository {
  final FirebaseFirestore _firestore;

  ProjectRepository(this._firestore);

  CollectionReference get _collection => _firestore.collection(FirebaseCollections.projects);

  Future<List<ProjectModel>> getAllProjects() async {
    try {
      final snapshot = await _collection.orderBy('createdAt', descending: true).get();
      if (snapshot.docs.isEmpty) return _dummyProjects;
      return snapshot.docs.map((doc) => ProjectModel.fromFirestore(doc)).toList();
    } catch (e) {
      AppLogger.error('Error fetching projects: $e');
      return _dummyProjects;
    }
  }

  Future<List<ProjectModel>> getFeaturedProjects() async {
    try {
      final snapshot = await _collection
          .where('featured', isEqualTo: true)
          .orderBy('createdAt', descending: true)
          .get();
      if (snapshot.docs.isEmpty) {
        return _dummyProjects.where((p) => p.featured).toList();
      }
      return snapshot.docs.map((doc) => ProjectModel.fromFirestore(doc)).toList();
    } catch (e) {
      AppLogger.error('Error fetching featured projects: $e');
      return _dummyProjects.where((p) => p.featured).toList();
    }
  }

  Future<ProjectModel?> getProjectBySlug(String slug) async {
    try {
      final snapshot = await _collection.where('slug', isEqualTo: slug).limit(1).get();
      if (snapshot.docs.isEmpty) {
        try {
          return _dummyProjects.firstWhere((p) => p.slug == slug);
        } catch (_) {
          return null;
        }
      }
      return ProjectModel.fromFirestore(snapshot.docs.first);
    } catch (e) {
      AppLogger.error('Error fetching project by slug: $e');
      return null;
    }
  }

  Future<void> addProject(ProjectModel project) async {
    try {
      await _collection.doc(project.id.isEmpty ? null : project.id).set(project.toMap());
    } catch (e) {
      AppLogger.error('Error adding project: $e');
      rethrow;
    }
  }

  Future<void> updateProject(ProjectModel project) async {
    try {
      await _collection.doc(project.id).update(project.toMap());
    } catch (e) {
      AppLogger.error('Error updating project: $e');
      rethrow;
    }
  }

  Future<void> deleteProject(String id) async {
    try {
      await _collection.doc(id).delete();
    } catch (e) {
      AppLogger.error('Error deleting project: $e');
      rethrow;
    }
  }

  final List<ProjectModel> _dummyProjects = [
    ProjectModel(
      id: '1',
      title: 'The Mobile Explorer App',
      slug: 'mobile-explorer-app',
      shortDescription: 'A comprehensive travel companion for trekking enthusiasts.',
      fullDescription: 'The Mobile Explorer App is designed for trekkers to track their routes, share experiences, and discover new trails in the Himalayas.',
      coverImage: ImageConstants.placeholderProject,
      galleryImages: const [],
      techStack: const ['Flutter', 'Firebase', 'Google Maps API'],
      platform: 'Android & iOS',
      githubUrl: 'https://github.com/sujoydutta/mobile-explorer',
      playStoreUrl: '',
      featured: true,
      status: 'In Development',
      highlights: const ['Offline Maps', 'Community Posts', 'Trek Tracking'],
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
      updatedAt: DateTime.now(),
    ),
    ProjectModel(
      id: '2',
      title: 'Portfolio Website',
      slug: 'portfolio-website',
      shortDescription: 'My personal portfolio built with Flutter Web.',
      fullDescription: 'A clean, responsive, and dynamic portfolio website showcasing my work, treks, and thoughts.',
      coverImage: ImageConstants.placeholderProject,
      galleryImages: const [],
      techStack: const ['Flutter Web', 'Firebase Firestore', 'Riverpod'],
      platform: 'Web',
      githubUrl: 'https://github.com/sujoydutta/portfolio',
      playStoreUrl: '',
      featured: true,
      status: 'Completed',
      highlights: const ['Responsive Design', 'Dynamic Data', 'SEO Optimized'],
      createdAt: DateTime.now().subtract(const Duration(days: 60)),
      updatedAt: DateTime.now(),
    ),
    ProjectModel(
      id: '3',
      title: 'Task Management System',
      slug: 'task-system',
      shortDescription: 'Enterprise-grade task management tool.',
      fullDescription: 'A robust system for teams to manage tasks, sprints, and productivity metrics.',
      coverImage: ImageConstants.placeholderProject,
      galleryImages: const [],
      techStack: const ['Flutter', 'Node.js', 'MongoDB'],
      platform: 'Android',
      githubUrl: 'https://github.com/sujoydutta/task-system',
      playStoreUrl: '',
      featured: false,
      status: 'Legacy',
      highlights: const ['Real-time Updates', 'Charts & Analytics', 'Team Collaboration'],
      createdAt: DateTime.now().subtract(const Duration(days: 90)),
      updatedAt: DateTime.now(),
    ),
  ];
}
