import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/admin_provider.dart';

class AdminChipInput extends StatefulWidget {
  final String label;
  final List<String> initialValues;
  final Function(List<String>) onChanged;

  const AdminChipInput({
    super.key,
    required this.label,
    required this.initialValues,
    required this.onChanged,
  });

  @override
  State<AdminChipInput> createState() => _AdminChipInputState();
}

class _AdminChipInputState extends State<AdminChipInput> {
  late List<String> _values;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _values = List.from(widget.initialValues);
  }

  void _addValue(String value) {
    if (value.isNotEmpty && !_values.contains(value)) {
      setState(() {
        _values.add(value);
        widget.onChanged(_values);
        _controller.clear();
      });
    }
  }

  void _removeValue(String value) {
    setState(() {
      _values.remove(value);
      widget.onChanged(_values);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: _values
              .map((v) => Chip(
                    label: Text(v),
                    onDeleted: () => _removeValue(v),
                    backgroundColor: Colors.blue.withOpacity(0.2),
                    labelStyle: const TextStyle(color: Colors.white),
                    deleteIconColor: Colors.redAccent,
                  ))
              .toList(),
        ),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: 'Add new...',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
                onSubmitted: _addValue,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.add, color: Colors.blue),
              onPressed: () => _addValue(_controller.text),
            ),
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

class AdminImageUploader extends ConsumerStatefulWidget {
  final String label;
  final String? imageUrl;
  final List<String>? imageUrls;
  final bool isMultiple;
  final String uploadPath;
  final Function(String) onUploadComplete;
  final Function(List<String>) onMultipleUploadComplete;
  final Function(String)? onSetAsCover;

  const AdminImageUploader({
    super.key,
    required this.label,
    this.imageUrl,
    this.imageUrls,
    this.isMultiple = false,
    required this.uploadPath,
    required this.onUploadComplete,
    required this.onMultipleUploadComplete,
    this.onSetAsCover,
  });

  @override
  ConsumerState<AdminImageUploader> createState() => _AdminImageUploaderState();
}

class _AdminImageUploaderState extends ConsumerState<AdminImageUploader> {
  bool _isUploading = false;

  @override
  Widget build(BuildContext context) {
    final uploadService = ref.read(uploadServiceProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(widget.label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
            if (_isUploading)
              const SizedBox(
                height: 12,
                width: 12,
                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.blue),
              ),
          ],
        ),
        const SizedBox(height: 8),
        if (!widget.isMultiple)
          Column(
            children: [
              if (widget.imageUrl != null && widget.imageUrl!.isNotEmpty)
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        widget.imageUrl!,
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          height: 200,
                          color: Colors.white10,
                          child: const Center(child: Icon(Icons.error, color: Colors.red)),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 8,
                      top: 8,
                      child: CircleAvatar(
                        backgroundColor: Colors.black54,
                        child: IconButton(
                          icon: const Icon(Icons.close, color: Colors.red),
                          onPressed: () => widget.onUploadComplete(''),
                        ),
                      ),
                    ),
                  ],
                )
              else
                _UploadPlaceholder(
                  isLoading: _isUploading,
                  onTap: () async {
                    final file = await uploadService.pickImage();
                    if (file != null && file.bytes != null) {
                      setState(() => _isUploading = true);
                      final url = await uploadService.uploadImage(
                        fileBytes: file.bytes!,
                        fileName: file.name,
                        path: widget.uploadPath,
                      );
                      if (url != null) widget.onUploadComplete(url);
                      setState(() => _isUploading = false);
                    }
                  },
                ),
            ],
          )
        else
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.imageUrls != null && widget.imageUrls!.isNotEmpty)
                Container(
                  height: 180,
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.imageUrls!.length,
                    itemBuilder: (context, index) {
                      final url = widget.imageUrls![index];
                      return Padding(
                        padding: const EdgeInsets.only(right: 12.0),
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                url,
                                height: 180,
                                width: 180,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => Container(
                                  width: 180,
                                  height: 180,
                                  color: Colors.white10,
                                  child: const Center(child: Icon(Icons.error, color: Colors.red)),
                                ),
                              ),
                            ),
                            Positioned(
                              right: 4,
                              top: 4,
                              child: CircleAvatar(
                                radius: 14,
                                backgroundColor: Colors.black54,
                                child: IconButton(
                                  iconSize: 14,
                                  icon: const Icon(Icons.close, color: Colors.red),
                                  onPressed: () {
                                    final newList = List<String>.from(widget.imageUrls!)..removeAt(index);
                                    widget.onMultipleUploadComplete(newList);
                                  },
                                ),
                              ),
                            ),
                            if (widget.onSetAsCover != null)
                              Positioned(
                                left: 4,
                                bottom: 4,
                                child: ElevatedButton(
                                  onPressed: () => widget.onSetAsCover!(url),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue.withOpacity(0.8),
                                    padding: const EdgeInsets.symmetric(horizontal: 8),
                                    minimumSize: const Size(0, 24),
                                  ),
                                  child: const Text('Set as Cover', style: TextStyle(fontSize: 10)),
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              _UploadPlaceholder(
                height: 100,
                isLoading: _isUploading,
                label: 'Add more images...',
                onTap: () async {
                  final files = await uploadService.pickMultipleImages();
                  if (files.isNotEmpty) {
                    setState(() => _isUploading = true);
                    final urls = await uploadService.uploadMultipleImages(
                      files: files,
                      path: widget.uploadPath,
                    );
                    widget.onMultipleUploadComplete([...(widget.imageUrls ?? []), ...urls]);
                    setState(() => _isUploading = false);
                  }
                },
              ),
            ],
          ),
        const SizedBox(height: 16),
      ],
    );
  }
}

class _UploadPlaceholder extends StatelessWidget {
  final double height;
  final bool isLoading;
  final VoidCallback onTap;
  final String label;

  const _UploadPlaceholder({
    this.height = 150,
    required this.isLoading,
    required this.onTap,
    this.label = 'Upload Image',
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isLoading ? null : onTap,
      child: Container(
        height: height,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.withOpacity(0.3), style: BorderStyle.solid),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isLoading)
                const CircularProgressIndicator()
              else ...[
                const Icon(Icons.cloud_upload_outlined, color: Colors.blue, size: 32),
                const SizedBox(height: 8),
                Text(label, style: const TextStyle(color: Colors.blue)),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
