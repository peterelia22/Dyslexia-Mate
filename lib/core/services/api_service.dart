import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'dart:convert';
import 'package:mime/mime.dart';
import 'models/extract_document_model.dart';

class DocumentService {
  static const String _baseUrl = 'https://backend.scandocflow.com/v1/api';
  static const String _accessToken =
      'f9FYZgYj4uxE2WY2xBn8rJxFP40ru37i3DCqWVN0EEzwSRbmlRtCw7juhdr5zW7B';

  static Future<ExtractedDocument?> extractDocument({
    required File file,
    String type = 'ocr',
    String lang = 'ara', // تغيير الافتراضي إلى العربية
    bool retain = true,
  }) async {
    try {
      // تحديد نوع الميديا بشكل دقيق
      final mimeType = lookupMimeType(file.path) ?? 'application/octet-stream';
      final contentType = MediaType.parse(mimeType);

      final uri =
          Uri.parse('$_baseUrl/documents/extract?access_token=$_accessToken');

      final request = http.MultipartRequest('POST', uri)
        ..files.add(
          await http.MultipartFile.fromPath(
            'files',
            file.path,
            contentType: contentType,
          ),
        )
        ..fields['type'] = type
        ..fields['lang'] = lang // إرسال اللغة العربية بشكل صريح
        ..fields['retain'] = retain.toString();

      final response = await request.send();
      final respStr = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final jsonData = json.decode(respStr);
        return ExtractedDocument.fromJson(jsonData);
      } else {
        throw Exception(
            'API request failed with status ${response.statusCode}: $respStr');
      }
    } catch (e) {
      print('Error in DocumentService.extractDocument: $e');
      return null;
    }
  }
}
