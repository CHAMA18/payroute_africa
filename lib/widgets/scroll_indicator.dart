import 'package:flutter/material.dart';
import 'package:payroute_desktop/theme.dart';

class ScrollIndicator extends StatelessWidget {
  final int totalPages;
  final int currentPage;
  final Function(int) onTap;

  const ScrollIndicator({
    super.key,
    required this.totalPages,
    required this.currentPage,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(totalPages, (index) {
        final isActive = index == currentPage;
        return GestureDetector(
          onTap: () => onTap(index),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 6,
            height: isActive ? 24 : 6,
            margin: const EdgeInsets.symmetric(vertical: 6),
            decoration: BoxDecoration(
              color: isActive 
                ? PayRouteColors.vibrantOrange 
                : PayRouteColors.earthClay.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(3),
            ),
          ),
        );
      }),
    );
  }
}
