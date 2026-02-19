import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'secure_storage_service.dart';

/// Model classes
class AnalysisMetadata {
  final int totalItems;
  final String inferenceTime;
  AnalysisMetadata({required this.totalItems, required this.inferenceTime});
  factory AnalysisMetadata.fromJson(Map<String, dynamic> json) =>
      AnalysisMetadata(
        totalItems: json['total_items'] ?? 0,
        inferenceTime: json['inference_time'] ?? '0ms',
      );
}

class Detection {
  final List<double> box;
  final String label;
  final double confidence;
  final bool isLearned;
  Detection({
    required this.box,
    required this.label,
    required this.confidence,
    required this.isLearned,
  });
  factory Detection.fromJson(Map<String, dynamic> json) => Detection(
    box: List<double>.from(
      (json['box'] as List).map((e) => (e as num).toDouble()),
    ),
    label: json['label'] ?? 'Unknown',
    confidence: (json['confidence'] ?? 0.0).toDouble(),
    isLearned: json['is_learned'] ?? false,
  );
}

class AnalysisResult {
  final AnalysisMetadata metadata;
  final Map<String, int> inventory;
  final List<Detection> detections;
  AnalysisResult({
    required this.metadata,
    required this.inventory,
    required this.detections,
  });
  factory AnalysisResult.fromJson(Map<String, dynamic> json) => AnalysisResult(
    metadata: AnalysisMetadata.fromJson(json['metadata'] ?? {}),
    inventory: Map<String, int>.from(
      (json['inventory'] ?? {}).map((k, v) => MapEntry(k, (v as num).toInt())),
    ),
    detections: (json['detections'] as List? ?? [])
        .map((d) => Detection.fromJson(d))
        .toList(),
  );
}

/// API Service — configurable base URL for dev vs prod (ONDC HTTPS requirement)
class ApiService {
  /// Dev: use 10.0.2.2 for Android emulator, or LAN IP for real device.
  /// Prod: replace with your HTTPS domain.
  static const String _baseUrl = 'http://10.0.2.2:8000';

  static Future<Map<String, String>> _authHeaders() async {
    final token = await SecureStorageService.getToken();
    return {if (token != null) 'Authorization': 'Bearer $token'};
  }

  /// POST /analyze-shelf — upload image and get GPU inference results
  static Future<AnalysisResult> analyzeShelf(File imageFile) async {
    final uri = Uri.parse('$_baseUrl/analyze-shelf');
    final headers = await _authHeaders();

    final request = http.MultipartRequest('POST', uri)
      ..headers.addAll(headers)
      ..files.add(await http.MultipartFile.fromPath('file', imageFile.path));

    final streamedResponse = await request.send().timeout(
      const Duration(seconds: 60),
    );
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      return AnalysisResult.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(
        'Analysis failed: ${response.statusCode} ${response.body}',
      );
    }
  }
}
