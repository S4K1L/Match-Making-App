import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_extension/services/api_service.dart';
import 'package:flutter_extension/model/multi_body.dart';

class MediaService {
  static final ImagePicker _picker = ImagePicker();
  static final ApiService _api = ApiService();

  // ================= PICKERS =================

  static Future<XFile?> pickFromCamera() async {
    return await _pickImage(ImageSource.camera);
  }

  static Future<XFile?> pickFromGallery() async {
    return await _pickImage(ImageSource.gallery);
  }

  static Future<XFile?> _pickImage(ImageSource source) async {
    try {
      return await _picker.pickImage(source: source, imageQuality: 70);
    } catch (e) {
      return null;
    }
  }

  static Future<XFile?> pickImage(ImageSource source) async {
    return await _picker.pickImage(source: source, imageQuality: 70);
  }

  // ================= SEND IMAGE =================

  static Future<Map<String, dynamic>> sendImageMessage({
    required int threadId,
    required XFile file,
  }) async {
    final response = await _api.postMultipartData(
      "chat/messages/",
      {
        "thread": threadId,
        "message_type": "image",
        "content": "",
        "is_like": false,
      },
      authReq: true,
      multipartBody: [
        MultipartBody(
          key: "attachment", // ✅ backend expects this
          file: File(file.path),
        ),
      ],
    );

    final body = jsonDecode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return body['data'];
    } else {
      throw Exception("Image message send failed");
    }
  }
}
