import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';

class AudioPlayerHandler extends BaseAudioHandler {
  final AudioPlayer _audioPlayer = AudioPlayer();
  late final List<MediaItem> _queue;

  AudioPlayerHandler() {
    _init();
  }

  Future<void> _init() async {
    // Voorbeeld queue
    _queue = [
      const MediaItem(
        id: 'https://raw.githubusercontent.com/1Sjoerd/MediaPlayer/main/assets/video/NeverGonnaGiveYouUp.mp4',
        album: 'Album 1',
        title: 'Track 1',
        artist: 'Artist 1',
      ),
      // Voeg meer items toe zoals nodig
    ];

    // Converteer MediaItems naar AudioSource voor just_audio
    final audioSources = _queue.map((item) => AudioSource.uri(Uri.parse(item.id))).toList();
    await _audioPlayer.setAudioSource(ConcatenatingAudioSource(children: audioSources));
    
    // Abonneer op wijzigingen in afspeelstatus en update de systeemmediabediening.
    _audioPlayer.playbackEventStream.listen((event) {
      _updatePlaybackState();
    });

    // Voeg queue toe aan audio_service
    queue.add(_queue);
  }

  void _updatePlaybackState() {
    final playing = _audioPlayer.playing;
    final processingState = _mapJustAudioProcessingStateToAudioServiceState(_audioPlayer.processingState);
    playbackState.add(playbackState.value.copyWith(
      playing: playing,
      processingState: processingState,
      controls: [
        MediaControl.skipToPrevious,
        if (playing) MediaControl.pause else MediaControl.play,
        MediaControl.stop,
        MediaControl.skipToNext,
      ],
    ));
  }

  AudioProcessingState _mapJustAudioProcessingStateToAudioServiceState(ProcessingState state) {
    switch (state) {
      case ProcessingState.idle:
        return AudioProcessingState.idle;
      case ProcessingState.loading:
        return AudioProcessingState.loading;
      case ProcessingState.buffering:
        return AudioProcessingState.buffering;
      case ProcessingState.ready:
        return AudioProcessingState.ready;
      case ProcessingState.completed:
        return AudioProcessingState.completed;
      default:
        return AudioProcessingState.idle;
    }
  }

  @override
  Future<void> play() => _audioPlayer.play();

  @override
  Future<void> pause() => _audioPlayer.pause();

  // Voeg indien nodig andere methoden toe zoals skipToNext, skipToPrevious, seek, etc.
}
