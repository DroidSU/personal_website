import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/utils/responsive.dart';
import '../../../shared/models/trek_model.dart';
import '../../../shared/widgets/section_title.dart';
import '../../treks/providers/treks_provider.dart';

class TreksSection extends ConsumerWidget {
  const TreksSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final treksAsyncValue = ref.watch(allTreksProvider);

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
                icon: const Text("View all treks",
                    style: TextStyle(color: AppColors.textSecondary)),
                label: const Icon(Icons.arrow_forward,
                    size: 16, color: AppColors.textSecondary),
              ),
            ],
          ),
          const SizedBox(height: 60),
          SizedBox(
            height: 280,
            child: treksAsyncValue.when(
              data: (treks) => ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: treks.length,
                itemBuilder: (context, index) {
                  return _buildTrekCard(context, treks[index]);
                },
              ),
              loading: () => const Center(
                child: CircularProgressIndicator(color: AppColors.accentPurple),
              ),
              error: (error, stack) => Center(
                child: Text(
                  'Error loading treks',
                  style: TextStyle(color: Colors.red[300]),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrekCard(BuildContext context, TrekModel trek) {
    return Container(
      width: 280,
      margin: const EdgeInsets.only(right: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: trek.coverImage.startsWith('http')
                  ? CachedNetworkImage(
                      imageUrl: trek.coverImage,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      placeholder: (context, url) => Container(
                        color: AppColors.borderColor,
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.accentPurple,
                            strokeWidth: 2,
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: AppColors.borderColor,
                        child: const Icon(Icons.error, color: Colors.red),
                      ),
                    )
                  : Image.asset(
                      trek.coverImage,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              const Icon(Icons.location_on,
                  size: 14, color: AppColors.accentPurple),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  trek.title,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 0, 0, 0),
            child: Text(
              trek.location,
              style:
                  const TextStyle(color: AppColors.textSecondary, fontSize: 12),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
