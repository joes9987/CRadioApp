import 'dart:io';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_session/audio_session.dart';
import '../config/app_config.dart';
import '../main.dart';
import '../services/battery_optimization.dart';
import '../utils/text_scale.dart';

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
    final shortestSide = screenWidth < screenHeight ? screenWidth : screenHeight;
    
    // Responsive sizing with min/max bounds
    final isSmallScreen = screenHeight < 700;
    final spacingMultiplier = isSmallScreen ? 0.8 : 1.0;
    
    // Button sizes - responsive with constraints
    final buttonSize = (screenWidth * 0.16).clamp(50.0, 80.0);
    final playButtonSize = (screenWidth * 0.20).clamp(60.0, 95.0);
    final buttonSpacing = (screenWidth * 0.035).clamp(10.0, 20.0);
    
    // Slider dimensions
    final sliderHeight = (shortestSide * 0.06).clamp(20.0, 30.0);
    final sliderThumbRadius = (sliderHeight / 2).clamp(10.0, 15.0);
    final sliderPadding = screenWidth * 0.08;
    
    // Icon sizes
    final iconSize = buttonSize * 0.5;
    final playIconSize = playButtonSize * 0.55;
    final loadingSize = playButtonSize * 0.4;
    
    // Border radius
    final buttonRadius = (shortestSide * 0.02).clamp(6.0, 12.0);
    final innerRadius = (shortestSide * 0.01).clamp(3.0, 6.0);
    final innerMargin = (shortestSide * 0.01).clamp(3.0, 6.0);
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Volume Slider (full width, blue)
        Padding(
          padding: EdgeInsets.symmetric(horizontal: sliderPadding),
          child: Container(
            height: sliderHeight,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(sliderHeight / 2),
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
                trackHeight: sliderHeight,
                thumbShape: RoundSliderThumbShape(
                  enabledThumbRadius: sliderThumbRadius,
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
        
        SizedBox(height: screenHeight * 0.03 * spacingMultiplier),
        
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
                  radius: buttonRadius,
                  innerRadius: innerRadius,
                  innerMargin: innerMargin,
                  child: Icon(
                    _isMuted ? Icons.volume_off : Icons.volume_up,
                    size: iconSize,
                    color: const Color(0xFF42A5F5),
                  ),
                ),
              ),
            ),
            
            SizedBox(width: buttonSpacing),
            
            // Play/Stop button (larger)
            Semantics(
              label: _isPlaying ? 'Stop radio' : 'Play radio',
              button: true,
              child: GestureDetector(
                onTap: _isLoading ? null : _togglePlayPause,
                child: _buildSquareButton(
                  size: playButtonSize,
                  radius: buttonRadius,
                  innerRadius: innerRadius,
                  innerMargin: innerMargin,
                  isPlayButton: true,
                  child: _isLoading
                      ? SizedBox(
                          width: loadingSize,
                          height: loadingSize,
                          child: CircularProgressIndicator(
                            color: const Color(0xFF42A5F5),
                            strokeWidth: (loadingSize * 0.1).clamp(2.0, 4.0),
                          ),
                        )
                      : Icon(
                          _isPlaying ? Icons.stop : Icons.play_arrow,
                          size: playIconSize,
                          color: const Color(0xFF42A5F5),
                        ),
                ),
              ),
            ),
            
            SizedBox(width: buttonSpacing),
            
            // Info button
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (dialogContext) {
                    final titleSize = TextScale.fontSize(dialogContext, 26);
                    final bodySize = TextScale.fontSize(dialogContext, 20);
                    return AlertDialog(
                      backgroundColor: const Color(0xFF1a1a1a),
                      title: Text(
                        AppConfig.appName,
                        style: TextStyle(color: Colors.white, fontSize: titleSize),
                      ),
                      content: Text(
                        'Church of the Firstborn Assembly\nBringing Hope to the World\n\nThe Old Time Gospel Hour Family Radio',
                        style: TextStyle(color: Colors.white70, fontSize: bodySize),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(dialogContext),
                          child: Text('Close'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: _buildSquareButton(
                size: buttonSize,
                radius: buttonRadius,
                innerRadius: innerRadius,
                innerMargin: innerMargin,
                child: Icon(
                  Icons.info_outline,
                  size: iconSize,
                  color: const Color(0xFF42A5F5),
                ),
              ),
            ),
          ],
        ),
        
        // Error message
        if (_errorMessage != null) ...[
          SizedBox(height: screenHeight * 0.015),
          Container(
            margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.04,
              vertical: screenHeight * 0.01,
            ),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.2),
              borderRadius: BorderRadius.circular(buttonRadius),
              border: Border.all(color: Colors.redAccent.withOpacity(0.5)),
            ),
            child: Text(
              _errorMessage!,
              style: TextStyle(
                color: Colors.redAccent,
                fontSize: TextScale.fontSize(context, 14),
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildSquareButton({
    required double size,
    required double radius,
    required double innerRadius,
    required double innerMargin,
    required Widget child,
    bool isPlayButton = false,
  }) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
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
          width: (size * 0.025).clamp(1.5, 3.0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.6),
            blurRadius: size * 0.1,
            offset: Offset(size * 0.025, size * 0.05),
          ),
          BoxShadow(
            color: const Color(0xFF3a3a3a).withOpacity(0.3),
            blurRadius: 2,
            offset: const Offset(-1, -1),
          ),
        ],
      ),
      child: Container(
        margin: EdgeInsets.all(innerMargin),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(innerRadius),
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
