import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/utils/responsive.dart';
import '../../../shared/widgets/hover_button.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: AppSpacing.maxWidth + 160),
      padding: EdgeInsets.symmetric(
        horizontal: Responsive.isMobile(context) ? 20 : 80,
        vertical: Responsive.isMobile(context) ? 40 : 100,
      ),
      child: Responsive(
        mobile: _buildMobileHero(context),
        desktop: _buildDesktopHero(context),
      ),
    );
  }

  Widget _buildDesktopHero(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 4,
          child: _buildHeroText(context),
        ),
        const SizedBox(width: 40),
        Expanded(
          flex: 5,
          child: _buildHeroImage(context),
        ),
      ],
    );
  }

  Widget _buildMobileHero(BuildContext context) {
    return Column(
      children: [
        _buildHeroImage(context),
        const SizedBox(height: 40),
        _buildHeroText(context),
      ],
    );
  }

  Widget _buildHeroText(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Hi, I'm",
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: AppColors.textSecondary,
          ),
        ).animate().fadeIn(duration: 600.ms),
        const SizedBox(height: 16),
        RichText(
          text: TextSpan(
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
              height: 1.1,
              letterSpacing: -2,
            ),
            children: [
              const TextSpan(text: "Sujoy "),
              TextSpan(
                text: "Dutta",
                style: TextStyle(
                  foreground: Paint()..shader = const LinearGradient(
                    colors: [Colors.white, AppColors.accentPurple],
                  ).createShader(const Rect.fromLTWH(0, 0, 400, 70)),
                ),
              ),
            ],
          ),
        ).animate().fadeIn(delay: 200.ms, duration: 600.ms).slideX(begin: -0.1),
        const SizedBox(height: 20),
        Text(
          AppStrings.role,
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
            color: AppColors.textSecondary,
            fontSize: 28,
            fontWeight: FontWeight.w500,
          ),
        ).animate().fadeIn(delay: 400.ms, duration: 600.ms),
        const SizedBox(height: 32),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Text(
            AppStrings.heroDescription,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.6),
          ),
        ).animate().fadeIn(delay: 600.ms, duration: 600.ms),
        const SizedBox(height: 48),
        Row(
          children: [
            HoverButton(
              text: "View My Work", 
              onPressed: () {},
              icon: Icons.arrow_forward,
            ),
            const SizedBox(width: 32),
            TextButton(
              onPressed: () {},
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Download CV", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  SizedBox(width: 8),
                  Icon(Icons.download_outlined, color: Colors.white, size: 20),
                ],
              ),
            ),
          ],
        ).animate().fadeIn(delay: 800.ms, duration: 600.ms),
        const SizedBox(height: 48),
        const Row(
          children: [
            _SocialIcon(icon: FontAwesomeIcons.github),
            _SocialIcon(icon: FontAwesomeIcons.linkedin),
            _SocialIcon(icon: FontAwesomeIcons.instagram),
            _SocialIcon(icon: Icons.email_outlined),
          ],
        ).animate().fadeIn(delay: 1000.ms, duration: 600.ms),
      ],
    );
  }

  Widget _buildHeroImage(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 550,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32),
            image: const DecorationImage(
              image: AssetImage("assets/images/phulara_ridge_2_png.png"),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          bottom: 32,
          right: 32,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.85),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(FontAwesomeIcons.mountain, color: AppColors.accentPurple, size: 20),
                SizedBox(height: 12),
                Text(
                  "Explorer at heart",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  "Developer by choice",
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
                ),
              ],
            ),
          ),
        ),
      ],
    ).animate().fadeIn(delay: 400.ms, duration: 800.ms).scale(begin: const Offset(0.9, 0.9));
  }
}

class _SocialIcon extends StatelessWidget {
  final IconData icon;
  const _SocialIcon({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 32),
      child: FaIcon(icon, color: AppColors.textSecondary, size: 20),
    );
  }
}
