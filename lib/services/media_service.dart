import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_extension/services/api_service.dart';
import 'package:flutter_extension/model/multi_body.dart';

class MediaService {
  static final ImagePicker _picker = ImagePicker();
  static final ApiService _api = ApiService();

  static Future<XFile?> pickFromCamera() async {
    return await _pickImage(ImageSource.camera);
  }

  static Future<XFile?> pickFromGallery() async {
    return await _pickImage(ImageSource.gallery);
  }

  static Future<XFile?> pickImage(ImageSource source) async {
    return await _pickImage(source);
  }

  static Future<XFile?> _pickImage(ImageSource source) async {
    try {
      return await _picker.pickImage(source: source, imageQuality: 70);
    } catch (e) {
      return null;
    }
  }

  static Future<Map<String, dynamic>> sendImageMessage({
    required int threadId,
    required XFile file,
  }) async {
    return await _sendMultipartMessage(
      endpoint: "chat/messages/",
      body: {
        "thread": threadId,
        "message_type": "image",
        "content": "",
        "is_like": false,
      },
      file: file,
    );
  }

  static Future<Map<String, dynamic>> sendSocietyImageMessage({
    required int societyId,
    required XFile file,
  }) async {
    return await _sendMultipartMessage(
      endpoint: "chat/societies/$societyId/messages/",
      body: {"message_type": "image", "content": ""},
      file: file,
    );
  }

  static Future<Map<String, dynamic>> _sendMultipartMessage({
    required String endpoint,
    required Map<String, dynamic> body,
    required XFile file,
  }) async {
    final response = await _api.postMultipartData(
      endpoint,
      body,
      authReq: true,
      multipartBody: [
        MultipartBody(
          key: "attachment", // ✅ unified backend key
          file: File(file.path),
        ),
      ],
    );

    final decoded = jsonDecode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return decoded['data'];
    } else {
      throw Exception("Image upload failed: ${decoded['message']}");
    }
  }
}
