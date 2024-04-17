import 'dart:async';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class AudioPlayerScreen extends StatefulWidget {
  final String audioUrl;

  const AudioPlayerScreen({super.key, required this.audioUrl});

  @override
  _AudioPlayerScreenState createState() => _AudioPlayerScreenState();
}

class _AudioPlayerScreenState extends State<AudioPlayerScreen> {
  late AudioPlayer _player;
  late StreamSubscription _positionSubscription;
  double _currentPosition = 0;
  double _totalDuration = 0;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    _initAudio();
  }

  Future<void> _initAudio() async {
    try {
      await _player.setUrl(widget.audioUrl);
      _positionSubscription = _player.positionStream.listen((position) {
        if (_player.duration != null) {
          setState(() {
            _currentPosition = position.inMilliseconds.toDouble();
            _totalDuration = _player.duration!.inMilliseconds.toDouble();
          });
        }
      });
    } catch (e) {
      print("Error loading audio source: $e");
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  Widget _progressIndicator() {
    return Slider(
      activeColor: Colors.amber[800],
      min: 0,
      max: _totalDuration,
      value: _currentPosition < _totalDuration ? _currentPosition : 0,
      onChanged: (value) async {
        await _player.seek(Duration(milliseconds: value.toInt()));
      },
    );
  }

  Widget _audioControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.replay_10),
          onPressed: () {
            _player.seek(Duration(milliseconds: _currentPosition.toInt() - 10000));
          },
        ),
        IconButton(
          icon: Icon(_player.playing ? Icons.pause : Icons.play_arrow),
          onPressed: () async {
            if (_player.playing) {
              await _player.pause();
            } else {
              await _player.play();
            }
          },
        ),
        IconButton(
          icon: const Icon(Icons.forward_10),
          onPressed: () {
            _player.seek(Duration(milliseconds: _currentPosition.toInt() + 10000));
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 224, 224, 224),
      appBar: AppBar(
        title: const Text('Audio Player'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _progressIndicator(),
            Text('${_formatDuration(Duration(milliseconds: _currentPosition.toInt()))} / ${_formatDuration(Duration(milliseconds: _totalDuration.toInt()))}'),
            _audioControls(),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _player.dispose();
    _positionSubscription.cancel();
    super.dispose();
  }
}
