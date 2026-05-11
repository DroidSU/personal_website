import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/utils/responsive.dart';

class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: AppSpacing.maxWidth + 160),
      padding: EdgeInsets.symmetric(
        horizontal: Responsive.isMobile(context) ? 20 : 80,
        vertical: 100,
      ),
      child: Column(
        children: [
          Divider(color: Colors.white.withValues(alpha: 0.05)),
          const SizedBox(height: 100),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 32,
              ),
              children: const [
                TextSpan(text: "Let's build something "),
                TextSpan(
                  text: "amazing ",
                  style: TextStyle(color: AppColors.accentPurple),
                ),
                TextSpan(text: "together."),
              ],
            ),
          ),
          const SizedBox(height: 100),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "SD",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Row(
                children: [
                  _SocialIcon(icon: FontAwesomeIcons.github),
                  _SocialIcon(icon: FontAwesomeIcons.linkedin),
                  _SocialIcon(icon: FontAwesomeIcons.instagram),
                  _SocialIcon(icon: Icons.email_outlined),
                ],
              ),
              Text(
                "© 2024 Sujoy Dutta. All rights reserved.",
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SocialIcon extends StatelessWidget {
  final IconData icon;
  const _SocialIcon({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: FaIcon(icon, color: AppColors.textSecondary, size: 18),
    );
  }
}
