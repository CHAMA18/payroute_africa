import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:payroute_desktop/nav.dart';
import 'package:payroute_desktop/theme.dart';
import 'package:payroute_desktop/providers/organization_application_provider.dart';
import 'package:payroute_desktop/providers/auth_provider.dart';

class ReviewPage extends StatefulWidget {
  const ReviewPage({super.key});

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  bool _declarationAccepted = false;

  void _goBack() {
    if (GoRouter.of(context).canPop()) {
      context.pop();
    }
  }

  Future<void> _submitApplication() async {
    if (!_declarationAccepted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please accept the declaration to continue'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }
    
    final authProvider = context.read<AuthProvider>();
    final appProvider = context.read<OrganizationApplicationProvider>();
    
    // Check if user is authenticated
    if (authProvider.firebaseUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please sign in to submit your application'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    final userId = authProvider.firebaseUser!.uid;
    final success = await appProvider.submitApplication(userId);
    
    if (success) {
      debugPrint('ReviewPage: Application submitted successfully');
      if (mounted) {
        // Navigate to success page after submission
        context.go(AppRoutes.success);
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(appProvider.submissionError ?? 'Failed to submit application'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  void _editEntityDetails() {
    context.go(AppRoutes.entityDetails);
  }

  void _editAuthorizedRep() {
    context.go(AppRoutes.authorizedRep);
  }

  void _editOwnership() {
    context.go(AppRoutes.ownership);
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
                const _ProgressIndicator(currentStep: 4, totalSteps: 4),
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
                            Consumer<OrganizationApplicationProvider>(
                              builder: (context, provider, _) {
                                return Column(
                                  children: [
                                    _EntityDetailsCard(
                                      onEdit: _editEntityDetails,
                                      entityType: provider.entityTypeDisplayName,
                                      hasDocument: provider.incorporationDocumentUrl != null,
                                    ),
                                    const SizedBox(height: 16),
                                    _AuthorizedRepCard(
                                      onEdit: _editAuthorizedRep,
                                      name: provider.authorizedRepName,
                                      position: provider.authorizedRepPosition,
                                      dob: provider.authorizedRepDob,
                                      idType: provider.idTypeDisplayName,
                                    ),
                                    const SizedBox(height: 16),
                                    _BeneficialOwnersCard(
                                      onEdit: _editOwnership,
                                      owners: provider.beneficialOwners,
                                    ),
                                  ],
                                );
                              },
                            ),
                            const SizedBox(height: 24),
                            _DeclarationSection(
                              accepted: _declarationAccepted,
                              onChanged: (v) => setState(() => _declarationAccepted = v ?? false),
                            ),
                            const SizedBox(height: 140),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Consumer<OrganizationApplicationProvider>(
            builder: (context, provider, _) {
              return _BottomSubmitButton(
                onSubmit: _submitApplication,
                isLoading: provider.isSubmitting,
              );
            },
          ),
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
                'STEP 4 OF 4',
                style: context.textStyles.labelSmall?.copyWith(
                  color: Colors.white.withValues(alpha: 0.6),
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1,
                  fontSize: 10,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Review',
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
          final isCurrent = index == currentStep - 1;
          return Expanded(
            child: Container(
              margin: EdgeInsets.only(right: index < totalSteps - 1 ? 8 : 0),
              height: 4,
              decoration: BoxDecoration(
                color: isActive
                    ? PayRouteColors.fintechNoirPrimary
                    : Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(2),
                boxShadow: isCurrent
                    ? [
                        BoxShadow(
                          color: PayRouteColors.fintechNoirPrimary.withValues(alpha: 0.6),
                          blurRadius: 8,
                          spreadRadius: 0,
                        ),
                      ]
                    : null,
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
          'Final Review',
          style: context.textStyles.headlineMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Please verify all the information provided below before submitting your application.',
          style: context.textStyles.bodyMedium?.copyWith(
            color: Colors.white.withValues(alpha: 0.5),
            height: 1.5,
          ),
        ),
      ],
    );
  }
}

class _GlassPanelCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onEdit;
  final Widget content;

  const _GlassPanelCard({
    required this.icon,
    required this.title,
    required this.onEdit,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.white.withValues(alpha: 0.05)),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(icon, color: PayRouteColors.fintechNoirPrimary, size: 20),
                    const SizedBox(width: 12),
                    Text(
                      title.toUpperCase(),
                      style: context.textStyles.labelSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.5,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: onEdit,
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      Icons.edit,
                      color: Colors.white.withValues(alpha: 0.5),
                      size: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: content,
          ),
        ],
      ),
    );
  }
}

class _ReviewRow extends StatelessWidget {
  final String label;
  final String value;

  const _ReviewRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: context.textStyles.bodySmall?.copyWith(
            color: Colors.white.withValues(alpha: 0.5),
            fontSize: 12,
          ),
        ),
        Flexible(
          child: Text(
            value,
            style: context.textStyles.bodySmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}

class _EntityDetailsCard extends StatelessWidget {
  final VoidCallback onEdit;
  final String entityType;
  final bool hasDocument;

  const _EntityDetailsCard({
    required this.onEdit,
    required this.entityType,
    required this.hasDocument,
  });

  @override
  Widget build(BuildContext context) {
    return _GlassPanelCard(
      icon: Icons.corporate_fare,
      title: 'Entity Details',
      onEdit: onEdit,
      content: Column(
        children: [
          _ReviewRow(label: 'Entity Type', value: entityType),
          const SizedBox(height: 12),
          _ReviewRow(
            label: 'Incorporation Document',
            value: hasDocument ? 'Uploaded' : 'Not Uploaded',
          ),
        ],
      ),
    );
  }
}

class _AuthorizedRepCard extends StatelessWidget {
  final VoidCallback onEdit;
  final String name;
  final String position;
  final DateTime? dob;
  final String idType;

  const _AuthorizedRepCard({
    required this.onEdit,
    required this.name,
    required this.position,
    required this.dob,
    required this.idType,
  });

  String _formatDate(DateTime? date) {
    if (date == null) return 'Not provided';
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return _GlassPanelCard(
      icon: Icons.person_outline,
      title: 'Authorized Representative',
      onEdit: onEdit,
      content: Column(
        children: [
          _ReviewRow(label: 'Full Name', value: name.isNotEmpty ? name : 'Not provided'),
          const SizedBox(height: 12),
          _ReviewRow(label: 'Position', value: position.isNotEmpty ? position : 'Not provided'),
          const SizedBox(height: 12),
          _ReviewRow(label: 'Date of Birth', value: _formatDate(dob)),
          const SizedBox(height: 12),
          _ReviewRow(label: 'ID Type', value: idType),
        ],
      ),
    );
  }
}

class _BeneficialOwnersCard extends StatelessWidget {
  final VoidCallback onEdit;
  final List<BeneficialOwnerDraft> owners;

  const _BeneficialOwnersCard({
    required this.onEdit,
    required this.owners,
  });

  @override
  Widget build(BuildContext context) {
    final validOwners = owners.where((o) => o.fullName.isNotEmpty).toList();
    
    return _GlassPanelCard(
      icon: Icons.group,
      title: 'Beneficial Owners',
      onEdit: onEdit,
      content: validOwners.isEmpty
          ? Text(
              'No beneficial owners added',
              style: context.textStyles.bodySmall?.copyWith(
                color: Colors.white.withValues(alpha: 0.5),
              ),
            )
          : Column(
              children: List.generate(validOwners.length, (index) {
                final owner = validOwners[index];
                return _OwnerReviewItem(
                  name: owner.fullName,
                  percentage: '${owner.ownershipPercent}%',
                  nationality: owner.nationality.isNotEmpty
                      ? '${owner.nationality} Nationality'
                      : 'Nationality not specified',
                  showDivider: index < validOwners.length - 1,
                );
              }),
            ),
    );
  }
}

class _OwnerReviewItem extends StatelessWidget {
  final String name;
  final String percentage;
  final String nationality;
  final bool showDivider;

  const _OwnerReviewItem({
    required this.name,
    required this.percentage,
    required this.nationality,
    required this.showDivider,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: showDivider ? 16 : 0),
      margin: EdgeInsets.only(bottom: showDivider ? 16 : 0),
      decoration: showDivider
          ? BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.white.withValues(alpha: 0.05)),
              ),
            )
          : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                name,
                style: context.textStyles.bodySmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
              Text(
                percentage,
                style: context.textStyles.labelSmall?.copyWith(
                  color: PayRouteColors.fintechNoirPrimary,
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            nationality.toUpperCase(),
            style: context.textStyles.labelSmall?.copyWith(
              color: Colors.white.withValues(alpha: 0.5),
              fontWeight: FontWeight.w500,
              letterSpacing: 0.5,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}

class _DeclarationSection extends StatelessWidget {
  final bool accepted;
  final ValueChanged<bool?> onChanged;

  const _DeclarationSection({required this.accepted, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'DECLARATION',
          style: context.textStyles.labelSmall?.copyWith(
            color: PayRouteColors.fintechNoirPrimary,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.5,
            fontSize: 11,
          ),
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: () => onChanged(!accepted),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: accepted
                  ? PayRouteColors.fintechNoirPrimary.withValues(alpha: 0.1)
                  : Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: accepted
                    ? PayRouteColors.fintechNoirPrimary
                    : PayRouteColors.fintechNoirPrimary.withValues(alpha: 0.5),
                width: accepted ? 2 : 1,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 24,
                  height: 24,
                  margin: const EdgeInsets.only(top: 2),
                  decoration: BoxDecoration(
                    color: accepted
                        ? PayRouteColors.fintechNoirPrimary
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: accepted
                          ? PayRouteColors.fintechNoirPrimary
                          : PayRouteColors.fintechNoirPrimary.withValues(alpha: 0.6),
                      width: 2,
                    ),
                  ),
                  child: accepted
                      ? const Icon(Icons.check, color: Colors.white, size: 16)
                      : null,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'I accept the terms and conditions',
                        style: context.textStyles.bodyMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'I hereby declare that the information provided is true and accurate to the best of my knowledge. I understand that providing false information may lead to rejection or legal consequences.',
                        style: context.textStyles.bodySmall?.copyWith(
                          color: Colors.white.withValues(alpha: 0.6),
                          height: 1.5,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        if (!accepted)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  size: 14,
                  color: PayRouteColors.fintechNoirPrimary,
                ),
                const SizedBox(width: 6),
                Text(
                  'Tap to accept before submitting',
                  style: context.textStyles.bodySmall?.copyWith(
                    color: PayRouteColors.fintechNoirPrimary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _BottomSubmitButton extends StatelessWidget {
  final VoidCallback onSubmit;
  final bool isLoading;

  const _BottomSubmitButton({
    required this.onSubmit,
    this.isLoading = false,
  });

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
                  child: _SubmitButton(onPressed: onSubmit, isLoading: isLoading),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SubmitButton extends StatefulWidget {
  final VoidCallback onPressed;
  final bool isLoading;

  const _SubmitButton({
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  State<_SubmitButton> createState() => _SubmitButtonState();
}

class _SubmitButtonState extends State<_SubmitButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: widget.isLoading ? SystemMouseCursors.basic : SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.isLoading ? null : widget.onPressed,
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
          child: widget.isLoading
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF05080F)),
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.check_circle, color: Color(0xFF05080F), size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Submit Application',
                      style: context.textStyles.titleMedium?.copyWith(
                        color: const Color(0xFF05080F),
                        fontWeight: FontWeight.w700,
                      ),
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
