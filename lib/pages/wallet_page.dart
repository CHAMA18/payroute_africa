import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:go_router/go_router.dart';
import 'package:payroute_desktop/nav.dart';
import 'package:payroute_desktop/theme.dart';
import 'package:payroute_desktop/widgets/finroute_responsive_scaffold.dart';
import 'package:payroute_desktop/providers/auth_provider.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({super.key});

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  int _selectedChartPeriod = 1; // 0 = 7 Days, 1 = 30 Days, 2 = All Time

  @override
  Widget build(BuildContext context) {
    final b = Theme.of(context).brightness;

    return FinRouteResponsiveScaffold(
      selectedLabel: 'Wallet',
      background: Container(
        decoration: BoxDecoration(
          color: DashboardPalette.bg(b),
        ),
      ),
      desktopHeader: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Wallets',
              style: GoogleFonts.outfit(
                color: DashboardPalette.textPrimary(b),
                fontSize: 28,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(width: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'GLOBAL VAULT',
                style: GoogleFonts.outfit(
                  color: DashboardPalette.textSecondary(b),
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.0,
                ),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: 90,
              height: 36,
              child: Stack(
                children: [
                  Positioned(
                    right: 48,
                    child: CircleAvatar(
                      radius: 18,
                      backgroundColor: Colors.blueGrey,
                      child: const Icon(Icons.person, size: 20, color: Colors.white),
                    ),
                  ),
                  Positioned(
                    right: 24,
                    child: CircleAvatar(
                      radius: 18,
                      backgroundColor: Colors.teal,
                      child: const Icon(Icons.person_3, size: 20, color: Colors.white),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    child: CircleAvatar(
                      radius: 18,
                      backgroundColor: DashboardPalette.surfaceMuted(b),
                      child: Text(
                        '+4',
                        style: GoogleFonts.outfit(
                          color: DashboardPalette.textPrimary(b),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: DashboardPalette.surface(b),
                border: Border.all(color: DashboardPalette.border(b)),
              ),
              child: Icon(
                Icons.notifications_none,
                color: DashboardPalette.textSecondary(b),
                size: 20,
              ),
            ),
          ],
        ),
      ),
      mobileTitle: 'Wallets',
      mobileSubtitle: 'GLOBAL VAULT',
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 24,
              runSpacing: 24,
              children: [
                _buildQuickAction(
                  context,
                  title: 'Analytics',
                  subtitle: 'Insights & ROI',
                  icon: Icons.analytics_rounded,
                  gradient: const LinearGradient(
                    colors: [PayRouteColors.vibrantGold, PayRouteColors.dashboardAccentOrange],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  onTap: () => context.go(AppRoutes.roiAnalytics),
                ),
                _buildQuickAction(
                  context,
                  title: 'Transaction History',
                  subtitle: 'Recent activity',
                  icon: Icons.receipt_long_rounded,
                  gradient: const LinearGradient(
                    colors: [PayRouteColors.dashboardPrimary, PayRouteColors.dashboardAccentOrange],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  onTap: () => context.go(AppRoutes.activity),
                ),
              ],
            ),
            const SizedBox(height: 32),
            Wrap(
              spacing: 24,
              runSpacing: 24,
              children: [
                _buildWalletCard(
                  context,
                  title: 'ZMW Wallet',
                  subtitle: 'ZAMBIAN KWACHA',
                  balance: 'ZK 145,000.00',
                  changeText: '+2.4%',
                  isPositive: true,
                  flagEmoji: '🇿🇲',
                  chartData: [2, 3, 2, 4, 3, 6],
                  chartColor: PayRouteColors.dashboardPrimary,
                ),
                _buildWalletCard(
                  context,
                  title: 'USD Vault',
                  subtitle: 'US DOLLAR',
                  balance: '\$ 12,450.50',
                  changeText: '+0.1%',
                  isPositive: true,
                  flagEmoji: '🇺🇸',
                  chartData: [1, 2, 3, 4, 3, 5],
                  chartColor: PayRouteColors.dashboardPrimary,
                ),
                _buildWalletCard(
                  context,
                  title: 'KES Settlement',
                  subtitle: 'KENYAN SHILLING',
                  balance: 'KSh 890,200',
                  changeText: '-1.2%',
                  isPositive: false,
                  flagEmoji: '🇰🇪',
                  chartData: [6, 5, 4, 4, 3, 2],
                  chartColor: PayRouteColors.dashboardPrimary,
                ),
                _buildAddCurrencyCard(context),
              ],
            ),
            const SizedBox(height: 48),
            _buildAggregateChartCard(context),
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAction(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Gradient gradient,
    required VoidCallback onTap,
  }) {
    final b = Theme.of(context).brightness;
    final isDark = b == Brightness.dark;
    
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        hoverColor: DashboardPalette.textSecondary(b).withValues(alpha: 0.05),
        child: Container(
          width: 320,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: DashboardPalette.surface(b),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: DashboardPalette.border(b),
            ),
            boxShadow: [
              BoxShadow(
                color: isDark ? Colors.black.withValues(alpha: 0.2) : Colors.black.withValues(alpha: 0.03),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: gradient,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: gradient.colors.first.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(icon, color: Colors.white, size: 24),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.outfit(
                        color: DashboardPalette.textPrimary(b),
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: GoogleFonts.outfit(
                        color: DashboardPalette.textSecondary(b),
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: DashboardPalette.textSecondary(b).withValues(alpha: 0.5),
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWalletCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required String balance,
    required String changeText,
    required bool isPositive,
    required String flagEmoji,
    required List<double> chartData,
    required Color chartColor,
  }) {
    final b = Theme.of(context).brightness;
    return Container(
      width: 320,
      height: 220,
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
      decoration: BoxDecoration(
        color: DashboardPalette.surface(b),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: DashboardPalette.border(b)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: DashboardPalette.surfaceMuted(b),
                child: Text(flagEmoji, style: const TextStyle(fontSize: 18)),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    subtitle.toUpperCase(),
                    style: GoogleFonts.outfit(
                      color: DashboardPalette.textSecondary(b),
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.0,
                    ),
                  ),
                  Text(
                    title,
                    style: GoogleFonts.outfit(
                      color: DashboardPalette.textPrimary(b),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Icon(Icons.more_vert, color: DashboardPalette.iconMuted(b), size: 20),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            balance,
            style: GoogleFonts.outfit(
              color: DashboardPalette.textPrimary(b),
              fontSize: 28,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                isPositive ? Icons.trending_up : Icons.trending_down,
                color: isPositive ? Colors.green : Colors.redAccent,
                size: 14,
              ),
              const SizedBox(width: 4),
              Text(
                changeText,
                style: GoogleFonts.outfit(
                  color: isPositive ? Colors.green : Colors.redAccent,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                'vs last week',
                style: GoogleFonts.outfit(
                  color: DashboardPalette.textSecondary(b),
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const Spacer(),
          _MiniBarChart(data: chartData, color: chartColor),
        ],
      ),
    );
  }

  Widget _buildAddCurrencyCard(BuildContext context) {
    final b = Theme.of(context).brightness;
    final color = DashboardPalette.textSecondary(b);

    return CustomPaint(
      painter: _DashedBorderPainter(
        color: color.withValues(alpha: 0.3),
        borderRadius: 24,
      ),
      child: Container(
        width: 320,
        height: 220,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add, size: 32, color: DashboardPalette.textPrimary(b)),
            const SizedBox(height: 16),
            Text(
              'Add Currency',
              style: GoogleFonts.outfit(
                color: DashboardPalette.textPrimary(b),
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Expand your routing portfolio',
              style: GoogleFonts.outfit(
                color: DashboardPalette.textSecondary(b),
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAggregateChartCard(BuildContext context) {
    final b = Theme.of(context).brightness;
    final primaryColor = PayRouteColors.dashboardPrimary;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: DashboardPalette.surface(b),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: DashboardPalette.border(b)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(32),
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.start,
              alignment: WrapAlignment.spaceBetween,
              spacing: 16,
              runSpacing: 16,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Aggregate Wallet Value',
                      style: GoogleFonts.outfit(
                        color: DashboardPalette.textPrimary(b),
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '\$158,230.40',
                          style: GoogleFonts.outfit(
                            color: DashboardPalette.textPrimary(b),
                            fontSize: 36,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.green.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '+5.2%',
                            style: GoogleFonts.outfit(
                              color: Colors.green,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: DashboardPalette.surfaceMuted(b),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildToggleButton(context, title: '7 Days', index: 0),
                      _buildToggleButton(context, title: '30 Days', index: 1),
                      _buildToggleButton(context, title: 'All Time', index: 2),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 250,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
              child: LineChart(
                LineChartData(
                  gridData: const FlGridData(show: false),
                  titlesData: const FlTitlesData(show: false),
                  borderData: FlBorderData(show: false),
                  lineTouchData: const LineTouchData(enabled: false),
                  minX: 0,
                  maxX: 7,
                  minY: 0,
                  maxY: 4,
                  lineBarsData: [
                    LineChartBarData(
                      spots: const [
                        FlSpot(0, 1),
                        FlSpot(1, 1.8),
                        FlSpot(2, 1.4),
                        FlSpot(3, 3.4),
                        FlSpot(4, 2.0),
                        FlSpot(5, 2.8),
                        FlSpot(6, 2.4),
                        FlSpot(7, 3.8),
                      ],
                      isCurved: true,
                      color: primaryColor,
                      barWidth: 4,
                      isStrokeCapRound: true,
                      dotData: const FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          colors: [
                            primaryColor.withValues(alpha: 0.4),
                            primaryColor.withValues(alpha: 0.0),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleButton(BuildContext context, {required String title, required int index}) {
    final b = Theme.of(context).brightness;
    final isSelected = _selectedChartPeriod == index;
    final primaryColor = PayRouteColors.dashboardPrimary;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedChartPeriod = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          title,
          style: GoogleFonts.outfit(
            color: isSelected ? Colors.white : DashboardPalette.textSecondary(b),
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _MiniBarChart extends StatelessWidget {
  final List<double> data;
  final Color color;

  const _MiniBarChart({required this.data, required this.color});

  @override
  Widget build(BuildContext context) {
    double maxVal = data.isEmpty ? 1 : data.reduce((a, b) => a > b ? a : b);
    if (maxVal == 0) maxVal = 1;

    return SizedBox(
      height: 40,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(data.length, (index) {
          final val = data[index];
          final heightFactor = val / maxVal;
          final opacity = 0.3 + (0.7 * (index / (data.length - 1)));
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2.0),
              child: Container(
                height: 40 * heightFactor,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: opacity),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(2)),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double dashWidth;
  final double dashSpace;
  final double borderRadius;

  _DashedBorderPainter({
    required this.color,
    this.strokeWidth = 2.0,
    this.dashWidth = 6.0,
    this.dashSpace = 6.0,
    this.borderRadius = 0.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(borderRadius),
    );

    Path path = Path()..addRRect(rrect);
    Path dashPath = Path();

    for (ui.PathMetric measurePath in path.computeMetrics()) {
      double distance = 0;
      while (distance < measurePath.length) {
        dashPath.addPath(
          measurePath.extractPath(distance, distance + dashWidth),
          Offset.zero,
        );
        distance += dashWidth + dashSpace;
      }
    }
    canvas.drawPath(dashPath, paint);
  }

  @override
  bool shouldRepaint(covariant _DashedBorderPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.dashWidth != dashWidth ||
        oldDelegate.dashSpace != dashSpace ||
        oldDelegate.borderRadius != borderRadius;
  }
}
