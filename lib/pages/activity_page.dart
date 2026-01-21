import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:payroute_desktop/theme.dart';
import 'package:payroute_desktop/widgets/finroute_responsive_scaffold.dart';

class ActivityPage extends StatelessWidget {
  const ActivityPage({super.key});

  @override
  Widget build(BuildContext context) {
    final b = Theme.of(context).brightness;
    return FinRouteResponsiveScaffold(
      selectedLabel: 'Activity',
      background: const _GlowBackground(),
      desktopHeader: _ActivityHeader(brightness: b),
      mobileTitle: 'Activity',
      mobileSubtitle: 'Transaction history & routing analysis',
      child: _ActivityBody(brightness: b),
    );
  }
}

class _GlowBackground extends StatelessWidget {
  const _GlowBackground();

  @override
  Widget build(BuildContext context) {
    final b = Theme.of(context).brightness;
    // In light mode we want a crisp, clear background (no glows/gradients).
    if (b == Brightness.light) return const SizedBox.shrink();
    final bg = DashboardPalette.bg(b);
    final neutralA = Colors.white.withValues(alpha: 0.06);
    final neutralB = Colors.white.withValues(alpha: 0.035);
    return IgnorePointer(
      child: Stack(
        children: [
          Positioned(
            top: -160,
            left: -120,
            child: _GlowCircle(color: neutralA, size: 520),
          ),
          Positioned(
            top: -120,
            right: -160,
            child: _GlowCircle(color: neutralB, size: 460),
          ),
          Positioned(
            bottom: -40,
            left: -20,
            right: -20,
            child: Container(
              height: 320,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [bg, Colors.transparent],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GlowCircle extends StatelessWidget {
  final Color color;
  final double size;

  const _GlowCircle({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(size),
        boxShadow: [
          BoxShadow(color: color, blurRadius: 120, spreadRadius: 40),
        ],
      ),
    );
  }
}

class _ActivityHeader extends StatelessWidget {
  final Brightness brightness;

  const _ActivityHeader({required this.brightness});

  @override
  Widget build(BuildContext context) {
    final bg = DashboardPalette.bg(brightness);
    final surface = DashboardPalette.surface(brightness);
    final border = DashboardPalette.border(brightness);
    final textPrimary = DashboardPalette.textPrimary(brightness);
    final textSecondary = DashboardPalette.textSecondary(brightness);
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final isTight = w < 1080;

        final title = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Activity Log', style: GoogleFonts.inter(color: textPrimary, fontWeight: FontWeight.w800, fontSize: 22), overflow: TextOverflow.ellipsis),
            const SizedBox(height: 4),
            Text('Detailed transaction history and routing analysis', style: GoogleFonts.inter(color: textSecondary, fontSize: 12), overflow: TextOverflow.ellipsis),
          ],
        );

        final search = SizedBox(
          width: 260,
          height: 42,
          child: TextField(
            style: GoogleFonts.inter(color: textPrimary, fontSize: 13),
            cursorColor: PayRouteColors.dashboardPrimary,
            decoration: InputDecoration(
              isDense: true,
              prefixIcon: Icon(Icons.search, size: 20, color: DashboardPalette.iconMuted(brightness)),
              prefixIconConstraints: const BoxConstraints(minWidth: 44),
              hintText: 'Global search...',
              hintStyle: GoogleFonts.inter(color: textSecondary, fontSize: 13),
              filled: true,
              fillColor: DashboardPalette.surfaceMuted(brightness),
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(999), borderSide: BorderSide(color: border)),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(999), borderSide: BorderSide(color: border)),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(999),
                borderSide: BorderSide(color: PayRouteColors.dashboardPrimary.withValues(alpha: 0.5)),
              ),
            ),
          ),
        );

        final notif = Stack(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(color: surface.withValues(alpha: brightness == Brightness.dark ? 0.55 : 1), shape: BoxShape.circle),
              child: Icon(Icons.notifications, color: DashboardPalette.iconMuted(brightness)),
            ),
            Positioned(top: 8, right: 9, child: Container(width: 8, height: 8, decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle))),
          ],
        );

        final avatar = Stack(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: border),
                image: const DecorationImage(
                  image: NetworkImage(
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuDIaCwDhxVyzTNPQbH6aaAvTB4kSusDv5bbYxEyGKb-1TPNRJk91FgmYmUXT0i8vx_rEyeiQxswISwl2k6YhPpF6d7qSqQ0mrrCPu_XpvzN_trba7SfY6EpmkKfdalH8K0Mm6lt6rVQdGweDb1PDRrudp21TTAMVmdeBLRsYyk0GZI8DhfWA-L90GYjvQbC3HfDiejXV3gCK4z_SmqjrS3TWliIRISkjuUcRqa_TlHL6rFb-MaL5LgFCZVt6Rl_zueXYSIRlwEvITx8',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              bottom: 2,
              right: 2,
              child: Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(color: PayRouteColors.dashboardGreen, shape: BoxShape.circle, border: Border.all(color: bg, width: 2)),
              ),
            ),
          ],
        );

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
          decoration: BoxDecoration(color: bg.withValues(alpha: 0.84), border: Border(bottom: BorderSide(color: border))),
          child: Row(
            children: [
              Expanded(child: title),
              if (!isTight) ...[
                const SizedBox(width: 16),
                search,
                Container(width: 1, height: 24, margin: const EdgeInsets.symmetric(horizontal: 18), color: border),
              ] else ...[
                const SizedBox(width: 12),
              ],
              notif,
              const SizedBox(width: 12),
              if (!isTight) ...[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('Tunde A.', style: GoogleFonts.inter(color: textPrimary, fontWeight: FontWeight.w700), overflow: TextOverflow.ellipsis),
                    Text('Admin', style: GoogleFonts.inter(color: textSecondary, fontSize: 12)),
                  ],
                ),
                const SizedBox(width: 12),
              ],
              avatar,
            ],
          ),
        );
      },
    );
  }
}

class _ActivityBody extends StatelessWidget {
  final Brightness brightness;

  const _ActivityBody({required this.brightness});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final padding = constraints.maxWidth < 600 ? 16.0 : 24.0;
        return SingleChildScrollView(
          padding: EdgeInsets.all(padding),
          child: Column(
            children: [
              _KpiRow(brightness: brightness),
              const SizedBox(height: 20),
              _FiltersRow(brightness: brightness),
              const SizedBox(height: 16),
              _ActivityTable(brightness: brightness),
            ],
          ),
        );
      },
    );
  }
}

class _KpiRow extends StatelessWidget {
  final Brightness brightness;

  const _KpiRow({required this.brightness});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 980;
        final children = [
          _KpiCard(
            icon: Icons.payments,
            iconBg: PayRouteColors.dashboardPrimary,
            label: 'Total Volume',
            value: '₦45,280,000',
            delta: '12.5%',
            deltaColor: PayRouteColors.dashboardGreen,
            brightness: brightness,
          ),
          _KpiCard(
            icon: Icons.check_circle,
            iconBg: PayRouteColors.dashboardGreen,
            label: 'Successful Transfers',
            value: '1,248',
            delta: '5.2%',
            deltaColor: PayRouteColors.dashboardGreen,
            brightness: brightness,
          ),
          _KpiCard(
            icon: Icons.savings,
            iconBg: PayRouteColors.dashboardAccentOrange,
            label: 'Avg Fee Saved',
            value: '₦125.00/tx',
            delta: '2.4%',
            deltaColor: PayRouteColors.dashboardGreen,
            brightness: brightness,
          ),
        ];

        if (isNarrow) {
          return Column(
            children: [
              for (final child in children) ...[child, const SizedBox(height: 14)],
            ],
          );
        }

        return Row(
          children: [
            for (var i = 0; i < children.length; i++) ...[
              Expanded(child: children[i]),
              if (i != children.length - 1) const SizedBox(width: 16),
            ],
          ],
        );
      },
    );
  }
}

class _KpiCard extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final String label;
  final String value;
  final String delta;
  final Color deltaColor;

  final Brightness brightness;

  const _KpiCard({required this.icon, required this.iconBg, required this.label, required this.value, required this.delta, required this.deltaColor, required this.brightness});

  @override
  Widget build(BuildContext context) {
    final surface = DashboardPalette.surface(brightness);
    final border = DashboardPalette.border(brightness);
    final textPrimary = DashboardPalette.textPrimary(brightness);
    final textSecondary = DashboardPalette.textSecondary(brightness);
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: surface.withValues(alpha: brightness == Brightness.dark ? 0.55 : 1),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: iconBg.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: iconBg.withValues(alpha: 0.20)),
                ),
                child: Icon(icon, color: iconBg, size: 22),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: deltaColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: deltaColor.withValues(alpha: 0.20)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.trending_up, size: 16, color: deltaColor),
                    const SizedBox(width: 6),
                    Text(delta, style: GoogleFonts.inter(color: deltaColor, fontSize: 11, fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(label, style: GoogleFonts.inter(color: textSecondary, fontSize: 12, fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          Text(value, style: GoogleFonts.inter(color: textPrimary, fontSize: 26, fontWeight: FontWeight.w800, letterSpacing: -0.5)),
        ],
      ),
    );
  }
}

class _FiltersRow extends StatelessWidget {
  final Brightness brightness;

  const _FiltersRow({required this.brightness});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 980;
        final right = Wrap(
          spacing: 10,
          runSpacing: 10,
          alignment: WrapAlignment.end,
          children: [
            _FilterChipButton(label: 'All Status', icon: Icons.expand_more, brightness: brightness),
            _FilterChipButton(label: 'All Rails', icon: Icons.expand_more, brightness: brightness),
            _FilterChipButton(label: 'Last 30 Days', icon: Icons.calendar_today, brightness: brightness),
            _PrimaryChipButton(label: 'Export', icon: Icons.download),
          ],
        );

        final left = SizedBox(
          width: isNarrow ? double.infinity : 380,
          height: 44,
          child: TextField(
            style: GoogleFonts.inter(color: DashboardPalette.textPrimary(brightness), fontSize: 13),
            cursorColor: PayRouteColors.dashboardPrimary,
            decoration: InputDecoration(
              isDense: true,
              prefixIcon: Icon(Icons.search, size: 20, color: DashboardPalette.iconMuted(brightness)),
              hintText: 'Search by recipient, ID or amount...',
              hintStyle: GoogleFonts.inter(color: DashboardPalette.textSecondary(brightness), fontSize: 13),
              filled: true,
              fillColor: DashboardPalette.surfaceMuted(brightness),
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: DashboardPalette.border(brightness)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: DashboardPalette.border(brightness)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: PayRouteColors.dashboardPrimary.withValues(alpha: 0.5)),
              ),
            ),
          ),
        );

        if (isNarrow) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              left,
              const SizedBox(height: 12),
              right,
            ],
          );
        }

        return Row(
          children: [
            left,
            const Spacer(),
            right,
          ],
        );
      },
    );
  }
}

class _FilterChipButton extends StatelessWidget {
  final String label;
  final IconData icon;

  final Brightness brightness;

  const _FilterChipButton({required this.label, required this.icon, required this.brightness});

  @override
  Widget build(BuildContext context) {
    final border = DashboardPalette.border(brightness);
    final surface = DashboardPalette.surface(brightness);
    final textSecondary = DashboardPalette.textSecondary(brightness);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: textSecondary),
          const SizedBox(width: 8),
          Text(label, style: GoogleFonts.inter(color: textSecondary, fontSize: 12, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _PrimaryChipButton extends StatelessWidget {
  final String label;
  final IconData icon;

  const _PrimaryChipButton({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: PayRouteColors.dashboardPrimary,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: PayRouteColors.dashboardPrimary.withValues(alpha: 0.25), blurRadius: 18, spreadRadius: 2),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: Colors.white),
          const SizedBox(width: 8),
          Text(label, style: GoogleFonts.inter(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

class _ActivityTable extends StatelessWidget {
  final Brightness brightness;

  const _ActivityTable({required this.brightness});

  static const _rows = <_ActivityRowData>[
    _ActivityRowData(
      initials: 'EO',
      name: 'Emmanuel Okafor',
      id: '#TRX-88291',
      type: 'Send',
      typeIcon: Icons.arrow_outward,
      typeColor: PayRouteColors.dashboardPrimary,
      date: 'Oct 24, 2023',
      time: '09:42 AM',
      railLeft: 'M-Pesa',
      railRight: 'Flutterwave',
      status: 'Completed',
      statusColor: PayRouteColors.dashboardGreen,
      amount: '₦ 250,000.00',
      meta: 'Fee: ₦150',
    ),
    _ActivityRowData(
      initials: 'SJ',
      name: 'Sarah Jenkins',
      id: '#TRX-88290',
      type: 'Exchange',
      typeIcon: Icons.swap_horiz,
      typeColor: PayRouteColors.dashboardAccentOrange,
      date: 'Oct 24, 2023',
      time: '09:15 AM',
      railLeft: 'USDC',
      railRight: 'NGN Bank',
      status: 'Pending',
      statusColor: Color(0xFFF59E0B),
      amount: r'$ 1,500.00',
      meta: r'Rate: ₦1050/$',
    ),
    _ActivityRowData(
      initials: 'MT',
      name: 'Michael Taiwo',
      id: '#TRX-88289',
      type: 'Receive',
      typeIcon: Icons.arrow_downward,
      typeColor: PayRouteColors.dashboardGreen,
      date: 'Oct 23, 2023',
      time: '04:20 PM',
      railLeft: 'Card (Visa)',
      railRight: 'Wallet',
      status: 'Failed',
      statusColor: Color(0xFFEF4444),
      amount: '₦ 15,000.00',
      meta: 'Network Err',
      amountFailed: true,
    ),
    _ActivityRowData(
      initials: 'AZ',
      name: 'Azure Cloud Svc',
      id: '#TRX-88288',
      type: 'Payment',
      typeIcon: Icons.arrow_outward,
      typeColor: PayRouteColors.dashboardPrimary,
      date: 'Oct 23, 2023',
      time: '02:30 PM',
      railLeft: 'Wallet',
      railRight: 'Direct Debit',
      status: 'Completed',
      statusColor: PayRouteColors.dashboardGreen,
      amount: r'$ 129.99',
      meta: 'Sub ID: #8892',
    ),
    _ActivityRowData(
      initials: 'KW',
      name: 'Kenya Waters Ltd',
      id: '#TRX-88285',
      type: 'Bill Pay',
      typeIcon: Icons.arrow_outward,
      typeColor: PayRouteColors.dashboardPrimary,
      date: 'Oct 23, 2023',
      time: '11:05 AM',
      railLeft: 'M-Pesa',
      railRight: 'Utility API',
      status: 'Completed',
      statusColor: PayRouteColors.dashboardGreen,
      amount: 'KSh 4,500.00',
      meta: 'Auto-Pay',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final surface = DashboardPalette.surface(brightness);
    final border = DashboardPalette.border(brightness);
    return Container(
      decoration: BoxDecoration(
        color: surface.withValues(alpha: brightness == Brightness.dark ? 0.55 : 1),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: border),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Column(
          children: [
            _TableHeader(brightness: brightness),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ConstrainedBox(
                constraints: const BoxConstraints(minWidth: 980),
                child: Column(
                  children: [
                    for (final row in _rows) _TableRow(row: row, brightness: brightness),
                  ],
                ),
              ),
            ),
            _TableFooter(brightness: brightness),
          ],
        ),
      ),
    );
  }
}

class _TableHeader extends StatelessWidget {
  final Brightness brightness;

  const _TableHeader({required this.brightness});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: DashboardPalette.surfaceMuted(brightness).withValues(alpha: brightness == Brightness.dark ? 0.6 : 1),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 980),
          child: Row(
            children: [
              _HeaderCell(text: 'Recipient / ID', width: 260),
              _HeaderCell(text: 'Type', width: 120),
              _HeaderCell(text: 'Date & Time', width: 150),
              _HeaderCell(text: 'Routing Rail', width: 190),
              _HeaderCell(text: 'Status', width: 140),
              _HeaderCell(text: 'Amount', width: 150, alignRight: true),
              _HeaderCell(text: 'Action', width: 80, alignRight: true),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeaderCell extends StatelessWidget {
  final String text;
  final double width;
  final bool alignRight;

  const _HeaderCell({required this.text, required this.width, this.alignRight = false});

  @override
  Widget build(BuildContext context) {
    final b = Theme.of(context).brightness;
    return SizedBox(
      width: width,
      child: Align(
        alignment: alignRight ? Alignment.centerRight : Alignment.centerLeft,
        child: Text(
          text.toUpperCase(),
          style: GoogleFonts.inter(
            color: DashboardPalette.textSecondary(b),
            fontSize: 11,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.1,
          ),
        ),
      ),
    );
  }
}

class _TableRow extends StatelessWidget {
  final _ActivityRowData row;

  final Brightness brightness;

  const _TableRow({required this.row, required this.brightness});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: DashboardPalette.border(brightness))),
      ),
      child: Row(
        children: [
          SizedBox(width: 260, child: _RecipientCell(row: row)),
          SizedBox(width: 120, child: _TypeCell(row: row)),
          SizedBox(width: 150, child: _DateCell(row: row)),
          SizedBox(width: 190, child: _RailCell(row: row)),
          SizedBox(width: 140, child: _StatusCell(row: row)),
          SizedBox(width: 150, child: _AmountCell(row: row)),
          SizedBox(width: 80, child: Align(alignment: Alignment.centerRight, child: Icon(Icons.more_horiz, color: DashboardPalette.iconMuted(brightness)))),
        ],
      ),
    );
  }
}

class _RecipientCell extends StatelessWidget {
  final _ActivityRowData row;

  const _RecipientCell({required this.row});

  @override
  Widget build(BuildContext context) {
    final b = Theme.of(context).brightness;
    final textPrimary = DashboardPalette.textPrimary(b);
    final textSecondary = DashboardPalette.textSecondary(b);
    final avatarGradient = LinearGradient(colors: [row.typeColor.withValues(alpha: 0.9), row.typeColor.withValues(alpha: 0.55)]);
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            gradient: avatarGradient,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: DashboardPalette.border(b)),
          ),
          child: Center(
            child: Text(row.initials, style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 11)),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(row.name, style: GoogleFonts.inter(color: textPrimary, fontSize: 13, fontWeight: FontWeight.w700), overflow: TextOverflow.ellipsis),
              const SizedBox(height: 2),
              Text(row.id, style: GoogleFonts.robotoMono(color: textSecondary, fontSize: 11, fontWeight: FontWeight.w600), overflow: TextOverflow.ellipsis),
            ],
          ),
        ),
      ],
    );
  }
}

class _TypeCell extends StatelessWidget {
  final _ActivityRowData row;

  const _TypeCell({required this.row});

  @override
  Widget build(BuildContext context) {
    final b = Theme.of(context).brightness;
    final surface = DashboardPalette.surface(b);
    final border = DashboardPalette.border(b);
    final textSecondary = DashboardPalette.textSecondary(b);
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: surface.withValues(alpha: b == Brightness.dark ? 0.55 : 1),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(row.typeIcon, size: 16, color: row.typeColor),
            const SizedBox(width: 6),
            Text(row.type, style: GoogleFonts.inter(color: textSecondary, fontSize: 12, fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }
}

class _DateCell extends StatelessWidget {
  final _ActivityRowData row;

  const _DateCell({required this.row});

  @override
  Widget build(BuildContext context) {
    final b = Theme.of(context).brightness;
    final textSecondary = DashboardPalette.textSecondary(b);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(row.date, style: GoogleFonts.inter(color: textSecondary, fontSize: 12, fontWeight: FontWeight.w600)),
        const SizedBox(height: 2),
        Text(row.time, style: GoogleFonts.inter(color: textSecondary.withValues(alpha: 0.7), fontSize: 11, fontWeight: FontWeight.w600)),
      ],
    );
  }
}

class _RailCell extends StatelessWidget {
  final _ActivityRowData row;

  const _RailCell({required this.row});

  @override
  Widget build(BuildContext context) {
    final b = Theme.of(context).brightness;
    final textSecondary = DashboardPalette.textSecondary(b);
    return Row(
      children: [
        Expanded(child: Text(row.railLeft, style: GoogleFonts.inter(color: textSecondary, fontSize: 12, fontWeight: FontWeight.w700), overflow: TextOverflow.ellipsis)),
        const SizedBox(width: 6),
        Icon(Icons.arrow_forward, size: 14, color: textSecondary.withValues(alpha: 0.7)),
        const SizedBox(width: 6),
        Expanded(child: Text(row.railRight, style: GoogleFonts.inter(color: textSecondary, fontSize: 12, fontWeight: FontWeight.w700), overflow: TextOverflow.ellipsis)),
      ],
    );
  }
}

class _StatusCell extends StatelessWidget {
  final _ActivityRowData row;

  const _StatusCell({required this.row});

  @override
  Widget build(BuildContext context) {
    final bg = row.statusColor.withValues(alpha: 0.12);
    final border = row.statusColor.withValues(alpha: 0.22);
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 6, height: 6, decoration: BoxDecoration(color: row.statusColor, shape: BoxShape.circle)),
            const SizedBox(width: 8),
            Text(row.status, style: GoogleFonts.inter(color: row.statusColor, fontSize: 12, fontWeight: FontWeight.w800)),
          ],
        ),
      ),
    );
  }
}

class _AmountCell extends StatelessWidget {
  final _ActivityRowData row;

  const _AmountCell({required this.row});

  @override
  Widget build(BuildContext context) {
    final b = Theme.of(context).brightness;
    final textPrimary = DashboardPalette.textPrimary(b);
    final textSecondary = DashboardPalette.textSecondary(b);
    final amountStyle = GoogleFonts.inter(
      color: row.amountFailed ? textSecondary : textPrimary,
      fontSize: 13,
      fontWeight: FontWeight.w800,
      decoration: row.amountFailed ? TextDecoration.lineThrough : TextDecoration.none,
    );
    final metaStyle = GoogleFonts.inter(
      color: row.amountFailed ? const Color(0xFFFCA5A5) : textSecondary.withValues(alpha: 0.7),
      fontSize: 11,
      fontWeight: FontWeight.w700,
    );
    return Align(
      alignment: Alignment.centerRight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(row.amount, style: amountStyle),
          const SizedBox(height: 2),
          Text(row.meta, style: metaStyle, overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }
}

class _TableFooter extends StatelessWidget {
  final Brightness brightness;

  const _TableFooter({required this.brightness});

  @override
  Widget build(BuildContext context) {
    final textPrimary = DashboardPalette.textPrimary(brightness);
    final textSecondary = DashboardPalette.textSecondary(brightness);
    return Container(
      color: DashboardPalette.surfaceMuted(brightness).withValues(alpha: brightness == Brightness.dark ? 0.6 : 1),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      child: Row(
        children: [
          Text(
            'Showing ',
            style: GoogleFonts.inter(color: textSecondary, fontSize: 12, fontWeight: FontWeight.w600),
          ),
          Text('1', style: GoogleFonts.inter(color: textPrimary, fontSize: 12, fontWeight: FontWeight.w800)),
          Text(' to ', style: GoogleFonts.inter(color: textSecondary, fontSize: 12, fontWeight: FontWeight.w600)),
          Text('5', style: GoogleFonts.inter(color: textPrimary, fontSize: 12, fontWeight: FontWeight.w800)),
          Text(' of ', style: GoogleFonts.inter(color: textSecondary, fontSize: 12, fontWeight: FontWeight.w600)),
          Text('128', style: GoogleFonts.inter(color: textPrimary, fontSize: 12, fontWeight: FontWeight.w800)),
          Text(' results', style: GoogleFonts.inter(color: textSecondary, fontSize: 12, fontWeight: FontWeight.w600)),
          const Spacer(),
          _PagerButton(label: 'Previous', enabled: false, brightness: brightness),
          const SizedBox(width: 10),
          _PagerButton(label: 'Next', enabled: true, brightness: brightness),
        ],
      ),
    );
  }
}

class _PagerButton extends StatelessWidget {
  final String label;
  final bool enabled;

  final Brightness brightness;

  const _PagerButton({required this.label, required this.enabled, required this.brightness});

  @override
  Widget build(BuildContext context) {
    final border = DashboardPalette.border(brightness);
    final textSecondary = DashboardPalette.textSecondary(brightness);
    return Opacity(
      opacity: enabled ? 1 : 0.5,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: border),
        ),
        child: Text(label, style: GoogleFonts.inter(color: textSecondary, fontSize: 12, fontWeight: FontWeight.w700)),
      ),
    );
  }
}

class _ActivityRowData {
  final String initials;
  final String name;
  final String id;
  final String type;
  final IconData typeIcon;
  final Color typeColor;
  final String date;
  final String time;
  final String railLeft;
  final String railRight;
  final String status;
  final Color statusColor;
  final String amount;
  final String meta;
  final bool amountFailed;

  const _ActivityRowData({
    required this.initials,
    required this.name,
    required this.id,
    required this.type,
    required this.typeIcon,
    required this.typeColor,
    required this.date,
    required this.time,
    required this.railLeft,
    required this.railRight,
    required this.status,
    required this.statusColor,
    required this.amount,
    required this.meta,
    this.amountFailed = false,
  });
}
