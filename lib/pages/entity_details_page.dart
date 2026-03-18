import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:payroute_desktop/nav.dart';
import 'package:payroute_desktop/theme.dart';
import 'package:payroute_desktop/models/account_type.dart';
import 'package:payroute_desktop/providers/organization_application_provider.dart';
import 'package:payroute_desktop/widgets/support_chat_widget.dart';

enum EntityType { fintech, neobank, remittance, enterprise }

class EntityDetailsPage extends StatefulWidget {
  final AccountType accountType;
  
  const EntityDetailsPage({super.key, required this.accountType});

  @override
  State<EntityDetailsPage> createState() => _EntityDetailsPageState();
}

class _EntityDetailsPageState extends State<EntityDetailsPage> {
  EntityType _selectedEntityType = EntityType.fintech;
  bool _hasUploadedDocument = false;
  String? _documentUrl;
  
  @override
  void initState() {
    super.initState();
    debugPrint('EntityDetailsPage: received account type = ${widget.accountType}');
    // Initialize from provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<OrganizationApplicationProvider>();
      setState(() {
        _selectedEntityType = _entityTypeFromString(provider.entityType);
        _documentUrl = provider.incorporationDocumentUrl;
        _hasUploadedDocument = _documentUrl != null;
      });
    });
  }

  EntityType _entityTypeFromString(String type) {
    switch (type) {
      case 'fintech':
        return EntityType.fintech;
      case 'neobank':
        return EntityType.neobank;
      case 'remittance':
        return EntityType.remittance;
      case 'enterprise':
        return EntityType.enterprise;
      default:
        return EntityType.fintech;
    }
  }

  String _entityTypeToString(EntityType type) {
    switch (type) {
      case EntityType.fintech:
        return 'fintech';
      case EntityType.neobank:
        return 'neobank';
      case EntityType.remittance:
        return 'remittance';
      case EntityType.enterprise:
        return 'enterprise';
    }
  }

  void _goBack() {
    if (GoRouter.of(context).canPop()) {
      context.pop();
    }
  }

  void _continue() {
    // Save to provider
    final provider = context.read<OrganizationApplicationProvider>();
    provider.updateEntityDetails(
      entityType: _entityTypeToString(_selectedEntityType),
      incorporationDocumentUrl: _documentUrl,
    );
    debugPrint('EntityDetailsPage: saved entity type = $_selectedEntityType to provider');
    context.push(AppRoutes.authorizedRep);
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
                const _ProgressIndicator(currentStep: 1, totalSteps: 4),
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
                            _TitleSection(),
                            const SizedBox(height: 32),
                            _EntityTypeSection(
                              selectedType: _selectedEntityType,
                              onSelect: (type) => setState(() => _selectedEntityType = type),
                            ),
                            const SizedBox(height: 32),
                            _DocumentUploadSection(
                              hasUploaded: _hasUploadedDocument,
                              onUpload: () => setState(() => _hasUploadedDocument = true),
                            ),
                            const SizedBox(height: 24),
                            const _ComplianceInfoCard(),
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
          // AI Chat Widget
          const Positioned(
            right: 20,
            bottom: 20,
            child: SupportChatWidget(),
          ),
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
          child: CustomPaint(
            painter: _MapPatternPainter(),
          ),
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

    // Draw grid lines to simulate map pattern
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
          // Back button
          GestureDetector(
            onTap: onBack,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
          // Title
          Column(
            children: [
              Text(
                'STEP 1 OF 4',
                style: context.textStyles.labelSmall?.copyWith(
                  color: Colors.white.withValues(alpha: 0.6),
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1,
                  fontSize: 10,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Entity Details',
                style: context.textStyles.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          // Help button
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Icon(
                Icons.help_outline,
                color: Colors.white,
                size: 20,
              ),
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

  const _ProgressIndicator({
    required this.currentStep,
    required this.totalSteps,
  });

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
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Business Verification',
          style: context.textStyles.headlineMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Begin your institutional onboarding by defining your entity and providing core documentation.',
          style: context.textStyles.bodyMedium?.copyWith(
            color: Colors.white.withValues(alpha: 0.5),
            height: 1.5,
          ),
        ),
      ],
    );
  }
}

class _EntityTypeSection extends StatelessWidget {
  final EntityType selectedType;
  final ValueChanged<EntityType> onSelect;

  const _EntityTypeSection({
    required this.selectedType,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(title: 'Select Entity Type'),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth > 400;
            final crossAxisCount = isWide ? 2 : 1;
            return GridView.count(
              crossAxisCount: crossAxisCount,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: isWide ? 2.2 : 3.5,
              children: [
                _EntityTypeCard(
                  type: EntityType.fintech,
                  icon: Icons.account_balance,
                  title: 'Fintech',
                  subtitle: 'Payment & Ledger',
                  isSelected: selectedType == EntityType.fintech,
                  onTap: () => onSelect(EntityType.fintech),
                ),
                _EntityTypeCard(
                  type: EntityType.neobank,
                  icon: Icons.language,
                  title: 'Neobank',
                  subtitle: 'Digital Banking',
                  isSelected: selectedType == EntityType.neobank,
                  onTap: () => onSelect(EntityType.neobank),
                ),
                _EntityTypeCard(
                  type: EntityType.remittance,
                  icon: Icons.payments,
                  title: 'Remittance',
                  subtitle: 'Cross-border',
                  isSelected: selectedType == EntityType.remittance,
                  onTap: () => onSelect(EntityType.remittance),
                ),
                _EntityTypeCard(
                  type: EntityType.enterprise,
                  icon: Icons.corporate_fare,
                  title: 'Enterprise',
                  subtitle: 'Infrastructure',
                  isSelected: selectedType == EntityType.enterprise,
                  onTap: () => onSelect(EntityType.enterprise),
                ),
              ],
            );
          },
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

class _EntityTypeCard extends StatefulWidget {
  final EntityType type;
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  const _EntityTypeCard({
    required this.type,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_EntityTypeCard> createState() => _EntityTypeCardState();
}

class _EntityTypeCardState extends State<_EntityTypeCard> {
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
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: widget.isSelected
                ? PayRouteColors.fintechNoirPrimary.withValues(alpha: 0.1)
                : Colors.white.withValues(alpha: _isHovered ? 0.05 : 0.03),
            border: Border.all(
              color: widget.isSelected
                  ? PayRouteColors.fintechNoirPrimary
                  : Colors.white.withValues(alpha: _isHovered ? 0.15 : 0.08),
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
                        : Colors.white.withValues(alpha: 0.5),
                    size: 22,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
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
                      color: Colors.white.withValues(alpha: 0.4),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DocumentUploadSection extends StatefulWidget {
  final bool hasUploaded;
  final VoidCallback onUpload;

  const _DocumentUploadSection({
    required this.hasUploaded,
    required this.onUpload,
  });

  @override
  State<_DocumentUploadSection> createState() => _DocumentUploadSectionState();
}

class _DocumentUploadSectionState extends State<_DocumentUploadSection> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(title: 'Incorporation Documents'),
        const SizedBox(height: 16),
        MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: widget.onUpload,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 40),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.white.withValues(alpha: 0.03),
                border: Border.all(
                  color: _isHovered
                      ? PayRouteColors.fintechNoirPrimary.withValues(alpha: 0.4)
                      : Colors.white.withValues(alpha: 0.1),
                  width: 2,
                  style: BorderStyle.solid,
                ),
              ),
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      // Glow effect
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: PayRouteColors.fintechNoirPrimary.withValues(alpha: 0.2),
                              blurRadius: 30,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                      ),
                      // Icon container
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: PayRouteColors.fintechNoirPrimary.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Icon(
                            Icons.cloud_upload_outlined,
                            color: PayRouteColors.fintechNoirPrimary,
                            size: 28,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Tap to upload Certificate',
                    style: context.textStyles.titleSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'PDF, JPG, or PNG (Max. 10MB)',
                    style: context.textStyles.bodySmall?.copyWith(
                      color: Colors.white.withValues(alpha: 0.4),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ComplianceInfoCard extends StatelessWidget {
  const _ComplianceInfoCard();

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
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.05),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.verified_user,
            color: PayRouteColors.fintechNoirPrimary,
            size: 24,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'The Importance of Compliance',
                  style: context.textStyles.titleSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Entity verification is a regulatory necessity that ensures the safety of the African fintech ecosystem. By verifying your business, you help prevent financial crime and unlock institutional-grade liquidity.',
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
                top: BorderSide(
                  color: Colors.white.withValues(alpha: 0.05),
                ),
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
              Icon(
                Icons.arrow_forward,
                color: const Color(0xFF05080F),
                size: 20,
              ),
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
