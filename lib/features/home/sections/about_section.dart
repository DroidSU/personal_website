import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/utils/responsive.dart';
import '../../../shared/widgets/section_title.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: AppSpacing.maxWidth + 160),
      padding: EdgeInsets.symmetric(
        horizontal: Responsive.isMobile(context) ? 20 : 80,
        vertical: 100,
      ),
      child: Responsive(
        mobile: _buildMobileAbout(context),
        desktop: _buildDesktopAbout(context),
      ),
    );
  }

  Widget _buildDesktopAbout(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionTitle(
                title: "I code. I build. I explore.",
                subtitle: "About Me",
              ),
              const SizedBox(height: 32),
              Text(
                AppStrings.aboutDescription,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.8),
              ),
              const SizedBox(height: 60),
              _buildStatsRow(context),
            ],
          ),
        ),
        const SizedBox(width: 80),
        Expanded(
          flex: 3,
          child: Container(
            padding: const EdgeInsets.all(40),
            decoration: BoxDecoration(
              color: AppColors.secondaryBackground,
              borderRadius: BorderRadius.circular(32),
              border: Border.all(color: AppColors.borderColor),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "What I Do",
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: AppColors.accentPurple,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 32),
                _buildWhatIDoItem(
                  context,
                  Icons.code,
                  "Mobile Development",
                  "Building performant and beautiful apps for Android.",
                ),
                const SizedBox(height: 32),
                _buildWhatIDoItem(
                  context,
                  Icons.phone_android,
                  "UI/UX Focused",
                  "Crafting clean and intuitive user experiences.",
                ),
                const SizedBox(height: 32),
                _buildWhatIDoItem(
                  context,
                  Icons.rocket_launch,
                  "Problem Solver",
                  "Turning complex problems into simple solutions.",
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileAbout(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle(
          title: "I code. I build. I explore.",
          subtitle: "About Me",
        ),
        const SizedBox(height: 24),
        Text(
          AppStrings.aboutDescription,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 40),
        _buildStatsRow(context),
        const SizedBox(height: 60),
        // ... (What I Do section for mobile)
      ],
    );
  }

  Widget _buildWhatIDoItem(BuildContext context, IconData icon, String title, String desc) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppColors.accentPurple, size: 24),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                desc,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatsRow(BuildContext context) {
    return Wrap(
      spacing: 60,
      runSpacing: 20,
      children: [
        _buildStatItem(context, "3+", "Years of Coding"),
        _buildStatItem(context, "10+", "Projects Built"),
        _buildStatItem(context, "10+", "Treks Completed"),
      ],
    );
  }

  Widget _buildStatItem(BuildContext context, String value, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
            color: AppColors.accentPurple,
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}
