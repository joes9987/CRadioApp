import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audio_service/audio_service.dart';
import 'theme/app_theme.dart';
import 'screens/home_screen.dart';
import 'services/audio_handler.dart';

// Global audio handler instance (nullable until initialized)
RadioAudioHandler? audioHandler;
bool audioServiceInitialized = false;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  // Set system UI overlay style for immersive experience
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: AppTheme.navyDark,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  
  // Initialize audio service for background playback
  try {
    audioHandler = await AudioService.init<RadioAudioHandler>(
      builder: () => RadioAudioHandler(),
      config: AudioServiceConfig(
        androidNotificationChannelId: 'com.church668.radio.audio',
        androidNotificationChannelName: 'Church 668 Radio',
        androidNotificationChannelDescription: 'Radio streaming notification',
        androidNotificationOngoing: true,
        androidStopForegroundOnPause: false,
        androidNotificationIcon: 'mipmap/ic_launcher',
        androidShowNotificationBadge: true,
        notificationColor: const Color(0xFF1565C0),
        fastForwardInterval: Duration.zero,
        rewindInterval: Duration.zero,
      ),
    );
    audioServiceInitialized = true;
    debugPrint('Audio service initialized successfully');
  } catch (e, stackTrace) {
    debugPrint('Failed to initialize audio service: $e');
    debugPrint('Stack trace: $stackTrace');
    audioServiceInitialized = false;
  }
  
  runApp(const ChurchRadioApp());
}

class ChurchRadioApp extends StatelessWidget {
  const ChurchRadioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Church 668 Radio',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.themeData,
      home: const HomeScreen(),
    );
  }
}
