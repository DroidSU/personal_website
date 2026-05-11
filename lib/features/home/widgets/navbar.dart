import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/utils/responsive.dart';

class Navbar extends StatelessWidget {
  final Function(int) onNavItemTap;
  final bool isScrolled;

  const Navbar({
    super.key,
    required this.onNavItemTap,
    this.isScrolled = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      padding: EdgeInsets.symmetric(
        horizontal: Responsive.isMobile(context) ? 20 : 80,
      ),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: AppSpacing.maxWidth + 160),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Logo
              Row(
                children: [
                  Text(
                    "SD ",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppColors.accentPurple,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Text(
                    "Sujoy Dutta",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),

              // Nav Items
              if (!Responsive.isMobile(context))
                Row(
                  children: [
                    _NavItem(title: "Home", isActive: true, onTap: () => onNavItemTap(0)),
                    _NavItem(title: "About", onTap: () => onNavItemTap(1)),
                    _NavItem(title: "Projects", onTap: () => onNavItemTap(2)),
                    _NavItem(title: "Treks", onTap: () => onNavItemTap(3)),
                    _NavItem(title: "Diary", onTap: () => onNavItemTap(4)),
                    _NavItem(title: "Contact", onTap: () => onNavItemTap(5)),
                  ],
                ),

              // Action Button
              if (!Responsive.isMobile(context))
                OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white24),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text("Let's Connect ↗"),
                )
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final String title;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.title, 
    this.isActive = false, 
    required this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: TextStyle(
                color: isActive ? Colors.white : AppColors.textSecondary,
                fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
              ),
            ),
            if (isActive) ...[
              const SizedBox(height: 4),
              Container(
                height: 2,
                width: 20,
                color: AppColors.accentPurple,
              ),
            ]
          ],
        ),
      ),
    );
  }
}
