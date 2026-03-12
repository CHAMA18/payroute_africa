import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:payroute_desktop/theme.dart';
import 'package:payroute_desktop/widgets/finroute_responsive_scaffold.dart';

class CrossBorderPage extends StatelessWidget {
  const CrossBorderPage({super.key});

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;

    return FinRouteResponsiveScaffold(
      selectedLabel: 'Cross-Border',
      mobileTitle: 'Cross-Border',
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.public_rounded,
              size: 80,
              color: DashboardPalette.iconMuted(brightness),
            ),
            const SizedBox(height: 24),
            Text(
              'Cross-Border Transactions',
              style: GoogleFonts.outfit(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: DashboardPalette.textPrimary(brightness),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Manage your international transfers and global payments.',
              style: GoogleFonts.outfit(
                fontSize: 16,
                color: DashboardPalette.textSecondary(brightness),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
