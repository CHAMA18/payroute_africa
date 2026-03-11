import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:payroute_desktop/theme.dart';
import 'package:payroute_desktop/widgets/finroute_responsive_scaffold.dart';

/// Smart Send page - Route Analysis and Optimization
class SmartSendPage extends StatefulWidget {
  const SmartSendPage({super.key});

  @override
  State<SmartSendPage> createState() => _SmartSendPageState();
}

class _SmartSendPageState extends State<SmartSendPage> with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _pathController;
  late Animation<double> _pulseAnimation;
  bool _hasShownSimulation = false;
  
  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1500))..repeat(reverse: true);
    _pathController = AnimationController(vsync: this, duration: const Duration(seconds: 3))..repeat();
    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut));
    
    // Trigger simulation after a short delay
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_hasShownSimulation) {
        _hasShownSimulation = true;
        Future.delayed(const Duration(milliseconds: 800), () {
          if (mounted) _showSendSimulationDialog();
        });
      }
    });
  }

  void _showSendSimulationDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const SmartSendSimulationDialog(),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _pathController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return FinRouteResponsiveScaffold(
      selectedLabel: 'Smart Send',
      mobileTitle: 'Smart Send',
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 800;
          if (isWide) {
            return Row(
              children: [
                Expanded(child: _buildMainContent(context, brightness)),
                _buildRightPanel(context, brightness),
              ],
            );
          }
          return SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 400, child: _buildMainContent(context, brightness)),
                _buildRightPanelMobile(context, brightness),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildRightPanelMobile(BuildContext context, Brightness brightness) {
    final borderColor = brightness == Brightness.dark ? const Color(0xFF2A3441) : Colors.grey.shade200;
    final surfaceColor = brightness == Brightness.dark ? const Color(0xFF151B23) : Colors.grey.shade50;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Route Intelligence', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w700, color: DashboardPalette.textPrimary(brightness))),
          const SizedBox(height: 4),
          Text('Technical comparison of available paths.', style: GoogleFonts.inter(fontSize: 14, color: DashboardPalette.textSecondary(brightness))),
          const SizedBox(height: 16),
          _buildComparisonTable(brightness, surfaceColor, borderColor),
          const SizedBox(height: 16),
          _buildAIInsightCard(brightness),
          const SizedBox(height: 16),
          _buildNetworkLoadCard(brightness, surfaceColor, borderColor),
          const SizedBox(height: 16),
          _buildConfirmButton(),
          const SizedBox(height: 12),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.lock, size: 12, color: DashboardPalette.textSecondary(brightness)),
                const SizedBox(width: 4),
                Text('256-bit Encrypted Transaction', style: GoogleFonts.inter(fontSize: 12, color: DashboardPalette.textSecondary(brightness))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent(BuildContext context, Brightness brightness) {
    return Column(
      children: [
        _buildHeader(context, brightness),
        Expanded(child: _buildRouteVisualization(context, brightness)),
      ],
    );
  }

  Widget _buildHeader(BuildContext context, Brightness brightness) {
    final bgColor = brightness == Brightness.dark ? const Color(0xFF0B0F15).withValues(alpha: 0.8) : Colors.white.withValues(alpha: 0.9);
    final borderColor = brightness == Brightness.dark ? const Color(0xFF2A3441) : Colors.grey.shade200;
    final textMuted = brightness == Brightness.dark ? Colors.grey.shade400 : Colors.grey.shade600;
    
    return Container(
      height: 64,
      decoration: BoxDecoration(
        color: bgColor,
        border: Border(bottom: BorderSide(color: borderColor)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          // Breadcrumbs
          Row(
            children: [
              Text('Transactions', style: GoogleFonts.inter(fontSize: 14, color: textMuted)),
              Icon(Icons.chevron_right, size: 16, color: textMuted),
              Text('#2094', style: GoogleFonts.inter(fontSize: 14, color: textMuted)),
              Icon(Icons.chevron_right, size: 16, color: textMuted),
              Text('Routing Optimization', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: DashboardPalette.textPrimary(brightness))),
            ],
          ),
          const Spacer(),
          // Status
          Text('Last updated: Just now', style: GoogleFonts.inter(fontSize: 12, color: textMuted)),
          const SizedBox(width: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: brightness == Brightness.dark ? const Color(0xFF151B23) : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: borderColor),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedBuilder(
                  animation: _pulseAnimation,
                  builder: (context, child) => Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: Colors.yellow.shade600,
                      shape: BoxShape.circle,
                      boxShadow: [BoxShadow(color: Colors.yellow.withValues(alpha: _pulseAnimation.value * 0.5), blurRadius: 6)],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text('ANALYSIS ACTIVE', style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w600, letterSpacing: 1, color: DashboardPalette.textSecondary(brightness))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRouteVisualization(BuildContext context, Brightness brightness) {
    return Container(
      decoration: BoxDecoration(
        color: brightness == Brightness.dark ? const Color(0xFF0B0F15) : Colors.grey.shade50,
      ),
      child: Stack(
        children: [
          // Grid background
          CustomPaint(painter: _GridPainter(brightness: brightness), size: Size.infinite),
          // Radial gradient overlay
          Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 1.2,
                colors: [PayRouteColors.dashboardPrimary.withValues(alpha: 0.05), Colors.transparent],
              ),
            ),
          ),
          // Route visualization
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 900, maxHeight: 550),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Stack(
                    children: [
                      // Animated path lines
                      CustomPaint(
                        painter: _RoutePathPainter(
                          animation: _pathController,
                          brightness: brightness,
                        ),
                        size: Size(constraints.maxWidth, constraints.maxHeight),
                      ),
                      // Source wallet - left
                      Positioned(
                        left: 0,
                        top: constraints.maxHeight * 0.5 - 60,
                        child: _buildSourceWallet(brightness),
                      ),
                      // Swift Network card - top center
                      Positioned(
                        left: constraints.maxWidth * 0.5 - 130,
                        top: constraints.maxHeight * 0.1,
                        child: _buildSwiftNetworkCard(brightness),
                      ),
                      // Smart Rail card - bottom center (recommended)
                      Positioned(
                        left: constraints.maxWidth * 0.5 - 150,
                        bottom: constraints.maxHeight * 0.05,
                        child: _buildSmartRailCard(brightness),
                      ),
                      // Destination account - right
                      Positioned(
                        right: 0,
                        top: constraints.maxHeight * 0.5 - 60,
                        child: _buildDestinationAccount(brightness),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSourceWallet(Brightness brightness) {
    final bgColor = brightness == Brightness.dark ? const Color(0xFF151B23) : Colors.white;
    final borderColor = brightness == Brightness.dark ? const Color(0xFF2A3441) : Colors.grey.shade300;
    
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor, width: 2),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 20, offset: const Offset(0, 8))],
          ),
          child: Icon(Icons.account_balance_wallet, size: 36, color: DashboardPalette.textPrimary(brightness)),
        ),
        const SizedBox(height: 12),
        Text('USD Wallet', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600, color: DashboardPalette.textPrimary(brightness))),
        Text('\$0.00', style: GoogleFonts.inter(fontSize: 14, color: DashboardPalette.textSecondary(brightness))),
      ],
    );
  }

  Widget _buildSwiftNetworkCard(Brightness brightness) {
    final bgColor = brightness == Brightness.dark ? const Color(0xFF151B23).withValues(alpha: 0.9) : Colors.white.withValues(alpha: 0.95);
    final borderColor = Colors.red.withValues(alpha: 0.3);
    
    return Container(
      width: 260,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.15), blurRadius: 20)],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.red.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text('HIGH FRICTION', style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.red, letterSpacing: 1)),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, color: Colors.red.shade400, size: 20),
              const SizedBox(width: 8),
              Text('Swift Network', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500, color: DashboardPalette.textSecondary(brightness))),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.only(top: 12),
            decoration: BoxDecoration(border: Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.05)))),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Text('COST', style: GoogleFonts.inter(fontSize: 10, color: DashboardPalette.textSecondary(brightness).withValues(alpha: 0.7), letterSpacing: 0.5)),
                      const SizedBox(height: 4),
                      Text('\$25.00', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700, color: DashboardPalette.textPrimary(brightness))),
                    ],
                  ),
                ),
                Container(width: 1, height: 40, color: Colors.white.withValues(alpha: 0.05)),
                Expanded(
                  child: Column(
                    children: [
                      Text('TIME', style: GoogleFonts.inter(fontSize: 10, color: DashboardPalette.textSecondary(brightness).withValues(alpha: 0.7), letterSpacing: 0.5)),
                      const SizedBox(height: 4),
                      Text('~ 3 Days', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.red.shade400)),
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

  Widget _buildSmartRailCard(Brightness brightness) {
    final bgColor = brightness == Brightness.dark ? const Color(0xFF151B23) : Colors.white;
    
    return Column(
      children: [
        // Recommended badge
        AnimatedBuilder(
          animation: _pulseAnimation,
          builder: (context, child) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: PayRouteColors.dashboardPrimary,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(color: PayRouteColors.dashboardPrimary.withValues(alpha: _pulseAnimation.value * 0.6), blurRadius: 15)],
            ),
            child: Text('RECOMMENDED PATH', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white, letterSpacing: 1)),
          ),
        ),
        const SizedBox(height: 12),
        // Main card
        Container(
          width: 300,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: PayRouteColors.dashboardPrimary, width: 2),
            boxShadow: [BoxShadow(color: PayRouteColors.dashboardPrimary.withValues(alpha: 0.15), blurRadius: 50)],
          ),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(color: PayRouteColors.dashboardPrimary.withValues(alpha: 0.05)),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedBuilder(
                    animation: _pulseAnimation,
                    builder: (context, child) => Icon(Icons.bolt, color: PayRouteColors.dashboardPrimary, size: 32),
                  ),
                  const SizedBox(width: 8),
                  Text('Smart Rail', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w700, color: DashboardPalette.textPrimary(brightness))),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.only(top: 16),
                decoration: BoxDecoration(border: Border(top: BorderSide(color: PayRouteColors.dashboardPrimary.withValues(alpha: 0.2)))),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Text('FEE', style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w700, color: PayRouteColors.dashboardPrimary.withValues(alpha: 0.7), letterSpacing: 0.5)),
                          const SizedBox(height: 4),
                          Text('\$20.80', style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.w700, color: DashboardPalette.textPrimary(brightness))),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text('SPEED', style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w700, color: PayRouteColors.dashboardPrimary.withValues(alpha: 0.7), letterSpacing: 0.5)),
                          const SizedBox(height: 4),
                          Text('5m', style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.w700, color: PayRouteColors.dashboardPrimary)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Savings badges
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.trending_down, size: 14, color: Colors.green.shade400),
                  const SizedBox(width: 4),
                  Text('\$4.20 Saved', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.green.shade400)),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: PayRouteColors.dashboardPrimary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: PayRouteColors.dashboardPrimary.withValues(alpha: 0.3)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.fast_forward, size: 14, color: PayRouteColors.dashboardPrimary),
                  const SizedBox(width: 4),
                  Text('2.5h Faster', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: PayRouteColors.dashboardPrimary)),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDestinationAccount(Brightness brightness) {
    final bgColor = brightness == Brightness.dark ? const Color(0xFF151B23) : Colors.white;
    final borderColor = brightness == Brightness.dark ? const Color(0xFF2A3441) : Colors.grey.shade300;
    
    return Column(
      children: [
        Stack(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: bgColor,
                shape: BoxShape.circle,
                border: Border.all(color: borderColor, width: 2),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 20, offset: const Offset(0, 8))],
              ),
              child: Icon(Icons.account_balance, size: 36, color: DashboardPalette.textPrimary(brightness)),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: borderColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: brightness == Brightness.dark ? const Color(0xFF0B0F15) : Colors.white, width: 4),
                ),
                child: Icon(Icons.lock, size: 12, color: DashboardPalette.textPrimary(brightness)),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text('NGN Account', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600, color: DashboardPalette.textPrimary(brightness))),
        Text('**** 8832', style: GoogleFonts.inter(fontSize: 14, color: DashboardPalette.textSecondary(brightness))),
      ],
    );
  }

  Widget _buildRightPanel(BuildContext context, Brightness brightness) {
    final bgColor = brightness == Brightness.dark ? const Color(0xFF0e1217) : Colors.white;
    final borderColor = brightness == Brightness.dark ? const Color(0xFF2A3441) : Colors.grey.shade200;
    final surfaceColor = brightness == Brightness.dark ? const Color(0xFF151B23) : Colors.grey.shade50;
    
    return Container(
      width: 380,
      decoration: BoxDecoration(
        color: bgColor,
        border: Border(left: BorderSide(color: borderColor)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 20)],
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: brightness == Brightness.dark ? const Color(0xFF0B0F15).withValues(alpha: 0.3) : Colors.grey.shade50,
              border: Border(bottom: BorderSide(color: borderColor)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Route Intelligence', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w700, color: DashboardPalette.textPrimary(brightness))),
                const SizedBox(height: 4),
                Text('Technical comparison of available paths.', style: GoogleFonts.inter(fontSize: 14, color: DashboardPalette.textSecondary(brightness))),
              ],
            ),
          ),
          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  _buildComparisonTable(brightness, surfaceColor, borderColor),
                  const SizedBox(height: 24),
                  _buildAIInsightCard(brightness),
                  const SizedBox(height: 16),
                  _buildNetworkLoadCard(brightness, surfaceColor, borderColor),
                ],
              ),
            ),
          ),
          // Bottom action
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: bgColor,
              border: Border(top: BorderSide(color: borderColor)),
            ),
            child: Column(
              children: [
                _buildConfirmButton(),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.lock, size: 12, color: DashboardPalette.textSecondary(brightness).withValues(alpha: 0.7)),
                    const SizedBox(width: 4),
                    Text('256-bit Encrypted Transaction', style: GoogleFonts.inter(fontSize: 12, color: DashboardPalette.textSecondary(brightness).withValues(alpha: 0.7))),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComparisonTable(Brightness brightness, Color surfaceColor, Color borderColor) {
    return Container(
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)],
      ),
      child: Column(
        children: [
          // Header row
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: brightness == Brightness.dark ? const Color(0xFF111418) : Colors.grey.shade100,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
              border: Border(bottom: BorderSide(color: borderColor)),
            ),
            child: Row(
              children: [
                Expanded(child: Text('Metric', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, color: DashboardPalette.textSecondary(brightness), letterSpacing: 0.5))),
                Expanded(child: Text('Default', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, color: DashboardPalette.textSecondary(brightness), letterSpacing: 0.5), textAlign: TextAlign.center)),
                Expanded(child: Text('Smart', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, color: PayRouteColors.dashboardPrimary, letterSpacing: 0.5), textAlign: TextAlign.center)),
              ],
            ),
          ),
          _buildTableRow(brightness, borderColor, Icons.payments, 'Fee', '\$25.00', '\$20.80', false),
          _buildTableRow(brightness, borderColor, Icons.timer, 'Time', '~3 Days', '5 Mins', true, isTimeRow: true),
          _buildTableRow(brightness, borderColor, Icons.verified_user, 'Success', '98.2%', '99.9%', false, isSuccessRow: true),
          _buildTableRow(brightness, borderColor, Icons.hub, 'Hops', '4 Inter.', 'Direct', false, isLast: true),
        ],
      ),
    );
  }

  Widget _buildTableRow(Brightness brightness, Color borderColor, IconData icon, String label, String defaultVal, String smartVal, bool isHighlightedDefault, {bool isTimeRow = false, bool isSuccessRow = false, bool isLast = false}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: isLast ? null : Border(bottom: BorderSide(color: borderColor.withValues(alpha: 0.5))),
      ),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                Icon(icon, size: 16, color: DashboardPalette.textSecondary(brightness).withValues(alpha: 0.7)),
                const SizedBox(width: 8),
                Text(label, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500, color: DashboardPalette.textSecondary(brightness))),
              ],
            ),
          ),
          Expanded(
            child: Text(
              defaultVal,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: isTimeRow ? Colors.red.shade400 : DashboardPalette.textSecondary(brightness),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Text(
              smartVal,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: isTimeRow ? PayRouteColors.dashboardPrimary : (isSuccessRow ? Colors.green.shade400 : DashboardPalette.textPrimary(brightness)),
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAIInsightCard(Brightness brightness) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: PayRouteColors.dashboardPrimary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: PayRouteColors.dashboardPrimary.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, size: 16, color: PayRouteColors.dashboardPrimary),
              const SizedBox(width: 8),
              Text('AI INSIGHT', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: PayRouteColors.dashboardPrimary, letterSpacing: 1)),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'The Smart Rail path bypasses 3 intermediate correspondents, reducing failure risk by 95% and settlement time by 98%.',
            style: GoogleFonts.inter(fontSize: 14, color: DashboardPalette.textSecondary(brightness), height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildNetworkLoadCard(Brightness brightness, Color surfaceColor, Color borderColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Network Load', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, color: DashboardPalette.textSecondary(brightness), letterSpacing: 0.5)),
              Text('Optimal', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.green.shade400)),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: 0.2,
              backgroundColor: borderColor,
              valueColor: AlwaysStoppedAnimation(Colors.green.shade500),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmButton() {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Route confirmed! Processing transaction...', style: GoogleFonts.inter()),
              backgroundColor: PayRouteColors.dashboardPrimary,
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
        child: AnimatedBuilder(
          animation: _pulseAnimation,
          builder: (context, child) => Container(
            width: double.infinity,
            height: 56,
            decoration: BoxDecoration(
              color: PayRouteColors.dashboardPrimary,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: PayRouteColors.dashboardPrimary.withValues(alpha: _pulseAnimation.value * 0.4), blurRadius: 20)],
            ),
            child: Stack(
              children: [
                // Shimmer effect
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: AnimatedBuilder(
                      animation: _pathController,
                      builder: (context, child) => Transform.translate(
                        offset: Offset(-200 + _pathController.value * 600, 0),
                        child: Container(
                          width: 100,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.transparent, Colors.white.withValues(alpha: 0.2), Colors.transparent],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.alt_route, color: Colors.white, size: 24),
                      const SizedBox(width: 12),
                      Text('Switch & Confirm Route', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  final Brightness brightness;
  _GridPainter({required this.brightness});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = (brightness == Brightness.dark ? const Color(0xFF2A3441) : Colors.grey.shade300).withValues(alpha: 0.1)
      ..strokeWidth = 1;

    const gridSize = 40.0;
    for (double x = 0; x < size.width; x += gridSize) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += gridSize) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _RoutePathPainter extends CustomPainter {
  final Animation<double> animation;
  final Brightness brightness;

  _RoutePathPainter({required this.animation, required this.brightness}) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final centerY = size.height * 0.5;
    final startX = 90.0;
    final endX = size.width - 90;
    final midX = size.width / 2;

    // Top path (Swift - dashed, red)
    final topPath = Path()
      ..moveTo(startX, centerY)
      ..cubicTo(startX + 100, centerY, midX - 100, size.height * 0.2, midX, size.height * 0.2)
      ..cubicTo(midX + 100, size.height * 0.2, endX - 100, centerY, endX, centerY);

    final dashedPaint = Paint()
      ..color = const Color(0xFF2A3441)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // Draw dashed line
    final dashPath = Path();
    final metrics = topPath.computeMetrics().first;
    double distance = 0;
    while (distance < metrics.length) {
      final extractPath = metrics.extractPath(distance, distance + 6);
      dashPath.addPath(extractPath, Offset.zero);
      distance += 12;
    }
    canvas.drawPath(dashPath, dashedPaint);

    // Red animated dot on top path
    final redDotPaint = Paint()..color = Colors.red;
    final topPosition = metrics.getTangentForOffset(animation.value * metrics.length)?.position;
    if (topPosition != null) {
      canvas.drawCircle(topPosition, 4, redDotPaint);
    }

    // Bottom path (Smart Rail - solid, blue, glowing)
    final bottomPath = Path()
      ..moveTo(startX, centerY)
      ..cubicTo(startX + 100, centerY, midX - 100, size.height * 0.8, midX, size.height * 0.8)
      ..cubicTo(midX + 100, size.height * 0.8, endX - 100, centerY, endX, centerY);

    // Glow effect
    final glowPaint = Paint()
      ..color = PayRouteColors.dashboardPrimary.withValues(alpha: 0.3)
      ..strokeWidth = 8
      ..style = PaintingStyle.stroke
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
    canvas.drawPath(bottomPath, glowPaint);

    // Main blue line
    final bluePaint = Paint()
      ..color = PayRouteColors.dashboardPrimary
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;
    canvas.drawPath(bottomPath, bluePaint);

    // White animated dot on bottom path
    final bottomMetrics = bottomPath.computeMetrics().first;
    final bottomPosition = bottomMetrics.getTangentForOffset(animation.value * bottomMetrics.length)?.position;
    if (bottomPosition != null) {
      final whiteDotPaint = Paint()..color = Colors.white;
      final whiteDotGlow = Paint()
        ..color = PayRouteColors.dashboardPrimary
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
      canvas.drawCircle(bottomPosition, 7, whiteDotGlow);
      canvas.drawCircle(bottomPosition, 5, whiteDotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _RoutePathPainter oldDelegate) => true;
}

/// Simulation Dialog for Smart Send Process
class SmartSendSimulationDialog extends StatefulWidget {
  const SmartSendSimulationDialog({super.key});

  @override
  State<SmartSendSimulationDialog> createState() => _SmartSendSimulationDialogState();
}

class _SmartSendSimulationDialogState extends State<SmartSendSimulationDialog> with TickerProviderStateMixin {
  int _currentStep = 0;
  bool _isProcessing = false;
  bool _isComplete = false;
  late AnimationController _progressController;
  late AnimationController _pulseController;
  Timer? _stepTimer;

  // Simulated contact data
  final Map<String, dynamic> _contact = {
    'name': 'Sarah Johnson',
    'email': 'sarah.johnson@techcorp.com',
    'accountNumber': '****8832',
    'bank': 'First National Bank',
    'country': 'Nigeria',
    'currency': 'NGN',
    'avatar': 'SJ',
  };

  final double _sendAmount = 0.00;
  final String _sendCurrency = 'USD';
  final double _receiveAmount = 0.00;
  final String _receiveCurrency = 'NGN';
  final double _fee = 20.80;
  final String _estimatedTime = '~5 minutes';

  final List<Map<String, dynamic>> _steps = [
    {'title': 'Verifying recipient', 'subtitle': 'Checking account details...', 'icon': Icons.person_search},
    {'title': 'Analyzing routes', 'subtitle': 'Finding optimal path...', 'icon': Icons.alt_route},
    {'title': 'Securing transaction', 'subtitle': 'Encrypting data...', 'icon': Icons.lock},
    {'title': 'Processing transfer', 'subtitle': 'Sending funds...', 'icon': Icons.send},
    {'title': 'Confirming delivery', 'subtitle': 'Verifying receipt...', 'icon': Icons.check_circle},
  ];

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _pulseController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000))..repeat(reverse: true);
  }

  @override
  void dispose() {
    _progressController.dispose();
    _pulseController.dispose();
    _stepTimer?.cancel();
    super.dispose();
  }

  void _startSending() {
    setState(() {
      _isProcessing = true;
      _currentStep = 0;
    });
    _progressController.forward();
    _processNextStep();
  }

  void _processNextStep() {
    if (_currentStep < _steps.length - 1) {
      _stepTimer = Timer(Duration(milliseconds: 800 + math.Random().nextInt(600)), () {
        if (mounted) {
          setState(() => _currentStep++);
          _processNextStep();
        }
      });
    } else {
      _stepTimer = Timer(const Duration(milliseconds: 1000), () {
        if (mounted) {
          setState(() => _isComplete = true);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final bgColor = brightness == Brightness.dark ? const Color(0xFF151B23) : Colors.white;
    final borderColor = brightness == Brightness.dark ? const Color(0xFF2A3441) : Colors.grey.shade200;

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 440,
        constraints: const BoxConstraints(maxHeight: 680),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: borderColor),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.3), blurRadius: 40, offset: const Offset(0, 20))],
        ),
        child: _isComplete
            ? _buildSuccessView(brightness)
            : _isProcessing
                ? _buildProcessingView(brightness)
                : _buildInitialView(brightness, borderColor),
      ),
    );
  }

  Widget _buildInitialView(Brightness brightness, Color borderColor) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(brightness, borderColor),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                _buildContactCard(brightness, borderColor),
                const SizedBox(height: 20),
                _buildTransferDetails(brightness, borderColor),
                const SizedBox(height: 20),
                _buildRouteInfo(brightness),
                const SizedBox(height: 24),
                _buildActionButtons(brightness),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(Brightness brightness, Color borderColor) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: PayRouteColors.dashboardPrimary.withValues(alpha: 0.05),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: Border(bottom: BorderSide(color: borderColor)),
      ),
      child: Row(
        children: [
          AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) => Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: PayRouteColors.dashboardPrimary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: PayRouteColors.dashboardPrimary.withValues(alpha: _pulseController.value * 0.3), blurRadius: 12)],
              ),
              child: const Icon(Icons.bolt, color: PayRouteColors.dashboardPrimary, size: 28),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Smart Send', style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w700, color: DashboardPalette.textPrimary(brightness))),
                Text('AI-optimized transfer ready', style: GoogleFonts.inter(fontSize: 14, color: PayRouteColors.dashboardPrimary)),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.close, color: DashboardPalette.textSecondary(brightness)),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  Widget _buildContactCard(Brightness brightness, Color borderColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: brightness == Brightness.dark ? const Color(0xFF1A2029) : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [PayRouteColors.dashboardPrimary, PayRouteColors.dashboardPrimary.withValues(alpha: 0.7)]),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(
              child: Text(_contact['avatar'], style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white)),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(_contact['name'], style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600, color: DashboardPalette.textPrimary(brightness))),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.green.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text('Verified', style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w600, color: Colors.green)),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(_contact['email'], style: GoogleFonts.inter(fontSize: 13, color: DashboardPalette.textSecondary(brightness))),
                const SizedBox(height: 2),
                Text('${_contact['bank']} • ${_contact['accountNumber']}', style: GoogleFonts.inter(fontSize: 13, color: DashboardPalette.textSecondary(brightness))),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: brightness == Brightness.dark ? const Color(0xFF0B0F15) : Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text('🇳🇬', style: const TextStyle(fontSize: 24)),
          ),
        ],
      ),
    );
  }

  Widget _buildTransferDetails(Brightness brightness, Color borderColor) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: brightness == Brightness.dark ? const Color(0xFF1A2029) : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        children: [
          _buildAmountRow(
            brightness,
            'You send',
            '\$${_sendAmount.toStringAsFixed(2)}',
            _sendCurrency,
            icon: Icons.arrow_upward,
            iconColor: Colors.orange,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              children: [
                Expanded(child: Container(height: 1, color: borderColor)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: PayRouteColors.dashboardPrimary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.swap_vert, color: PayRouteColors.dashboardPrimary, size: 20),
                  ),
                ),
                Expanded(child: Container(height: 1, color: borderColor)),
              ],
            ),
          ),
          _buildAmountRow(
            brightness,
            'They receive',
            '₦${_receiveAmount.toStringAsFixed(0)}',
            _receiveCurrency,
            icon: Icons.arrow_downward,
            iconColor: Colors.green,
            isReceive: true,
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: brightness == Brightness.dark ? const Color(0xFF0B0F15) : Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.percent, size: 16, color: DashboardPalette.textSecondary(brightness)),
                    const SizedBox(width: 8),
                    Text('Transfer fee', style: GoogleFonts.inter(fontSize: 13, color: DashboardPalette.textSecondary(brightness))),
                  ],
                ),
                Text('\$${_fee.toStringAsFixed(2)}', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: DashboardPalette.textPrimary(brightness))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmountRow(Brightness brightness, String label, String amount, String currency, {required IconData icon, required Color iconColor, bool isReceive = false}) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: GoogleFonts.inter(fontSize: 12, color: DashboardPalette.textSecondary(brightness))),
              const SizedBox(height: 2),
              Text(amount, style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.w700, color: isReceive ? Colors.green : DashboardPalette.textPrimary(brightness))),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: brightness == Brightness.dark ? const Color(0xFF0B0F15) : Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(currency, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: DashboardPalette.textSecondary(brightness))),
        ),
      ],
    );
  }

  Widget _buildRouteInfo(Brightness brightness) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: PayRouteColors.dashboardPrimary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: PayRouteColors.dashboardPrimary.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          const Icon(Icons.bolt, color: PayRouteColors.dashboardPrimary, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Smart Rail Route Selected', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: PayRouteColors.dashboardPrimary)),
                Text('Fastest path • Est. $_estimatedTime', style: GoogleFonts.inter(fontSize: 12, color: DashboardPalette.textSecondary(brightness))),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.green.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.trending_down, size: 14, color: Colors.green.shade400),
                const SizedBox(width: 4),
                Text('\$4.20 saved', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.green.shade400)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(Brightness brightness) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: _startSending,
            style: ElevatedButton.styleFrom(
              backgroundColor: PayRouteColors.dashboardPrimary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              elevation: 0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.send_rounded, size: 20),
                const SizedBox(width: 10),
                Text('Send Now', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel', style: GoogleFonts.inter(fontSize: 14, color: DashboardPalette.textSecondary(brightness))),
        ),
      ],
    );
  }

  Widget _buildProcessingView(Brightness brightness) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 20),
          _buildProcessingAnimation(brightness),
          const SizedBox(height: 32),
          Text('Processing Transfer', style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.w700, color: DashboardPalette.textPrimary(brightness))),
          const SizedBox(height: 8),
          Text('Please wait while we complete your transaction', style: GoogleFonts.inter(fontSize: 14, color: DashboardPalette.textSecondary(brightness)), textAlign: TextAlign.center),
          const SizedBox(height: 40),
          ..._steps.asMap().entries.map((entry) => _buildStepItem(brightness, entry.key, entry.value)),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildProcessingAnimation(Brightness brightness) {
    return Stack(
      alignment: Alignment.center,
      children: [
        AnimatedBuilder(
          animation: _pulseController,
          builder: (context, child) => Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: PayRouteColors.dashboardPrimary.withValues(alpha: 0.2 + _pulseController.value * 0.3), width: 3),
            ),
          ),
        ),
        AnimatedBuilder(
          animation: _pulseController,
          builder: (context, child) => Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: PayRouteColors.dashboardPrimary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
              boxShadow: [BoxShadow(color: PayRouteColors.dashboardPrimary.withValues(alpha: _pulseController.value * 0.4), blurRadius: 30)],
            ),
            child: const Icon(Icons.bolt, color: PayRouteColors.dashboardPrimary, size: 40),
          ),
        ),
      ],
    );
  }

  Widget _buildStepItem(Brightness brightness, int index, Map<String, dynamic> step) {
    final isActive = index == _currentStep;
    final isComplete = index < _currentStep;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isActive
              ? PayRouteColors.dashboardPrimary.withValues(alpha: 0.1)
              : isComplete
                  ? Colors.green.withValues(alpha: 0.05)
                  : (brightness == Brightness.dark ? const Color(0xFF1A2029) : Colors.grey.shade50),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isActive
                ? PayRouteColors.dashboardPrimary.withValues(alpha: 0.5)
                : isComplete
                    ? Colors.green.withValues(alpha: 0.3)
                    : Colors.transparent,
          ),
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: isComplete
                    ? Colors.green
                    : isActive
                        ? PayRouteColors.dashboardPrimary
                        : (brightness == Brightness.dark ? const Color(0xFF2A3441) : Colors.grey.shade300),
                borderRadius: BorderRadius.circular(10),
              ),
              child: isComplete
                  ? const Icon(Icons.check, color: Colors.white, size: 20)
                  : isActive
                      ? AnimatedBuilder(
                          animation: _pulseController,
                          builder: (context, child) => Icon(step['icon'], color: Colors.white.withValues(alpha: 0.7 + _pulseController.value * 0.3), size: 20),
                        )
                      : Icon(step['icon'], color: DashboardPalette.textSecondary(brightness), size: 18),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    step['title'],
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: isActive || isComplete ? FontWeight.w600 : FontWeight.w500,
                      color: isActive || isComplete ? DashboardPalette.textPrimary(brightness) : DashboardPalette.textSecondary(brightness),
                    ),
                  ),
                  if (isActive)
                    Text(step['subtitle'], style: GoogleFonts.inter(fontSize: 12, color: PayRouteColors.dashboardPrimary)),
                ],
              ),
            ),
            if (isActive)
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation(PayRouteColors.dashboardPrimary),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuccessView(Brightness brightness) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 20),
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.green.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.check_circle, color: Colors.green.shade400, size: 60),
          ),
          const SizedBox(height: 24),
          Text('Transfer Complete!', style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.w700, color: DashboardPalette.textPrimary(brightness))),
          const SizedBox(height: 8),
          Text('Your money is on its way to ${_contact['name']}', style: GoogleFonts.inter(fontSize: 15, color: DashboardPalette.textSecondary(brightness)), textAlign: TextAlign.center),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: brightness == Brightness.dark ? const Color(0xFF1A2029) : Colors.grey.shade50,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                _buildSuccessDetail(brightness, 'Amount sent', '\$${_sendAmount.toStringAsFixed(2)} $_sendCurrency'),
                const SizedBox(height: 12),
                _buildSuccessDetail(brightness, 'Recipient receives', '₦${_receiveAmount.toStringAsFixed(0)} $_receiveCurrency'),
                const SizedBox(height: 12),
                _buildSuccessDetail(brightness, 'Transaction ID', '#TXN${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}'),
                const SizedBox(height: 12),
                _buildSuccessDetail(brightness, 'Estimated arrival', _estimatedTime),
              ],
            ),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: PayRouteColors.dashboardPrimary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                elevation: 0,
              ),
              child: Text('Done', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600)),
            ),
          ),
          const SizedBox(height: 12),
          TextButton.icon(
            onPressed: () {},
            icon: Icon(Icons.receipt_long, size: 18, color: PayRouteColors.dashboardPrimary),
            label: Text('View Receipt', style: GoogleFonts.inter(fontSize: 14, color: PayRouteColors.dashboardPrimary)),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildSuccessDetail(Brightness brightness, String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: GoogleFonts.inter(fontSize: 14, color: DashboardPalette.textSecondary(brightness))),
        Text(value, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: DashboardPalette.textPrimary(brightness))),
      ],
    );
  }
}
