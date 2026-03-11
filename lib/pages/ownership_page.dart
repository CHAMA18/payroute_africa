import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:payroute_desktop/nav.dart';
import 'package:payroute_desktop/theme.dart';
import 'package:payroute_desktop/providers/organization_application_provider.dart';

class OwnershipPage extends StatefulWidget {
  const OwnershipPage({super.key});

  @override
  State<OwnershipPage> createState() => _OwnershipPageState();
}

class _OwnershipPageState extends State<OwnershipPage> {
  List<BeneficialOwnerDraft> _owners = [BeneficialOwnerDraft()];

  @override
  void initState() {
    super.initState();
    // Initialize from provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<OrganizationApplicationProvider>();
      setState(() {
        _owners = provider.beneficialOwners.isNotEmpty
            ? provider.beneficialOwners.map((o) => BeneficialOwnerDraft(
                fullName: o.fullName,
                ownershipPercent: o.ownershipPercent,
                nationality: o.nationality,
              )).toList()
            : [BeneficialOwnerDraft()];
      });
    });
  }

  void _goBack() {
    if (GoRouter.of(context).canPop()) {
      context.pop();
    }
  }

  void _continue() {
    // Save to provider
    final provider = context.read<OrganizationApplicationProvider>();
    provider.updateBeneficialOwners(_owners);
    debugPrint('OwnershipPage: saved to provider - owners=${_owners.map((o) => '${o.fullName} (${o.ownershipPercent}%)').join(', ')}');
    context.push(AppRoutes.review);
  }

  void _addOwner() {
    setState(() => _owners.add(BeneficialOwnerDraft()));
  }

  void _removeOwner(int index) {
    if (_owners.length > 1) {
      setState(() => _owners.removeAt(index));
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
                const _ProgressIndicator(currentStep: 3, totalSteps: 4),
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
                            _OwnersListSection(
                              owners: _owners,
                              onRemove: _removeOwner,
                              onUpdate: (index, data) {
                                setState(() => _owners[index] = data);
                              },
                            ),
                            const SizedBox(height: 16),
                            _AddOwnerButton(onAdd: _addOwner),
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
                'STEP 3 OF 4',
                style: context.textStyles.labelSmall?.copyWith(
                  color: Colors.white.withValues(alpha: 0.6),
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1,
                  fontSize: 10,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Ownership',
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
          'Beneficial Ownership',
          style: context.textStyles.headlineMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Identify individuals who own or control 25% or more of the company.',
          style: context.textStyles.bodyMedium?.copyWith(
            color: Colors.white.withValues(alpha: 0.5),
            height: 1.5,
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

class _OwnersListSection extends StatelessWidget {
  final List<BeneficialOwnerDraft> owners;
  final void Function(int index) onRemove;
  final void Function(int index, BeneficialOwnerDraft data) onUpdate;

  const _OwnersListSection({
    required this.owners,
    required this.onRemove,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionHeader(title: 'List of Owners'),
        const SizedBox(height: 16),
        ...List.generate(owners.length, (index) {
          return Padding(
            padding: EdgeInsets.only(bottom: index < owners.length - 1 ? 16 : 0),
            child: _OwnerCard(
              ownerNumber: index + 1,
              data: owners[index],
              canDelete: owners.length > 1,
              onDelete: () => onRemove(index),
              onUpdate: (data) => onUpdate(index, data),
            ),
          );
        }),
      ],
    );
  }
}

class _OwnerCard extends StatelessWidget {
  final int ownerNumber;
  final BeneficialOwnerDraft data;
  final bool canDelete;
  final VoidCallback onDelete;
  final void Function(BeneficialOwnerDraft data) onUpdate;

  const _OwnerCard({
    required this.ownerNumber,
    required this.data,
    required this.canDelete,
    required this.onDelete,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'OWNER #$ownerNumber',
                style: context.textStyles.labelSmall?.copyWith(
                  color: PayRouteColors.fintechNoirPrimary,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1,
                  fontSize: 10,
                ),
              ),
              if (canDelete)
                GestureDetector(
                  onTap: onDelete,
                  child: Icon(
                    Icons.delete_outline,
                    color: Colors.grey.withValues(alpha: 0.5),
                    size: 20,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          _OwnerFormField(
            label: 'Full Name',
            icon: Icons.person,
            placeholder: 'Legal name of owner',
            value: data.fullName,
            onChanged: (v) => onUpdate(BeneficialOwnerDraft(
              fullName: v,
              ownershipPercent: data.ownershipPercent,
              nationality: data.nationality,
            )),
          ),
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 400) {
                return Row(
                  children: [
                    Expanded(
                      child: _OwnerFormField(
                        label: 'Ownership %',
                        icon: Icons.pie_chart,
                        placeholder: 'e.g. 25',
                        value: data.ownershipPercent,
                        keyboardType: TextInputType.number,
                        onChanged: (v) => onUpdate(BeneficialOwnerDraft(
                          fullName: data.fullName,
                          ownershipPercent: v,
                          nationality: data.nationality,
                        )),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _OwnerFormField(
                        label: 'Nationality',
                        icon: Icons.flag,
                        placeholder: 'Country',
                        value: data.nationality,
                        onChanged: (v) => onUpdate(BeneficialOwnerDraft(
                          fullName: data.fullName,
                          ownershipPercent: data.ownershipPercent,
                          nationality: v,
                        )),
                      ),
                    ),
                  ],
                );
              }
              return Column(
                children: [
                  _OwnerFormField(
                    label: 'Ownership %',
                    icon: Icons.pie_chart,
                    placeholder: 'e.g. 25',
                    value: data.ownershipPercent,
                    keyboardType: TextInputType.number,
                    onChanged: (v) => onUpdate(BeneficialOwnerDraft(
                      fullName: data.fullName,
                      ownershipPercent: v,
                      nationality: data.nationality,
                    )),
                  ),
                  const SizedBox(height: 16),
                  _OwnerFormField(
                    label: 'Nationality',
                    icon: Icons.flag,
                    placeholder: 'Country',
                    value: data.nationality,
                    onChanged: (v) => onUpdate(BeneficialOwnerDraft(
                      fullName: data.fullName,
                      ownershipPercent: data.ownershipPercent,
                      nationality: v,
                    )),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _OwnerFormField extends StatelessWidget {
  final String label;
  final IconData icon;
  final String placeholder;
  final String value;
  final TextInputType keyboardType;
  final void Function(String) onChanged;

  const _OwnerFormField({
    required this.label,
    required this.icon,
    required this.placeholder,
    required this.value,
    this.keyboardType = TextInputType.text,
    required this.onChanged,
  });

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
              color: Colors.white.withValues(alpha: 0.6),
              fontWeight: FontWeight.w700,
              letterSpacing: 1.5,
              fontSize: 10,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
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
              Expanded(
                child: TextFormField(
                  initialValue: value,
                  style: const TextStyle(color: Colors.white),
                  keyboardType: keyboardType,
                  decoration: InputDecoration(
                    hintText: placeholder,
                    hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.3)),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onChanged: onChanged,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _AddOwnerButton extends StatefulWidget {
  final VoidCallback onAdd;

  const _AddOwnerButton({required this.onAdd});

  @override
  State<_AddOwnerButton> createState() => _AddOwnerButtonState();
}

class _AddOwnerButtonState extends State<_AddOwnerButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onAdd,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _isHovered
                  ? PayRouteColors.fintechNoirPrimary.withValues(alpha: 0.5)
                  : Colors.white.withValues(alpha: 0.1),
              width: 2,
              style: BorderStyle.solid,
            ),
            color: _isHovered ? Colors.white.withValues(alpha: 0.05) : Colors.transparent,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add_circle_outline,
                color: _isHovered ? Colors.white : const Color(0xFF94A3B8),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Add Another Owner',
                style: context.textStyles.titleSmall?.copyWith(
                  color: _isHovered ? Colors.white : const Color(0xFF94A3B8),
                  fontWeight: FontWeight.w600,
                ),
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
