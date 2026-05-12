import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../../core/utils/slug_helper.dart';
import '../../../shared/models/trek_model.dart';
import '../../treks/providers/treks_provider.dart';
import '../providers/admin_provider.dart';
import '../widgets/admin_common_widgets.dart';
import '../widgets/admin_form_widgets.dart';

class AddEditTrekPage extends ConsumerStatefulWidget {
  final String? slug;

  const AddEditTrekPage({super.key, this.slug});

  @override
  ConsumerState<AddEditTrekPage> createState() => _AddEditTrekPageState();
}

class _AddEditTrekPageState extends ConsumerState<AddEditTrekPage> {
  final _formKey = GlobalKey<FormState>();
  late TrekModel _trek;
  bool _isEdit = false;
  bool _isLoading = false;

  final _titleController = TextEditingController();
  final _slugController = TextEditingController();
  final _locationController = TextEditingController();
  final _descController = TextEditingController();
  final _difficultyController = TextEditingController();
  final _durationController = TextEditingController();
  final _altitudeController = TextEditingController();
  final _completedOnController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _trek = TrekModel.empty();
    _isEdit = widget.slug != null;
    if (_isEdit) {
      _loadTrek();
    } else {
      _completedOnController.text = DateFormat('yyyy-MM-dd').format(_trek.completedOn);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _slugController.dispose();
    _locationController.dispose();
    _descController.dispose();
    _difficultyController.dispose();
    _durationController.dispose();
    _altitudeController.dispose();
    _completedOnController.dispose();
    super.dispose();
  }

  Future<void> _loadTrek() async {
    setState(() => _isLoading = true);
    final repository = ref.read(trekRepositoryProvider);
    final trek = await repository.getTrekBySlug(widget.slug!);
    if (trek != null) {
      setState(() {
        _trek = trek;
        _titleController.text = trek.title;
        _slugController.text = trek.slug;
        _locationController.text = trek.location;
        _descController.text = trek.description;
        _difficultyController.text = trek.difficulty;
        _durationController.text = trek.duration;
        _altitudeController.text = trek.altitude;
        _completedOnController.text = DateFormat('yyyy-MM-dd').format(trek.completedOn);
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

    final updatedTrek = _trek.copyWith(
      id: _trek.id.isEmpty ? const Uuid().v4() : _trek.id,
      title: _titleController.text,
      slug: _slugController.text,
      location: _locationController.text,
      description: _descController.text,
      difficulty: _difficultyController.text,
      duration: _durationController.text,
      altitude: _altitudeController.text,
      completedOn: DateTime.tryParse(_completedOnController.text) ?? _trek.completedOn,
      createdAt: _trek.id.isEmpty ? DateTime.now() : _trek.createdAt,
    );

    try {
      final repository = ref.read(trekRepositoryProvider);
      if (_isEdit) {
        await repository.updateTrek(updatedTrek);
      } else {
        await repository.addTrek(updatedTrek);
      }
      ref.invalidate(adminTreksProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Trek saved successfully')));
        context.go('/admin/treks');
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
              title: _isEdit ? 'Edit Trek' : 'Add New Trek',
              actions: [
                TextButton(
                  onPressed: () => context.go('/admin/treks'),
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
                        label: 'Location',
                        controller: _locationController,
                        validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                      ),
                      AdminTextarea(
                        label: 'Description',
                        controller: _descController,
                        validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: AdminTextField(label: 'Difficulty', controller: _difficultyController),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: AdminTextField(label: 'Duration', controller: _durationController),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: AdminTextField(label: 'Altitude', controller: _altitudeController),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: AdminTextField(
                              label: 'Completed On (YYYY-MM-DD)',
                              controller: _completedOnController,
                              readOnly: true,
                              onTap: () async {
                                final date = await showDatePicker(
                                  context: context,
                                  initialDate: _trek.completedOn,
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime.now(),
                                );
                                if (date != null) {
                                  _completedOnController.text = DateFormat('yyyy-MM-dd').format(date);
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      AdminChipInput(
                        label: 'Tags',
                        initialValues: _trek.tags,
                        onChanged: (v) => _trek = _trek.copyWith(tags: v),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 32),
                Expanded(
                  child: Column(
                    children: [
                      SwitchListTile(
                        title: const Text('Featured Trek', style: TextStyle(color: Colors.white)),
                        value: _trek.featured,
                        onChanged: (v) => setState(() => _trek = _trek.copyWith(featured: v)),
                        contentPadding: EdgeInsets.zero,
                      ),
                      const SizedBox(height: 16),
                      AdminImageUploader(
                        label: 'Cover Image',
                        imageUrl: _trek.coverImage,
                        uploadPath: 'treks/${_slugController.text}/cover',
                        onUploadComplete: (url) => setState(() => _trek = _trek.copyWith(coverImage: url)),
                        onMultipleUploadComplete: (_) {},
                      ),
                      AdminImageUploader(
                        label: 'Gallery Images',
                        imageUrls: _trek.galleryImages,
                        isMultiple: true,
                        uploadPath: 'treks/${_slugController.text}/gallery',
                        onUploadComplete: (_) {},
                        onMultipleUploadComplete: (urls) => setState(() => _trek = _trek.copyWith(galleryImages: urls)),
                        onSetAsCover: (url) => setState(() => _trek = _trek.copyWith(coverImage: url)),
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
