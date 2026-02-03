import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audio_service/audio_service.dart';
import 'theme/app_theme.dart';
import 'screens/home_screen.dart';
import 'services/audio_handler.dart';

// Global audio handler instance
late RadioAudioHandler audioHandler;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize audio service for background playback
  audioHandler = await AudioService.init(
    builder: () => RadioAudioHandler(),
    config: AudioServiceConfig(
      androidNotificationChannelId: 'com.church668.radio.channel.audio',
      androidNotificationChannelName: 'Church 668 Radio',
      androidNotificationOngoing: true,
      androidStopForegroundOnPause: false,
      androidNotificationIcon: 'mipmap/ic_launcher',
    ),
  );
  
  // Set preferred orientations
  SystemChrome.setPreferredOrientations([
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
