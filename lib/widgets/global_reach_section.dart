import 'package:flutter/material.dart';
import 'package:payroute_desktop/theme.dart';
import 'package:payroute_desktop/widgets/hero_themed_section_scaffold.dart';

class GlobalReachSection extends StatelessWidget {
  const GlobalReachSection({super.key});

  @override
  Widget build(BuildContext context) {
    return HeroThemedSectionScaffold(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(width: 32, height: 1, color: PayRouteColors.electricBlue.withValues(alpha: 0.9)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          'INSTANT GLOBAL REACH',
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: PayRouteColors.electricBlue,
                            letterSpacing: 3,
                          ),
                        ),
                      ),
                      Container(width: 32, height: 1, color: PayRouteColors.electricBlue.withValues(alpha: 0.9)),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'One API.',
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      color: PayRouteColors.white,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -1,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'A Whole ',
                          style: Theme.of(context).textTheme.displaySmall?.copyWith(
                            color: PayRouteColors.white,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -1,
                          ),
                        ),
                        TextSpan(
                          text: 'Continent.',
                          style: Theme.of(context).textTheme.displaySmall?.copyWith(
                            color: PayRouteColors.electricBlue,
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.italic,
                            letterSpacing: -1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 360),
                    child: Text(
                      'Connect once, settle everywhere. From M-Pesa in Kenya to GTBank in Nigeria, we\'ve unified the landscape for you.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: PayRouteColors.white.withValues(alpha: 0.72),
                        height: 1.6,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 32),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 320),
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(context, Icons.public, PayRouteColors.electricBlue, '54 Markets', 'Full coverage.'),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildStatCard(context, Icons.speed, PayRouteColors.vibrantOrange, 'Real-time', 'Instant settlements.'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.35),
              border: Border(top: BorderSide(color: PayRouteColors.white.withValues(alpha: 0.12))),
            ),
            padding: const EdgeInsets.all(32),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 24,
                      runSpacing: 12,
                      children: [
                        _buildFooterLink(context, 'About Us'),
                        _buildFooterLink(context, 'Services'),
                        _buildFooterLink(context, 'Contact'),
                        _buildFooterLink(context, 'Privacy Policy'),
                      ],
                    ),
                    Row(
                      children: [
                        _buildSocialButton(Icons.share),
                        const SizedBox(width: 8),
                        _buildSocialButton(Icons.alternate_email),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                Container(
                  padding: const EdgeInsets.only(top: 24),
                  decoration: BoxDecoration(border: Border(top: BorderSide(color: PayRouteColors.white.withValues(alpha: 0.08)))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Opacity(
                        opacity: 0.7,
                        child: Row(
                          children: [
                            Container(
                              width: 16,
                              height: 16,
                              decoration: BoxDecoration(color: PayRouteColors.vibrantOrange, borderRadius: BorderRadius.circular(8)),
                              child: const Icon(Icons.hub, size: 10, color: PayRouteColors.white),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'PAYROUTE',
                              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: PayRouteColors.white,
                                fontSize: 10,
                                letterSpacing: 2,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '© 2024 PAYROUTE INC.',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: PayRouteColors.white.withValues(alpha: 0.45),
                          fontSize: 10,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, IconData icon, Color color, String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: PayRouteColors.white.withValues(alpha: 0.12),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            title,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: PayRouteColors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: PayRouteColors.white.withValues(alpha: 0.55),
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooterLink(BuildContext context, String text) {
    return GestureDetector(
      onTap: () {},
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: PayRouteColors.white.withValues(alpha: 0.7),
        ),
      ),
    );
  }

  Widget _buildSocialButton(IconData icon) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: PayRouteColors.white.withValues(alpha: 0.12)),
      ),
      child: Icon(icon, size: 16, color: PayRouteColors.white.withValues(alpha: 0.75)),
    );
  }
}
