import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:payroute_desktop/theme.dart';
import 'package:payroute_desktop/widgets/finroute_responsive_scaffold.dart';

const Color _settingsPrimary = Color(0xFF256AF4);
const Color _settingsAccentOrange = Color(0xFFF47E25);
const Color _settingsNeonBlue = Color(0xFF00F2FF);
const Color _settingsPurple = Color(0xFFA855F7);

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final TextEditingController _nameController = TextEditingController(text: 'Tunde Adebayo');
  final TextEditingController _emailController = TextEditingController(text: 'tunde.a@finroute.io');

  bool _twoFactorEnabled = true;
  bool _biometricEnabled = false;
  bool _dynamicRoutingEnabled = true;
  String _region = 'Lagos, Nigeria';

  void _saveChanges() {}

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return FinRouteResponsiveScaffold(
      selectedLabel: 'Settings',
      background: const _SettingsGlowBackground(),
      desktopHeader: _SettingsHeader(
        brightness: brightness,
        onSave: _saveChanges,
      ),
      mobileTitle: 'Account Settings',
      mobileSubtitle: 'Configure your personal preferences and developer tools',
      mobileActions: [
        IconButton(
          onPressed: _saveChanges,
          style: const ButtonStyle(overlayColor: WidgetStatePropertyAll(Colors.transparent)),
          icon: const Icon(Icons.save, color: _settingsPrimary),
          tooltip: 'Save changes',
        ),
      ],
      child: LayoutBuilder(
        builder: (context, constraints) {
          final padding = constraints.maxWidth < 600 ? 16.0 : 24.0;
          return SingleChildScrollView(
            padding: EdgeInsets.all(padding),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1040),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _AccountProfileSection(
                      nameController: _nameController,
                      emailController: _emailController,
                      region: _region,
                      onRegionChanged: (value) => setState(() => _region = value),
                    ),
                    const SizedBox(height: 24),
                    _SecuritySection(
                      twoFactorEnabled: _twoFactorEnabled,
                      biometricEnabled: _biometricEnabled,
                      onTwoFactorChanged: (value) => setState(() => _twoFactorEnabled = value),
                      onBiometricChanged: (value) => setState(() => _biometricEnabled = value),
                    ),
                    const SizedBox(height: 24),
                    _PaymentPreferencesSection(
                      dynamicRoutingEnabled: _dynamicRoutingEnabled,
                      onDynamicRoutingChanged: (value) => setState(() => _dynamicRoutingEnabled = value),
                    ),
                    const SizedBox(height: 24),
                    const _DeveloperApiSection(),
                    const SizedBox(height: 24),
                    const _LastSavedRow(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _SettingsGlowBackground extends StatelessWidget {
  const _SettingsGlowBackground();

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    if (brightness == Brightness.light) return const SizedBox.shrink();
    final bg = DashboardPalette.bg(brightness);
    return IgnorePointer(
      child: Stack(
        children: [
          Positioned(
            top: -180,
            left: -140,
            child: _GlowCircle(
              color: _settingsPrimary.withValues(alpha: 0.14),
              size: 640,
            ),
          ),
          Positioned(
            bottom: -140,
            right: -160,
            child: _GlowCircle(
              color: _settingsAccentOrange.withValues(alpha: 0.08),
              size: 560,
            ),
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
          BoxShadow(color: color, blurRadius: 140, spreadRadius: 50),
        ],
      ),
    );
  }
}

class _SettingsHeader extends StatelessWidget {
  final Brightness brightness;
  final VoidCallback onSave;

  const _SettingsHeader({
    required this.brightness,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    final bg = DashboardPalette.bg(brightness);
    final border = DashboardPalette.border(brightness);
    final textPrimary = DashboardPalette.textPrimary(brightness);
    final textSecondary = DashboardPalette.textSecondary(brightness);

    return LayoutBuilder(
      builder: (context, constraints) {
        final isTight = constraints.maxWidth < 960;
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
          decoration: BoxDecoration(
            color: brightness == Brightness.dark ? bg.withValues(alpha: 0.86) : bg,
            border: Border(bottom: BorderSide(color: border)),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Account Settings',
                      style: GoogleFonts.inter(color: textPrimary, fontWeight: FontWeight.w800, fontSize: 22),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Configure your personal preferences and developer environment',
                      style: GoogleFonts.inter(color: textSecondary, fontSize: 12),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              if (isTight)
                IconButton(
                  onPressed: onSave,
                  style: const ButtonStyle(overlayColor: WidgetStatePropertyAll(Colors.transparent)),
                  icon: const Icon(Icons.save, color: _settingsPrimary),
                  tooltip: 'Save changes',
                )
              else
                _GlowButton(label: 'Save Changes', onPressed: onSave),
              if (!isTight) ...[
                const SizedBox(width: 16),
                Container(width: 1, height: 24, color: border),
                const SizedBox(width: 16),
                const _ProfileAvatar(),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _ProfileAvatar extends StatelessWidget {
  const _ProfileAvatar();

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final border = DashboardPalette.border(brightness);
    final bg = DashboardPalette.bg(brightness);
    return Stack(
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
            decoration: BoxDecoration(
              color: PayRouteColors.dashboardGreen,
              shape: BoxShape.circle,
              border: Border.all(color: bg, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}

class _GlowButton extends StatefulWidget {
  final String label;
  final VoidCallback onPressed;

  const _GlowButton({required this.label, required this.onPressed});

  @override
  State<_GlowButton> createState() => _GlowButtonState();
}

class _GlowButtonState extends State<_GlowButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [_settingsPrimary, _settingsNeonBlue]),
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: _settingsPrimary.withValues(alpha: _hovered ? 0.55 : 0.35),
                blurRadius: _hovered ? 26 : 18,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Text(
            widget.label,
            style: GoogleFonts.inter(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700),
          ),
        ),
      ),
    );
  }
}

class _GlassPanel extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;

  const _GlassPanel({required this.child, this.padding = const EdgeInsets.all(24)});

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final border = DashboardPalette.border(brightness);
    final base = DashboardPalette.surface(brightness);
    final gradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        base.withValues(alpha: brightness == Brightness.dark ? 0.75 : 1),
        base.withValues(alpha: brightness == Brightness.dark ? 0.5 : 1),
      ],
    );

    final panel = Container(
      padding: padding,
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: border),
      ),
      child: child,
    );

    if (brightness == Brightness.light) {
      return panel;
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: panel,
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final Color accentColor;
  final String title;
  final String subtitle;

  const _SectionHeader({
    required this.icon,
    required this.accentColor,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final textPrimary = DashboardPalette.textPrimary(Theme.of(context).brightness);
    final textSecondary = DashboardPalette.textSecondary(Theme.of(context).brightness);
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: accentColor.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(icon, color: accentColor, size: 24),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.inter(color: textPrimary, fontWeight: FontWeight.w800, fontSize: 20),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: GoogleFonts.inter(color: textSecondary, fontSize: 12),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _AccountProfileSection extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final String region;
  final ValueChanged<String> onRegionChanged;

  const _AccountProfileSection({
    required this.nameController,
    required this.emailController,
    required this.region,
    required this.onRegionChanged,
  });

  @override
  Widget build(BuildContext context) {
    const regionOptions = [
      'Lagos, Nigeria',
      'Nairobi, Kenya',
      'Accra, Ghana',
      'Johannesburg, SA',
    ];

    return _GlassPanel(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isCompact = constraints.maxWidth < 720;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _SectionHeader(
                icon: Icons.person,
                accentColor: _settingsPrimary,
                title: 'Account Profile',
                subtitle: 'Update your public information and profile details',
              ),
              const SizedBox(height: 24),
              if (isCompact) ...[
                _SettingsTextField(
                  label: 'Full Name',
                  controller: nameController,
                  keyboardType: TextInputType.name,
                ),
                const SizedBox(height: 16),
                _SettingsTextField(
                  label: 'Email Address',
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                _SettingsDropdownField(
                  label: 'Region',
                  value: region,
                  items: regionOptions,
                  onChanged: onRegionChanged,
                ),
                const SizedBox(height: 16),
                const _SettingsReadOnlyField(label: 'Role', value: 'Administrator'),
              ] else ...[
                Row(
                  children: [
                    Expanded(
                      child: _SettingsTextField(
                        label: 'Full Name',
                        controller: nameController,
                        keyboardType: TextInputType.name,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _SettingsTextField(
                        label: 'Email Address',
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _SettingsDropdownField(
                        label: 'Region',
                        value: region,
                        items: regionOptions,
                        onChanged: onRegionChanged,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(child: _SettingsReadOnlyField(label: 'Role', value: 'Administrator')),
                  ],
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _SettingsTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final TextInputType keyboardType;

  const _SettingsTextField({
    required this.label,
    required this.controller,
    required this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final border = DashboardPalette.border(brightness);
    final textPrimary = DashboardPalette.textPrimary(brightness);
    final textSecondary = DashboardPalette.textSecondary(brightness);
    final fill = brightness == Brightness.dark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.04);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: GoogleFonts.inter(color: textSecondary, fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 1.2),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: fill,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: border),
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            cursorColor: _settingsPrimary,
            style: GoogleFonts.inter(color: textPrimary, fontSize: 14, fontWeight: FontWeight.w500),
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
        ),
      ],
    );
  }
}

class _SettingsDropdownField extends StatelessWidget {
  final String label;
  final String value;
  final List<String> items;
  final ValueChanged<String> onChanged;

  const _SettingsDropdownField({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final border = DashboardPalette.border(brightness);
    final textPrimary = DashboardPalette.textPrimary(brightness);
    final textSecondary = DashboardPalette.textSecondary(brightness);
    final fill = brightness == Brightness.dark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.04);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: GoogleFonts.inter(color: textSecondary, fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 1.2),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
          decoration: BoxDecoration(
            color: fill,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: border),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              icon: Icon(Icons.expand_more, color: textSecondary),
              dropdownColor: DashboardPalette.surface(brightness),
              style: GoogleFonts.inter(color: textPrimary, fontSize: 14, fontWeight: FontWeight.w500),
              onChanged: (next) {
                if (next == null) return;
                onChanged(next);
              },
              items: items
                  .map(
                    (item) => DropdownMenuItem<String>(
                      value: item,
                      child: Text(item, overflow: TextOverflow.ellipsis),
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }
}

class _SettingsReadOnlyField extends StatelessWidget {
  final String label;
  final String value;

  const _SettingsReadOnlyField({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final border = DashboardPalette.border(brightness);
    final textSecondary = DashboardPalette.textSecondary(brightness);
    final fill = brightness == Brightness.dark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.04);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: GoogleFonts.inter(color: textSecondary, fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 1.2),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: fill,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: border),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  value,
                  style: GoogleFonts.inter(color: textSecondary, fontSize: 14, fontWeight: FontWeight.w600),
                ),
              ),
              Icon(Icons.lock, color: textSecondary, size: 16),
            ],
          ),
        ),
      ],
    );
  }
}

class _SecuritySection extends StatelessWidget {
  final bool twoFactorEnabled;
  final bool biometricEnabled;
  final ValueChanged<bool> onTwoFactorChanged;
  final ValueChanged<bool> onBiometricChanged;

  const _SecuritySection({
    required this.twoFactorEnabled,
    required this.biometricEnabled,
    required this.onTwoFactorChanged,
    required this.onBiometricChanged,
  });

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final textSecondary = DashboardPalette.textSecondary(brightness);
    final iconMuted = DashboardPalette.iconMuted(brightness);
    return _GlassPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionHeader(
            icon: Icons.shield,
            accentColor: _settingsNeonBlue,
            title: 'Security & Privacy',
            subtitle: 'Secure your account with multi-factor authentication',
          ),
          const SizedBox(height: 24),
          _SettingsRow(
            icon: Icons.security,
            iconColor: _settingsPrimary,
            title: 'Two-Factor Authentication (2FA)',
            subtitle: 'Secure your login with a mobile authenticator app',
            trailing: _NeonSwitch(value: twoFactorEnabled, onChanged: onTwoFactorChanged, activeColor: _settingsNeonBlue),
          ),
          const SizedBox(height: 12),
          _SettingsRow(
            icon: Icons.fingerprint,
            iconColor: _settingsNeonBlue,
            title: 'Biometric Login',
            subtitle: 'Use FaceID or fingerprint for faster transactions',
            trailing: _NeonSwitch(value: biometricEnabled, onChanged: onBiometricChanged, activeColor: _settingsNeonBlue),
          ),
          const SizedBox(height: 24),
          Text(
            'ACTIVE SESSIONS',
            style: GoogleFonts.inter(color: textSecondary, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1.2),
          ),
          const SizedBox(height: 12),
          _SettingsRow(
            icon: Icons.laptop_mac,
            iconColor: iconMuted,
            title: 'MacBook Pro 16" - Lagos, NG',
            subtitle: 'Current Session',
            subtitleColor: PayRouteColors.dashboardGreen,
            trailing: _TextPillButton(
              label: 'Terminate',
              color: Colors.redAccent,
              onPressed: () {},
            ),
          ),
          const SizedBox(height: 12),
          _SettingsRow(
            icon: Icons.phone_iphone,
            iconColor: iconMuted,
            title: 'iPhone 15 Pro - Abuja, NG',
            subtitle: 'Last active: 2 hours ago',
            trailing: _TextPillButton(
              label: 'Terminate',
              color: Colors.redAccent,
              onPressed: () {},
            ),
            subdued: true,
          ),
        ],
      ),
    );
  }
}

class _SettingsRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final Color? subtitleColor;
  final Widget trailing;
  final bool subdued;

  const _SettingsRow({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.trailing,
    this.subtitleColor,
    this.subdued = false,
  });

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final border = DashboardPalette.border(brightness);
    final textPrimary = DashboardPalette.textPrimary(brightness);
    final textSecondary = DashboardPalette.textSecondary(brightness);
    final fill = brightness == Brightness.dark ? Colors.white.withValues(alpha: 0.03) : DashboardPalette.surfaceMuted(brightness);
    return Opacity(
      opacity: subdued ? 0.6 : 1,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: fill,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: border),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(color: textPrimary, fontSize: 13, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: GoogleFonts.inter(color: subtitleColor ?? textSecondary, fontSize: 11),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            trailing,
          ],
        ),
      ),
    );
  }
}

class _TextPillButton extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onPressed;

  const _TextPillButton({
    required this.label,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: color,
        textStyle: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      ),
      child: Text(label),
    );
  }
}

class _NeonSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final Color activeColor;

  const _NeonSwitch({
    required this.value,
    required this.onChanged,
    required this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final offTrack = brightness == Brightness.dark ? Colors.white.withValues(alpha: 0.08) : Colors.black.withValues(alpha: 0.08);
    final offKnob = brightness == Brightness.dark ? Colors.white.withValues(alpha: 0.45) : Colors.black.withValues(alpha: 0.5);
    final trackColor = value ? activeColor.withValues(alpha: 0.2) : offTrack;
    final knobColor = value ? activeColor : offKnob;

    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        width: 46,
        height: 24,
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: trackColor,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: value ? activeColor.withValues(alpha: 0.7) : DashboardPalette.border(brightness)),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: knobColor,
              shape: BoxShape.circle,
              boxShadow: value
                  ? [
                      BoxShadow(color: activeColor.withValues(alpha: 0.9), blurRadius: 10, spreadRadius: 1),
                    ]
                  : null,
            ),
          ),
        ),
      ),
    );
  }
}

class _PaymentPreferencesSection extends StatelessWidget {
  final bool dynamicRoutingEnabled;
  final ValueChanged<bool> onDynamicRoutingChanged;

  const _PaymentPreferencesSection({
    required this.dynamicRoutingEnabled,
    required this.onDynamicRoutingChanged,
  });

  @override
  Widget build(BuildContext context) {
    return _GlassPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionHeader(
            icon: Icons.payments,
            accentColor: _settingsAccentOrange,
            title: 'Payment Preferences',
            subtitle: 'Manage default routing rules and settlement accounts',
          ),
          const SizedBox(height: 24),
          _SettingsRow(
            icon: Icons.account_balance,
            iconColor: DashboardPalette.iconMuted(Theme.of(context).brightness),
            title: 'Primary Settlement Account',
            subtitle: 'Access Bank - **** 8821 (NGN)',
            trailing: _ChipActionButton(
              label: 'Change',
              color: _settingsPrimary,
              onPressed: () {},
            ),
          ),
          const SizedBox(height: 12),
          _SettingsRow(
            icon: Icons.route,
            iconColor: DashboardPalette.iconMuted(Theme.of(context).brightness),
            title: 'Dynamic Routing',
            subtitle: 'Optimize for lowest transaction fees across rails',
            trailing: _NeonSwitch(value: dynamicRoutingEnabled, onChanged: onDynamicRoutingChanged, activeColor: _settingsNeonBlue),
          ),
        ],
      ),
    );
  }
}

class _ChipActionButton extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onPressed;

  const _ChipActionButton({
    required this.label,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: color,
        backgroundColor: color.withValues(alpha: 0.08),
        textStyle: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Text(label),
    );
  }
}

class _DeveloperApiSection extends StatelessWidget {
  const _DeveloperApiSection();

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final textSecondary = DashboardPalette.textSecondary(brightness);
    return _GlassPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionHeader(
            icon: Icons.code,
            accentColor: _settingsPurple,
            title: 'Developer API',
            subtitle: 'Manage your integration keys and webhook endpoints',
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Live Secret Key',
                  style: GoogleFonts.inter(color: textSecondary, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1.1),
                ),
              ),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  foregroundColor: _settingsPrimary,
                  textStyle: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700),
                ),
                child: const Text('Roll Key'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: brightness == Brightness.dark ? Colors.black.withValues(alpha: 0.45) : Colors.black.withValues(alpha: 0.04),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: DashboardPalette.border(brightness)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'sk_live_****************4f2a',
                    style: GoogleFonts.robotoMono(color: textSecondary, fontSize: 12, fontWeight: FontWeight.w500),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.content_copy, size: 18, color: textSecondary),
                  tooltip: 'Copy',
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: brightness == Brightness.dark ? Colors.black.withValues(alpha: 0.4) : Colors.black.withValues(alpha: 0.04),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: DashboardPalette.border(brightness)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(color: PayRouteColors.dashboardGreen, shape: BoxShape.circle),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'WEBHOOK ENDPOINT',
                      style: GoogleFonts.robotoMono(color: textSecondary, fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 1.2),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  'https://api.yourcompany.com/v1/webhooks/finroute-payload-v2',
                  style: GoogleFonts.robotoMono(color: _settingsNeonBlue, fontSize: 12, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Review your integration secrets and webhook endpoints regularly.',
            style: GoogleFonts.inter(color: textSecondary, fontSize: 11),
          ),
        ],
      ),
    );
  }
}

class _LastSavedRow extends StatelessWidget {
  const _LastSavedRow();

  @override
  Widget build(BuildContext context) {
    final textSecondary = DashboardPalette.textSecondary(Theme.of(context).brightness);
    return Align(
      alignment: Alignment.centerRight,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.info_outline, size: 16, color: textSecondary),
          const SizedBox(width: 8),
          Text(
            'Last saved: Today at 09:42 AM',
            style: GoogleFonts.inter(color: textSecondary, fontSize: 11, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
