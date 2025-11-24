// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/video_provider.dart';
import 'pages/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // The provider is created here and immediately loads the first page
    return ChangeNotifierProvider<VideoProvider>(
      create: (_) => VideoProvider()..loadInitial(),
      child: MaterialApp(
        title: 'Pexels Video Player',
        theme: ThemeData.dark(),
        home: const HomePage(),
      ),
    );
  }
}
