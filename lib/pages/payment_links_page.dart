import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class PaymentLinksPage extends StatefulWidget {
  const PaymentLinksPage({super.key});

  @override
  State<PaymentLinksPage> createState() => _PaymentLinksPageState();
}

class _PaymentLinksPageState extends State<PaymentLinksPage> {
  // Colors mimicking the exact screenshot
  static const Color _sidebarBg = Color(0xFF10131E);
  static const Color _mainBg = Color(0xFF151924);
  static const Color _surfaceColor = Color(0xFF1A1F2C);
  static const Color _borderColor = Color(0xFF262E40);
  
  static const Color _textPrimary = Colors.white;
  static const Color _textSecondary = Color(0xFF8E99B0);
  static const Color _accentBlue = Color(0xFF2563EB);
  static const Color _accentOrange = Color(0xFFF59E0B);
  static const Color _successGreen = Color(0xFF10B981);
  static const Color _dangerRed = Color(0xFFEF4444);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _mainBg,
      body: Row(
        children: [
          // Sidebar
          _buildSidebar(),
          // Main Content
          Expanded(
            child: _buildMainContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebar() {
    return Container(
      width: 260,
      color: _sidebarBg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Logo Area
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 32, 24, 32),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: _surfaceColor,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: _accentBlue.withValues(alpha: 0.3)),
                  ),
                  child: const Center(
                    child: Icon(Icons.hub_rounded, color: _accentBlue, size: 20),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Fintech Noir',
                      style: GoogleFonts.inter(
                        color: _textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'Enterprise Tier',
                      style: GoogleFonts.inter(
                        color: _textSecondary,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Navigation
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildNavItem(Icons.grid_view_rounded, 'Dashboard', false),
                _buildNavItem(Icons.sync_alt_rounded, 'Transactions', false),
                _buildNavItem(Icons.link_rounded, 'Payment Links', true),
                _buildNavItem(Icons.group_outlined, 'Customers', false),
                _buildNavItem(Icons.bar_chart_rounded, 'Analytics', false),
                _buildNavItem(Icons.settings_outlined, 'Settings', false),
              ],
            ),
          ),
          
          // Upgrade Plan Card
          Padding(
            padding: const EdgeInsets.all(20),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _surfaceColor.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: _borderColor),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Current Plan',
                    style: GoogleFonts.inter(
                      color: _textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'PRO ENTERPRISE',
                    style: GoogleFonts.inter(
                      color: _textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _accentBlue,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'UPGRADE PLAN',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
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

  Widget _buildNavItem(IconData icon, String label, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        color: isSelected ? _accentBlue.withValues(alpha: 0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: isSelected ? Border.all(color: _accentBlue.withValues(alpha: 0.2)) : null,
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isSelected ? _accentBlue : _textSecondary,
          size: 20,
        ),
        title: Text(
          label,
          style: GoogleFonts.inter(
            color: isSelected ? _accentBlue : _textSecondary,
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        onTap: () {
          if (label == 'Dashboard') {
            context.go('/dashboard');
          }
        },
      ),
    );
  }

  Widget _buildMainContent() {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 32),
                _buildStatsCards(),
                const SizedBox(height: 32),
                _buildFiltersRow(),
                const SizedBox(height: 24),
                _buildTable(),
              ],
            ),
          ),
        ),
        _buildBottomFooter(),
      ],
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Payment Links',
              style: GoogleFonts.inter(
                color: _textPrimary,
                fontSize: 28,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Manage and monitor your global checkout\nendpoints.',
              style: GoogleFonts.inter(
                color: _textSecondary,
                fontSize: 14,
                fontWeight: FontWeight.w400,
                height: 1.5,
              ),
            ),
          ],
        ),
        Row(
          children: [
            Container(
              width: 240,
              height: 48,
              decoration: BoxDecoration(
                color: _surfaceColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _borderColor),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  const Icon(Icons.search, color: _textSecondary, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      style: GoogleFonts.inter(color: _textPrimary, fontSize: 14),
                      decoration: InputDecoration(
                        hintText: 'Search link ID or name...',
                        hintStyle: GoogleFonts.inter(color: _textSecondary, fontSize: 14),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add_link_rounded, size: 20),
              label: Text(
                'Create New\nLink',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  height: 1.2,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: _accentOrange,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
            ),
            const SizedBox(width: 16),
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: _surfaceColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _borderColor),
              ),
              child: const Icon(Icons.notifications_none_rounded, color: _textPrimary),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatsCards() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            title: 'Active Links',
            value: '128',
            percentage: '+5.2%',
            isPositive: true,
            icon: Icons.link_rounded,
            progressColor: _accentBlue,
            progressValue: 0.7,
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
          child: _buildStatCard(
            title: 'Total Revenue via Links',
            value: '\$42,500.00',
            percentage: '+12.4%',
            isPositive: true,
            icon: Icons.payments_rounded,
            progressColor: _accentOrange,
            progressValue: 0.6,
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
          child: _buildStatCard(
            title: 'Avg. Conversion Rate',
            value: '14.2%',
            percentage: '-1.1%',
            isPositive: false,
            icon: Icons.insights_rounded,
            progressColor: _accentBlue,
            progressValue: 0.3,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required String percentage,
    required bool isPositive,
    required IconData icon,
    required Color progressColor,
    required double progressValue,
  }) {
    final badgeColor = isPositive ? _successGreen : _dangerRed;
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: _surfaceColor.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _borderColor),
      ),
      child: Stack(
        children: [
          Positioned(
            right: 0,
            top: 0,
            child: Icon(
              icon,
              size: 48,
              color: _borderColor.withValues(alpha: 0.5),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.inter(
                  color: _textSecondary,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    value,
                    style: GoogleFonts.inter(
                      color: _textPrimary,
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    margin: const EdgeInsets.only(bottom: 6),
                    decoration: BoxDecoration(
                      color: badgeColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      percentage,
                      style: GoogleFonts.inter(
                        color: badgeColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              ClipRRect(
                borderRadius: BorderRadius.circular(2),
                child: LinearProgressIndicator(
                  value: progressValue,
                  backgroundColor: _borderColor,
                  valueColor: AlwaysStoppedAnimation<Color>(progressColor),
                  minHeight: 4,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFiltersRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            _buildFilterButton('All Links', isPrimary: true),
            const SizedBox(width: 12),
            _buildFilterButton('Status: Active', isPrimary: false),
            const SizedBox(width: 12),
            _buildFilterButton('Currency: USD', isPrimary: false),
          ],
        ),
        Row(
          children: [
            Text(
              'Show:',
              style: GoogleFonts.inter(
                color: _textSecondary,
                fontSize: 13,
              ),
            ),
            const SizedBox(width: 8),
            _buildFilterButton('10 rows', isPrimary: false, hideChevron: false),
          ],
        ),
      ],
    );
  }

  Widget _buildFilterButton(String label, {required bool isPrimary, bool hideChevron = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isPrimary ? _accentBlue.withValues(alpha: 0.2) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isPrimary ? _accentBlue.withValues(alpha: 0.5) : _borderColor,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              color: isPrimary ? _accentBlue : _textSecondary,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (!hideChevron) ...[
            const SizedBox(width: 8),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              color: isPrimary ? _accentBlue : _textSecondary,
              size: 16,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTable() {
    return Container(
      decoration: BoxDecoration(
        color: _surfaceColor.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _borderColor),
      ),
      child: Column(
        children: [
          // Table Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    'LINK NAME & DESCRIPTION',
                    style: GoogleFonts.inter(color: _textSecondary, fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 0.5),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    'AMOUNT',
                    style: GoogleFonts.inter(color: _textSecondary, fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 0.5),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    'PAYMENTS',
                    style: GoogleFonts.inter(color: _textSecondary, fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 0.5),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    'STATUS',
                    style: GoogleFonts.inter(color: _textSecondary, fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 0.5),
                  ),
                ),
                SizedBox(
                  width: 120,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'ACTION',
                      style: GoogleFonts.inter(color: _textSecondary, fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 0.5),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: _borderColor),
          
          // Table Rows
          _buildTableRow(
            icon: Icons.shopping_bag_rounded,
            iconBg: _accentBlue.withValues(alpha: 0.1),
            iconColor: _accentBlue,
            title: 'Q4 Enterprise Software License',
            subtitle: 'fintech.noir/pay/q4-software-2024',
            amount: '\$12,000.00',
            payments: '42',
            status: 'ACTIVE',
            isAutoRouting: true,
          ),
          Divider(height: 1, color: _borderColor),
          _buildTableRow(
            icon: Icons.volunteer_activism_rounded,
            iconBg: _accentOrange.withValues(alpha: 0.1),
            iconColor: _accentOrange,
            title: 'Global Tech Summit Donation',
            subtitle: 'fintech.noir/pay/summit-2024',
            amount: 'Flexible\nAmount',
            payments: '892',
            status: 'ACTIVE',
            isAutoRouting: true,
          ),
          Divider(height: 1, color: _borderColor),
          _buildTableRow(
            icon: Icons.history_rounded,
            iconBg: _textSecondary.withValues(alpha: 0.1),
            iconColor: _textSecondary,
            title: 'Early Bird Access - Archive',
            subtitle: 'fintech.noir/pay/early-archive-01',
            amount: '\$499.00',
            payments: '1,204',
            status: 'EXPIRED',
            isAutoRouting: false,
          ),
          Divider(height: 1, color: _borderColor),
          _buildTableRow(
            icon: Icons.cloud_done_rounded,
            iconBg: _accentBlue.withValues(alpha: 0.1),
            iconColor: _accentBlue,
            title: 'SaaS Monthly Subscription',
            subtitle: 'fintech.noir/pay/saas-monthly-sub',
            amount: '\$99.00',
            payments: '3,120',
            status: 'ACTIVE',
            isAutoRouting: true,
          ),
          Divider(height: 1, color: _borderColor),
          
          // Table Footer / Pagination
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Showing 1-10 of 128 links',
                  style: GoogleFonts.inter(color: _textSecondary, fontSize: 13),
                ),
                Row(
                  children: [
                    _buildPageButton(Icons.chevron_left_rounded, false),
                    _buildPageText('1', true),
                    _buildPageText('2', false),
                    _buildPageText('3', false),
                    _buildPageText('...', false),
                    _buildPageText('13', false),
                    _buildPageButton(Icons.chevron_right_rounded, false),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableRow({
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String title,
    required String subtitle,
    required String amount,
    required String payments,
    required String status,
    required bool isAutoRouting,
  }) {
    final statusColor = status == 'ACTIVE' ? _successGreen : _textSecondary;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 3,
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: iconBg,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: iconColor, size: 20),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              title,
                              style: GoogleFonts.inter(
                                color: _textPrimary,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (isAutoRouting) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: _accentBlue.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(color: _accentBlue.withValues(alpha: 0.3)),
                              ),
                              child: Text(
                                'AUTO-ROUTING\nACTIVE',
                                style: GoogleFonts.inter(
                                  color: _accentBlue,
                                  fontSize: 8,
                                  fontWeight: FontWeight.w700,
                                  height: 1.1,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: GoogleFonts.inter(
                          color: _textSecondary,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              amount,
              style: GoogleFonts.inter(
                color: _textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                fontStyle: amount.contains('Flexible') ? FontStyle.italic : FontStyle.normal,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              payments,
              style: GoogleFonts.inter(
                color: _textSecondary,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Row(
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: statusColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  status,
                  style: GoogleFonts.inter(
                    color: statusColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 120,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: _surfaceColor,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: _borderColor),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.copy_rounded, color: _textPrimary, size: 14),
                      const SizedBox(width: 6),
                      Text(
                        'Copy\nLink',
                        style: GoogleFonts.inter(
                          color: _textPrimary,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          height: 1.1,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                const Icon(Icons.more_vert_rounded, color: _textSecondary, size: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPageButton(IconData icon, bool isSelected) {
    return Container(
      width: 32,
      height: 32,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: isSelected ? _accentBlue : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        icon,
        color: isSelected ? Colors.white : _textSecondary,
        size: 16,
      ),
    );
  }

  Widget _buildPageText(String text, bool isSelected) {
    return Container(
      width: 32,
      height: 32,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: isSelected ? _accentBlue : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          text,
          style: GoogleFonts.inter(
            color: isSelected ? Colors.white : _textSecondary,
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildBottomFooter() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: _borderColor)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.verified_user_rounded, color: _successGreen, size: 16),
              const SizedBox(width: 8),
              Text(
                'PCI-DSS LEVEL 1 COMPLIANT',
                style: GoogleFonts.inter(
                  color: _textSecondary,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(width: 32),
              const Icon(Icons.public_rounded, color: _accentBlue, size: 16),
              const SizedBox(width: 8),
              Text(
                'MULTI-REGION ROUTING ACTIVE',
                style: GoogleFonts.inter(
                  color: _textSecondary,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          Row(
            children: [
              _buildFooterLink('DOCUMENTATION'),
              const SizedBox(width: 24),
              _buildFooterLink('API KEYS'),
              const SizedBox(width: 24),
              _buildFooterLink('WEBHOOK STATUS'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFooterLink(String text) {
    return Text(
      text,
      style: GoogleFonts.inter(
        color: _textSecondary,
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      ),
    );
  }
}
