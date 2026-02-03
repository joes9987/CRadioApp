import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'theme/app_theme.dart';
import 'screens/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
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
      title: 'Church of the Firstborn Assembly',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.themeData,
      home: const HomeScreen(),
    );
  }
}
