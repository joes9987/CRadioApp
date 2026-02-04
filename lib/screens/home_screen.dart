import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../config/app_config.dart';
import '../widgets/audio_player.dart';
import '../widgets/social_links.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            // Metal mesh background
            Positioned.fill(
              child: CustomPaint(
                painter: _MetalMeshPainter(),
              ),
            ),
            
            // Main content
            SafeArea(
              child: Column(
                children: [
                  // Radio Station Name at top (header bar)
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      vertical: screenHeight * 0.02,
                      horizontal: 16,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          const Color(0xFF2a2a2a),
                          const Color(0xFF1a1a1a),
                          Colors.black.withOpacity(0.8),
                        ],
                      ),
                      border: const Border(
                        bottom: BorderSide(
                          color: Color(0xFF444444),
                          width: 1,
                        ),
                      ),
                    ),
                    child: Text(
                      AppConfig.radioStationName.toUpperCase(),
                      style: TextStyle(
                        fontSize: screenWidth * 0.065,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  
                  // Spacer
                  SizedBox(height: screenHeight * 0.03),
                  
                  // Large logo in white frame
                  Container(
                    width: screenWidth * 0.75,
                    height: screenHeight * 0.28,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFF555555),
                        width: 3,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          blurRadius: 20,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        AppConfig.logoPath,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.white,
                            child: Icon(
                              Icons.church,
                              size: screenWidth * 0.3,
                              color: AppTheme.primaryBlue,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  
                  SizedBox(height: screenHeight * 0.03),
                  
                  // Church name (centered, below logo)
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                    child: Text(
                      AppConfig.churchName.toUpperCase(),
                      style: TextStyle(
                        fontSize: screenWidth * 0.055,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 0.5,
                        height: 1.2,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  
                  SizedBox(height: screenHeight * 0.01),
                  
                  // Tagline in blue italic
                  Text(
                    AppConfig.tagline,
                    style: GoogleFonts.playfairDisplay(
                      fontSize: screenWidth * 0.055,
                      fontStyle: FontStyle.italic,
                      color: AppTheme.lightBlue,
                      letterSpacing: 0.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  
                  // Spacer - pushes controls to bottom
                  const Spacer(),
                  
                  // Audio Player (volume slider + buttons)
                  const AudioPlayerWidget(),
                  
                  SizedBox(height: screenHeight * 0.02),
                  
                  // "CONNECT WITH US" text
                  Text(
                    'CONNECT WITH US',
                    style: TextStyle(
                      fontSize: screenWidth * 0.035,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.lightBlue,
                      letterSpacing: 2,
                    ),
                  ),
                  
                  SizedBox(height: screenHeight * 0.01),
                  
                  // Social Links
                  const SocialLinksWidget(),
                  
                  SizedBox(height: screenHeight * 0.02),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Custom painter for metal mesh perforated pattern
class _MetalMeshPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Dark metal background
    final bgPaint = Paint()
      ..color = const Color(0xFF1a1a1a);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);
    
    // Perforated holes
    final holePaint = Paint()
      ..color = const Color(0xFF0a0a0a)
      ..style = PaintingStyle.fill;
    
    // Highlight for 3D effect
    final highlightPaint = Paint()
      ..color = const Color(0xFF2a2a2a)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;
    
    const double holeRadius = 5;
    const double spacing = 18;
    
    for (double y = spacing / 2; y < size.height; y += spacing) {
      // Offset every other row for hex pattern
      double offsetX = (y ~/ spacing) % 2 == 0 ? 0 : spacing / 2;
      for (double x = spacing / 2 + offsetX; x < size.width; x += spacing) {
        // Draw hole (dark center)
        canvas.drawCircle(Offset(x, y), holeRadius, holePaint);
        // Draw subtle highlight on top edge for depth
        canvas.drawArc(
          Rect.fromCircle(center: Offset(x, y), radius: holeRadius),
          3.14,
          3.14,
          false,
          highlightPaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
