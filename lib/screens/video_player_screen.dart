import 'package:flutter/material.dart';
import 'package:media_player/widgets/video_player.dart';

class VideoPlayerScreen extends StatefulWidget {

  const VideoPlayerScreen({super.key,});

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 224, 224, 224),
      appBar: AppBar(
        title: const Text('Video Player'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SamplePlayer(),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}