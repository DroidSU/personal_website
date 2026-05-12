import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as p;

import '../../../core/utils/logger.dart';

class UploadService {
  final FirebaseStorage _storage;

  UploadService(this._storage);

  Future<String?> uploadImage({
    required Uint8List fileBytes,
    required String fileName,
    required String path,
  }) async {
    try {
      final extension = p.extension(fileName);
      final uniqueFileName = '${DateTime.now().millisecondsSinceEpoch}$extension';
      final ref = _storage.ref().child('$path/$uniqueFileName');
      
      final uploadTask = ref.putData(
        fileBytes,
        SettableMetadata(contentType: 'image/${extension.replaceFirst('.', '')}'),
      );
      
      final snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      AppLogger.error('Error uploading image: $e');
      return null;
    }
  }

  Future<List<String>> uploadMultipleImages({
    required List<PlatformFile> files,
    required String path,
  }) async {
    List<String> urls = [];
    for (final file in files) {
      if (file.bytes != null) {
        final url = await uploadImage(
          fileBytes: file.bytes!,
          fileName: file.name,
          path: path,
        );
        if (url != null) {
          urls.add(url);
        }
      }
    }
    return urls;
  }

  Future<PlatformFile?> pickImage() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );
      return result?.files.first;
    } catch (e) {
      AppLogger.error('Error picking image: $e');
      return null;
    }
  }

  Future<List<PlatformFile>> pickMultipleImages() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: true,
      );
      return result?.files ?? [];
    } catch (e) {
      AppLogger.error('Error picking multiple images: $e');
      return [];
    }
  }
}
