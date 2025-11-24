// lib/models/pexels_video.dart
class PexelsVideo {
  final int id;
  final String url; // the page on pexels.com
  final String image; // still image thumbnail
  final List<PexelsVideoFile> files;
  final List<PexelsVideoPicture> pictures;
  final int width;
  final int height;

  PexelsVideo({
    required this.id,
    required this.url,
    required this.image,
    required this.files,
    required this.pictures,
    required this.width,
    required this.height,
  });

  factory PexelsVideo.fromJson(Map<String, dynamic> json) {
    var filesJson = json['video_files'] as List<dynamic>;
    var picsJson = json['video_pictures'] as List<dynamic>;

    return PexelsVideo(
      id: json['id'],
      url: json['url'],
      image: json['image'],
      files: filesJson.map((e) => PexelsVideoFile.fromJson(e)).toList(),
      pictures: picsJson.map((e) => PexelsVideoPicture.fromJson(e)).toList(),
      width: json['width'],
      height: json['height'],
    );
  }

  /// Returns the first MP4 file that is 720p or lower.
  /// You can tweak the logic for your quality preference.
  String? get bestMp4Url {
    // Try 720p first, then 480p, then the lowest quality.
    final mp4Files = files.where((f) => f.fileType == 'video/mp4').toList();
    if (mp4Files.isEmpty) return null;
    mp4Files.sort((a, b) => b.width.compareTo(a.width)); // largest first

    // Prefer 720p or lower
    final chosen = mp4Files.firstWhere(
      (f) => f.width <= 1280,
      orElse: () => mp4Files.first,
    );
    return chosen.link;
  }
}

class PexelsVideoFile {
  final int id;
  final int width;
  final int height;
  final String fileType; // e.g. "video/mp4"
  final String link;
  final int size; // bytes

  PexelsVideoFile({
    required this.id,
    required this.width,
    required this.height,
    required this.fileType,
    required this.link,
    required this.size,
  });

  factory PexelsVideoFile.fromJson(Map<String, dynamic> json) =>
      PexelsVideoFile(
        id: json['id'],
        width: json['width'],
        height: json['height'],
        fileType: json['file_type'],
        link: json['link'],
        size: json['size'],
      );
}

class PexelsVideoPicture {
  final int id;
  final String url;

  PexelsVideoPicture({required this.id, required this.url});

  factory PexelsVideoPicture.fromJson(Map<String, dynamic> json) =>
      PexelsVideoPicture(id: json['id'], url: json['picture']);
}
