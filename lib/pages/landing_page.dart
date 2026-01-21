import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:payroute_desktop/nav.dart';
import 'package:payroute_desktop/theme.dart';
import 'package:payroute_desktop/widgets/hero_section.dart';
import 'package:payroute_desktop/widgets/reliability_section.dart';
import 'package:payroute_desktop/widgets/savings_section.dart';
import 'package:payroute_desktop/widgets/global_reach_section.dart';
import 'package:payroute_desktop/widgets/scroll_indicator.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() => _currentPage = page);
  }

  void _scrollToPage(int page) {
    _pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Keep a dark base so we never flash a light canvas between sections.
      backgroundColor: PayRouteColors.noirBg,
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            scrollDirection: Axis.vertical,
            onPageChanged: _onPageChanged,
            children: [
              HeroSection(onGetStarted: () => context.go(AppRoutes.login)),
              const ReliabilitySection(),
              const SavingsSection(),
              const GlobalReachSection(),
            ],
          ),
          // Scroll indicator
          Positioned(
            right: 16,
            top: 0,
            bottom: 0,
            child: Center(
              child: ScrollIndicator(
                totalPages: 4,
                currentPage: _currentPage,
                onTap: _scrollToPage,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
