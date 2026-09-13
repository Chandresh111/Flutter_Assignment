import 'dart:math' as math;

import 'package:flutter/material.dart';
import '../utils/app_theme.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  late final AnimationController _animationController;

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // ============================================================
  // VALIDATION
  // ============================================================

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Full name is required';
    }

    if (value.trim().length < 2) {
      return 'Name must contain at least 2 characters';
    }

    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email address is required';
    }

    final emailRegex = RegExp(
      r'^[\w\.-]+@[\w\.-]+\.\w+$',
    );

    if (!emailRegex.hasMatch(value.trim())) {
      return 'Enter a valid email address';
    }

    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    if (value.length < 6) {
      return 'Password must contain at least 6 characters';
    }

    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }

    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }

    return null;
  }

  // ============================================================
  // SUBMIT
  // ============================================================

  Future<void> _submitForm() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    // Small delay gives the button a premium loading interaction.
    await Future.delayed(
      const Duration(milliseconds: 650),
    );

    if (!mounted) return;

    setState(() {
      _isSubmitting = false;
    });

    Navigator.pushNamed(
      context,
      '/details',
      arguments: {
        'name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
      },
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Stack(
        children: [
          // Animated background
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return CustomPaint(
                  painter: _RegistrationBackgroundPainter(
                    animationValue: _animationController.value,
                  ),
                );
              },
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 18,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 900,
                  ),
                  child: Column(
                    children: [
                      _buildTopBar(),

                      const SizedBox(height: 35),

                      _buildIntro(),

                      const SizedBox(height: 28),

                      _buildFormCard(),

                      const SizedBox(height: 20),

                      _buildSecurityCard(),

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // TOP BAR
  // ============================================================

  Widget _buildTopBar() {
    return Row(
      children: [
        // Back button
        _GlassCircleButton(
          icon: Icons.arrow_back_rounded,
          onTap: () {
            Navigator.pop(context);
          },
        ),

        const SizedBox(width: 14),

        // Logo
        _buildLogo(),

        const SizedBox(width: 10),

        const Text(
          'FormFlow',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: AppTheme.textPrimary,
            letterSpacing: -0.5,
          ),
        ),

        const Spacer(),

        // Progress
        if (MediaQuery.sizeOf(context).width > 520)
          _buildProgress(),

        const SizedBox(width: 4),
      ],
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 39,
      height: 39,
      decoration: BoxDecoration(
        gradient: AppTheme.primaryGradient,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primary.withValues(alpha: 0.20),
            blurRadius: 16,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: const Icon(
        Icons.auto_awesome_rounded,
        color: Colors.white,
        size: 21,
      ),
    );
  }

  Widget _buildProgress() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const Text(
          '1 / 3',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w800,
            color: AppTheme.primary,
          ),
        ),
        const SizedBox(height: 7),
        SizedBox(
          width: 105,
          child: Row(
            children: [
              _progressDot(true),
              _progressLine(),
              _progressDot(false),
              _progressLine(),
              _progressDot(false),
            ],
          ),
        ),
      ],
    );
  }

  Widget _progressDot(bool active) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: active ? 12 : 10,
      height: active ? 12 : 10,
      decoration: BoxDecoration(
        color: active
            ? AppTheme.primary
            : const Color(0xFFD1D4E6),
        shape: BoxShape.circle,
        boxShadow: active
            ? [
                BoxShadow(
                  color: AppTheme.primary.withValues(alpha: 0.25),
                  blurRadius: 8,
                ),
              ]
            : null,
      ),
    );
  }

  Widget _progressLine() {
    return Expanded(
      child: Container(
        height: 2,
        color: const Color(0xFFD8DBEC),
      ),
    );
  }

  // ============================================================
  // INTRO
  // ============================================================

  Widget _buildIntro() {
    return TweenAnimationBuilder<double>(
      tween: Tween(
        begin: 0,
        end: 1,
      ),
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: child,
          ),
        );
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 600;

          if (isMobile) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildIntroIcon(),
                const SizedBox(height: 18),
                _buildIntroText(),
              ],
            );
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildIntroIcon(),
              const SizedBox(width: 18),
              Expanded(
                child: _buildIntroText(),
              ),
              const SizedBox(width: 20),
              _buildQuote(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildIntroIcon() {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFFE9DEFF),
            Color(0xFFFFE5F8),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Icon(
        Icons.person_add_alt_1_rounded,
        color: AppTheme.primary,
        size: 31,
      ),
    );
  }

  Widget _buildIntroText() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Create an Account',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w800,
            color: AppTheme.textPrimary,
            letterSpacing: -0.8,
          ),
        ),
        SizedBox(height: 7),
        Text(
          'Join FormFlow and be part of something amazing.',
          style: TextStyle(
            fontSize: 14,
            color: AppTheme.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildQuote() {
    return const SizedBox(
      width: 175,
      child: Text(
        '“A small step today, a bigger future tomorrow.”',
        style: TextStyle(
          fontSize: 12,
          height: 1.5,
          fontStyle: FontStyle.italic,
          color: AppTheme.textSecondary,
        ),
      ),
    );
  }

  // ============================================================
  // FORM CARD
  // ============================================================

  Widget _buildFormCard() {
    return TweenAnimationBuilder<double>(
      tween: Tween(
        begin: 0.97,
        end: 1,
      ),
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: child,
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(26),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.91),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: Colors.white,
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primary.withValues(alpha: 0.055),
              blurRadius: 35,
              offset: const Offset(0, 18),
            ),
          ],
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Heading
              const Text(
                'Personal Information',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.textPrimary,
                ),
              ),

              const SizedBox(height: 5),

              const Text(
                'All fields marked with * are required.',
                style: TextStyle(
                  fontSize: 12,
                  color: AppTheme.textSecondary,
                ),
              ),

              const SizedBox(height: 25),

              _buildField(
                label: 'Full Name',
                controller: _nameController,
                hint: 'Enter your full name',
                icon: Icons.person_outline_rounded,
                validator: _validateName,
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.next,
              ),

              const SizedBox(height: 18),

              _buildField(
                label: 'Email Address',
                controller: _emailController,
                hint: 'example@email.com',
                icon: Icons.email_outlined,
                validator: _validateEmail,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
              ),

              const SizedBox(height: 18),

              _buildPasswordField(
                label: 'Password',
                controller: _passwordController,
                hint: 'Minimum 6 characters',
                obscure: _obscurePassword,
                onToggle: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
                validator: _validatePassword,
                textInputAction: TextInputAction.next,
              ),

              const SizedBox(height: 18),

              _buildPasswordField(
                label: 'Confirm Password',
                controller: _confirmPasswordController,
                hint: 'Re-enter your password',
                obscure: _obscureConfirmPassword,
                onToggle: () {
                  setState(() {
                    _obscureConfirmPassword =
                        !_obscureConfirmPassword;
                  });
                },
                validator: _validateConfirmPassword,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _submitForm(),
              ),

              const SizedBox(height: 26),

              _buildSubmitButton(),

              const SizedBox(height: 18),

              // Divider / OR
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 1,
                      color: AppTheme.border,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 15,
                    ),
                    child: Text(
                      'OR',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textMuted,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 1,
                      color: AppTheme.border,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 15),

              Center(
                child: Wrap(
                  alignment: WrapAlignment.center,
                  children: [
                    const Text(
                      'Already have an account? ',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Back to Home',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // NORMAL FIELD
  // ============================================================

  Widget _buildField({
    required String label,
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    required String? Function(String?) validator,
    TextInputType? keyboardType,
    TextInputAction? textInputAction,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label),

        const SizedBox(height: 7),

        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          textCapitalization: TextCapitalization.words,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: _buildInputIcon(icon),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // PASSWORD FIELD
  // ============================================================

  Widget _buildPasswordField({
    required String label,
    required TextEditingController controller,
    required String hint,
    required bool obscure,
    required VoidCallback onToggle,
    required String? Function(String?) validator,
    TextInputAction? textInputAction,
    void Function(String)? onSubmitted,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label),

        const SizedBox(height: 7),

        TextFormField(
          controller: controller,
          obscureText: obscure,
          textInputAction: textInputAction,
          validator: validator,
          onFieldSubmitted: onSubmitted,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: _buildInputIcon(
              Icons.lock_outline_rounded,
            ),
            suffixIcon: IconButton(
              onPressed: onToggle,
              icon: Icon(
                obscure
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                size: 20,
                color: AppTheme.textSecondary,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLabel(String label) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: AppTheme.textPrimary,
        ),
        children: [
          TextSpan(text: label),
          const TextSpan(
            text: ' *',
            style: TextStyle(
              color: AppTheme.error,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputIcon(IconData icon) {
    return Padding(
      padding: const EdgeInsets.all(7),
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color(0xFFEAF0FF),
              Color(0xFFF0E9FF),
            ],
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          size: 19,
          color: AppTheme.primary,
        ),
      ),
    );
  }

  // ============================================================
  // SUBMIT BUTTON
  // ============================================================

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            gradient: AppTheme.primaryGradient,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primary.withValues(alpha: 0.23),
                blurRadius: 22,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _isSubmitting ? null : _submitForm,
              borderRadius: BorderRadius.circular(16),
              child: Center(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: _isSubmitting
                      ? const SizedBox(
                          key: ValueKey('loading'),
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : const Row(
                          key: ValueKey('button'),
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Create Account',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            SizedBox(width: 12),
                            Icon(
                              Icons.arrow_forward_rounded,
                              color: Colors.white,
                              size: 19,
                            ),
                          ],
                        ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // SECURITY CARD
  // ============================================================

  Widget _buildSecurityCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 17,
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFFEAF3FF),
            Color(0xFFEFF0FF),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              gradient: AppTheme.primaryGradient,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.shield_outlined,
              color: Colors.white,
              size: 23,
            ),
          ),

          const SizedBox(width: 14),

          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your information is secure with us.',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textSecondary,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'We only use your data for demonstration purposes.',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppTheme.textMuted,
                  ),
                ),
              ],
            ),
          ),

          if (MediaQuery.sizeOf(context).width > 500)
            const Icon(
              Icons.verified_user_outlined,
              color: AppTheme.primary,
              size: 27,
            ),
        ],
      ),
    );
  }
}

// ================================================================
// GLASS CIRCLE BUTTON
// ================================================================

class _GlassCircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _GlassCircleButton({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: 0.75),
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: const Padding(
          padding: EdgeInsets.all(11),
          child: Icon(
            Icons.arrow_back_rounded,
            color: AppTheme.textPrimary,
            size: 20,
          ),
        ),
      ),
    );
  }
}

// ================================================================
// BACKGROUND PAINTER
// ================================================================

class _RegistrationBackgroundPainter extends CustomPainter {
  final double animationValue;

  const _RegistrationBackgroundPainter({
    required this.animationValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final movement =
        math.sin(animationValue * math.pi * 2) * 18;

    final paint = Paint();

    // Top-right purple glow
    paint.shader = RadialGradient(
      colors: [
        AppTheme.secondary.withValues(alpha: 0.075),
        Colors.transparent,
      ],
    ).createShader(
      Rect.fromCircle(
        center: Offset(
          size.width * 0.88,
          size.height * 0.12 + movement,
        ),
        radius: 260,
      ),
    );

    canvas.drawCircle(
      Offset(
        size.width * 0.88,
        size.height * 0.12 + movement,
      ),
      260,
      paint,
    );

    // Bottom-left blue glow
    paint.shader = RadialGradient(
      colors: [
        AppTheme.primary.withValues(alpha: 0.055),
        Colors.transparent,
      ],
    ).createShader(
      Rect.fromCircle(
        center: Offset(
          size.width * 0.08,
          size.height * 0.90 - movement,
        ),
        radius: 240,
      ),
    );

    canvas.drawCircle(
      Offset(
        size.width * 0.08,
        size.height * 0.90 - movement,
      ),
      240,
      paint,
    );
  }

  @override
  bool shouldRepaint(
    covariant _RegistrationBackgroundPainter oldDelegate,
  ) {
    return oldDelegate.animationValue != animationValue;
  }
}