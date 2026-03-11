import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:payroute_desktop/theme.dart';
import 'package:payroute_desktop/widgets/finroute_responsive_scaffold.dart';

/// ROI Analytics page displaying savings timeline and profitability impact.
class ROIAnalyticsPage extends StatefulWidget {
  const ROIAnalyticsPage({super.key});

  @override
  State<ROIAnalyticsPage> createState() => _ROIAnalyticsPageState();
}

class _ROIAnalyticsPageState extends State<ROIAnalyticsPage> {
  String _selectedPeriod = '6M';
  final List<String> _periods = ['1M', '3M', '6M', 'YTD'];

  @override
  Widget build(BuildContext context) {
    return FinRouteResponsiveScaffold(
      selectedLabel: 'ROI Analytics',
      mobileTitle: 'ROI Analytics',
      mobileSubtitle: 'Savings & profitability impact',
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 1200;
          if (isWide) {
            return Row(
              children: [
                Expanded(child: _buildMainContent(context)),
                _buildRightSidebar(context),
              ],
            );
          }
          return SingleChildScrollView(
            child: Column(
              children: [
                _buildMainContent(context),
                _buildRightSidebar(context, isCompact: true),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMainContent(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final textPrimary = DashboardPalette.textPrimary(brightness);
    final textSecondary = DashboardPalette.textSecondary(brightness);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(context),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Savings Timeline',
                            style: GoogleFonts.inter(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: textPrimary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Visualize cumulative cost reduction achieved through intelligent routing logic versus standard provider fees.',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 24),
                    Row(
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: PayRouteColors.vibrantOrange,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: PayRouteColors.vibrantOrange.withValues(alpha: 0.5),
                                blurRadius: 8,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'LIVE CALCULATION',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: PayRouteColors.vibrantOrange,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Expanded(child: _buildSavingsChart(context)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final bgColor = brightness == Brightness.dark 
        ? const Color(0xFF0B0F15).withValues(alpha: 0.9) 
        : Colors.white.withValues(alpha: 0.9);
    final borderColor = DashboardPalette.border(brightness);
    final textPrimary = DashboardPalette.textPrimary(brightness);
    final textSecondary = DashboardPalette.textSecondary(brightness);

    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: bgColor,
        border: Border(bottom: BorderSide(color: borderColor)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text('Analytics', style: GoogleFonts.inter(fontSize: 14, color: textSecondary)),
              const SizedBox(width: 8),
              Icon(Icons.chevron_right, size: 14, color: textSecondary),
              const SizedBox(width: 8),
              Text('ROI Impact Engine', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500, color: textPrimary)),
            ],
          ),
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: brightness == Brightness.dark ? const Color(0xFF151B23) : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: borderColor),
                ),
                padding: const EdgeInsets.all(4),
                child: Row(
                  children: _periods.map((period) {
                    final isSelected = period == _selectedPeriod;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedPeriod = period),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: isSelected 
                              ? (brightness == Brightness.dark ? const Color(0xFF2A3441) : Colors.white) 
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(6),
                          boxShadow: isSelected 
                              ? [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 4)] 
                              : null,
                        ),
                        child: Text(
                          period,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: isSelected ? textPrimary : textSecondary,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(width: 16),
              Container(width: 1, height: 24, color: borderColor),
              const SizedBox(width: 16),
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 18, color: textSecondary),
                  const SizedBox(width: 8),
                  Text(
                    'Oct 2023 - Mar 2024',
                    style: GoogleFonts.inter(fontSize: 14, color: textSecondary),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSavingsChart(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final surfaceColor = brightness == Brightness.dark 
        ? const Color(0xFF151B23).withValues(alpha: 0.5) 
        : Colors.grey.shade50;
    final borderColor = DashboardPalette.border(brightness);
    final textSecondary = DashboardPalette.textSecondary(brightness);

    return Container(
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: brightness == Brightness.dark ? 0.3 : 0.08),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Grid lines
          _buildGridLines(context),
          // Chart
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 32, 16, 48),
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: false),
                titlesData: const FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                lineTouchData: LineTouchData(
                  enabled: true,
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipColor: (spot) => const Color(0xFF1c242f),
                    tooltipRoundedRadius: 12,
                    tooltipPadding: const EdgeInsets.all(16),
                    getTooltipItems: (spots) => spots.map((spot) {
                      return LineTooltipItem(
                        'Daily Savings\n\$${(spot.y * 100).toStringAsFixed(0)}',
                        GoogleFonts.inter(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      );
                    }).toList(),
                  ),
                ),
                minX: 0,
                maxX: 5,
                minY: 0,
                maxY: 5,
                lineBarsData: [
                  // Projected spend (legacy) - dashed line
                  LineChartBarData(
                    spots: const [
                      FlSpot(0, 0.5),
                      FlSpot(1, 0.8),
                      FlSpot(2, 1.2),
                      FlSpot(3, 2.0),
                      FlSpot(4, 2.8),
                      FlSpot(5, 3.5),
                    ],
                    isCurved: true,
                    color: const Color(0xFF2A3441),
                    barWidth: 2,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                    dashArray: [8, 8],
                  ),
                  // Optimized savings line
                  LineChartBarData(
                    spots: const [
                      FlSpot(0, 0.5),
                      FlSpot(1, 0.6),
                      FlSpot(2, 1.0),
                      FlSpot(3, 2.0),
                      FlSpot(4, 3.5),
                      FlSpot(5, 4.5),
                    ],
                    isCurved: true,
                    gradient: const LinearGradient(
                      colors: [PayRouteColors.vibrantOrange, Color(0xFFFBBF24)],
                    ),
                    barWidth: 4,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          PayRouteColors.vibrantOrange.withValues(alpha: 0.3),
                          PayRouteColors.vibrantOrange.withValues(alpha: 0.0),
                        ],
                      ),
                    ),
                    shadow: Shadow(
                      color: PayRouteColors.vibrantOrange.withValues(alpha: 0.5),
                      blurRadius: 8,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Tooltip marker
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            bottom: 48,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final markerPosition = constraints.maxWidth * 0.7;
                return Stack(
                  children: [
                    Positioned(
                      left: markerPosition,
                      top: 0,
                      bottom: 0,
                      child: Container(
                        width: 1,
                        color: PayRouteColors.vibrantOrange.withValues(alpha: 0.5),
                      ),
                    ),
                    Positioned(
                      left: markerPosition - 24,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: PayRouteColors.vibrantOrange,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'MAR 14',
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: markerPosition - 8,
                      top: constraints.maxHeight * 0.35,
                      child: Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: brightness == Brightness.dark ? const Color(0xFF0B0F15) : Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: PayRouteColors.vibrantOrange, width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: PayRouteColors.vibrantOrange.withValues(alpha: 0.8),
                              blurRadius: 15,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      left: markerPosition + 16,
                      top: constraints.maxHeight * 0.25,
                      child: _buildDailyImpactTooltip(context),
                    ),
                  ],
                );
              },
            ),
          ),
          // Bottom labels
          Positioned(
            left: 24,
            right: 24,
            bottom: 12,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: ['Oct 1', 'Nov 1', 'Dec 1', 'Jan 1', 'Feb 1', 'Mar 1'].map((label) {
                final isHighlighted = label == 'Mar 1';
                return Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: isHighlighted ? DashboardPalette.textPrimary(brightness) : textSecondary,
                    letterSpacing: 1,
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridLines(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final lineColor = brightness == Brightness.dark 
        ? Colors.white.withValues(alpha: 0.05) 
        : Colors.black.withValues(alpha: 0.05);

    return Positioned.fill(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 32, 0, 48),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(5, (index) => Container(
            height: 1,
            color: lineColor,
          )),
        ),
      ),
    );
  }

  Widget _buildDailyImpactTooltip(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final cardColor = brightness == Brightness.dark 
        ? const Color(0xFF1c242f) 
        : Colors.white;
    final borderColor = DashboardPalette.border(brightness);
    final textPrimary = DashboardPalette.textPrimary(brightness);
    final textSecondary = DashboardPalette.textSecondary(brightness);

    return Container(
      width: 220,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: brightness == Brightness.dark ? 0.4 : 0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Daily Impact',
                style: GoogleFonts.inter(fontSize: 12, color: textSecondary, fontWeight: FontWeight.w500),
              ),
              Text(
                '+18.2% vs Baseline',
                style: GoogleFonts.inter(fontSize: 11, color: PayRouteColors.vibrantOrange, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Divider(height: 1, color: borderColor),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(width: 8, height: 8, decoration: BoxDecoration(color: Colors.red.withValues(alpha: 0.5), shape: BoxShape.circle)),
                  const SizedBox(width: 8),
                  Text('Legacy Cost', style: GoogleFonts.inter(fontSize: 12, color: textSecondary)),
                ],
              ),
              Text('\$4,250.00', style: GoogleFonts.inter(fontSize: 13, color: textSecondary, decoration: TextDecoration.lineThrough)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(width: 8, height: 8, decoration: BoxDecoration(color: PayRouteColors.vibrantOrange, shape: BoxShape.circle)),
                  const SizedBox(width: 8),
                  Text('Optimized', style: GoogleFonts.inter(fontSize: 12, color: textPrimary, fontWeight: FontWeight.w500)),
                ],
              ),
              Text('\$845.00', style: GoogleFonts.inter(fontSize: 13, color: textPrimary, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 12),
          Divider(height: 1, color: borderColor),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('NET SAVED', style: GoogleFonts.inter(fontSize: 10, color: PayRouteColors.vibrantOrange, fontWeight: FontWeight.bold, letterSpacing: 1)),
              Text(
                '\$3,405.00',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  color: PayRouteColors.vibrantOrange,
                  fontWeight: FontWeight.bold,
                  shadows: [Shadow(color: PayRouteColors.vibrantOrange.withValues(alpha: 0.4), blurRadius: 10)],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRightSidebar(BuildContext context, {bool isCompact = false}) {
    final brightness = Theme.of(context).brightness;
    final bgColor = brightness == Brightness.dark ? const Color(0xFF0e1217) : Colors.white;
    final borderColor = DashboardPalette.border(brightness);
    final textPrimary = DashboardPalette.textPrimary(brightness);
    final textSecondary = DashboardPalette.textSecondary(brightness);

    final content = Column(
      children: [
        // Header
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: borderColor)),
            color: brightness == Brightness.dark ? const Color(0xFF0B0F15).withValues(alpha: 0.3) : Colors.grey.shade50,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Profitability Impact', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: textPrimary)),
              const SizedBox(height: 4),
              Text('Contribution to bottom line metrics.', style: GoogleFonts.inter(fontSize: 13, color: textSecondary)),
            ],
          ),
        ),
        // Content
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                _buildTotalSavings(context),
                const SizedBox(height: 32),
                _buildCostComparison(context),
                const SizedBox(height: 32),
                _buildSavingsSource(context),
              ],
            ),
          ),
        ),
        // Download button
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            border: Border(top: BorderSide(color: borderColor)),
            color: bgColor,
          ),
          child: Column(
            children: [
              _buildDownloadButton(context),
              const SizedBox(height: 12),
              Text(
                'Generated using ISO 20022 compliant data models.',
                style: GoogleFonts.inter(fontSize: 10, color: textSecondary.withValues(alpha: 0.6)),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );

    if (isCompact) {
      return Container(
        decoration: BoxDecoration(
          color: bgColor,
          border: Border(top: BorderSide(color: borderColor)),
        ),
        height: 600,
        child: content,
      );
    }

    return Container(
      width: 340,
      decoration: BoxDecoration(
        color: bgColor,
        border: Border(left: BorderSide(color: borderColor)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: brightness == Brightness.dark ? 0.3 : 0.05),
            blurRadius: 20,
            offset: const Offset(-4, 0),
          ),
        ],
      ),
      child: content,
    );
  }

  Widget _buildTotalSavings(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final textPrimary = DashboardPalette.textPrimary(brightness);
    final textSecondary = DashboardPalette.textSecondary(brightness);

    return Stack(
      children: [
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              color: PayRouteColors.vibrantOrange.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(100),
            ),
          ),
        ),
        Column(
          children: [
            Text(
              'TOTAL REALIZED SAVINGS',
              style: GoogleFonts.inter(fontSize: 11, color: textSecondary, fontWeight: FontWeight.w500, letterSpacing: 1.5),
            ),
            const SizedBox(height: 8),
            Text(
              '\$142,890',
              style: GoogleFonts.inter(fontSize: 44, fontWeight: FontWeight.bold, color: textPrimary, letterSpacing: -1),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF22C55E).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: const Color(0xFF22C55E).withValues(alpha: 0.2)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.trending_up, size: 14, color: Color(0xFF22C55E)),
                      const SizedBox(width: 4),
                      Text('+12.4% Margin', style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF22C55E), fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Text('Since Oct 1, 2023', style: GoogleFonts.inter(fontSize: 11, color: textSecondary)),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCostComparison(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final surfaceColor = brightness == Brightness.dark ? const Color(0xFF151B23) : Colors.grey.shade50;
    final borderColor = DashboardPalette.border(brightness);
    final textPrimary = DashboardPalette.textPrimary(brightness);
    final textSecondary = DashboardPalette.textSecondary(brightness);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('COST EFFICIENCY COMPARISON', style: GoogleFonts.inter(fontSize: 10, color: textSecondary, fontWeight: FontWeight.bold, letterSpacing: 1)),
        const SizedBox(height: 16),
        // Baseline cost card
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: surfaceColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: borderColor),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.red.withValues(alpha: 0.2)),
                ),
                child: const Icon(Icons.money_off, color: Colors.red, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Baseline Cost', style: GoogleFonts.inter(fontSize: 11, color: textSecondary)),
                    Text('Standard Routing', style: GoogleFonts.inter(fontSize: 14, color: textPrimary, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('\$2.50', style: GoogleFonts.inter(fontSize: 15, color: Colors.red.shade400, fontWeight: FontWeight.bold)),
                  Text('AVG PER TXN', style: GoogleFonts.inter(fontSize: 9, color: textSecondary, letterSpacing: 0.5)),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        // Optimized cost card
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: PayRouteColors.vibrantOrange.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: PayRouteColors.vibrantOrange.withValues(alpha: 0.3)),
            boxShadow: [
              BoxShadow(
                color: PayRouteColors.vibrantOrange.withValues(alpha: 0.05),
                blurRadius: 20,
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: PayRouteColors.vibrantOrange.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: PayRouteColors.vibrantOrange.withValues(alpha: 0.4)),
                  boxShadow: [
                    BoxShadow(
                      color: PayRouteColors.vibrantOrange.withValues(alpha: 0.3),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: const Icon(Icons.auto_awesome, color: PayRouteColors.vibrantOrange, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('OPTIMIZED', style: GoogleFonts.inter(fontSize: 10, color: PayRouteColors.vibrantOrange.withValues(alpha: 0.8), fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                    Text('Smart Engine', style: GoogleFonts.inter(fontSize: 14, color: textPrimary, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('\$0.45', style: GoogleFonts.inter(fontSize: 15, color: const Color(0xFF22C55E), fontWeight: FontWeight.bold)),
                  Text('AVG PER TXN', style: GoogleFonts.inter(fontSize: 9, color: textSecondary, letterSpacing: 0.5)),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSavingsSource(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final borderColor = DashboardPalette.border(brightness);
    final textPrimary = DashboardPalette.textPrimary(brightness);
    final textSecondary = DashboardPalette.textSecondary(brightness);
    final trackColor = brightness == Brightness.dark ? const Color(0xFF2A3441) : Colors.grey.shade200;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.only(top: 16),
          decoration: BoxDecoration(border: Border(top: BorderSide(color: borderColor))),
          child: Text('SAVINGS SOURCE', style: GoogleFonts.inter(fontSize: 10, color: textSecondary, fontWeight: FontWeight.bold, letterSpacing: 1)),
        ),
        const SizedBox(height: 16),
        _buildProgressItem('FX Spreads', 65, PayRouteColors.vibrantOrange, textPrimary, textSecondary, trackColor),
        const SizedBox(height: 16),
        _buildProgressItem('Network Fees', 25, const Color(0xFF258CF4), textPrimary, textSecondary, trackColor),
        const SizedBox(height: 16),
        _buildProgressItem('Failures Avoided', 10, const Color(0xFF22C55E), textPrimary, textSecondary, trackColor),
      ],
    );
  }

  Widget _buildProgressItem(String label, int percentage, Color color, Color textPrimary, Color textSecondary, Color trackColor) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: GoogleFonts.inter(fontSize: 12, color: textSecondary)),
            Text('$percentage%', style: GoogleFonts.inter(fontSize: 12, color: textPrimary, fontWeight: FontWeight.w500)),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: percentage / 100,
            backgroundColor: trackColor,
            valueColor: AlwaysStoppedAnimation(color),
            minHeight: 6,
          ),
        ),
      ],
    );
  }

  Widget _buildDownloadButton(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 52,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFEA580C), PayRouteColors.vibrantOrange],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFEA580C).withValues(alpha: 0.4),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.download, color: Colors.white, size: 18),
              const SizedBox(width: 10),
              Text(
                'Download Executive Report',
                style: GoogleFonts.inter(fontSize: 13, color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 0.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
