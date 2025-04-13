// lib/models/extracted_document_model.dart

class ExtractedDocument {
  final String status;
  final String id;
  final List<Document> documents;

  ExtractedDocument({
    required this.status,
    required this.id,
    required this.documents,
  });

  factory ExtractedDocument.fromJson(Map<String, dynamic> json) {
    return ExtractedDocument(
      status: json['status'],
      id: json['id'],
      documents: List<Document>.from(
          json['documents'].map((x) => Document.fromJson(x))),
    );
  }
}

class Document {
  final String id;
  final String version;
  final String type;
  final List<PageData> pages;
  final String? categorizedUrl;
  final String? plainTextBase64;
  final ValidationChecks? validationChecks;
  final TextAnnotation? textAnnotation;

  Document({
    required this.id,
    required this.version,
    required this.type,
    required this.pages,
    this.categorizedUrl,
    this.plainTextBase64,
    this.validationChecks,
    this.textAnnotation,
  });

  factory Document.fromJson(Map<String, dynamic> json) {
    return Document(
      id: json['id'],
      version: json['version'],
      type: json['type'],
      pages:
          List<PageData>.from(json['pages'].map((x) => PageData.fromJson(x))),
      categorizedUrl: json['categorizedUrl'],
      plainTextBase64: json['plainTextBase64'],
      validationChecks: json['validationChecks'] != null
          ? ValidationChecks.fromJson(json['validationChecks'])
          : null,
      textAnnotation: json['textAnnotation'] != null
          ? TextAnnotation.fromJson(json['textAnnotation'])
          : null,
    );
  }
}

class PageData {
  final int fileIdx;
  final int offset;
  final int count;

  PageData({required this.fileIdx, required this.offset, required this.count});

  factory PageData.fromJson(Map<String, dynamic> json) {
    return PageData(
      fileIdx: json['fileIdx'],
      offset: json['offset'],
      count: json['count'],
    );
  }
}

class ValidationChecks {
  final int result;
  final Map<String, dynamic> validations;

  ValidationChecks({required this.result, required this.validations});

  factory ValidationChecks.fromJson(Map<String, dynamic> json) {
    return ValidationChecks(
      result: json['result'],
      validations: json['validations'],
    );
  }
}

class TextAnnotation {
  final List<AnnotationPage> pages;

  TextAnnotation({required this.pages});

  factory TextAnnotation.fromJson(Map<String, dynamic> json) {
    return TextAnnotation(
      pages: List<AnnotationPage>.from(
          json['Pages'].map((x) => AnnotationPage.fromJson(x))),
    );
  }
}

class AnnotationPage {
  final double clockwiseOrientation;
  final List<Word> words;

  AnnotationPage({required this.clockwiseOrientation, required this.words});

  factory AnnotationPage.fromJson(Map<String, dynamic> json) {
    return AnnotationPage(
      clockwiseOrientation: json['ClockwiseOrientation'].toDouble(),
      words: List<Word>.from(json['Words'].map((x) => Word.fromJson(x))),
    );
  }
}

class Word {
  final String id;
  final String text;
  final List<double> outline;
  final double confidence;
  final String lang;

  Word({
    required this.id,
    required this.text,
    required this.outline,
    required this.confidence,
    required this.lang,
  });

  factory Word.fromJson(Map<String, dynamic> json) {
    return Word(
      id: json['Id'],
      text: json['Text'],
      outline: List<double>.from(json['Outline'].map((x) => x.toDouble())),
      confidence: json['Confidence'].toDouble(),
      lang: json['Lang'],
    );
  }
}
