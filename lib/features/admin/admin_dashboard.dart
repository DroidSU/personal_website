import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AdminDashboard extends ConsumerStatefulWidget {
  final Widget child;

  const AdminDashboard({super.key, required this.child});

  @override
  ConsumerState<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends ConsumerState<AdminDashboard> {
  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width < 800;

    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      appBar: isMobile
          ? AppBar(
              backgroundColor: const Color(0xFF1E1E1E),
              title: const Text('Admin Panel'),
            )
          : null,
      drawer: isMobile ? const AdminSidebar() : null,
      body: Row(
        children: [
          if (!isMobile) const AdminSidebar(),
          Expanded(
            child: Column(
              children: [
                if (!isMobile) const AdminTopbar(),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: widget.child,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AdminSidebar extends StatelessWidget {
  const AdminSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final String currentRoute = GoRouterState.of(context).uri.toString();

    return Container(
      width: 250,
      color: const Color(0xFF1E1E1E),
      child: Column(
        children: [
          const SizedBox(height: 40),
          const Text(
            'PORTFOLIO ADMIN',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 40),
          _SidebarItem(
            title: 'Dashboard',
            icon: Icons.dashboard_outlined,
            route: '/admin',
            isActive: currentRoute == '/admin',
          ),
          _SidebarItem(
            title: 'Projects',
            icon: Icons.code,
            route: '/admin/projects',
            isActive: currentRoute.startsWith('/admin/projects'),
          ),
          _SidebarItem(
            title: 'Treks',
            icon: Icons.landscape_outlined,
            route: '/admin/treks',
            isActive: currentRoute.startsWith('/admin/treks'),
          ),
          _SidebarItem(
            title: 'Diary Posts',
            icon: Icons.book_outlined,
            route: '/admin/diary',
            isActive: currentRoute.startsWith('/admin/diary'),
          ),
          const Spacer(),
          _SidebarItem(
            title: 'View Site',
            icon: Icons.launch,
            route: '/',
            isActive: false,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _SidebarItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final String route;
  final bool isActive;

  const _SidebarItem({
    required this.title,
    required this.icon,
    required this.route,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: ListTile(
        onTap: () => context.go(route),
        leading: Icon(icon, color: isActive ? Colors.blue : Colors.grey),
        title: Text(
          title,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.grey,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        tileColor: isActive ? Colors.blue.withOpacity(0.1) : Colors.transparent,
      ),
    );
  }
}

class AdminTopbar extends StatelessWidget {
  const AdminTopbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.05))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const Text('Admin User', style: TextStyle(color: Colors.white70)),
          const SizedBox(width: 16),
          CircleAvatar(
            backgroundColor: Colors.blue.withOpacity(0.2),
            child: const Icon(Icons.person, color: Colors.blue),
          ),
        ],
      ),
    );
  }
}
