import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:payroute_desktop/nav.dart';
import 'package:payroute_desktop/theme.dart';
import 'package:payroute_desktop/providers/organization_application_provider.dart';

enum IdentityDocType { nationalId, passport, driversLicense }

class AuthorizedRepPage extends StatefulWidget {
  const AuthorizedRepPage({super.key});

  @override
  State<AuthorizedRepPage> createState() => _AuthorizedRepPageState();
}

class _AuthorizedRepPageState extends State<AuthorizedRepPage> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _positionController = TextEditingController();
  DateTime? _dateOfBirth;
  IdentityDocType _selectedDocType = IdentityDocType.nationalId;

  @override
  void initState() {
    super.initState();
    // Initialize from provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<OrganizationApplicationProvider>();
      setState(() {
        _fullNameController.text = provider.authorizedRepName;
        _positionController.text = provider.authorizedRepPosition;
        _dateOfBirth = provider.authorizedRepDob;
        _selectedDocType = _docTypeFromString(provider.authorizedRepIdType);
      });
    });
  }

  IdentityDocType _docTypeFromString(String type) {
    switch (type) {
      case 'nationalId':
        return IdentityDocType.nationalId;
      case 'passport':
        return IdentityDocType.passport;
      case 'driversLicense':
        return IdentityDocType.driversLicense;
      default:
        return IdentityDocType.nationalId;
    }
  }

  String _docTypeToString(IdentityDocType type) {
    switch (type) {
      case IdentityDocType.nationalId:
        return 'nationalId';
      case IdentityDocType.passport:
        return 'passport';
      case IdentityDocType.driversLicense:
        return 'driversLicense';
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _positionController.dispose();
    super.dispose();
  }

  void _goBack() {
    if (GoRouter.of(context).canPop()) {
      context.pop();
    }
  }

  void _continue() {
    // Save to provider
    final provider = context.read<OrganizationApplicationProvider>();
    provider.updateAuthorizedRep(
      fullName: _fullNameController.text,
      dob: _dateOfBirth,
      position: _positionController.text,
      idType: _docTypeToString(_selectedDocType),
    );
    debugPrint('AuthorizedRepPage: saved to provider - fullName=${_fullNameController.text}, dob=$_dateOfBirth, position=${_positionController.text}, docType=$_selectedDocType');
    context.push(AppRoutes.ownership);
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dateOfBirth ?? DateTime(1990, 1, 1),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: PayRouteColors.fintechNoirPrimary,
              onPrimary: Colors.black,
              surface: const Color(0xFF1A1F2E),
              onSurface: Colors.white,
            ),
            dialogTheme: DialogThemeData(backgroundColor: const Color(0xFF1A1F2E)),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _dateOfBirth = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF050810),
      body: Stack(
        children: [
          const _MapBackground(),
          SafeArea(
            child: Column(
              children: [
                _Header(onBack: _goBack),
                const _ProgressIndicator(currentStep: 2, totalSteps: 4),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 640),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 24),
                            const _TitleSection(),
                            const SizedBox(height: 32),
                            _FormSection(
                              fullNameController: _fullNameController,
                              positionController: _positionController,
                              dateOfBirth: _dateOfBirth,
                              onSelectDate: _selectDate,
                            ),
                            const SizedBox(height: 32),
                            _IdentityVerificationSection(
                              selectedType: _selectedDocType,
                              onSelect: (type) => setState(() => _selectedDocType = type),
                            ),
                            const SizedBox(height: 32),
                            const _PrivacyInfoCard(),
                            const SizedBox(height: 120),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          _BottomContinueButton(onContinue: _continue),
          const _CornerLogo(),
        ],
      ),
    );
  }
}

class _MapBackground extends StatelessWidget {
  const _MapBackground();

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Opacity(
        opacity: 0.07,
        child: Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.center,
              radius: 1.5,
              colors: [
                Colors.white.withValues(alpha: 0.1),
                Colors.transparent,
              ],
            ),
          ),
          child: CustomPaint(painter: _MapPatternPainter()),
        ),
      ),
    );
  }
}

class _MapPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.3)
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;

    const spacing = 40.0;
    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _Header extends StatelessWidget {
  final VoidCallback onBack;

  const _Header({required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: onBack,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Center(
                child: Icon(Icons.arrow_back, color: Colors.white, size: 20),
              ),
            ),
          ),
          Column(
            children: [
              Text(
                'STEP 2 OF 4',
                style: context.textStyles.labelSmall?.copyWith(
                  color: Colors.white.withValues(alpha: 0.6),
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1,
                  fontSize: 10,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Authorized Rep',
                style: context.textStyles.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Center(
              child: Icon(Icons.help_outline, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgressIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const _ProgressIndicator({required this.currentStep, required this.totalSteps});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Row(
        children: List.generate(totalSteps, (index) {
          final isActive = index < currentStep;
          return Expanded(
            child: Container(
              margin: EdgeInsets.only(right: index < totalSteps - 1 ? 8 : 0),
              height: 4,
              decoration: BoxDecoration(
                color: isActive
                    ? PayRouteColors.fintechNoirPrimary
                    : Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _TitleSection extends StatelessWidget {
  const _TitleSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Representative Details',
          style: context.textStyles.headlineMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Provide information for the individual authorized to act on behalf of the business.',
          style: context.textStyles.bodyMedium?.copyWith(
            color: Colors.white.withValues(alpha: 0.5),
            height: 1.5,
          ),
        ),
      ],
    );
  }
}

class _FormSection extends StatelessWidget {
  final TextEditingController fullNameController;
  final TextEditingController positionController;
  final DateTime? dateOfBirth;
  final VoidCallback onSelectDate;

  const _FormSection({
    required this.fullNameController,
    required this.positionController,
    required this.dateOfBirth,
    required this.onSelectDate,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FormField(
          label: 'Full Legal Name',
          icon: Icons.person,
          child: TextField(
            controller: fullNameController,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              hintText: 'Enter as shown on ID',
              hintStyle: TextStyle(color: Color(0xFF64748B)),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth > 400) {
              return Row(
                children: [
                  Expanded(
                    child: _DateField(
                      dateOfBirth: dateOfBirth,
                      onTap: onSelectDate,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _FormField(
                      label: 'Position / Title',
                      icon: Icons.work,
                      child: TextField(
                        controller: positionController,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          hintText: 'e.g. Director',
                          hintStyle: TextStyle(color: Color(0xFF64748B)),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }
            return Column(
              children: [
                _DateField(dateOfBirth: dateOfBirth, onTap: onSelectDate),
                const SizedBox(height: 16),
                _FormField(
                  label: 'Position / Title',
                  icon: Icons.work,
                  child: TextField(
                    controller: positionController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: 'e.g. Director',
                      hintStyle: TextStyle(color: Color(0xFF64748B)),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _FormField extends StatelessWidget {
  final String label;
  final IconData icon;
  final Widget child;

  const _FormField({required this.label, required this.icon, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            label.toUpperCase(),
            style: context.textStyles.labelSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.5,
              fontSize: 10,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.03),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Icon(icon, color: const Color(0xFF64748B), size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(child: child),
            ],
          ),
        ),
      ],
    );
  }
}

class _DateField extends StatelessWidget {
  final DateTime? dateOfBirth;
  final VoidCallback onTap;

  const _DateField({required this.dateOfBirth, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final displayText = dateOfBirth != null
        ? '${dateOfBirth!.year}-${dateOfBirth!.month.toString().padLeft(2, '0')}-${dateOfBirth!.day.toString().padLeft(2, '0')}'
        : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            'DATE OF BIRTH',
            style: context.textStyles.labelSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.5,
              fontSize: 10,
            ),
          ),
        ),
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: 56,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.03),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
            ),
            child: Row(
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 16),
                  child: Icon(Icons.calendar_today, color: Color(0xFF64748B), size: 20),
                ),
                const SizedBox(width: 12),
                Text(
                  displayText ?? 'Select date',
                  style: TextStyle(
                    color: displayText != null ? Colors.white : const Color(0xFF64748B),
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 4,
          decoration: BoxDecoration(
            color: PayRouteColors.fintechNoirPrimary,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title.toUpperCase(),
          style: context.textStyles.labelSmall?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.5,
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}

class _IdentityVerificationSection extends StatelessWidget {
  final IdentityDocType selectedType;
  final ValueChanged<IdentityDocType> onSelect;

  const _IdentityVerificationSection({required this.selectedType, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionHeader(title: 'Identity Verification'),
        const SizedBox(height: 16),
        _IdentityDocCard(
          type: IdentityDocType.nationalId,
          icon: Icons.badge,
          title: 'National ID Card',
          subtitle: 'Biometric ID preferred',
          isSelected: selectedType == IdentityDocType.nationalId,
          onTap: () => onSelect(IdentityDocType.nationalId),
        ),
        const SizedBox(height: 12),
        _IdentityDocCard(
          type: IdentityDocType.passport,
          icon: Icons.public,
          title: 'International Passport',
          subtitle: 'Standard travel document',
          isSelected: selectedType == IdentityDocType.passport,
          onTap: () => onSelect(IdentityDocType.passport),
        ),
        const SizedBox(height: 12),
        _IdentityDocCard(
          type: IdentityDocType.driversLicense,
          icon: Icons.directions_car,
          title: 'Driver\'s License',
          subtitle: 'Valid government issue',
          isSelected: selectedType == IdentityDocType.driversLicense,
          onTap: () => onSelect(IdentityDocType.driversLicense),
        ),
      ],
    );
  }
}

class _IdentityDocCard extends StatefulWidget {
  final IdentityDocType type;
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  const _IdentityDocCard({
    required this.type,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_IdentityDocCard> createState() => _IdentityDocCardState();
}

class _IdentityDocCardState extends State<_IdentityDocCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: widget.isSelected
                ? PayRouteColors.fintechNoirPrimary.withValues(alpha: 0.1)
                : Colors.white.withValues(alpha: _isHovered ? 0.05 : 0.03),
            border: Border.all(
              color: widget.isSelected
                  ? PayRouteColors.fintechNoirPrimary
                  : Colors.white.withValues(alpha: _isHovered ? 0.15 : 0.05),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: widget.isSelected
                      ? PayRouteColors.fintechNoirPrimary.withValues(alpha: 0.2)
                      : Colors.white.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Icon(
                    widget.icon,
                    color: widget.isSelected
                        ? PayRouteColors.fintechNoirPrimary
                        : const Color(0xFF94A3B8),
                    size: 22,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: context.textStyles.titleSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.subtitle,
                      style: context.textStyles.bodySmall?.copyWith(
                        color: const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                widget.isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
                color: widget.isSelected
                    ? PayRouteColors.fintechNoirPrimary
                    : const Color(0xFF334155),
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PrivacyInfoCard extends StatelessWidget {
  const _PrivacyInfoCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withValues(alpha: 0.05),
            Colors.transparent,
          ],
        ),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.security, color: PayRouteColors.fintechNoirPrimary, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bank-Grade Privacy',
                  style: context.textStyles.titleSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Your personal data is encrypted using AES-256 and is only used for regulatory compliance. We never share your private documents with third parties.',
                  style: context.textStyles.bodySmall?.copyWith(
                    color: Colors.white.withValues(alpha: 0.5),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomContinueButton extends StatelessWidget {
  final VoidCallback onContinue;

  const _BottomContinueButton({required this.onContinue});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF050810).withValues(alpha: 0.8),
              border: Border(
                top: BorderSide(color: Colors.white.withValues(alpha: 0.05)),
              ),
            ),
            child: SafeArea(
              top: false,
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 640),
                  child: _ContinueButton(onPressed: onContinue),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ContinueButton extends StatefulWidget {
  final VoidCallback onPressed;

  const _ContinueButton({required this.onPressed});

  @override
  State<_ContinueButton> createState() => _ContinueButtonState();
}

class _ContinueButtonState extends State<_ContinueButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: double.infinity,
          height: 56,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                PayRouteColors.fintechNoirPrimary,
                PayRouteColors.fintechNoirPrimaryLight,
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: PayRouteColors.fintechNoirPrimary.withValues(alpha: _isHovered ? 0.4 : 0.2),
                blurRadius: _isHovered ? 30 : 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Continue',
                style: context.textStyles.titleMedium?.copyWith(
                  color: const Color(0xFF05080F),
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.arrow_forward, color: Color(0xFF05080F), size: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _CornerLogo extends StatelessWidget {
  const _CornerLogo();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 24,
      right: 24,
      child: Opacity(
        opacity: 0.4,
        child: SizedBox(
          width: 48,
          height: 48,
          child: Image.asset(
            'assets/images/Dynamic_Logo_for_PayRoute_Africa_1.png',
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
