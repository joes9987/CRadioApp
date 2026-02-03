import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';
import '../config/app_config.dart';

/// Custom AudioHandler for background audio playback
class RadioAudioHandler extends BaseAudioHandler with SeekHandler {
  final AudioPlayer _player = AudioPlayer();
  
  bool _isInitialized = false;

  RadioAudioHandler() {
    _init();
  }

  Future<void> _init() async {
    // Broadcast playback state changes
    _player.playbackEventStream.map(_transformEvent).pipe(playbackState);
    
    // Set the media item
    mediaItem.add(MediaItem(
      id: AppConfig.radioStreamUrl,
      album: AppConfig.churchName,
      title: AppConfig.radioStationName,
      artist: AppConfig.tagline,
      artUri: null, // Could add artwork URI here
    ));
  }

  PlaybackState _transformEvent(PlaybackEvent event) {
    return PlaybackState(
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
      processingState: const {
        ProcessingState.idle: AudioProcessingState.idle,
        ProcessingState.loading: AudioProcessingState.loading,
        ProcessingState.buffering: AudioProcessingState.buffering,
        ProcessingState.ready: AudioProcessingState.ready,
        ProcessingState.completed: AudioProcessingState.completed,
      }[_player.processingState]!,
      playing: _player.playing,
      updatePosition: _player.position,
      bufferedPosition: _player.bufferedPosition,
      speed: _player.speed,
      queueIndex: 0,
    );
  }

  @override
  Future<void> play() async {
    if (!_isInitialized) {
      await _player.setUrl(AppConfig.radioStreamUrl);
      _isInitialized = true;
    }
    await _player.play();
  }

  @override
  Future<void> pause() async {
    await _player.pause();
  }

  @override
  Future<void> stop() async {
    await _player.stop();
    _isInitialized = false;
    // Reset to beginning
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
    await stop();
    await super.onTaskRemoved();
  }
}
