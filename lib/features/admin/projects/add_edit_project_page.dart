import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import '../../../core/utils/slug_helper.dart';
import '../../../shared/models/project_model.dart';
import '../../projects/providers/projects_provider.dart';
import '../providers/admin_provider.dart';
import '../widgets/admin_common_widgets.dart';
import '../widgets/admin_form_widgets.dart';

class AddEditProjectPage extends ConsumerStatefulWidget {
  final String? slug;

  const AddEditProjectPage({super.key, this.slug});

  @override
  ConsumerState<AddEditProjectPage> createState() => _AddEditProjectPageState();
}

class _AddEditProjectPageState extends ConsumerState<AddEditProjectPage> {
  final _formKey = GlobalKey<FormState>();
  late ProjectModel _project;
  bool _isEdit = false;
  bool _isLoading = false;

  final _titleController = TextEditingController();
  final _slugController = TextEditingController();
  final _shortDescController = TextEditingController();
  final _fullDescController = TextEditingController();
  final _platformController = TextEditingController();
  final _githubController = TextEditingController();
  final _playStoreController = TextEditingController();
  final _statusController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _isEdit = widget.slug != null;
    if (_isEdit) {
      _loadProject();
    } else {
      _project = ProjectModel.empty();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _slugController.dispose();
    _shortDescController.dispose();
    _fullDescController.dispose();
    _platformController.dispose();
    _githubController.dispose();
    _playStoreController.dispose();
    _statusController.dispose();
    super.dispose();
  }

  Future<void> _loadProject() async {
    setState(() => _isLoading = true);
    final repository = ref.read(projectRepositoryProvider);
    final project = await repository.getProjectBySlug(widget.slug!);
    if (project != null) {
      setState(() {
        _project = project;
        _titleController.text = project.title;
        _slugController.text = project.slug;
        _shortDescController.text = project.shortDescription;
        _fullDescController.text = project.fullDescription;
        _platformController.text = project.platform;
        _githubController.text = project.githubUrl;
        _playStoreController.text = project.playStoreUrl;
        _statusController.text = project.status;
      });
    }
    setState(() => _isLoading = false);
  }

  void _onTitleChanged(String value) {
    if (!_isEdit) {
      _slugController.text = SlugHelper.generateSlug(value);
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final updatedProject = _project.copyWith(
      id: _project.id.isEmpty ? const Uuid().v4() : _project.id,
      title: _titleController.text,
      slug: _slugController.text,
      shortDescription: _shortDescController.text,
      fullDescription: _fullDescController.text,
      platform: _platformController.text,
      githubUrl: _githubController.text,
      playStoreUrl: _playStoreController.text,
      status: _statusController.text,
      updatedAt: DateTime.now(),
      createdAt: _project.id.isEmpty ? DateTime.now() : _project.createdAt,
    );

    try {
      final repository = ref.read(projectRepositoryProvider);
      if (_isEdit) {
        await repository.updateProject(updatedProject);
      } else {
        await repository.addProject(updatedProject);
      }
      ref.invalidate(adminProjectsProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Project saved successfully')));
        context.go('/admin/projects');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading && _isEdit && _titleController.text.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AdminSectionTitle(
              title: _isEdit ? 'Edit Project' : 'Add New Project',
              actions: [
                TextButton(
                  onPressed: () => context.go('/admin/projects'),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 16),
                SizedBox(
                  width: 120,
                  child: AdminLoadingButton(
                    text: 'Save',
                    onPressed: _save,
                    isLoading: _isLoading,
                  ),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      AdminTextField(
                        label: 'Title',
                        controller: _titleController,
                        onChanged: _onTitleChanged,
                        validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                      ),
                      AdminTextField(
                        label: 'Slug',
                        controller: _slugController,
                        validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                      ),
                      AdminTextField(
                        label: 'Short Description',
                        controller: _shortDescController,
                        validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                      ),
                      AdminTextarea(
                        label: 'Full Description',
                        controller: _fullDescController,
                        validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: AdminTextField(
                              label: 'Platform',
                              controller: _platformController,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: AdminTextField(
                              label: 'Status',
                              controller: _statusController,
                            ),
                          ),
                        ],
                      ),
                      AdminTextField(label: 'GitHub URL', controller: _githubController),
                      AdminTextField(label: 'Play Store URL', controller: _playStoreController),
                      AdminChipInput(
                        label: 'Tech Stack',
                        initialValues: _project.techStack,
                        onChanged: (v) => _project = _project.copyWith(techStack: v),
                      ),
                      AdminChipInput(
                        label: 'Highlights',
                        initialValues: _project.highlights,
                        onChanged: (v) => _project = _project.copyWith(highlights: v),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 32),
                Expanded(
                  child: Column(
                    children: [
                      SwitchListTile(
                        title: const Text('Featured Project', style: TextStyle(color: Colors.white)),
                        value: _project.featured,
                        onChanged: (v) => setState(() => _project = _project.copyWith(featured: v)),
                        contentPadding: EdgeInsets.zero,
                      ),
                      const SizedBox(height: 16),
                      AdminImageUploader(
                        label: 'Cover Image',
                        imageUrl: _project.coverImage,
                        uploadPath: 'projects/${_slugController.text}/cover',
                        onUploadComplete: (url) => setState(() => _project = _project.copyWith(coverImage: url)),
                        onMultipleUploadComplete: (_) {},
                      ),
                      AdminImageUploader(
                        label: 'Gallery Images',
                        imageUrls: _project.galleryImages,
                        isMultiple: true,
                        uploadPath: 'projects/${_slugController.text}/gallery',
                        onUploadComplete: (_) {},
                        onMultipleUploadComplete: (urls) => setState(() => _project = _project.copyWith(galleryImages: urls)),
                        onSetAsCover: (url) => setState(() => _project = _project.copyWith(coverImage: url)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
