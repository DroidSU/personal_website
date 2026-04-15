import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../shared/widgets/section_page.dart';

class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionPage(
      title: 'Page not found',
      subtitle:
          'The page you were looking for does not exist. Use the navigation to return to a section.',
      children: [
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 32),
            child: ElevatedButton(
              onPressed: () => context.go('/'),
              child: const Text('Return home'),
            ),
          ),
        ),
      ],
    );
  }
}
