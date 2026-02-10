import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_theme.dart';
import '../config/app_config.dart';

class SocialLinksWidget extends StatelessWidget {
  const SocialLinksWidget({super.key});

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final shortestSide = screenWidth < screenHeight ? screenWidth : screenHeight;
    
    // Responsive sizing with constraints
    final buttonSize = (screenWidth * 0.11).clamp(36.0, 56.0);
    final iconSize = (buttonSize * 0.42).clamp(14.0, 24.0);
    final buttonSpacing = (screenWidth * 0.03).clamp(8.0, 20.0);
    final containerPadding = (screenWidth * 0.035).clamp(10.0, 20.0);
    final containerVerticalPadding = (screenHeight * 0.01).clamp(6.0, 14.0);
    final borderRadius = (shortestSide * 0.06).clamp(18.0, 30.0);
    final borderWidth = (shortestSide * 0.004).clamp(1.0, 2.0);
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: containerPadding,
            vertical: containerVerticalPadding,
          ),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.5),
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _SocialButton(
                icon: FontAwesomeIcons.facebook,
                onTap: () => _launchUrl(AppConfig.facebookUrl),
                label: 'Facebook',
                size: buttonSize,
                iconSize: iconSize,
                borderWidth: borderWidth,
              ),
              SizedBox(width: buttonSpacing),
              _SocialButton(
                icon: FontAwesomeIcons.whatsapp,
                onTap: () => _launchUrl(AppConfig.whatsappUrl),
                label: 'WhatsApp',
                size: buttonSize,
                iconSize: iconSize,
                borderWidth: borderWidth,
              ),
              SizedBox(width: buttonSpacing),
              _SocialButton(
                icon: FontAwesomeIcons.youtube,
                onTap: () => _launchUrl(AppConfig.youtubeUrl),
                label: 'YouTube',
                size: buttonSize,
                iconSize: iconSize,
                borderWidth: borderWidth,
              ),
              SizedBox(width: buttonSpacing),
              _SocialButton(
                icon: FontAwesomeIcons.xTwitter,
                onTap: () => _launchUrl(AppConfig.twitterUrl),
                label: 'X',
                size: buttonSize,
                iconSize: iconSize,
                borderWidth: borderWidth,
              ),
              SizedBox(width: buttonSpacing),
              _SocialButton(
                icon: FontAwesomeIcons.globe,
                onTap: () => _launchUrl(AppConfig.websiteUrl),
                label: 'Website',
                size: buttonSize,
                iconSize: iconSize,
                borderWidth: borderWidth,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SocialButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;
  final String label;
  final double size;
  final double iconSize;
  final double borderWidth;

  const _SocialButton({
    required this.icon,
    required this.onTap,
    required this.label,
    required this.size,
    required this.iconSize,
    required this.borderWidth,
  });

  @override
  State<_SocialButton> createState() => _SocialButtonState();
}

class _SocialButtonState extends State<_SocialButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: widget.label,
      child: GestureDetector(
        onTap: widget.onTap,
        onTapDown: (_) => setState(() => _isHovered = true),
        onTapUp: (_) => setState(() => _isHovered = false),
        onTapCancel: () => setState(() => _isHovered = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _isHovered 
                ? AppTheme.primaryBlue.withOpacity(0.3)
                : Colors.transparent,
            border: Border.all(
              color: _isHovered 
                  ? AppTheme.lightBlue 
                  : AppTheme.lightBlue.withOpacity(0.4),
              width: widget.borderWidth,
            ),
          ),
          child: Center(
            child: FaIcon(
              widget.icon,
              size: widget.iconSize,
              color: _isHovered ? AppTheme.textWhite : AppTheme.lightBlue,
            ),
          ),
        ),
      ),
    );
  }
}
