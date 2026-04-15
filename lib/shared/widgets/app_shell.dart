import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/app_state.dart';

class AppShell extends ConsumerWidget {
  final Widget child;

  const AppShell({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedSection = ref.watch(selectedSectionProvider);
    final sections = ref.watch(sectionsProvider);
    final theme = Theme.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 900;
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            scrolledUnderElevation: 0,
            surfaceTintColor: Colors.white,
            backgroundColor: Colors.white,
            title: Text(
              'Personal Website',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            actions: isDesktop
                ? _buildDesktopActions(context, ref, sections, selectedSection)
                : null,
          ),
          drawer: isDesktop
              ? null
              : Drawer(
                  child: _buildDrawer(context, ref, sections, selectedSection),
                ),
          body: SafeArea(
            child: Container(
              width: double.infinity,
              color: theme.colorScheme.surface,
              child: child,
            ),
          ),
        );
      },
    );
  }

  List<Widget> _buildDesktopActions(
    BuildContext context,
    WidgetRef ref,
    List<AppSection> sections,
    AppSection selectedSection,
  ) {
    return sections
        .map(
          (section) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: TextButton.icon(
              onPressed: () => _navigate(context, ref, section),
              icon: Icon(section.icon, size: 18),
              label: Text(section.title),
              style: TextButton.styleFrom(
                foregroundColor: selectedSection == section
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        )
        .toList();
  }

  Widget _buildDrawer(
    BuildContext context,
    WidgetRef ref,
    List<AppSection> sections,
    AppSection selectedSection,
  ) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              'Menu',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          const Divider(height: 0),
          ...sections.map(
            (section) => ListTile(
              leading: Icon(
                section.icon,
                color: selectedSection == section
                    ? Theme.of(context).colorScheme.primary
                    : null,
              ),
              title: Text(section.title),
              selected: selectedSection == section,
              onTap: () => _navigate(context, ref, section),
            ),
          ),
        ],
      ),
    );
  }

  void _navigate(BuildContext context, WidgetRef ref, AppSection section) {
    ref.read(selectedSectionProvider.notifier).state = section;
    context.go(section.path);
    if (Scaffold.maybeOf(context)?.isDrawerOpen == true) {
      Navigator.of(context).pop();
    }
  }
}
