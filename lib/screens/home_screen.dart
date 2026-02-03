import 'package:flutter/material.dart';
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
                  // Title bar at top
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
                      AppConfig.churchName,
                      style: TextStyle(
                        fontSize: screenWidth * 0.08,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  
                  // Spacer
                  SizedBox(height: screenHeight * 0.04),
                  
                  // Large logo in white frame
                  Container(
                    width: screenWidth * 0.85,
                    height: screenHeight * 0.35,
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
                  
                  // Spacer - pushes controls to bottom
                  const Spacer(),
                  
                  // Audio Player (volume slider + buttons)
                  const AudioPlayerWidget(),
                  
                  SizedBox(height: screenHeight * 0.02),
                  
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
