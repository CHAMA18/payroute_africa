import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:payroute_desktop/theme.dart';
import 'package:payroute_desktop/widgets/finroute_responsive_scaffold.dart';
import 'package:payroute_desktop/providers/auth_provider.dart';
import 'package:payroute_desktop/models/transaction_model.dart';
import 'package:payroute_desktop/services/transaction_service.dart';

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
    if (b == Brightness.light) return const SizedBox.shrink();
    final bg = DashboardPalette.bg(b);
    final neutralA = Colors.white.withValues(alpha: 0.06);
    final neutralB = Colors.white.withValues(alpha: 0.035);
    return IgnorePointer(
      child: Stack(
        children: [
          Positioned(top: -160, left: -120, child: _GlowCircle(color: neutralA, size: 520)),
          Positioned(top: -120, right: -160, child: _GlowCircle(color: neutralB, size: 460)),
          Positioned(
            bottom: -40,
            left: -20,
            right: -20,
            child: Container(
              height: 320,
              decoration: BoxDecoration(
                gradient: LinearGradient(begin: Alignment.bottomCenter, end: Alignment.topCenter, colors: [bg, Colors.transparent]),
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
        boxShadow: [BoxShadow(color: color, blurRadius: 120, spreadRadius: 40)],
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
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(999), borderSide: BorderSide(color: PayRouteColors.dashboardPrimary.withValues(alpha: 0.5))),
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

        Widget buildAvatar(String? photoUrl, String initials, Color border, Color bg) {
          return Stack(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: border),
                  image: photoUrl != null ? DecorationImage(image: NetworkImage(photoUrl), fit: BoxFit.cover) : null,
                  color: photoUrl == null ? PayRouteColors.dashboardPrimary : null,
                ),
                child: photoUrl == null ? Center(child: Text(initials, style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16))) : null,
              ),
              Positioned(
                bottom: 2,
                right: 2,
                child: Container(width: 10, height: 10, decoration: BoxDecoration(color: PayRouteColors.dashboardGreen, shape: BoxShape.circle, border: Border.all(color: bg, width: 2))),
              ),
            ],
          );
        }

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
                Consumer<AuthProvider>(
                  builder: (context, authProvider, _) {
                    final user = authProvider.userModel;
                    final firebaseUser = authProvider.firebaseUser;
                    final displayName = user?.displayName ?? firebaseUser?.email?.split('@')[0] ?? 'User';
                    final displayRole = user?.displayRole ?? 'User';
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(displayName, style: GoogleFonts.inter(color: textPrimary, fontWeight: FontWeight.w700), overflow: TextOverflow.ellipsis),
                        Text(displayRole, style: GoogleFonts.inter(color: textSecondary, fontSize: 12)),
                      ],
                    );
                  },
                ),
                const SizedBox(width: 12),
              ],
              Consumer<AuthProvider>(
                builder: (context, authProvider, _) {
                  final user = authProvider.userModel;
                  final firebaseUser = authProvider.firebaseUser;
                  final photoUrl = user?.photoUrl ?? firebaseUser?.photoURL;
                  final initials = user?.initials ?? 'U';
                  return buildAvatar(photoUrl, initials, border, bg);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ActivityBody extends StatefulWidget {
  final Brightness brightness;

  const _ActivityBody({required this.brightness});

  @override
  State<_ActivityBody> createState() => _ActivityBodyState();
}

class _ActivityBodyState extends State<_ActivityBody> {
  final TransactionService _transactionService = TransactionService();
  List<TransactionModel> _transactions = [];
  Map<String, dynamic> _kpis = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final authProvider = context.read<AuthProvider>();
    final userId = authProvider.firebaseUser?.uid;

    if (userId != null) {
      final transactions = await _transactionService.getTransactionsByUserId(userId);
      final kpis = await _transactionService.getTransactionKPIs(userId);

      if (mounted) {
        setState(() {
          _transactions = transactions;
          _kpis = kpis;
          _isLoading = false;
        });
      }
    } else {
      // If no user ID, try fetching all transactions (for demo purposes)
      final transactions = await _transactionService.getAllTransactions();
      if (mounted) {
        setState(() {
          _transactions = transactions;
          _kpis = {
            'totalVolume': transactions.fold(0.0, (sum, tx) => sum + tx.amount),
            'successfulTransfers': transactions.where((tx) => tx.status == TransactionStatus.completed).length,
            'avgFeeSaved': transactions.where((tx) => tx.feeSaved != null && tx.feeSaved! > 0).fold(0.0, (sum, tx) => sum + (tx.feeSaved ?? 0)) / (transactions.where((tx) => tx.feeSaved != null && tx.feeSaved! > 0).length.clamp(1, 9999)),
            'totalTransactions': transactions.length,
          };
          _isLoading = false;
        });
      }
    }
  }

  String _formatVolume(double volume) {
    if (volume >= 1000000) {
      return '₦${(volume / 1000000).toStringAsFixed(1)}M';
    } else if (volume >= 1000) {
      return '₦${volume.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}';
    }
    return '₦${volume.toStringAsFixed(2)}';
  }

  String _formatNumber(int number) {
    return number.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},');
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final padding = constraints.maxWidth < 600 ? 16.0 : 24.0;
        return SingleChildScrollView(
          padding: EdgeInsets.all(padding),
          child: Column(
            children: [
              _KpiRow(
                brightness: widget.brightness,
                isLoading: _isLoading,
                totalVolume: _formatVolume((_kpis['totalVolume'] ?? 0).toDouble()),
                successfulTransfers: _formatNumber((_kpis['successfulTransfers'] ?? 0) as int),
                avgFeeSaved: '₦${((_kpis['avgFeeSaved'] ?? 0).toDouble()).toStringAsFixed(2)}/tx',
              ),
              const SizedBox(height: 20),
              _FiltersRow(brightness: widget.brightness),
              const SizedBox(height: 16),
              _ActivityTable(
                brightness: widget.brightness,
                transactions: _transactions,
                isLoading: _isLoading,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _KpiRow extends StatelessWidget {
  final Brightness brightness;
  final bool isLoading;
  final String totalVolume;
  final String successfulTransfers;
  final String avgFeeSaved;

  const _KpiRow({
    required this.brightness,
    required this.isLoading,
    required this.totalVolume,
    required this.successfulTransfers,
    required this.avgFeeSaved,
  });

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
            value: isLoading ? '...' : totalVolume,
            delta: '12.5%',
            deltaColor: PayRouteColors.dashboardGreen,
            brightness: brightness,
            isLoading: isLoading,
          ),
          _KpiCard(
            icon: Icons.check_circle,
            iconBg: PayRouteColors.dashboardGreen,
            label: 'Successful Transfers',
            value: isLoading ? '...' : successfulTransfers,
            delta: '5.2%',
            deltaColor: PayRouteColors.dashboardGreen,
            brightness: brightness,
            isLoading: isLoading,
          ),
          _KpiCard(
            icon: Icons.savings,
            iconBg: PayRouteColors.dashboardAccentOrange,
            label: 'Avg Fee Saved',
            value: isLoading ? '...' : avgFeeSaved,
            delta: '2.4%',
            deltaColor: PayRouteColors.dashboardGreen,
            brightness: brightness,
            isLoading: isLoading,
          ),
        ];

        if (isNarrow) {
          return Column(children: [for (final child in children) ...[child, const SizedBox(height: 14)]]);
        }

        return Row(children: [for (var i = 0; i < children.length; i++) ...[Expanded(child: children[i]), if (i != children.length - 1) const SizedBox(width: 16)]]);
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
  final bool isLoading;

  const _KpiCard({
    required this.icon,
    required this.iconBg,
    required this.label,
    required this.value,
    required this.delta,
    required this.deltaColor,
    required this.brightness,
    this.isLoading = false,
  });

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
          isLoading
              ? Container(
                  height: 26,
                  width: 100,
                  decoration: BoxDecoration(color: textSecondary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                )
              : Text(value, style: GoogleFonts.inter(color: textPrimary, fontSize: 26, fontWeight: FontWeight.w800, letterSpacing: -0.5)),
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
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: DashboardPalette.border(brightness))),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: DashboardPalette.border(brightness))),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: PayRouteColors.dashboardPrimary.withValues(alpha: 0.5))),
            ),
          ),
        );

        if (isNarrow) {
          return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [left, const SizedBox(height: 12), right]);
        }

        return Row(children: [left, const Spacer(), right]);
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
      decoration: BoxDecoration(color: surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: border)),
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
        boxShadow: [BoxShadow(color: PayRouteColors.dashboardPrimary.withValues(alpha: 0.25), blurRadius: 18, spreadRadius: 2)],
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
  final List<TransactionModel> transactions;
  final bool isLoading;

  const _ActivityTable({
    required this.brightness,
    required this.transactions,
    this.isLoading = false,
  });

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
            if (isLoading)
              _LoadingState(brightness: brightness)
            else if (transactions.isEmpty)
              _EmptyState(brightness: brightness)
            else
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(minWidth: 980),
                  child: Column(children: [for (final tx in transactions) _TableRow(transaction: tx, brightness: brightness)]),
                ),
              ),
            if (transactions.isNotEmpty) _TableFooter(brightness: brightness, totalCount: transactions.length),
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
        child: Text(text.toUpperCase(), style: GoogleFonts.inter(color: DashboardPalette.textSecondary(b), fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 1.1)),
      ),
    );
  }
}

class _TableRow extends StatelessWidget {
  final TransactionModel transaction;
  final Brightness brightness;

  const _TableRow({required this.transaction, required this.brightness});

  Color get _typeColor {
    switch (transaction.type) {
      case TransactionType.send:
        return PayRouteColors.dashboardPrimary;
      case TransactionType.receive:
        return PayRouteColors.dashboardGreen;
      case TransactionType.exchange:
        return PayRouteColors.dashboardAccentOrange;
      case TransactionType.withdrawal:
        return const Color(0xFF8B5CF6);
    }
  }

  IconData get _typeIcon {
    switch (transaction.type) {
      case TransactionType.send:
        return Icons.arrow_upward;
      case TransactionType.receive:
        return Icons.arrow_downward;
      case TransactionType.exchange:
        return Icons.swap_horiz;
      case TransactionType.withdrawal:
        return Icons.account_balance;
    }
  }

  Color get _statusColor {
    switch (transaction.status) {
      case TransactionStatus.completed:
        return PayRouteColors.dashboardGreen;
      case TransactionStatus.pending:
        return PayRouteColors.dashboardAccentOrange;
      case TransactionStatus.processing:
        return const Color(0xFF3B82F6);
      case TransactionStatus.failed:
        return const Color(0xFFEF4444);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textPrimary = DashboardPalette.textPrimary(brightness);
    final textSecondary = DashboardPalette.textSecondary(brightness);
    final border = DashboardPalette.border(brightness);
    final surface = DashboardPalette.surface(brightness);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: border))),
      child: Row(
        children: [
          // Recipient Cell
          SizedBox(
            width: 260,
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [_typeColor.withValues(alpha: 0.9), _typeColor.withValues(alpha: 0.55)]),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: border),
                  ),
                  child: Center(child: Text(transaction.initials, style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 11))),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(transaction.recipientName, style: GoogleFonts.inter(color: textPrimary, fontSize: 13, fontWeight: FontWeight.w700), overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 2),
                      Text(transaction.recipientId, style: GoogleFonts.robotoMono(color: textSecondary, fontSize: 11, fontWeight: FontWeight.w600), overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Type Cell
          SizedBox(
            width: 120,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: surface.withValues(alpha: brightness == Brightness.dark ? 0.55 : 1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: border),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(_typeIcon, size: 16, color: _typeColor),
                    const SizedBox(width: 6),
                    Text(transaction.typeLabel, style: GoogleFonts.inter(color: textSecondary, fontSize: 12, fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
            ),
          ),
          // Date Cell
          SizedBox(
            width: 150,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(transaction.formattedDate, style: GoogleFonts.inter(color: textSecondary, fontSize: 12, fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text(transaction.formattedTime, style: GoogleFonts.inter(color: textSecondary.withValues(alpha: 0.7), fontSize: 11, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          // Rail Cell
          SizedBox(
            width: 190,
            child: Row(
              children: [
                Expanded(child: Text(transaction.sourceRail, style: GoogleFonts.inter(color: textSecondary, fontSize: 12, fontWeight: FontWeight.w700), overflow: TextOverflow.ellipsis)),
                const SizedBox(width: 6),
                Icon(Icons.arrow_forward, size: 14, color: textSecondary.withValues(alpha: 0.7)),
                const SizedBox(width: 6),
                Expanded(child: Text(transaction.destinationRail, style: GoogleFonts.inter(color: textSecondary, fontSize: 12, fontWeight: FontWeight.w700), overflow: TextOverflow.ellipsis)),
              ],
            ),
          ),
          // Status Cell
          SizedBox(
            width: 140,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                decoration: BoxDecoration(
                  color: _statusColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: _statusColor.withValues(alpha: 0.22)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(width: 6, height: 6, decoration: BoxDecoration(color: _statusColor, shape: BoxShape.circle)),
                    const SizedBox(width: 8),
                    Text(transaction.statusLabel, style: GoogleFonts.inter(color: _statusColor, fontSize: 12, fontWeight: FontWeight.w800)),
                  ],
                ),
              ),
            ),
          ),
          // Amount Cell
          SizedBox(
            width: 150,
            child: Align(
              alignment: Alignment.centerRight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    transaction.formattedAmount,
                    style: GoogleFonts.inter(
                      color: transaction.status == TransactionStatus.failed ? textSecondary : textPrimary,
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      decoration: transaction.status == TransactionStatus.failed ? TextDecoration.lineThrough : TextDecoration.none,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    transaction.feeSaved != null && transaction.feeSaved! > 0 ? 'Saved ₦${transaction.feeSaved!.toStringAsFixed(2)}' : transaction.currency,
                    style: GoogleFonts.inter(
                      color: transaction.status == TransactionStatus.failed ? const Color(0xFFFCA5A5) : textSecondary.withValues(alpha: 0.7),
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
          // Action Cell
          SizedBox(width: 80, child: Align(alignment: Alignment.centerRight, child: Icon(Icons.more_horiz, color: DashboardPalette.iconMuted(brightness)))),
        ],
      ),
    );
  }
}

class _TableFooter extends StatelessWidget {
  final Brightness brightness;
  final int totalCount;

  const _TableFooter({required this.brightness, required this.totalCount});

  @override
  Widget build(BuildContext context) {
    final textPrimary = DashboardPalette.textPrimary(brightness);
    final textSecondary = DashboardPalette.textSecondary(brightness);
    final showingEnd = totalCount > 10 ? 10 : totalCount;
    return Container(
      color: DashboardPalette.surfaceMuted(brightness).withValues(alpha: brightness == Brightness.dark ? 0.6 : 1),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      child: Row(
        children: [
          Text('Showing ', style: GoogleFonts.inter(color: textSecondary, fontSize: 12, fontWeight: FontWeight.w600)),
          Text('1', style: GoogleFonts.inter(color: textPrimary, fontSize: 12, fontWeight: FontWeight.w800)),
          Text(' to ', style: GoogleFonts.inter(color: textSecondary, fontSize: 12, fontWeight: FontWeight.w600)),
          Text('$showingEnd', style: GoogleFonts.inter(color: textPrimary, fontSize: 12, fontWeight: FontWeight.w800)),
          Text(' of ', style: GoogleFonts.inter(color: textSecondary, fontSize: 12, fontWeight: FontWeight.w600)),
          Text('$totalCount', style: GoogleFonts.inter(color: textPrimary, fontSize: 12, fontWeight: FontWeight.w800)),
          Text(' results', style: GoogleFonts.inter(color: textSecondary, fontSize: 12, fontWeight: FontWeight.w600)),
          const Spacer(),
          _PagerButton(label: 'Previous', enabled: false, brightness: brightness),
          const SizedBox(width: 10),
          _PagerButton(label: 'Next', enabled: totalCount > 10, brightness: brightness),
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
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(color: border)),
        child: Text(label, style: GoogleFonts.inter(color: textSecondary, fontSize: 12, fontWeight: FontWeight.w700)),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final Brightness brightness;

  const _EmptyState({required this.brightness});

  @override
  Widget build(BuildContext context) {
    final textSecondary = DashboardPalette.textSecondary(brightness);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox_outlined, size: 48, color: textSecondary.withValues(alpha: 0.5)),
          const SizedBox(height: 16),
          Text('No transactions yet', style: GoogleFonts.inter(color: textSecondary, fontSize: 14, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _LoadingState extends StatelessWidget {
  final Brightness brightness;

  const _LoadingState({required this.brightness});

  @override
  Widget build(BuildContext context) {
    final textSecondary = DashboardPalette.textSecondary(brightness);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 32,
            height: 32,
            child: CircularProgressIndicator(color: PayRouteColors.dashboardPrimary, strokeWidth: 3),
          ),
          const SizedBox(height: 16),
          Text('Loading transactions...', style: GoogleFonts.inter(color: textSecondary, fontSize: 14, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
