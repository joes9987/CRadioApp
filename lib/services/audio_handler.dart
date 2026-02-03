import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';
import '../config/app_config.dart';

/// Custom AudioHandler for background audio playback
class RadioAudioHandler extends BaseAudioHandler with SeekHandler {
  final AudioPlayer _player = AudioPlayer();

  RadioAudioHandler() {
    // Set up the media item immediately
    mediaItem.add(MediaItem(
      id: AppConfig.radioStreamUrl,
      album: AppConfig.churchName,
      title: AppConfig.radioStationName,
      artist: AppConfig.tagline,
      playable: true,
      displayTitle: AppConfig.radioStationName,
      displaySubtitle: AppConfig.churchName,
    ));
    
    // Broadcast player state changes to the audio service
    _player.playbackEventStream.listen((event) {
      _broadcastState();
    });
    
    _player.playerStateStream.listen((state) {
      _broadcastState();
    });
  }

  void _broadcastState() {
    playbackState.add(PlaybackState(
      controls: [
        if (_player.playing) MediaControl.pause else MediaControl.play,
        MediaControl.stop,
      ],
      systemActions: const {
        MediaAction.play,
        MediaAction.pause,
        MediaAction.stop,
      },
      androidCompactActionIndices: const [0, 1],
      processingState: _getProcessingState(),
      playing: _player.playing,
      updatePosition: _player.position,
      bufferedPosition: _player.bufferedPosition,
      speed: _player.speed,
      queueIndex: 0,
    ));
  }

  AudioProcessingState _getProcessingState() {
    switch (_player.processingState) {
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
    }
  }

  @override
  Future<void> play() async {
    try {
      // Set URL if not already set or if completed
      if (_player.processingState == ProcessingState.idle ||
          _player.processingState == ProcessingState.completed) {
        await _player.setUrl(AppConfig.radioStreamUrl);
      }
      await _player.play();
    } catch (e) {
      // Handle error
      print('Error playing audio: $e');
    }
  }

  @override
  Future<void> pause() async {
    await _player.pause();
  }

  @override
  Future<void> stop() async {
    await _player.stop();
    await _player.seek(Duration.zero);
  }

  @override
  Future<void> seek(Duration position) async {
    await _player.seek(position);
  }

  Future<void> setVolume(double volume) async {
    await _player.setVolume(volume);
  }

  // Expose player state streams
  Stream<bool> get playingStream => _player.playingStream;
  Stream<ProcessingState> get processingStateStream => _player.processingStateStream;
  bool get playing => _player.playing;
  ProcessingState get processingState => _player.processingState;

  @override
  Future<void> onTaskRemoved() async {
    // Keep playing when app is removed from recents (optional - remove if you want it to stop)
    // await stop();
    await super.onTaskRemoved();
  }
}
