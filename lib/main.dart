import 'package:flutter/material.dart';
import './screens/video_player_screen.dart'; // Zorg ervoor dat je het pad aanpast

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: VideoPlayerScreen(videoUrl: './screens/video/NeverGonnaGiveYouUp.mp4'),
    );
  }
}
