import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:payroute_desktop/nav.dart';
import 'package:payroute_desktop/models/account_type.dart';
import 'package:payroute_desktop/providers/auth_provider.dart';
import 'package:payroute_desktop/utils/country_data.dart';
import 'package:payroute_desktop/widgets/animated_background.dart';

class CreateAccountPage extends StatefulWidget {
  final AccountType accountType;
  const CreateAccountPage({super.key, required this.accountType});

  @override
  State<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  bool _isCreating = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _continue() async {
    FocusScope.of(context).unfocus();

    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    if (_isCreating) return;
    setState(() => _isCreating = true);

    try {
      final email = _emailController.text.trim();
      final authProvider = context.read<AuthProvider>();
      
      // Auto-generate a robust password to satisfy Firebase since we aren't asking for one in this step
      final defaultPassword = "FintechUser!123456";
      
      final success = await authProvider.signUp(email, defaultPassword, 'personal');
      
      if (!mounted) return;
      
      if (success) {
        await authProvider.setRememberMe(true);
        context.go(AppRoutes.dashboard);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authProvider.errorMessage ?? 'Failed to create account'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isCreating = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0C11),
      body: Stack(
        children: [
          const MeshGradientBackground(),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraints.maxHeight),
                    child: IntrinsicHeight(
                      child: Column(
                        children: [
                          const Spacer(),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 48.0),
                            child: Builder(
                                  builder: (context) {
                                    final formSection = ConstrainedBox(
                                      constraints: const BoxConstraints(maxWidth: 480),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          // Logo
                                          const _Logo(),
                                          const SizedBox(height: 56),
                                          
                                          // Title
                                          Text.rich(
                                            TextSpan(
                                              children: [
                                                const TextSpan(text: 'Tell us about\n'),
                                                TextSpan(
                                                  text: 'yourself',
                                                  style: TextStyle(
                                                    color: const Color(0xFFF58A1F),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 48,
                                              fontWeight: FontWeight.w800,
                                              height: 1.1,
                                              letterSpacing: -1,
                                            ),
                                          ),
                                          const SizedBox(height: 16),
                                          
                                          // Subtitle
                                          Text(
                                            'We need a few basic details to set up your institutional-grade personal dashboard.',
                                            style: TextStyle(
                                              color: Colors.white.withValues(alpha: 0.6),
                                              fontSize: 18,
                                              height: 1.5,
                                            ),
                                          ),
                                          const SizedBox(height: 48),
                                          
                                          // Form Card
                                          Container(
                                            decoration: BoxDecoration(
                                              color: const Color(0xFF131720),
                                              borderRadius: BorderRadius.circular(24),
                                              border: Border.all(
                                                color: Colors.white.withValues(alpha: 0.05),
                                                width: 1,
                                              ),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black.withValues(alpha: 0.4),
                                                  blurRadius: 40,
                                                  offset: const Offset(0, 20),
                                                ),
                                              ],
                                            ),
                                            padding: const EdgeInsets.all(32),
                                            child: Form(
                                              key: _formKey,
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                                children: [
                                                  _buildLabel('Full Legal Name'),
                                                  const SizedBox(height: 8),
                                                  _InputField(
                                                    controller: _nameController,
                                                    hintText: 'Johnathan Doe',
                                                    keyboardType: TextInputType.name,
                                                    validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
                                                  ),
                                                  const SizedBox(height: 24),
                                                  
                                                  _buildLabel('Email Address'),
                                                  const SizedBox(height: 8),
                                                  _InputField(
                                                    controller: _emailController,
                                                    hintText: 'john@noir-finance.com',
                                                    keyboardType: TextInputType.emailAddress,
                                                    validator: (v) => v?.contains('@') != true ? 'Invalid email' : null,
                                                  ),
                                                  const SizedBox(height: 24),
                                                  
                                                  _buildLabel('Phone Number'),
                                                  const SizedBox(height: 8),
                                                  Row(
                                                    children: [
                                                      _PhoneDropdown(),
                                                      const SizedBox(width: 12),
                                                      Expanded(
                                                        child: _InputField(
                                                          controller: _phoneController,
                                                          hintText: '0801 234 5678',
                                                          keyboardType: TextInputType.phone,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 40),
                                                  
                                                  _SubmitButton(
                                                    isLoading: _isCreating,
                                                    onPressed: _continue,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                    
                                    if (constraints.maxWidth > 1000) {
                                      final double childWidth = (constraints.maxWidth - 80) / 2;
                                      return Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width: childWidth,
                                            child: Align(
                                              alignment: Alignment.centerRight,
                                              child: formSection,
                                            ),
                                          ),
                                          const SizedBox(width: 80),
                                          SizedBox(
                                            width: childWidth,
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: ConstrainedBox(
                                                constraints: const BoxConstraints(maxWidth: 480),
                                                child: const _RightSection(isStretched: false),
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    } else {
                                      return Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          formSection,
                                          const SizedBox(height: 80),
                                          ConstrainedBox(
                                            constraints: BoxConstraints(maxWidth: 480),
                                            child: _RightSection(),
                                          ),
                                        ],
                                      );
                                    }
                                },
                              ),
                            ),
                          const Spacer(),
                          // Footer
                          const _Footer(),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        color: Colors.white.withValues(alpha: 0.9),
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  const _Logo();

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => context.go(AppRoutes.landing),
        child: Image.asset(
          'assets/images/Dynamic_Logo_for_PayRoute_Africa_1.png',
          height: 60,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;

  const _InputField({
    required this.controller,
    required this.hintText,
    this.keyboardType = TextInputType.text,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      style: const TextStyle(color: Colors.white, fontSize: 16),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.2), fontSize: 16),
        filled: true,
        fillColor: const Color(0xFF1A1F2B),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFF58A1F), width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
        ),
      ),
    );
  }
}

class _PhoneDropdown extends StatefulWidget {
  @override
  State<_PhoneDropdown> createState() => _PhoneDropdownState();
}

class _PhoneDropdownState extends State<_PhoneDropdown> {
  CountryEntry? _selectedCountry;

  @override
  void initState() {
    super.initState();
    _selectedCountry = CountryData.all.firstWhere((c) => c.code == 'US',
        orElse: () => CountryData.all.first);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1F2B),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<CountryEntry>(
          value: _selectedCountry,
          icon: Icon(
            Icons.keyboard_arrow_down,
            color: Colors.white.withValues(alpha: 0.5),
            size: 20,
          ),
          dropdownColor: const Color(0xFF1A1F2B),
          style: const TextStyle(color: Colors.white, fontSize: 16),
          onChanged: (CountryEntry? newValue) {
            if (newValue != null) {
              setState(() {
                _selectedCountry = newValue;
              });
            }
          },
          items: CountryData.all.map<DropdownMenuItem<CountryEntry>>((CountryEntry entry) {
            final int firstLetter = entry.code.toUpperCase().codeUnitAt(0) - 0x41 + 0x1F1E6;
            final int secondLetter = entry.code.toUpperCase().codeUnitAt(1) - 0x41 + 0x1F1E6;
            final String flagEmoji = String.fromCharCode(firstLetter) + String.fromCharCode(secondLetter);
            
            return DropdownMenuItem<CountryEntry>(
              value: entry,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(flagEmoji, style: const TextStyle(fontSize: 16)),
                  const SizedBox(width: 8),
                  Text('${entry.code} (+${entry.dialCode})'),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _SubmitButton extends StatefulWidget {
  final bool isLoading;
  final VoidCallback onPressed;

  const _SubmitButton({required this.isLoading, required this.onPressed});

  @override
  State<_SubmitButton> createState() => _SubmitButtonState();
}

class _SubmitButtonState extends State<_SubmitButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: widget.isLoading ? SystemMouseCursors.basic : SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.isLoading ? null : widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          transform: Matrix4.identity()..translate(0.0, _hovered && !widget.isLoading ? -2.0 : 0.0),
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            color: const Color(0xFFF58A1F),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              if (_hovered || true) // always subtle glow, stronger on hover
                BoxShadow(
                  color: const Color(0xFFF58A1F).withValues(alpha: _hovered ? 0.3 : 0.15),
                  blurRadius: _hovered ? 30 : 20,
                  spreadRadius: _hovered ? 4 : 0,
                  offset: const Offset(0, 4),
                ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.isLoading) ...[
                const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                  ),
                ),
                const SizedBox(width: 12),
              ],
              const Text(
                'Continue to Address',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.2,
                ),
              ),
              if (!widget.isLoading) ...[
                const SizedBox(width: 8),
                AnimatedSlide(
                  duration: const Duration(milliseconds: 200),
                  offset: _hovered ? const Offset(0.2, 0) : Offset.zero,
                  child: const Icon(Icons.arrow_forward, color: Colors.black, size: 22),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.white.withValues(alpha: 0.05)),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Column(
        children: [
          Text(
            '© 2024 PAYROUTE AFRICA. SECURE INSTITUTIONAL GATEWAY.',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.2),
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.shield, color: Colors.white.withValues(alpha: 0.2), size: 18),
              const SizedBox(width: 24),
              Icon(Icons.verified, color: Colors.white.withValues(alpha: 0.2), size: 18),
              const SizedBox(width: 24),
              Icon(Icons.lock, color: Colors.white.withValues(alpha: 0.2), size: 18),
            ],
          ),
        ],
      ),
    );
  }
}

class _RightSection extends StatelessWidget {
  final bool isStretched;
  const _RightSection({this.isStretched = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: const Color(0xFF131720),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.05),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'PERSONAL HUB',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.5),
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text.rich(
            TextSpan(
              children: [
                const TextSpan(text: 'Your financial\n'),
                TextSpan(
                  text: 'ecosystem ',
                  style: TextStyle(
                    color: const Color(0xFFF58A1F),
                  ),
                ),
                const TextSpan(text: 'awaits.'),
              ],
            ),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 40,
              fontWeight: FontWeight.w800,
              height: 1.2,
              letterSpacing: -1,
            ),
          ),
          const SizedBox(height: 40),
          const _FeatureCard(
            icon: Icons.payments_outlined,
            iconColor: Color(0xFFF58A1F),
            iconBgColor: Color(0x1AF58A1F),
            title: 'Zero-Fee Transfers',
            description:
                'Leverage our local rails to eliminate predatory transaction costs across African borders.',
          ),
          const SizedBox(height: 24),
          const _FeatureCard(
            icon: Icons.account_balance_wallet_outlined,
            iconColor: Color(0xFF4A90E2),
            iconBgColor: Color(0x1A4A90E2),
            title: 'Real-time Routing',
            description:
                'Intelligent algorithm-driven pathfinding ensuring your funds arrive in milliseconds, not days.',
          ),
          if (isStretched) const Spacer() else const SizedBox(height: 48),
          Row(
            children: [
              SizedBox(
                height: 40,
                width: 120,
                child: Stack(
                  children: [
                    Positioned(
                      left: 0,
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.person, color: Colors.grey[400], size: 24),
                      ),
                    ),
                    Positioned(
                      left: 28,
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.grey[200],
                        child: Icon(Icons.person, color: Colors.grey[500], size: 24),
                      ),
                    ),
                    Positioned(
                      left: 56,
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: const Color(0xFFFFF0E0),
                        child: Icon(Icons.person, color: const Color(0xFFF58A1F), size: 24),
                      ),
                    ),
                    Positioned(
                      left: 84,
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: const Color(0xFFF58A1F),
                        child: const Text(
                          '+24k',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  'Joined by thousands of elite users',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.4),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final String title;
  final String description;

  const _FeatureCard({
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.02),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.05),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.5),
                    fontSize: 14,
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
