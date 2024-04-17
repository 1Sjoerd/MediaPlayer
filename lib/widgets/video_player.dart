import 'package:flutter/material.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:video_player/video_player.dart';

class SamplePlayer extends StatefulWidget {
  @override
  _SamplePlayerState createState() => _SamplePlayerState();
}

class _SamplePlayerState extends State<SamplePlayer> {
  late VideoPlayerController _controller;
  late FlickManager flickManager;
  @override
  void initState() {
    super.initState();
    flickManager = FlickManager(
      videoPlayerController: _controller = VideoPlayerController.networkUrl(Uri.parse('https://raw.githubusercontent.com/1Sjoerd/MediaPlayer/main/assets/video/NeverGonnaGiveYouUp.mp4'))
      ..initialize().then((_) {
        setState(() {});
        
      _controller.pause();
      }
    ));
  }

  @override
  void dispose() {
    flickManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FlickVideoPlayer(
        flickManager: flickManager
      ),
    );
  }
}
