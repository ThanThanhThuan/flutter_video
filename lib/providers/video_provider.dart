// lib/providers/video_provider.dart
import 'package:flutter/material.dart';
import '../services/pexels_service.dart';
import '../models/pexels_video.dart';

class VideoProvider extends ChangeNotifier {
  final PexelsService _service = PexelsService();

  List<PexelsVideo> _videos = [];
  List<PexelsVideo> get videos => _videos;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  int _page = 1;
  final int _perPage = 15;

  /// Call this to load the first page
  Future<void> loadInitial() async {
    _isLoading = true;
    notifyListeners();

    _videos = await _service.fetchPopularVideos(page: 1, perPage: _perPage);
    _page = 1;

    _isLoading = false;
    notifyListeners();
  }

  /// Call to fetch the next page (pagination)
  Future<void> loadMore() async {
    if (_isLoading) return; // debounce

    _isLoading = true;
    notifyListeners();

    final more = await _service.fetchPopularVideos(
      page: _page + 1,
      perPage: _perPage,
    );
    _videos.addAll(more);
    _page++;

    _isLoading = false;
    notifyListeners();
  }

  /// Convenience: search by keyword
  Future<void> search(String query) async {
    _isLoading = true;
    notifyListeners();

    _videos = await _service.searchVideos(query, page: 1, perPage: _perPage);
    _page = 1;

    _isLoading = false;
    notifyListeners();
  }
}
