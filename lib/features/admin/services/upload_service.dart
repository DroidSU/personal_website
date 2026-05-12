import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../../core/utils/logger.dart';

class UploadService {
  final FirebaseStorage _storage;
  final Dio _dio = Dio();
  static const String _imgbbApiKey = String.fromEnvironment('IMGBB_API_KEY');

  UploadService(this._storage);

  Future<String?> uploadImage({
    required Uint8List fileBytes,
    required String fileName,
    required String path,
  }) async {
    try {
      // Temporary bypass: Using ImgBB instead of Firebase Storage with Dio
      final formData = FormData.fromMap({
        'key': _imgbbApiKey,
        'image': MultipartFile.fromBytes(
          fileBytes,
          filename: fileName,
        ),
      });

      final response = await _dio.post(
        'https://api.imgbb.com/1/upload',
        data: formData,
      );

      if (response.statusCode == 200) {
        return response.data['data']['url'] as String?;
      } else {
        AppLogger.error('ImgBB upload failed: ${response.statusCode}');
        return null;
      }

      /* 
      // Original Firebase Storage Implementation
      final extension = p.extension(fileName);
      final uniqueFileName = '${DateTime.now().millisecondsSinceEpoch}$extension';
      final ref = _storage.ref().child('$path/$uniqueFileName');
      
      final uploadTask = ref.putData(
        fileBytes,
        SettableMetadata(contentType: 'image/${extension.replaceFirst('.', '')}'),
      );
      
      final snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
      */
    } catch (e) {
      AppLogger.error('Error uploading image to ImgBB with Dio: $e');
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
