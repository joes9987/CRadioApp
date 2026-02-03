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
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.5),
            borderRadius: BorderRadius.circular(25),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _SocialButton(
                icon: FontAwesomeIcons.facebook,
                onTap: () => _launchUrl(AppConfig.facebookUrl),
                label: 'Facebook',
              ),
              const SizedBox(width: 16),
              _SocialButton(
                icon: FontAwesomeIcons.whatsapp,
                onTap: () => _launchUrl(AppConfig.whatsappUrl),
                label: 'WhatsApp',
              ),
              const SizedBox(width: 16),
              _SocialButton(
                icon: FontAwesomeIcons.youtube,
                onTap: () => _launchUrl(AppConfig.youtubeUrl),
                label: 'YouTube',
              ),
              const SizedBox(width: 16),
              _SocialButton(
                icon: FontAwesomeIcons.xTwitter,
                onTap: () => _launchUrl(AppConfig.twitterUrl),
                label: 'X',
              ),
              const SizedBox(width: 16),
              _SocialButton(
                icon: FontAwesomeIcons.globe,
                onTap: () => _launchUrl(AppConfig.websiteUrl),
                label: 'Website',
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

  const _SocialButton({
    required this.icon,
    required this.onTap,
    required this.label,
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
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _isHovered 
                ? AppTheme.primaryBlue.withOpacity(0.3)
                : Colors.transparent,
            border: Border.all(
              color: _isHovered 
                  ? AppTheme.lightBlue 
                  : AppTheme.lightBlue.withOpacity(0.4),
              width: 1.5,
            ),
          ),
          child: Center(
            child: FaIcon(
              widget.icon,
              size: 20,
              color: _isHovered ? AppTheme.textWhite : AppTheme.lightBlue,
            ),
          ),
        ),
      ),
    );
  }
}
