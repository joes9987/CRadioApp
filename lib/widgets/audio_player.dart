import 'dart:io';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_session/audio_session.dart';
import '../config/app_config.dart';
import '../main.dart';
import '../services/battery_optimization.dart';

class AudioPlayerWidget extends StatefulWidget {
  const AudioPlayerWidget({super.key});

  @override
  State<AudioPlayerWidget> createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  // Fallback player if audio_service isn't available
  AudioPlayer? _fallbackPlayer;
  
  bool _isLoading = false;
  bool _isPlaying = false;
  bool _isMuted = false;
  String? _errorMessage;
  double _volume = 0.8;

  bool get _useAudioService => audioHandler != null;

  @override
  void initState() {
    super.initState();
    _initPlayer();
  }

  Future<void> _initPlayer() async {
    if (_useAudioService) {
      // Use audio service for background playback
      audioHandler!.setVolume(_volume);
      
      audioHandler!.playingStream.listen((playing) {
        if (mounted) {
          setState(() {
            _isPlaying = playing;
            if (playing) {
              _isLoading = false;
            }
          });
        }
      });
      
      audioHandler!.processingStateStream.listen((state) {
        if (mounted) {
          setState(() {
            if (!_isPlaying) {
              _isLoading = state == ProcessingState.loading ||
                           state == ProcessingState.buffering;
            }
          });
        }
      });
    } else {
      // Fallback to local player
      _fallbackPlayer = AudioPlayer();
      _fallbackPlayer!.setVolume(_volume);
      await _initAudioSession();
      
      _fallbackPlayer!.playerStateStream.listen((state) {
        if (mounted) {
          setState(() {
            _isPlaying = state.playing;
            if (state.playing) {
              _isLoading = false;
            } else {
              _isLoading = state.processingState == ProcessingState.loading ||
                           state.processingState == ProcessingState.buffering;
            }
          });
        }
      });
      
      _fallbackPlayer!.playbackEventStream.listen(
        (event) {},
        onError: (Object e, StackTrace st) {
          if (mounted) {
            setState(() {
              _errorMessage = 'Unable to connect to stream';
              _isLoading = false;
            });
          }
        },
      );
    }
  }

  Future<void> _initAudioSession() async {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration(
      avAudioSessionCategory: AVAudioSessionCategory.playback,
      avAudioSessionCategoryOptions: AVAudioSessionCategoryOptions.mixWithOthers,
      avAudioSessionMode: AVAudioSessionMode.defaultMode,
      avAudioSessionRouteSharingPolicy: AVAudioSessionRouteSharingPolicy.defaultPolicy,
      avAudioSessionSetActiveOptions: AVAudioSessionSetActiveOptions.none,
      androidAudioAttributes: AndroidAudioAttributes(
        contentType: AndroidAudioContentType.music,
        usage: AndroidAudioUsage.media,
      ),
      androidAudioFocusGainType: AndroidAudioFocusGainType.gain,
      androidWillPauseWhenDucked: false,
    ));
  }

  @override
  void dispose() {
    _fallbackPlayer?.stop();
    _fallbackPlayer?.dispose();
    super.dispose();
  }

  Future<void> _togglePlayPause() async {
    setState(() {
      _errorMessage = null;
    });
    
    if (_isPlaying) {
      if (_useAudioService) {
        await audioHandler!.stop();
      } else {
        await _fallbackPlayer?.stop();
      }
      setState(() {
        _isPlaying = false;
      });
    } else {
      setState(() {
        _isLoading = true;
      });
      
      // Request battery optimization exemption on Android
      if (Platform.isAndroid) {
        final isIgnoring = await BatteryOptimization.isIgnoringBatteryOptimizations();
        if (!isIgnoring) {
          await BatteryOptimization.requestIgnoreBatteryOptimizations();
        }
      }
      
      try {
        if (_useAudioService) {
          await audioHandler!.play();
        } else {
          await _fallbackPlayer?.setUrl(AppConfig.radioStreamUrl);
          await _fallbackPlayer?.play();
        }
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            _errorMessage = 'Unable to connect to stream';
            _isLoading = false;
          });
        }
      }
    }
  }

  void _toggleMute() {
    setState(() {
      _isMuted = !_isMuted;
    });
    final volume = _isMuted ? 0.0 : _volume;
    if (_useAudioService) {
      audioHandler!.setVolume(volume);
    } else {
      _fallbackPlayer?.setVolume(volume);
    }
  }

  void _setVolume(double value) {
    setState(() {
      _volume = value;
      _isMuted = value == 0;
    });
    if (_useAudioService) {
      audioHandler!.setVolume(value);
    } else {
      _fallbackPlayer?.setVolume(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final buttonSize = screenWidth * 0.18;
    final playButtonSize = screenWidth * 0.22;
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Volume Slider (full width, blue)
        Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
          child: Container(
            height: 24,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF1565C0),
                  Color(0xFF42A5F5),
                  Color(0xFF1565C0),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
                BoxShadow(
                  color: const Color(0xFF42A5F5).withOpacity(0.3),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: SliderTheme(
              data: SliderThemeData(
                activeTrackColor: Colors.transparent,
                inactiveTrackColor: Colors.transparent,
                thumbColor: Colors.white,
                overlayColor: Colors.white.withOpacity(0.2),
                trackHeight: 24,
                thumbShape: const RoundSliderThumbShape(
                  enabledThumbRadius: 12,
                  elevation: 4,
                ),
              ),
              child: Slider(
                value: _isMuted ? 0.0 : _volume,
                min: 0.0,
                max: 1.0,
                onChanged: _setVolume,
              ),
            ),
          ),
        ),
        
        SizedBox(height: screenHeight * 0.04),
        
        // Control buttons row
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Speaker/Volume button
            Semantics(
              label: _isMuted ? 'Unmute audio' : 'Mute audio',
              button: true,
              child: GestureDetector(
                onTap: _toggleMute,
                child: _buildSquareButton(
                  size: buttonSize,
                  child: Icon(
                    _isMuted ? Icons.volume_off : Icons.volume_up,
                    size: buttonSize * 0.5,
                    color: const Color(0xFF42A5F5),
                  ),
                ),
              ),
            ),
            
            SizedBox(width: screenWidth * 0.04),
            
            // Play/Stop button (larger)
            Semantics(
              label: _isPlaying ? 'Stop radio' : 'Play radio',
              button: true,
              child: GestureDetector(
                onTap: _isLoading ? null : _togglePlayPause,
                child: _buildSquareButton(
                  size: playButtonSize,
                  isPlayButton: true,
                  child: _isLoading
                      ? SizedBox(
                          width: playButtonSize * 0.4,
                          height: playButtonSize * 0.4,
                          child: const CircularProgressIndicator(
                            color: Color(0xFF42A5F5),
                            strokeWidth: 3,
                          ),
                        )
                      : Icon(
                          _isPlaying ? Icons.stop : Icons.play_arrow,
                          size: playButtonSize * 0.6,
                          color: const Color(0xFF42A5F5),
                        ),
                ),
              ),
            ),
            
            SizedBox(width: screenWidth * 0.04),
            
            // Info button
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    backgroundColor: const Color(0xFF1a1a1a),
                    title: const Text(
                      'Church 668 Radio',
                      style: TextStyle(color: Colors.white),
                    ),
                    content: const Text(
                      'Church of the Firstborn Assembly\nBringing Hope to the World\n\nThe Old Time Gospel Hour Family Radio',
                      style: TextStyle(color: Colors.white70),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Close'),
                      ),
                    ],
                  ),
                );
              },
              child: _buildSquareButton(
                size: buttonSize,
                child: Icon(
                  Icons.info_outline,
                  size: buttonSize * 0.5,
                  color: const Color(0xFF42A5F5),
                ),
              ),
            ),
          ],
        ),
        
        // Error message
        if (_errorMessage != null) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.redAccent.withOpacity(0.5)),
            ),
            child: Text(
              _errorMessage!,
              style: const TextStyle(color: Colors.redAccent, fontSize: 12),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildSquareButton({
    required double size,
    required Widget child,
    bool isPlayButton = false,
  }) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF4a4a4a),
            const Color(0xFF2a2a2a),
            const Color(0xFF1a1a1a),
          ],
        ),
        border: Border.all(
          color: const Color(0xFF5a5a5a),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.6),
            blurRadius: 8,
            offset: const Offset(2, 4),
          ),
          BoxShadow(
            color: const Color(0xFF3a3a3a).withOpacity(0.3),
            blurRadius: 2,
            offset: const Offset(-1, -1),
          ),
        ],
      ),
      child: Container(
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF2a2a2a),
              Color(0xFF1a1a1a),
              Color(0xFF0a0a0a),
            ],
          ),
        ),
        child: Center(child: child),
      ),
    );
  }
}
