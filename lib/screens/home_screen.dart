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
    
    // Calculate responsive sizes based on screen dimensions
    // Use the smaller dimension to ensure everything fits
    final shortestSide = screenWidth < screenHeight ? screenWidth : screenHeight;
    final isSmallScreen = screenHeight < 700;
    final isVerySmallScreen = screenHeight < 600;
    
    // Responsive spacing multipliers
    final spacingMultiplier = isVerySmallScreen ? 0.6 : (isSmallScreen ? 0.8 : 1.0);
    
    // Logo size - scales with screen but has min/max bounds
    final logoWidth = (screenWidth * 0.75).clamp(200.0, 400.0);
    final logoHeight = (screenHeight * 0.25 * spacingMultiplier).clamp(150.0, 300.0);
    
    // Text sizes - responsive with min/max
    final headerFontSize = (screenWidth * 0.06).clamp(18.0, 28.0);
    final churchNameFontSize = (screenWidth * 0.05).clamp(14.0, 24.0);
    final taglineFontSize = (screenWidth * 0.05).clamp(14.0, 22.0);
    final connectFontSize = (screenWidth * 0.035).clamp(10.0, 16.0);
    
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            // Metal mesh background
            Positioned.fill(
              child: CustomPaint(
                painter: _MetalMeshPainter(shortestSide: shortestSide),
              ),
            ),
            
            // Main content - use SingleChildScrollView for overflow protection
            SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: IntrinsicHeight(
                        child: Column(
                          children: [
                            // Radio Station Name at top (header bar)
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(
                                vertical: screenHeight * 0.015 * spacingMultiplier,
                                horizontal: screenWidth * 0.04,
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
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  AppConfig.radioStationName.toUpperCase(),
                                  style: TextStyle(
                                    fontSize: headerFontSize,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    letterSpacing: 1,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            
                            // Spacer
                            SizedBox(height: screenHeight * 0.02 * spacingMultiplier),
                            
                            // Large logo in white frame
                            Container(
                              width: logoWidth,
                              height: logoHeight,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(shortestSide * 0.03),
                                border: Border.all(
                                  color: const Color(0xFF555555),
                                  width: (shortestSide * 0.008).clamp(2.0, 4.0),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.5),
                                    blurRadius: shortestSide * 0.05,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(shortestSide * 0.02),
                                child: Image.asset(
                                  AppConfig.logoPath,
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      color: Colors.white,
                                      child: Icon(
                                        Icons.church,
                                        size: logoWidth * 0.4,
                                        color: AppTheme.primaryBlue,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            
                            SizedBox(height: screenHeight * 0.02 * spacingMultiplier),
                            
                            // Church name (centered, below logo)
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  AppConfig.churchName.toUpperCase(),
                                  style: TextStyle(
                                    fontSize: churchNameFontSize,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    letterSpacing: 0.5,
                                    height: 1.2,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            
                            SizedBox(height: screenHeight * 0.008 * spacingMultiplier),
                            
                            // Tagline in blue italic
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  AppConfig.tagline,
                                  style: GoogleFonts.playfairDisplay(
                                    fontSize: taglineFontSize,
                                    fontStyle: FontStyle.italic,
                                    color: AppTheme.lightBlue,
                                    letterSpacing: 0.5,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            
                            // Flexible spacer - pushes controls to bottom
                            Expanded(
                              child: SizedBox(
                                height: screenHeight * 0.02,
                              ),
                            ),
                            
                            // Audio Player (volume slider + buttons)
                            const AudioPlayerWidget(),
                            
                            SizedBox(height: screenHeight * 0.015 * spacingMultiplier),
                            
                            // "CONNECT WITH US" text
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                'CONNECT WITH US',
                                style: TextStyle(
                                  fontSize: connectFontSize,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.lightBlue,
                                  letterSpacing: 2,
                                ),
                              ),
                            ),
                            
                            SizedBox(height: screenHeight * 0.008 * spacingMultiplier),
                            
                            // Social Links
                            const SocialLinksWidget(),
                            
                            SizedBox(height: screenHeight * 0.015 * spacingMultiplier),
                          ],
                        ),
                      ),
                    ),
                  );
                },
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
  final double shortestSide;
  
  _MetalMeshPainter({required this.shortestSide});
  
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
    
    // Scale hole size and spacing based on screen size
    final double holeRadius = (shortestSide * 0.012).clamp(3.0, 6.0);
    final double spacing = (shortestSide * 0.045).clamp(12.0, 22.0);
    
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
  bool shouldRepaint(covariant _MetalMeshPainter oldDelegate) => 
      oldDelegate.shortestSide != shortestSide;
}
