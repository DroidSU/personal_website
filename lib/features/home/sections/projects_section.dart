import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/utils/responsive.dart';
import '../../../shared/widgets/animated_card.dart';
import '../../../shared/widgets/section_title.dart';

class ProjectsSection extends StatelessWidget {
  const ProjectsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: AppSpacing.maxWidth + 160),
      padding: EdgeInsets.symmetric(
        horizontal: Responsive.isMobile(context) ? 20 : 80,
        vertical: 100,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const SectionTitle(
                title: "Some cool applications.",
                subtitle: "Projects",
              ),
              if (!Responsive.isMobile(context))
                TextButton.icon(
                  onPressed: () {},
                  icon: const Text("View all projects", style: TextStyle(color: AppColors.textSecondary)),
                  label: const Icon(Icons.arrow_forward, size: 16, color: AppColors.textSecondary),
                ),
            ],
          ),
          const SizedBox(height: 60),
          LayoutBuilder(
            builder: (context, constraints) {
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: Responsive.isMobile(context) ? 1 : (Responsive.isTablet(context) ? 2 : 3),
                  crossAxisSpacing: 32,
                  mainAxisSpacing: 32,
                  childAspectRatio: 1.3,
                ),
                itemCount: 3,
                itemBuilder: (context, index) => _buildProjectCard(context, index),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildProjectCard(BuildContext context, int index) {
    final projects = [
      {
        "name": "Taskify",
        "desc": "Task manager to help you stay focused and get things done.",
        "icon": Icons.check_circle,
        "color": Colors.indigo,
        "category": "Productivity",
      },
      {
        "name": "SplitEase",
        "desc": "Split expenses with friends, effortlessly and instantly.",
        "icon": Icons.currency_rupee,
        "color": Colors.teal,
        "category": "Finance",
      },
      {
        "name": "HydroTrack",
        "desc": "Stay hydrated, stay healthy. Track your daily water intake.",
        "icon": Icons.water_drop,
        "color": Colors.blue,
        "category": "Health",
      },
    ];
    final p = projects[index];

    return AnimatedCard(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: (p['color'] as Color).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(p['icon'] as IconData, color: p['color'] as Color, size: 28),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        p['name'] as String,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      Text(
                        p['category'] as String,
                        style: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              p['desc'] as String,
              style: const TextStyle(color: AppColors.textSecondary, height: 1.5),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const Spacer(),
            const Icon(FontAwesomeIcons.android, size: 16, color: Colors.white24),
          ],
        ),
      ),
    );
  }
}
