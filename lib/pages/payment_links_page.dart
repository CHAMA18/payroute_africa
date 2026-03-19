import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:payroute_desktop/theme.dart';
import 'package:payroute_desktop/widgets/finroute_responsive_scaffold.dart';

class PaymentLinksPage extends StatefulWidget {
  const PaymentLinksPage({super.key});

  @override
  State<PaymentLinksPage> createState() => _PaymentLinksPageState();
}

class _PaymentLinksPageState extends State<PaymentLinksPage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brightness = theme.brightness;
    final textStyles = context.textStyles;
    
    final bg = DashboardPalette.bg(brightness);
    final surface = DashboardPalette.surface(brightness);
    final border = DashboardPalette.border(brightness);
    final textPrimary = DashboardPalette.textPrimary(brightness);
    final textSecondary = DashboardPalette.textSecondary(brightness);
    final primaryColor = PayRouteColors.dashboardPrimary;

    return FinRouteResponsiveScaffold(
      selectedLabel: 'Payment Links',
      mobileTitle: 'Payment Links',
      mobileSubtitle: 'Global checkout endpoints',
      child: Container(
        color: bg,
        child: _buildMainContent(
          theme,
          brightness,
          textStyles,
          bg,
          surface,
          border,
          textPrimary,
          textSecondary,
          primaryColor,
        ),
      ),
    );
  }

  Widget _buildMainContent(
    ThemeData theme,
    Brightness brightness,
    TextTheme textStyles,
    Color bg,
    Color surface,
    Color border,
    Color textPrimary,
    Color textSecondary,
    Color primaryColor,
  ) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: AppSpacing.paddingXl,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(textStyles, surface, border, textPrimary, textSecondary, primaryColor),
                const SizedBox(height: AppSpacing.xl),
                _buildStatsCards(textStyles, surface, border, textPrimary, textSecondary),
                const SizedBox(height: AppSpacing.xl),
                _buildFiltersRow(textStyles, border, textSecondary),
                const SizedBox(height: AppSpacing.lg),
                _buildTable(textStyles, surface, border, textPrimary, textSecondary),
              ],
            ),
          ),
        ),
        _buildBottomFooter(textStyles, border, textSecondary),
      ],
    );
  }

  Widget _buildHeader(
    TextTheme textStyles,
    Color surface,
    Color border,
    Color textPrimary,
    Color textSecondary,
    Color primaryColor,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Payment Links',
              style: textStyles.headlineMedium?.bold.withColor(textPrimary),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Manage and monitor your global checkout\nendpoints.',
              style: textStyles.bodyMedium?.withColor(textSecondary),
            ),
          ],
        ),
        Row(
          children: [
            Container(
              width: 280,
              height: 48,
              decoration: BoxDecoration(
                color: surface,
                borderRadius: BorderRadius.circular(AppRadius.md),
                border: Border.all(color: border),
              ),
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: Row(
                children: [
                  Icon(Icons.search, color: textSecondary, size: 20),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: TextField(
                      style: textStyles.bodyMedium?.withColor(textPrimary),
                      decoration: InputDecoration(
                        hintText: 'Search link ID or name...',
                        hintStyle: textStyles.bodyMedium?.withColor(textSecondary),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add_link_rounded, size: 20),
              label: Text(
                'Create New Link',
                style: textStyles.labelLarge?.bold.withColor(Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.md,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                elevation: 0,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: surface,
                borderRadius: BorderRadius.circular(AppRadius.md),
                border: Border.all(color: border),
              ),
              child: Icon(
                Icons.notifications_none_rounded,
                color: textPrimary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatsCards(
    TextTheme textStyles,
    Color surface,
    Color border,
    Color textPrimary,
    Color textSecondary,
  ) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            textStyles: textStyles,
            surface: surface,
            border: border,
            textPrimary: textPrimary,
            textSecondary: textSecondary,
            title: 'Active Links',
            value: '128',
            percentage: '+5.2%',
            isPositive: true,
            icon: Icons.link_rounded,
            progressColor: PayRouteColors.electricBlue,
            progressValue: 0.7,
          ),
        ),
        const SizedBox(width: AppSpacing.lg),
        Expanded(
          child: _buildStatCard(
            textStyles: textStyles,
            surface: surface,
            border: border,
            textPrimary: textPrimary,
            textSecondary: textSecondary,
            title: 'Total Revenue via Links',
            value: '\$42,500.00',
            percentage: '+12.4%',
            isPositive: true,
            icon: Icons.payments_rounded,
            progressColor: PayRouteColors.vibrantGold,
            progressValue: 0.6,
          ),
        ),
        const SizedBox(width: AppSpacing.lg),
        Expanded(
          child: _buildStatCard(
            textStyles: textStyles,
            surface: surface,
            border: border,
            textPrimary: textPrimary,
            textSecondary: textSecondary,
            title: 'Avg. Conversion Rate',
            value: '14.2%',
            percentage: '-1.1%',
            isPositive: false,
            icon: Icons.insights_rounded,
            progressColor: PayRouteColors.cyanGlow,
            progressValue: 0.3,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required TextTheme textStyles,
    required Color surface,
    required Color border,
    required Color textPrimary,
    required Color textSecondary,
    required String title,
    required String value,
    required String percentage,
    required bool isPositive,
    required IconData icon,
    required Color progressColor,
    required double progressValue,
  }) {
    final successColor = PayRouteColors.dashboardGreen;
    final dangerColor = const Color(0xFFEF4444);
    final badgeColor = isPositive ? successColor : dangerColor;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: surface.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: border),
      ),
      child: Stack(
        children: [
          Positioned(
            right: 0,
            top: 0,
            child: Icon(
              icon,
              size: 40,
              color: border.withValues(alpha: 0.8),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: textStyles.bodySmall?.withColor(textSecondary).medium,
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    value,
                    style: textStyles.headlineMedium?.bold.withColor(textPrimary),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    margin: const EdgeInsets.only(bottom: 4),
                    decoration: BoxDecoration(
                      color: badgeColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                    ),
                    child: Text(
                      percentage,
                      style: textStyles.labelSmall?.bold.withColor(badgeColor),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              ClipRRect(
                borderRadius: BorderRadius.circular(2),
                child: LinearProgressIndicator(
                  value: progressValue,
                  backgroundColor: border,
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

  Widget _buildFiltersRow(
    TextTheme textStyles,
    Color border,
    Color textSecondary,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            _buildFilterButton(textStyles, border, textSecondary, 'All Links', isPrimary: true),
            const SizedBox(width: AppSpacing.sm),
            _buildFilterButton(textStyles, border, textSecondary, 'Status: Active', isPrimary: false),
            const SizedBox(width: AppSpacing.sm),
            _buildFilterButton(textStyles, border, textSecondary, 'Currency: USD', isPrimary: false),
          ],
        ),
        Row(
          children: [
            Text(
              'Show:',
              style: textStyles.bodySmall?.withColor(textSecondary),
            ),
            const SizedBox(width: AppSpacing.sm),
            _buildFilterButton(textStyles, border, textSecondary, '10 rows', isPrimary: false, hideChevron: false),
          ],
        ),
      ],
    );
  }

  Widget _buildFilterButton(
    TextTheme textStyles,
    Color border,
    Color textSecondary,
    String label, {
    required bool isPrimary,
    bool hideChevron = false,
  }) {
    final activeColor = PayRouteColors.dashboardPrimary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      decoration: BoxDecoration(
        color: isPrimary ? activeColor.withValues(alpha: 0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: Border.all(
          color: isPrimary ? activeColor.withValues(alpha: 0.5) : border,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: textStyles.bodySmall?.semiBold.withColor(
              isPrimary ? activeColor : textSecondary,
            ),
          ),
          if (!hideChevron) ...[
            const SizedBox(width: AppSpacing.xs),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              color: isPrimary ? activeColor : textSecondary,
              size: 16,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTable(
    TextTheme textStyles,
    Color surface,
    Color border,
    Color textPrimary,
    Color textSecondary,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: surface.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: border),
      ),
      child: Column(
        children: [
          // Table Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    'LINK NAME & DESCRIPTION',
                    style: textStyles.labelSmall?.bold.withColor(textSecondary),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    'AMOUNT',
                    style: textStyles.labelSmall?.bold.withColor(textSecondary),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    'PAYMENTS',
                    style: textStyles.labelSmall?.bold.withColor(textSecondary),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    'STATUS',
                    style: textStyles.labelSmall?.bold.withColor(textSecondary),
                  ),
                ),
                SizedBox(
                  width: 120,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'ACTION',
                      style: textStyles.labelSmall?.bold.withColor(textSecondary),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: border),

          // Table Rows
          _buildTableRow(
            textStyles: textStyles,
            surface: surface,
            border: border,
            textPrimary: textPrimary,
            textSecondary: textSecondary,
            icon: Icons.shopping_bag_rounded,
            iconBg: PayRouteColors.electricBlue.withValues(alpha: 0.1),
            iconColor: PayRouteColors.electricBlue,
            title: 'Q4 Enterprise Software License',
            subtitle: 'fintech.noir/pay/q4-software-2024',
            amount: '\$12,000.00',
            payments: '42',
            status: 'ACTIVE',
            isAutoRouting: true,
          ),
          Divider(height: 1, color: border),
          _buildTableRow(
            textStyles: textStyles,
            surface: surface,
            border: border,
            textPrimary: textPrimary,
            textSecondary: textSecondary,
            icon: Icons.volunteer_activism_rounded,
            iconBg: PayRouteColors.vibrantGold.withValues(alpha: 0.1),
            iconColor: PayRouteColors.vibrantGold,
            title: 'Global Tech Summit Donation',
            subtitle: 'fintech.noir/pay/summit-2024',
            amount: 'Flexible\nAmount',
            payments: '892',
            status: 'ACTIVE',
            isAutoRouting: true,
          ),
          Divider(height: 1, color: border),
          _buildTableRow(
            textStyles: textStyles,
            surface: surface,
            border: border,
            textPrimary: textPrimary,
            textSecondary: textSecondary,
            icon: Icons.history_rounded,
            iconBg: textSecondary.withValues(alpha: 0.1),
            iconColor: textSecondary,
            title: 'Early Bird Access - Archive',
            subtitle: 'fintech.noir/pay/early-archive-01',
            amount: '\$499.00',
            payments: '1,204',
            status: 'EXPIRED',
            isAutoRouting: false,
          ),
          Divider(height: 1, color: border),
          _buildTableRow(
            textStyles: textStyles,
            surface: surface,
            border: border,
            textPrimary: textPrimary,
            textSecondary: textSecondary,
            icon: Icons.cloud_done_rounded,
            iconBg: PayRouteColors.electricBlue.withValues(alpha: 0.1),
            iconColor: PayRouteColors.electricBlue,
            title: 'SaaS Monthly Subscription',
            subtitle: 'fintech.noir/pay/saas-monthly-sub',
            amount: '\$99.00',
            payments: '3,120',
            status: 'ACTIVE',
            isAutoRouting: true,
          ),
          Divider(height: 1, color: border),

          // Table Footer / Pagination
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Showing 1-10 of 128 links',
                  style: textStyles.bodySmall?.withColor(textSecondary),
                ),
                Row(
                  children: [
                    _buildPageButton(textSecondary, Icons.chevron_left_rounded, false),
                    _buildPageText(textSecondary, '1', true),
                    _buildPageText(textSecondary, '2', false),
                    _buildPageText(textSecondary, '3', false),
                    _buildPageText(textSecondary, '...', false),
                    _buildPageText(textSecondary, '13', false),
                    _buildPageButton(textSecondary, Icons.chevron_right_rounded, false),
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
    required TextTheme textStyles,
    required Color surface,
    required Color border,
    required Color textPrimary,
    required Color textSecondary,
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
    final successColor = PayRouteColors.dashboardGreen;
    final statusColor = status == 'ACTIVE' ? successColor : textSecondary;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.lg),
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
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  child: Icon(icon, color: iconColor, size: 20),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              title,
                              style: textStyles.bodyMedium?.bold.withColor(textPrimary),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (isAutoRouting) ...[
                            const SizedBox(width: AppSpacing.sm),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: PayRouteColors.electricBlue.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(
                                  color: PayRouteColors.electricBlue.withValues(alpha: 0.3),
                                ),
                              ),
                              child: Text(
                                'AUTO-ROUTING\nACTIVE',
                                style: textStyles.labelSmall?.bold.withColor(PayRouteColors.electricBlue).withSize(7),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: textStyles.bodySmall?.withColor(textSecondary),
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
              style: textStyles.bodyMedium?.semiBold.withColor(textPrimary).copyWith(
                    fontStyle: amount.contains('Flexible') ? FontStyle.italic : FontStyle.normal,
                  ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              payments,
              style: textStyles.bodyMedium?.withColor(textSecondary),
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
                  style: textStyles.labelSmall?.bold.withColor(statusColor),
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: surface,
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                    border: Border.all(color: border),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.copy_rounded,
                        color: textPrimary,
                        size: 14,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Copy\nLink',
                        style: textStyles.labelSmall?.bold.withColor(textPrimary).copyWith(height: 1.1),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Icon(
                  Icons.more_vert_rounded,
                  color: textSecondary,
                  size: 20,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildPageButton(Color textSecondary, IconData icon, bool isSelected) {
    final activeColor = PayRouteColors.dashboardPrimary;
    return Container(
      width: 32,
      height: 32,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: isSelected ? activeColor : Colors.transparent,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Icon(
        icon,
        color: isSelected ? Colors.white : textSecondary,
        size: 16,
      ),
    );
  }

  Widget _buildPageText(Color textSecondary, String text, bool isSelected) {
    final activeColor = PayRouteColors.dashboardPrimary;
    return Container(
      width: 32,
      height: 32,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: isSelected ? activeColor : Colors.transparent,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.white : textSecondary,
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }

    Widget _buildBottomFooter(
    TextTheme textStyles,
    Color border,
    Color textSecondary,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: border)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(
                Icons.verified_user_rounded,
                color: PayRouteColors.dashboardGreen,
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                'PCI-DSS LEVEL 1 COMPLIANT',
                style: textStyles.labelSmall?.bold.withColor(textSecondary).copyWith(letterSpacing: 0.5),
              ),
              const SizedBox(width: 32),
              const Icon(Icons.public_rounded, color: PayRouteColors.electricBlue, size: 16),
              const SizedBox(width: 8),
              Text(
                'MULTI-REGION ROUTING ACTIVE',
                style: textStyles.labelSmall?.bold.withColor(textSecondary).copyWith(letterSpacing: 0.5),
              ),
            ],
          ),
          Row(
            children: [
              _buildFooterLink(textStyles, textSecondary, 'DOCUMENTATION'),
              const SizedBox(width: 24),
              _buildFooterLink(textStyles, textSecondary, 'API KEYS'),
              const SizedBox(width: 24),
              _buildFooterLink(textStyles, textSecondary, 'WEBHOOK STATUS'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFooterLink(TextTheme textStyles, Color textSecondary, String label) {
    return Text(
      label,
      style: textStyles.labelSmall?.bold.withColor(textSecondary).copyWith(letterSpacing: 0.5),
    );
  }
}
