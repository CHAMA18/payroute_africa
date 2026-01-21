import 'package:flutter/material.dart';
import 'package:payroute_desktop/theme.dart';
import 'package:payroute_desktop/widgets/hero_themed_section_scaffold.dart';

class ReliabilitySection extends StatelessWidget {
  const ReliabilitySection({super.key});

  @override
  Widget build(BuildContext context) {
    return HeroThemedSectionScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 64,
            height: 4,
            decoration: BoxDecoration(color: PayRouteColors.electricBlue, borderRadius: BorderRadius.circular(2)),
          ),
          const SizedBox(height: 32),
          Text(
            'UNMATCHED',
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
              color: PayRouteColors.white,
              fontWeight: FontWeight.w900,
              letterSpacing: -1,
              height: 0.9,
            ),
          ),
          Text(
            'RELIABILITY',
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
              color: PayRouteColors.white,
              fontWeight: FontWeight.w900,
              letterSpacing: -1,
              height: 0.9,
            ),
          ),
          const SizedBox(height: 24),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.35),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: PayRouteColors.white.withValues(alpha: 0.12)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.verified_user, color: PayRouteColors.electricBlue, size: 36),
                      const SizedBox(width: 16),
                      Text(
                        '99.9%',
                        style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          color: PayRouteColors.white,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Our multi-rail system ensures that your payments never fail. If one path closes, three more open instantly.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: PayRouteColors.white.withValues(alpha: 0.78),
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              _buildCity(context, 'Lagos'),
              _buildDot(),
              _buildCity(context, 'Nairobi'),
              _buildDot(),
              _buildCity(context, 'Accra'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCity(BuildContext context, String name) {
    return Text(
      name,
      style: Theme.of(context).textTheme.labelSmall?.copyWith(
        color: PayRouteColors.white.withValues(alpha: 0.6),
        letterSpacing: 2,
      ),
    );
  }

  Widget _buildDot() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Container(
        width: 4,
        height: 4,
        decoration: BoxDecoration(
          color: PayRouteColors.electricBlue,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}
