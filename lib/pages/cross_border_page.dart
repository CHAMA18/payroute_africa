import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:payroute_desktop/theme.dart';
import 'package:payroute_desktop/nav.dart';
import 'package:payroute_desktop/widgets/finroute_responsive_scaffold.dart';

/// World-class Cross-Border Payments page
class CrossBorderPage extends StatefulWidget {
  const CrossBorderPage({super.key});

  @override
  State<CrossBorderPage> createState() => _CrossBorderPageState();
}

class _CrossBorderPageState extends State<CrossBorderPage> with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _flowController;
  late Animation<double> _pulseAnimation;
  
  String _sourceCurrency = 'USD';
  String _destinationCurrency = 'EUR';
  double _amount = 10000.00;
  String _selectedMethod = 'instant';
  
  final Map<String, double> _exchangeRates = {
    'EUR': 0.92,
    'GBP': 0.79,
    'JPY': 149.50,
    'CAD': 1.36,
    'AUD': 1.53,
    'CHF': 0.88,
    'CNY': 7.24,
    'INR': 83.12,
    'MXN': 17.15,
    'SGD': 1.34,
  };
  
  final Map<String, Map<String, dynamic>> _corridorData = {
    'EUR': {'name': 'Europe', 'flag': '🇪🇺', 'time': '< 30 sec', 'fee': 0.15},
    'GBP': {'name': 'United Kingdom', 'flag': '🇬🇧', 'time': '< 30 sec', 'fee': 0.12},
    'JPY': {'name': 'Japan', 'flag': '🇯🇵', 'time': '< 2 min', 'fee': 0.25},
    'CAD': {'name': 'Canada', 'flag': '🇨🇦', 'time': '< 30 sec', 'fee': 0.10},
    'AUD': {'name': 'Australia', 'flag': '🇦🇺', 'time': '< 1 min', 'fee': 0.18},
    'CHF': {'name': 'Switzerland', 'flag': '🇨🇭', 'time': '< 30 sec', 'fee': 0.20},
    'CNY': {'name': 'China', 'flag': '🇨🇳', 'time': '< 5 min', 'fee': 0.35},
    'INR': {'name': 'India', 'flag': '🇮🇳', 'time': '< 2 min', 'fee': 0.22},
    'MXN': {'name': 'Mexico', 'flag': '🇲🇽', 'time': '< 1 min', 'fee': 0.15},
    'SGD': {'name': 'Singapore', 'flag': '🇸🇬', 'time': '< 30 sec', 'fee': 0.12},
  };
  
  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);
    
    _flowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
    
    _pulseAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }
  
  @override
  void dispose() {
    _pulseController.dispose();
    _flowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    
    return FinRouteResponsiveScaffold(
      selectedLabel: 'Cross-Border',
      mobileTitle: 'Cross-Border',
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 900;
          
          if (isWide) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: _buildMainContent(context, brightness),
                ),
                Container(
                  width: 380,
                  decoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(
                        color: brightness == Brightness.dark
                            ? const Color(0xFF2A3441)
                            : Colors.grey.shade200,
                      ),
                    ),
                  ),
                  child: _buildRightPanel(context, brightness),
                ),
              ],
            );
          }
          
          return SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 32),
            child: Column(
              children: [
                _buildMainContent(context, brightness, isMobile: true),
                _buildRightPanel(context, brightness, isMobile: true),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMainContent(BuildContext context, Brightness brightness, {bool isMobile = false}) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(brightness),
          const SizedBox(height: 24),
          _buildQuickActions(brightness, isMobile: isMobile),
          const SizedBox(height: 24),
          _buildTransferCard(brightness, isMobile: isMobile),
          const SizedBox(height: 24),
          _buildCorridorVisualization(brightness, isMobile: isMobile),
          const SizedBox(height: 24),
          _buildTransferMethods(brightness, isMobile: isMobile),
        ],
      ),
    );
  }

  Widget _buildQuickActions(Brightness brightness, {bool isMobile = false}) {
    final actions = [
      _buildQuickActionCard(brightness, 'Smart Send', Icons.bolt_rounded, onTap: () => context.go(AppRoutes.smartSend)),
      _buildQuickActionCard(brightness, 'Payment Links', Icons.link_rounded, onTap: () => context.go(AppRoutes.paymentLinks)),
      _buildQuickActionCard(brightness, 'Scheduled Payments', Icons.schedule_send_rounded),
      _buildQuickActionCard(brightness, 'Bill & Utilities', Icons.receipt_long_rounded),
    ];

    if (isMobile) {
      return Column(
        children: actions.map((action) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: action,
        )).toList(),
      );
    }

    return Row(
      children: [
        Expanded(child: actions[0]),
        const SizedBox(width: 16),
        Expanded(child: actions[1]),
        const SizedBox(width: 16),
        Expanded(child: actions[2]),
        const SizedBox(width: 16),
        Expanded(child: actions[3]),
      ],
    );
  }

  Widget _buildQuickActionCard(Brightness brightness, String title, IconData icon, {VoidCallback? onTap}) {
    final bgColor = brightness == Brightness.dark
        ? const Color(0xFF151B23)
        : Colors.white;
    final borderColor = brightness == Brightness.dark
        ? const Color(0xFF2A3441)
        : Colors.grey.shade200;

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: PayRouteColors.vibrantOrange.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap ?? () {},
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: PayRouteColors.vibrantOrange.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: PayRouteColors.vibrantOrange),
                ),
                const SizedBox(height: 12),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: DashboardPalette.textPrimary(brightness),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(Brightness brightness) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Payments',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: DashboardPalette.textSecondary(brightness),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Icon(
                Icons.chevron_right,
                size: 16,
                color: DashboardPalette.textSecondary(brightness),
              ),
            ),
            Text(
              'Cross-Border',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: PayRouteColors.vibrantOrange,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          'International Transfer',
          style: GoogleFonts.outfit(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: DashboardPalette.textPrimary(brightness),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Send money globally with real-time FX rates and instant settlement',
          style: GoogleFonts.inter(
            fontSize: 15,
            color: DashboardPalette.textSecondary(brightness),
          ),
        ),
      ],
    );
  }

  Widget _buildTransferCard(Brightness brightness, {bool isMobile = false}) {
    final bgColor = brightness == Brightness.dark
        ? const Color(0xFF151B23)
        : Colors.white;
    final borderColor = brightness == Brightness.dark
        ? const Color(0xFF2A3441)
        : Colors.grey.shade200;

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: PayRouteColors.vibrantOrange.withValues(alpha: 0.05),
            blurRadius: 40,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          // Source Currency
          _buildCurrencyInput(
            brightness: brightness,
            label: 'You send',
            currency: _sourceCurrency,
            amount: _amount,
            isSource: true,
            flag: '🇺🇸',
            isMobile: isMobile,
          ),
          
          // Exchange Rate Indicator
          _buildExchangeIndicator(brightness, isMobile: isMobile),
          
          // Destination Currency
          _buildCurrencyInput(
            brightness: brightness,
            label: 'Recipient gets',
            currency: _destinationCurrency,
            amount: _amount * (_exchangeRates[_destinationCurrency] ?? 1),
            isSource: false,
            flag: _corridorData[_destinationCurrency]?['flag'] ?? '🌍',
            isMobile: isMobile,
          ),
        ],
      ),
    );
  }

  Widget _buildCurrencyInput({
    required Brightness brightness,
    required String label,
    required String currency,
    required double amount,
    required bool isSource,
    required String flag,
    bool isMobile = false,
  }) {
    final textColor = DashboardPalette.textPrimary(brightness);
    final mutedColor = DashboardPalette.textSecondary(brightness);
    
    return Padding(
      padding: EdgeInsets.all(isMobile ? 16 : 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: mutedColor,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: isSource
                    ? TextField(
                        style: GoogleFonts.outfit(
                          fontSize: isMobile ? 24 : 32,
                          fontWeight: FontWeight.w600,
                          color: textColor,
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: '0.00',
                          hintStyle: GoogleFonts.outfit(
                            fontSize: isMobile ? 24 : 32,
                            fontWeight: FontWeight.w600,
                            color: mutedColor.withValues(alpha: 0.5),
                          ),
                          prefixText: '\$ ',
                          prefixStyle: GoogleFonts.outfit(
                            fontSize: isMobile ? 24 : 32,
                            fontWeight: FontWeight.w600,
                            color: textColor,
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        controller: TextEditingController(text: amount.toStringAsFixed(2)),
                        onChanged: (value) {
                          setState(() {
                            _amount = double.tryParse(value) ?? 0;
                          });
                        },
                      )
                    : Text(
                        '${_getCurrencySymbol(_destinationCurrency)} ${amount.toStringAsFixed(2)}',
                        style: GoogleFonts.outfit(
                          fontSize: isMobile ? 24 : 32,
                          fontWeight: FontWeight.w600,
                          color: PayRouteColors.vibrantOrange,
                        ),
                      ),
              ),
              const SizedBox(width: 12),
              _buildCurrencySelector(brightness, currency, flag, isSource, isMobile: isMobile),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCurrencySelector(Brightness brightness, String currency, String flag, bool isSource, {bool isMobile = false}) {
    final bgColor = brightness == Brightness.dark
        ? const Color(0xFF1E2530)
        : Colors.grey.shade100;
    
    return PopupMenuButton<String>(
      initialValue: isSource ? _sourceCurrency : _destinationCurrency,
      onSelected: (value) {
        setState(() {
          if (isSource) {
            _sourceCurrency = value;
          } else {
            _destinationCurrency = value;
          }
        });
      },
      itemBuilder: (context) => [
        if (isSource)
          _buildCurrencyMenuItem('USD', '🇺🇸', 'US Dollar'),
        ..._exchangeRates.keys.map((code) => _buildCurrencyMenuItem(
          code,
          _corridorData[code]?['flag'] ?? '🌍',
          _corridorData[code]?['name'] ?? code,
        )),
      ],
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: isMobile ? 12 : 16, vertical: isMobile ? 10 : 12),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(flag, style: TextStyle(fontSize: isMobile ? 16 : 20)),
            const SizedBox(width: 8),
            Text(
              currency,
              style: GoogleFonts.inter(
                fontSize: isMobile ? 14 : 16,
                fontWeight: FontWeight.w600,
                color: DashboardPalette.textPrimary(brightness),
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.keyboard_arrow_down,
              size: isMobile ? 16 : 20,
              color: DashboardPalette.textSecondary(brightness),
            ),
          ],
        ),
      ),
    );
  }

  PopupMenuItem<String> _buildCurrencyMenuItem(String code, String flag, String name) {
    return PopupMenuItem(
      value: code,
      child: Row(
        children: [
          Text(flag, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(code, style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
              Text(name, style: GoogleFonts.inter(fontSize: 12, color: Colors.grey)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildExchangeIndicator(Brightness brightness, {bool isMobile = false}) {
    final borderColor = brightness == Brightness.dark
        ? const Color(0xFF2A3441)
        : Colors.grey.shade200;
    final rate = _exchangeRates[_destinationCurrency] ?? 1;
    
    return Container(
      padding: EdgeInsets.symmetric(vertical: isMobile ? 12 : 16, horizontal: isMobile ? 16 : 0),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: borderColor),
          bottom: BorderSide(color: borderColor),
        ),
      ),
      child: Row(
        mainAxisAlignment: isMobile ? MainAxisAlignment.start : MainAxisAlignment.center,
        children: [
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      PayRouteColors.vibrantOrange.withValues(alpha: _pulseAnimation.value * 0.3),
                      PayRouteColors.vibrantOrangeDark.withValues(alpha: _pulseAnimation.value * 0.3),
                    ],
                  ),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.swap_vert_rounded,
                  color: PayRouteColors.vibrantOrange,
                  size: 24,
                ),
              );
            },
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 8,
                  runSpacing: 4,
                  children: [
                    Text(
                      '1 $_sourceCurrency = $rate $_destinationCurrency',
                      style: GoogleFonts.inter(
                        fontSize: isMobile ? 14 : 15,
                        fontWeight: FontWeight.w600,
                        color: DashboardPalette.textPrimary(brightness),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.green.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.trending_up, size: 12, color: Colors.green),
                          const SizedBox(width: 4),
                          Text(
                            '+0.12%',
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  'Mid-market rate • Updated 2s ago',
                  style: GoogleFonts.inter(
                    fontSize: isMobile ? 11 : 12,
                    color: DashboardPalette.textSecondary(brightness),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCorridorVisualization(Brightness brightness, {bool isMobile = false}) {
    final bgColor = brightness == Brightness.dark
        ? const Color(0xFF151B23)
        : Colors.white;
    final borderColor = brightness == Brightness.dark
        ? const Color(0xFF2A3441)
        : Colors.grey.shade200;
    final corridor = _corridorData[_destinationCurrency]!;

    return Container(
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Transfer Corridor',
                  style: GoogleFonts.outfit(
                    fontSize: isMobile ? 16 : 18,
                    fontWeight: FontWeight.w600,
                    color: DashboardPalette.textPrimary(brightness),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      PayRouteColors.vibrantOrange.withValues(alpha: 0.15),
                      PayRouteColors.vibrantOrangeDark.withValues(alpha: 0.15),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Corridor Active',
                      style: GoogleFonts.inter(
                        fontSize: isMobile ? 10 : 12,
                        fontWeight: FontWeight.w600,
                        color: PayRouteColors.vibrantOrange,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // Animated corridor visualization
          SizedBox(
            height: 120,
            child: AnimatedBuilder(
              animation: _flowController,
              builder: (context, child) {
                return CustomPaint(
                  painter: _CorridorPainter(
                    progress: _flowController.value,
                    brightness: brightness,
                    sourceFlag: '🇺🇸',
                    destFlag: corridor['flag'],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildEndpoint(brightness, '🇺🇸', 'United States', 'Source', isMobile: isMobile),
                      _buildEndpoint(brightness, corridor['flag'], corridor['name'], 'Destination', isMobile: isMobile),
                    ],
                  ),
                );
              },
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Corridor stats
          Row(
            children: [
              Expanded(
                child: _buildCorridorStat(
                  brightness,
                  Icons.speed_rounded,
                  'Est. Time',
                  corridor['time'],
                  isMobile: isMobile,
                ),
              ),
              SizedBox(width: isMobile ? 8 : 16),
              Expanded(
                child: _buildCorridorStat(
                  brightness,
                  Icons.percent_rounded,
                  'Fee',
                  '${corridor['fee']}%',
                  isMobile: isMobile,
                ),
              ),
              SizedBox(width: isMobile ? 8 : 16),
              Expanded(
                child: _buildCorridorStat(
                  brightness,
                  Icons.verified_rounded,
                  isMobile ? 'Cleared' : 'Compliance',
                  'Pre-cleared',
                  isMobile: isMobile,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEndpoint(Brightness brightness, String flag, String name, String label, {bool isMobile = false}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.all(isMobile ? 8 : 12),
          decoration: BoxDecoration(
            color: brightness == Brightness.dark
                ? const Color(0xFF1E2530)
                : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: PayRouteColors.vibrantOrange.withValues(alpha: 0.3),
              width: 2,
            ),
          ),
          child: Text(flag, style: TextStyle(fontSize: isMobile ? 24 : 28)),
        ),
        const SizedBox(height: 8),
        Text(
          name,
          style: GoogleFonts.inter(
            fontSize: isMobile ? 11 : 13,
            fontWeight: FontWeight.w600,
            color: DashboardPalette.textPrimary(brightness),
          ),
          textAlign: TextAlign.center,
        ),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: isMobile ? 10 : 11,
            color: DashboardPalette.textSecondary(brightness),
          ),
        ),
      ],
    );
  }

  Widget _buildCorridorStat(Brightness brightness, IconData icon, String label, String value, {bool isMobile = false}) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 10 : 16),
      decoration: BoxDecoration(
        color: brightness == Brightness.dark
            ? const Color(0xFF1E2530)
            : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: PayRouteColors.vibrantOrange, size: isMobile ? 20 : 24),
          const SizedBox(height: 8),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: GoogleFonts.outfit(
                fontSize: isMobile ? 14 : 16,
                fontWeight: FontWeight.w700,
                color: DashboardPalette.textPrimary(brightness),
              ),
            ),
          ),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              label,
              style: GoogleFonts.inter(
                fontSize: isMobile ? 10 : 12,
                color: DashboardPalette.textSecondary(brightness),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransferMethods(Brightness brightness, {bool isMobile = false}) {
    final bgColor = brightness == Brightness.dark
        ? const Color(0xFF151B23)
        : Colors.white;
    final borderColor = brightness == Brightness.dark
        ? const Color(0xFF2A3441)
        : Colors.grey.shade200;

    return Container(
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Transfer Method',
            style: GoogleFonts.outfit(
              fontSize: isMobile ? 16 : 18,
              fontWeight: FontWeight.w600,
              color: DashboardPalette.textPrimary(brightness),
            ),
          ),
          const SizedBox(height: 16),
          _buildMethodOption(
            brightness,
            'instant',
            'Instant Transfer',
            'Real-time settlement via local rails',
            Icons.bolt_rounded,
            '< 30 seconds',
            true,
            isMobile: isMobile,
          ),
          const SizedBox(height: 12),
          _buildMethodOption(
            brightness,
            'standard',
            'Standard Transfer',
            'SWIFT network processing',
            Icons.schedule_rounded,
            '1-2 business days',
            false,
            isMobile: isMobile,
          ),
          const SizedBox(height: 12),
          _buildMethodOption(
            brightness,
            'batch',
            'Batch Transfer',
            'Optimized for bulk payments',
            Icons.layers_rounded,
            'Next settlement window',
            false,
            isMobile: isMobile,
          ),
        ],
      ),
    );
  }

  Widget _buildMethodOption(
    Brightness brightness,
    String id,
    String title,
    String subtitle,
    IconData icon,
    String time,
    bool recommended, {
    bool isMobile = false,
  }) {
    final isSelected = _selectedMethod == id;
    final bgColor = isSelected
        ? PayRouteColors.vibrantOrange.withValues(alpha: 0.1)
        : (brightness == Brightness.dark ? const Color(0xFF1E2530) : Colors.grey.shade50);
    final borderColor = isSelected
        ? PayRouteColors.vibrantOrange
        : (brightness == Brightness.dark ? const Color(0xFF2A3441) : Colors.grey.shade200);

    return GestureDetector(
      onTap: () => setState(() => _selectedMethod = id),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.all(isMobile ? 12 : 16),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor, width: isSelected ? 2 : 1),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(isMobile ? 10 : 12),
              decoration: BoxDecoration(
                gradient: isSelected
                    ? const LinearGradient(
                        colors: [PayRouteColors.vibrantOrange, PayRouteColors.vibrantOrangeDark],
                      )
                    : null,
                color: isSelected ? null : (brightness == Brightness.dark ? const Color(0xFF2A3441) : Colors.grey.shade200),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: isSelected ? Colors.white : DashboardPalette.textSecondary(brightness),
                size: isMobile ? 20 : 24,
              ),
            ),
            SizedBox(width: isMobile ? 12 : 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 8,
                    runSpacing: 4,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.inter(
                          fontSize: isMobile ? 14 : 15,
                          fontWeight: FontWeight.w600,
                          color: DashboardPalette.textPrimary(brightness),
                        ),
                      ),
                      if (recommended)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [PayRouteColors.vibrantOrange, PayRouteColors.vibrantOrangeDark],
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'RECOMMENDED',
                            style: GoogleFonts.inter(
                              fontSize: isMobile ? 8 : 9,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: GoogleFonts.inter(
                      fontSize: isMobile ? 11 : 13,
                      color: DashboardPalette.textSecondary(brightness),
                    ),
                  ),
                  if (isMobile) ...[
                    const SizedBox(height: 4),
                    Text(
                      time,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: isSelected ? PayRouteColors.vibrantOrange : DashboardPalette.textSecondary(brightness),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (!isMobile) ...[
              Text(
                time,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: isSelected ? PayRouteColors.vibrantOrange : DashboardPalette.textSecondary(brightness),
                ),
              ),
              const SizedBox(width: 8),
            ],
            Container(
              width: isMobile ? 20 : 24,
              height: isMobile ? 20 : 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? PayRouteColors.vibrantOrange : borderColor,
                  width: 2,
                ),
                color: isSelected ? PayRouteColors.vibrantOrange : Colors.transparent,
              ),
              child: isSelected
                  ? Icon(Icons.check, size: isMobile ? 12 : 14, color: Colors.white)
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRightPanel(BuildContext context, Brightness brightness, {bool isMobile = false}) {
    final bgColor = brightness == Brightness.dark
        ? const Color(0xFF0D1117)
        : Colors.grey.shade50;

    return Container(
      color: bgColor,
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSummaryCard(brightness),
          const SizedBox(height: 20),
          _buildComplianceStatus(brightness),
          const SizedBox(height: 20),
          _buildRecentCorridors(brightness),
          const SizedBox(height: 24),
          _buildSendButton(brightness),
          const SizedBox(height: 12),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.lock, size: 12, color: DashboardPalette.textSecondary(brightness)),
                const SizedBox(width: 4),
                Text(
                  'Bank-grade encryption',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: DashboardPalette.textSecondary(brightness),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(Brightness brightness) {
    final bgColor = brightness == Brightness.dark
        ? const Color(0xFF151B23)
        : Colors.white;
    final borderColor = brightness == Brightness.dark
        ? const Color(0xFF2A3441)
        : Colors.grey.shade200;
    final corridor = _corridorData[_destinationCurrency]!;
    final rate = _exchangeRates[_destinationCurrency] ?? 1;
    final convertedAmount = _amount * rate;
    final fee = _amount * (corridor['fee'] / 100);
    final totalAmount = _amount + fee;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Transfer Summary',
            style: GoogleFonts.outfit(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: DashboardPalette.textPrimary(brightness),
            ),
          ),
          const SizedBox(height: 16),
          _buildSummaryRow(brightness, 'Amount', '\$${_amount.toStringAsFixed(2)}'),
          _buildSummaryRow(brightness, 'Fee (${corridor['fee']}%)', '\$${fee.toStringAsFixed(2)}'),
          _buildSummaryRow(brightness, 'Exchange Rate', '1 $_sourceCurrency = $rate $_destinationCurrency'),
          const Divider(height: 24),
          _buildSummaryRow(
            brightness,
            'You pay',
            '\$${totalAmount.toStringAsFixed(2)}',
            isBold: true,
          ),
          const SizedBox(height: 8),
          _buildSummaryRow(
            brightness,
            'Recipient gets',
            '${_getCurrencySymbol(_destinationCurrency)}${convertedAmount.toStringAsFixed(2)}',
            isBold: true,
            isHighlighted: true,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(Brightness brightness, String label, String value, {bool isBold = false, bool isHighlighted = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: isBold ? FontWeight.w600 : FontWeight.w400,
              color: DashboardPalette.textSecondary(brightness),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
                color: isHighlighted
                    ? PayRouteColors.vibrantOrange
                    : DashboardPalette.textPrimary(brightness),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComplianceStatus(Brightness brightness) {
    final bgColor = brightness == Brightness.dark
        ? const Color(0xFF151B23)
        : Colors.white;
    final borderColor = brightness == Brightness.dark
        ? const Color(0xFF2A3441)
        : Colors.grey.shade200;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.verified_user_rounded, color: Colors.green, size: 20),
              const SizedBox(width: 8),
              Text(
                'Compliance Check',
                style: GoogleFonts.outfit(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: DashboardPalette.textPrimary(brightness),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildComplianceItem(brightness, 'AML Screening', true),
          _buildComplianceItem(brightness, 'Sanctions Check', true),
          _buildComplianceItem(brightness, 'KYC Verified', true),
          _buildComplianceItem(brightness, 'Regulatory Approval', true),
        ],
      ),
    );
  }

  Widget _buildComplianceItem(Brightness brightness, String label, bool passed) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: passed ? Colors.green.withValues(alpha: 0.1) : Colors.red.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              passed ? Icons.check : Icons.close,
              size: 14,
              color: passed ? Colors.green : Colors.red,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: DashboardPalette.textPrimary(brightness),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentCorridors(Brightness brightness) {
    final bgColor = brightness == Brightness.dark
        ? const Color(0xFF151B23)
        : Colors.white;
    final borderColor = brightness == Brightness.dark
        ? const Color(0xFF2A3441)
        : Colors.grey.shade200;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Popular Corridors',
            style: GoogleFonts.outfit(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: DashboardPalette.textPrimary(brightness),
            ),
          ),
          const SizedBox(height: 16),
          _buildCorridorItem(brightness, '🇬🇧', 'GBP', 'United Kingdom', 0.79),
          _buildCorridorItem(brightness, '🇪🇺', 'EUR', 'Europe', 0.92),
          _buildCorridorItem(brightness, '🇯🇵', 'JPY', 'Japan', 149.50),
          _buildCorridorItem(brightness, '🇨🇦', 'CAD', 'Canada', 1.36),
        ],
      ),
    );
  }

  Widget _buildCorridorItem(Brightness brightness, String flag, String code, String name, double rate) {
    return GestureDetector(
      onTap: () => setState(() => _destinationCurrency = code),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Text(flag, style: const TextStyle(fontSize: 24)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    code,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: DashboardPalette.textPrimary(brightness),
                    ),
                  ),
                  Text(
                    name,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: DashboardPalette.textSecondary(brightness),
                    ),
                  ),
                ],
              ),
            ),
            Text(
              rate.toString(),
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: PayRouteColors.vibrantOrange,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSendButton(Brightness brightness) {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [PayRouteColors.vibrantOrange, PayRouteColors.vibrantOrangeDark],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: PayRouteColors.vibrantOrange.withValues(alpha: 0.4),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // Handle transfer
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Transfer initiated successfully!',
                  style: GoogleFonts.inter(fontWeight: FontWeight.w500),
                ),
                backgroundColor: Colors.green,
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
          borderRadius: BorderRadius.circular(16),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.send_rounded, color: Colors.white),
                const SizedBox(width: 12),
                Text(
                  'Send Transfer',
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getCurrencySymbol(String currency) {
    const symbols = {
      'USD': '\$',
      'EUR': '€',
      'GBP': '£',
      'JPY': '¥',
      'CAD': 'C\$',
      'AUD': 'A\$',
      'CHF': 'CHF ',
      'CNY': '¥',
      'INR': '₹',
      'MXN': '\$',
      'SGD': 'S\$',
    };
    return symbols[currency] ?? '\$';
  }
}

/// Custom painter for animated corridor visualization
class _CorridorPainter extends CustomPainter {
  final double progress;
  final Brightness brightness;
  final String sourceFlag;
  final String destFlag;

  _CorridorPainter({
    required this.progress,
    required this.brightness,
    required this.sourceFlag,
    required this.destFlag,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // Draw the corridor line
    final startX = 70.0;
    final endX = size.width - 70;
    final centerY = size.height / 2;

    // Background line
    paint.color = brightness == Brightness.dark
        ? const Color(0xFF2A3441)
        : Colors.grey.shade300;
    canvas.drawLine(
      Offset(startX, centerY),
      Offset(endX, centerY),
      paint,
    );

    // Animated gradient line
    final gradient = LinearGradient(
      colors: [
        PayRouteColors.vibrantOrange.withValues(alpha: 0),
        PayRouteColors.vibrantOrange,
        PayRouteColors.vibrantOrangeDark,
        PayRouteColors.vibrantOrange.withValues(alpha: 0),
      ],
      stops: const [0.0, 0.3, 0.7, 1.0],
    );

    final animatedStart = startX + (endX - startX) * progress - 50;
    final animatedEnd = animatedStart + 100;

    paint.shader = gradient.createShader(
      Rect.fromLTRB(animatedStart, centerY - 2, animatedEnd, centerY + 2),
    );
    paint.strokeWidth = 3;

    canvas.drawLine(
      Offset(math.max(startX, animatedStart), centerY),
      Offset(math.min(endX, animatedEnd), centerY),
      paint,
    );

    // Draw animated dots
    final dotPaint = Paint()
      ..color = PayRouteColors.vibrantOrange
      ..style = PaintingStyle.fill;

    final dotX = startX + (endX - startX) * progress;
    canvas.drawCircle(Offset(dotX, centerY), 5, dotPaint);

    // Glow effect
    dotPaint.color = PayRouteColors.vibrantOrange.withValues(alpha: 0.3);
    canvas.drawCircle(Offset(dotX, centerY), 10, dotPaint);
  }

  @override
  bool shouldRepaint(covariant _CorridorPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
