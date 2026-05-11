import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/utils/responsive.dart';
import '../../../shared/widgets/animated_card.dart';
import '../../../shared/widgets/section_title.dart';

class DiarySection extends StatelessWidget {
  const DiarySection({super.key});

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
                title: "Thoughts. Learnings. Moments.",
                subtitle: "Diary",
              ),
              TextButton.icon(
                onPressed: () {},
                icon: const Text("View all entries", style: TextStyle(color: AppColors.textSecondary)),
                label: const Icon(Icons.arrow_forward, size: 16, color: AppColors.textSecondary),
              ),
            ],
          ),
          const SizedBox(height: 60),
          Row(
            children: _buildDiaryCards(context).map((e) => Expanded(child: Padding(
              padding: const EdgeInsets.only(right: 32),
              child: e,
            ))).toList(),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildDiaryCards(BuildContext context) {
    final entries = [
      {
        "date": "May 18, 2024",
        "title": "Why I love building in public",
        "desc": "Sharing the journey, the wins, the struggles and everything in between.",
      },
      {
        "date": "Apr 27, 2024",
        "title": "Lessons from Kedarkantha",
        "desc": "Sometimes the best views come after the hardest climbs.",
      },
      {
        "date": "Apr 10, 2024",
        "title": "Building consistently",
        "desc": "Consistency compounds. Just like code, and like the mountains.",
      },
    ];

    return entries.map((e) {
      return AnimatedCard(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                e['date'] as String,
                style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
              ),
              const SizedBox(height: 16),
              Text(
                e['title'] as String,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, height: 1.4),
              ),
              const SizedBox(height: 12),
              Text(
                e['desc'] as String,
                style: const TextStyle(color: AppColors.textSecondary, fontSize: 14, height: 1.6),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 24),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  foregroundColor: AppColors.accentPurple,
                ),
                child: const Text("Read more →", style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      );
    }).toList();
  }
}
