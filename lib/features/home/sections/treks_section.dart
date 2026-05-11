import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/utils/responsive.dart';
import '../../../shared/widgets/section_title.dart';

class TreksSection extends StatelessWidget {
  const TreksSection({super.key});

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
                title: "Places that recharge me.",
                subtitle: "Treks",
              ),
              TextButton.icon(
                onPressed: () {},
                icon: const Text("View all treks", style: TextStyle(color: AppColors.textSecondary)),
                label: const Icon(Icons.arrow_forward, size: 16, color: AppColors.textSecondary),
              ),
            ],
          ),
          const SizedBox(height: 60),
          SizedBox(
            height: 280,
            child: ListView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              children: [
                _buildTrekCard(context, "Triund Trek", "Dharamshala, HP"),
                _buildTrekCard(context, "Kedarkantha Trek", "Uttarkashi, UK"),
                _buildTrekCard(context, "Hampta Pass", "Manali, HP"),
                _buildTrekCard(context, "Valley of Flowers", "Chamoli, UK"),
                _buildTrekCard(context, "Goecha La Trek", "Sikkim"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrekCard(BuildContext context, String name, String location) {
    return Container(
      width: 280,
      margin: const EdgeInsets.only(right: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Image.asset(
                "assets/images/phulara_ridge_1_png.png",
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              const Icon(Icons.location_on, size: 14, color: AppColors.accentPurple),
              const SizedBox(width: 8),
              Text(
                name,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(22,0,0,0),
            child: Text(
              location,
              style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
