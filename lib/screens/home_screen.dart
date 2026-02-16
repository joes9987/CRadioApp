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
    
    // Base font sizes for width-fitting text (FittedBox.fitWidth scales to fill)
    const double headerFontSize = 56;
    const double churchNameFontSize = 52;  // Larger than tagline
    const double taglineFontSize = 28;
    const double connectFontSize = 24;
    
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            // Background image from fwdradioappimage
            Positioned.fill(
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('fwdradioappimage/e6a411e538cb8429b8293504fa06643f.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  // Dark overlay for text readability
                  Container(
                    color: Colors.black.withOpacity(0.45),
                  ),
                ],
              ),
            ),
            
            // Main content - use SingleChildScrollView for overflow protection
            SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                            // Radio Station Name at top (header bar)
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(
                                vertical: screenHeight * 0.02 * spacingMultiplier,
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
                                fit: BoxFit.fitWidth,
                                alignment: Alignment.center,
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
                            
                            // Church name ribbon (taller vertical space, more width for larger text)
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(
                                horizontal: screenWidth * 0.02,
                                vertical: screenHeight * 0.06 * spacingMultiplier,
                              ),
                              margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.35),
                                borderRadius: BorderRadius.circular(shortestSide * 0.02),
                              ),
                              child: FittedBox(
                                fit: BoxFit.fitWidth,
                                alignment: Alignment.center,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'CHURCH OF THE FIRST BORN ASSEMBLY',
                                      style: TextStyle(
                                        fontSize: churchNameFontSize,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        letterSpacing: 0.5,
                                        height: 1.2,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(height: churchNameFontSize * 0.15),
                                    Text(
                                      'MIRACLE CENTER',
                                      style: TextStyle(
                                        fontSize: churchNameFontSize,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        letterSpacing: 0.5,
                                        height: 1.2,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            
                            SizedBox(height: screenHeight * 0.008 * spacingMultiplier),
                            
                            // Tagline in blue italic
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                              child: FittedBox(
                                fit: BoxFit.fitWidth,
                                alignment: Alignment.center,
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
                            
                            SizedBox(height: screenHeight * 0.06 * spacingMultiplier),
                            
                            // Audio Player (volume slider + buttons)
                            const AudioPlayerWidget(),
                            
                            SizedBox(height: screenHeight * 0.015 * spacingMultiplier),
                            
                            // "CONNECT WITH US" text
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
                              child: FittedBox(
                                fit: BoxFit.fitWidth,
                                alignment: Alignment.center,
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
                            ),
                            
                            SizedBox(height: screenHeight * 0.008 * spacingMultiplier),
                            
                            // Social Links
                            const SocialLinksWidget(),
                            
                            SizedBox(height: screenHeight * 0.015 * spacingMultiplier),
                          ],
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
