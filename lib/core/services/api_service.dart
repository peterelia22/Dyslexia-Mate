import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'dart:convert';

import 'models/extract_document_model.dart';

class DocumentService {
  static Future<ExtractedDocument?> extractDocument({
    required File file,
  }) async {
    const String baseUrl = 'https://backend.scandocflow.com/v1/api';
    const String accessToken =
        'l2kD6UjBQPhyXEOhhWbFACgABQ8as0VU16aM60TK9tNMOjVGsuaqZRJA9HMCkSXW';

    final uri =
        Uri.parse('$baseUrl/documents/extract?access_token=$accessToken&file');

    final request = http.MultipartRequest('POST', uri);

    request.files.add(
      await http.MultipartFile.fromPath(
        'files',
        file.path,
        contentType: MediaType('image', 'jpeg'),
      ),
    );

    request.fields['type'] = 'ocr';
    request.fields['lang'] = 'auto';
    request.fields['retain'] = 'true';

    final response = await request.send();

    if (response.statusCode == 200) {
      final respStr = await response.stream.bytesToString();
      final jsonData = json.decode(respStr);
      return ExtractedDocument.fromJson(jsonData);
    } else {
      print('Request failed: ${response.statusCode}');
      return null;
    }
  }
}
