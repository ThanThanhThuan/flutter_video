// lib/pages/home_page.dart
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../providers/video_provider.dart';
import '../models/pexels_video.dart';
import '../pages/video_player_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<VideoProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pexels Video Player'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: provider.loadInitial,
          ),
        ],
      ),
      body: provider.isLoading && provider.videos.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollInfo) {
                if (!provider.isLoading &&
                    scrollInfo.metrics.pixels ==
                        scrollInfo.metrics.maxScrollExtent) {
                  provider.loadMore();
                }
                return false;
              },
              child: ListView.builder(
                itemCount: provider.videos.length,
                itemBuilder: (context, index) {
                  final video = provider.videos[index];
                  return ListTile(
                    leading: CachedNetworkImage(
                      imageUrl: video.image,
                      width: 120,
                      height: 70,
                      fit: BoxFit.cover,
                    ),
                    title: Text('Video #${video.id}'),
                    subtitle: Text('${video.width} × ${video.height}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.play_arrow),
                      onPressed: () {
                        final url = video.bestMp4Url;
                        if (url == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('No playable MP4 found'),
                            ),
                          );
                          return;
                        }
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => VideoPlayerPage(videoUrl: url),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
    );
  }
}
