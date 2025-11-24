// lib/services/pexels_service.dart
import 'package:dio/dio.dart';
import '../keys.dart';
import '../models/pexels_video.dart';

class PexelsService {
  static const String _baseUrl = 'https://api.pexels.com/v1';
  // or https://api.pexels.com/videos/ if you want the new endpoint

  final Dio _dio;

  PexelsService()
    : _dio = Dio(
        BaseOptions(
          baseUrl: _baseUrl,
          headers: {
            'Authorization': pexelsApiKey,
            'Accept': 'application/json',
          },
        ),
      );

  /// Fetch *popular* Pexels videos (paginated).
  /// page: 1‑… , perPage: 15‑50 (max 80)
  Future<List<PexelsVideo>> fetchPopularVideos({
    int page = 1,
    int perPage = 15,
  }) async {
    final response = await _dio.get(
      '/videos/popular',
      queryParameters: {'page': page, 'per_page': perPage},
    );

    final List<dynamic> videosJson = response.data['videos'];
    return videosJson.map((e) => PexelsVideo.fromJson(e)).toList();
  }

  /// Optional: search by keyword
  Future<List<PexelsVideo>> searchVideos(
    String query, {
    int page = 1,
    int perPage = 15,
  }) async {
    final response = await _dio.get(
      '/videos/search',
      queryParameters: {'query': query, 'page': page, 'per_page': perPage},
    );
    final List<dynamic> videosJson = response.data['videos'];
    return videosJson.map((e) => PexelsVideo.fromJson(e)).toList();
  }
}
