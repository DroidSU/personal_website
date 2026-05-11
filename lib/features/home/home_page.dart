import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../core/constants/app_constants.dart';
import 'sections/about_section.dart';
import 'sections/diary_section.dart';
import 'sections/footer_section.dart';
import 'sections/hero_section.dart';
import 'sections/projects_section.dart';
import 'sections/treks_section.dart';
import 'widgets/navbar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  bool _isScrolled = false;

  final List<GlobalKey> _sectionKeys = List.generate(6, (index) => GlobalKey());

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.offset > 50 && !_isScrolled) {
      setState(() => _isScrolled = true);
    } else if (_scrollController.offset <= 50 && _isScrolled) {
      setState(() => _isScrolled = false);
    }
  }

  void _scrollToSection(int index) {
    final key = _sectionKeys[index];
    if (key.currentContext != null) {
      Scrollable.ensureVisible(
        key.currentContext!,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Content
          SelectionArea(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: [
                  const SizedBox(height: 100), // Space for Navbar
                  Center(child: HeroSection(key: _sectionKeys[0])),
                  Center(child: _wrapWithReveal(const AboutSection(), _sectionKeys[1])),
                  Center(child: _wrapWithReveal(const ProjectsSection(), _sectionKeys[2])),
                  Center(child: _wrapWithReveal(const TreksSection(), _sectionKeys[3])),
                  Center(child: _wrapWithReveal(const DiarySection(), _sectionKeys[4])),
                  Center(child: FooterSection(key: _sectionKeys[5])),
                ],
              ),
            ),
          ),

          // Navbar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              color: _isScrolled ? AppColors.background.withValues(alpha: 0.9) : Colors.transparent,
              child: Navbar(
                isScrolled: _isScrolled,
                onNavItemTap: _scrollToSection,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _wrapWithReveal(Widget child, Key key) {
    return VisibilityDetector(
      key: key,
      onVisibilityChanged: (info) {},
      child: child,
    );
  }
}
