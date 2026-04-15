import 'package:flutter/material.dart';

class SectionPage extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<Widget> children;

  const SectionPage({
    super.key,
    required this.title,
    required this.subtitle,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: theme.textTheme.displayMedium),
                const SizedBox(height: 14),
                Text(subtitle, style: theme.textTheme.bodyLarge),
                const SizedBox(height: 28),
                ...children,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
