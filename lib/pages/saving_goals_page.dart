import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:payroute_desktop/theme.dart';
import 'package:payroute_desktop/widgets/finroute_responsive_scaffold.dart';

class SavingGoalsPage extends StatefulWidget {
  const SavingGoalsPage({super.key});

  @override
  State<SavingGoalsPage> createState() => _SavingGoalsPageState();
}

class _SavingGoalsPageState extends State<SavingGoalsPage> {
  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;

    return FinRouteResponsiveScaffold(
      selectedLabel: 'Saving Goals',
      mobileTitle: 'Saving Goals',
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(brightness),
            const SizedBox(height: 32),
            _buildOverviewCards(brightness),
            const SizedBox(height: 32),
            Text(
              'Active Goals',
              style: GoogleFonts.outfit(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: DashboardPalette.textPrimary(brightness),
              ),
            ),
            const SizedBox(height: 16),
            _buildGoalsGrid(brightness),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(Brightness brightness) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Saving Goals',
              style: GoogleFonts.outfit(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: DashboardPalette.textPrimary(brightness),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Track and manage your financial milestones.',
              style: GoogleFonts.outfit(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: DashboardPalette.textSecondary(brightness),
              ),
            ),
          ],
        ),
        ElevatedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.add_rounded, size: 20, color: Colors.white),
          label: const Text('New Goal', style: TextStyle(color: Colors.white)),
          style: ElevatedButton.styleFrom(
            backgroundColor: PayRouteColors.dashboardPrimary,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOverviewCards(Brightness brightness) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 600;
        return Flex(
          direction: isWide ? Axis.horizontal : Axis.vertical,
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              flex: isWide ? 1 : 0,
              child: _buildSummaryCard(
                brightness: brightness,
                title: 'Total Saved',
                amount: '\$45,200.00',
                trend: '+12% this month',
                icon: Icons.savings_rounded,
                iconColor: PayRouteColors.dashboardPrimary,
              ),
            ),
            if (isWide) const SizedBox(width: 16) else const SizedBox(height: 16),
            Flexible(
              flex: isWide ? 1 : 0,
              child: _buildSummaryCard(
                brightness: brightness,
                title: 'Monthly Target',
                amount: '\$5,000.00',
                trend: 'On track',
                icon: Icons.track_changes_rounded,
                iconColor: PayRouteColors.vibrantTeal,
              ),
            ),
            if (isWide) const SizedBox(width: 16) else const SizedBox(height: 16),
            Flexible(
              flex: isWide ? 1 : 0,
              child: _buildSummaryCard(
                brightness: brightness,
                title: 'Goals Achieved',
                amount: '3',
                trend: 'Lifetime',
                icon: Icons.emoji_events_rounded,
                iconColor: PayRouteColors.vibrantGold,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSummaryCard({
    required Brightness brightness,
    required String title,
    required String amount,
    required String trend,
    required IconData icon,
    required Color iconColor,
  }) {
    final isDark = brightness == Brightness.dark;
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: DashboardPalette.surface(brightness),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: DashboardPalette.border(brightness).withValues(alpha: isDark ? 0.2 : 0.6),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: DashboardPalette.textSecondary(brightness),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 20, color: iconColor),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            amount,
            style: GoogleFonts.outfit(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: DashboardPalette.textPrimary(brightness),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            trend,
            style: GoogleFonts.outfit(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: trend.contains('+') || trend == 'On track'
                  ? PayRouteColors.vibrantTeal
                  : DashboardPalette.textSecondary(brightness),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGoalsGrid(Brightness brightness) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = 1;
        if (constraints.maxWidth > 1200) {
          crossAxisCount = 3;
        } else if (constraints.maxWidth > 700) {
          crossAxisCount = 2;
        }

        return GridView.count(
          crossAxisCount: crossAxisCount,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 24,
          mainAxisSpacing: 24,
          childAspectRatio: 1.1,
          children: [
            _buildGoalCard(
              brightness: brightness,
              title: 'Emergency Fund',
              target: 20000,
              current: 12500,
              icon: Icons.health_and_safety_rounded,
              color: PayRouteColors.dashboardPrimary,
              deadline: 'Dec 2024',
            ),
            _buildGoalCard(
              brightness: brightness,
              title: 'New Office Equipment',
              target: 8000,
              current: 6400,
              icon: Icons.computer_rounded,
              color: PayRouteColors.vibrantTeal,
              deadline: 'Aug 2024',
            ),
            _buildGoalCard(
              brightness: brightness,
              title: 'Company Retreat',
              target: 15000,
              current: 3000,
              icon: Icons.flight_takeoff_rounded,
              color: PayRouteColors.vibrantGold,
              deadline: 'Mar 2025',
            ),
            _buildGoalCard(
              brightness: brightness,
              title: 'Tax Reserve',
              target: 50000,
              current: 45000,
              icon: Icons.account_balance_rounded,
              color: PayRouteColors.cyanGlow,
              deadline: 'Apr 2025',
            ),
          ],
        );
      },
    );
  }

  Widget _buildGoalCard({
    required Brightness brightness,
    required String title,
    required double target,
    required double current,
    required IconData icon,
    required Color color,
    required String deadline,
  }) {
    final isDark = brightness == Brightness.dark;
    final progress = (current / target).clamp(0.0, 1.0);
    
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: DashboardPalette.surface(brightness),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: DashboardPalette.border(brightness).withValues(alpha: isDark ? 0.2 : 0.6),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: DashboardPalette.surfaceMuted(brightness),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  deadline,
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: DashboardPalette.textSecondary(brightness),
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            title,
            style: GoogleFonts.outfit(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: DashboardPalette.textPrimary(brightness),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '\$${(current).toStringAsFixed(0)}',
                style: GoogleFonts.outfit(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: DashboardPalette.textPrimary(brightness),
                ),
              ),
              const SizedBox(width: 4),
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  '/ \$${(target).toStringAsFixed(0)}',
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: DashboardPalette.textSecondary(brightness),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: DashboardPalette.surfaceMuted(brightness),
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${(progress * 100).toStringAsFixed(1)}% complete',
                style: GoogleFonts.outfit(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: DashboardPalette.textSecondary(brightness),
                ),
              ),
              Text(
                '\$${(target - current).toStringAsFixed(0)} left',
                style: GoogleFonts.outfit(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: DashboardPalette.textSecondary(brightness),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
