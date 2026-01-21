import 'package:flutter/material.dart';
import 'package:payroute_desktop/theme.dart';
import 'package:payroute_desktop/widgets/hero_themed_section_scaffold.dart';

class SavingsSection extends StatelessWidget {
  const SavingsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return HeroThemedSectionScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          Text(
            'Pioneering',
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
              color: PayRouteColors.white,
              fontWeight: FontWeight.w900,
              height: 1,
            ),
          ),
          Text(
            'Cost Savings',
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
              color: PayRouteColors.white,
              fontWeight: FontWeight.w900,
              height: 1,
            ),
          ),
          const SizedBox(height: 16),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 340),
            child: Text(
              'Aggregating FX rates across 54 markets to find you the absolute floor.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: PayRouteColors.white.withValues(alpha: 0.75),
                height: 1.5,
              ),
            ),
          ),
          const Spacer(),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.35),
                borderRadius: BorderRadius.circular(32),
                border: Border.all(color: PayRouteColors.white.withValues(alpha: 0.12)),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'STANDARD ROUTE',
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: PayRouteColors.white.withValues(alpha: 0.45),
                              letterSpacing: 2,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '\$42.50 Fee',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: PayRouteColors.white.withValues(alpha: 0.3),
                              decoration: TextDecoration.lineThrough,
                              decorationColor: PayRouteColors.white.withValues(alpha: 0.3),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: PayRouteColors.vibrantOrange.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: const Icon(Icons.trending_down, color: PayRouteColors.vibrantOrange),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(height: 1, color: PayRouteColors.white.withValues(alpha: 0.08)),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'PAYROUTE OPTI',
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: PayRouteColors.electricBlue,
                              letterSpacing: 2,
                            ),
                          ),
                          const SizedBox(height: 4),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: '\$12.80 ',
                                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                    color: PayRouteColors.white,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                TextSpan(
                                  text: 'Fee',
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: PayRouteColors.electricBlue,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: PayRouteColors.electricBlue.withValues(alpha: 0.18),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: PayRouteColors.electricBlue.withValues(alpha: 0.35)),
                        ),
                        child: Text(
                          'SAVED 68%',
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: PayRouteColors.electricBlue,
                            fontSize: 10,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: PayRouteColors.vibrantOrange,
                        foregroundColor: PayRouteColors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Start Saving Now', style: Theme.of(context).textTheme.labelLarge?.copyWith(color: PayRouteColors.white)),
                          const SizedBox(width: 8),
                          const Icon(Icons.bolt, size: 16, color: PayRouteColors.white),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
