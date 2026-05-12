import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../../core/utils/slug_helper.dart';
import '../../../shared/models/diary_post_model.dart';
import '../../diary/providers/diary_provider.dart';
import '../providers/admin_provider.dart';
import '../widgets/admin_common_widgets.dart';
import '../widgets/admin_form_widgets.dart';

class AddEditDiaryPage extends ConsumerStatefulWidget {
  final String? slug;

  const AddEditDiaryPage({super.key, this.slug});

  @override
  ConsumerState<AddEditDiaryPage> createState() => _AddEditDiaryPageState();
}

class _AddEditDiaryPageState extends ConsumerState<AddEditDiaryPage> {
  final _formKey = GlobalKey<FormState>();
  late DiaryPostModel _post;
  bool _isEdit = false;
  bool _isLoading = false;

  final _titleController = TextEditingController();
  final _slugController = TextEditingController();
  final _excerptController = TextEditingController();
  final _contentController = TextEditingController();
  final _categoryController = TextEditingController();
  final _readTimeController = TextEditingController();
  final _publishedAtController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _isEdit = widget.slug != null;
    if (_isEdit) {
      _loadPost();
    } else {
      _post = DiaryPostModel.empty();
      _publishedAtController.text = DateFormat('yyyy-MM-dd').format(_post.publishedAt);
    }
    
    _contentController.addListener(() {
      setState(() {}); // For live markdown preview
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _slugController.dispose();
    _excerptController.dispose();
    _contentController.dispose();
    _categoryController.dispose();
    _readTimeController.dispose();
    _publishedAtController.dispose();
    super.dispose();
  }

  Future<void> _loadPost() async {
    setState(() => _isLoading = true);
    final repository = ref.read(diaryRepositoryProvider);
    final post = await repository.getPostBySlug(widget.slug!);
    if (post != null) {
      setState(() {
        _post = post;
        _titleController.text = post.title;
        _slugController.text = post.slug;
        _excerptController.text = post.excerpt;
        _contentController.text = post.content;
        _categoryController.text = post.category;
        _readTimeController.text = post.readTime.toString();
        _publishedAtController.text = DateFormat('yyyy-MM-dd').format(post.publishedAt);
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

    final updatedPost = _post.copyWith(
      id: _post.id.isEmpty ? const Uuid().v4() : _post.id,
      title: _titleController.text,
      slug: _slugController.text,
      excerpt: _excerptController.text,
      content: _contentController.text,
      category: _categoryController.text,
      readTime: int.tryParse(_readTimeController.text) ?? 0,
      publishedAt: DateTime.tryParse(_publishedAtController.text) ?? _post.publishedAt,
      createdAt: _post.id.isEmpty ? DateTime.now() : _post.createdAt,
    );

    try {
      final repository = ref.read(diaryRepositoryProvider);
      if (_isEdit) {
        await repository.updatePost(updatedPost);
      } else {
        await repository.addPost(updatedPost);
      }
      ref.invalidate(adminDiaryPostsProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Diary post saved successfully')));
        context.go('/admin/diary');
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
              title: _isEdit ? 'Edit Diary Post' : 'New Diary Post',
              actions: [
                TextButton(
                  onPressed: () => context.go('/admin/diary'),
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
                        label: 'Excerpt',
                        controller: _excerptController,
                        validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                      ),
                      AdminTextarea(
                        label: 'Content (Markdown)',
                        controller: _contentController,
                        maxLines: 20,
                        validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                      ),
                      const SizedBox(height: 16),
                      MarkdownPreviewCard(content: _contentController.text),
                    ],
                  ),
                ),
                const SizedBox(width: 32),
                Expanded(
                  child: Column(
                    children: [
                      SwitchListTile(
                        title: const Text('Published', style: TextStyle(color: Colors.white)),
                        value: _post.published,
                        onChanged: (v) => setState(() => _post = _post.copyWith(published: v)),
                        contentPadding: EdgeInsets.zero,
                      ),
                      SwitchListTile(
                        title: const Text('Featured', style: TextStyle(color: Colors.white)),
                        value: _post.featured,
                        onChanged: (v) => setState(() => _post = _post.copyWith(featured: v)),
                        contentPadding: EdgeInsets.zero,
                      ),
                      const SizedBox(height: 16),
                      AdminTextField(label: 'Category', controller: _categoryController),
                      AdminTextField(label: 'Read Time (minutes)', controller: _readTimeController),
                      AdminTextField(
                        label: 'Publish Date (YYYY-MM-DD)',
                        controller: _publishedAtController,
                        readOnly: true,
                        onTap: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: _post.publishedAt,
                            firstDate: DateTime(2000),
                            lastDate: DateTime.now().add(const Duration(days: 365)),
                          );
                          if (date != null) {
                            _publishedAtController.text = DateFormat('yyyy-MM-dd').format(date);
                          }
                        },
                      ),
                      AdminChipInput(
                        label: 'Tags',
                        initialValues: _post.tags,
                        onChanged: (v) => _post = _post.copyWith(tags: v),
                      ),
                      AdminImageUploader(
                        label: 'Cover Image',
                        imageUrl: _post.coverImage,
                        uploadPath: 'diary/${_slugController.text}/cover',
                        onUploadComplete: (url) => setState(() => _post = _post.copyWith(coverImage: url)),
                        onMultipleUploadComplete: (_) {},
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
