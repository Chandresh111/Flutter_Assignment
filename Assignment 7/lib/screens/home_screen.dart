import 'dart:math' as math;

import 'package:flutter/material.dart';
import '../utils/app_theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _openRegistration() {
    Navigator.pushNamed(context, '/form');
  }

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
                  painter: _BackgroundPainter(
                    animationValue: _animationController.value,
                  ),
                );
              },
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 1280,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 28,
                    ),
                    child: Column(
                      children: [
                        _buildHeader(),

                        const SizedBox(height: 28),

                        _buildHeroSection(),

                        const SizedBox(height: 28),

                        _buildFeatureSection(),

                        const SizedBox(height: 28),

                        _buildJourneyCard(),

                        const SizedBox(height: 34),

                        _buildQuote(),

                        const SizedBox(height: 24),
                      ],
                    ),
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
  // HEADER
  // ============================================================

  Widget _buildHeader() {
    return Row(
      children: [
        // Logo
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildLogo(),
            const SizedBox(width: 12),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'FormFlow',
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.textPrimary,
                    letterSpacing: -0.5,
                  ),
                ),
                Text(
                  'Simple Forms. Better Futures.',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),

        const Spacer(),

        // Desktop tagline
        if (MediaQuery.sizeOf(context).width > 700)
          const Text(
            'Build. Validate. Navigate.',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppTheme.textSecondary,
            ),
          ),

        const SizedBox(width: 18),

        // Profile button
        _GlassIconButton(
          icon: Icons.person_outline_rounded,
          onTap: _openRegistration,
        ),
      ],
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        gradient: AppTheme.primaryGradient,
        borderRadius: BorderRadius.circular(13),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primary.withValues(alpha: 0.20),
            blurRadius: 18,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: const Center(
        child: Icon(
          Icons.auto_awesome_rounded,
          color: Colors.white,
          size: 23,
        ),
      ),
    );
  }

  // ============================================================
  // HERO
  // ============================================================

  Widget _buildHeroSection() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 760;

        return Container(
          width: double.infinity,
          padding: EdgeInsets.all(
            isMobile ? 25 : 42,
          ),
          decoration: BoxDecoration(
            gradient: AppTheme.heroGradient,
            borderRadius: BorderRadius.circular(
              isMobile ? 28 : 38,
            ),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.9),
            ),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primary.withValues(alpha: 0.06),
                blurRadius: 40,
                offset: const Offset(0, 20),
              ),
            ],
          ),
          child: isMobile
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeroCopy(isMobile),
                    const SizedBox(height: 35),
                    _buildHeroVisual(isMobile),
                  ],
                )
              : Row(
                  children: [
                    Expanded(
                      flex: 11,
                      child: _buildHeroCopy(isMobile),
                    ),
                    const SizedBox(width: 30),
                    Expanded(
                      flex: 9,
                      child: _buildHeroVisual(isMobile),
                    ),
                  ],
                ),
        );
      },
    );
  }

  Widget _buildHeroCopy(bool isMobile) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 25 * (1 - value)),
            child: child,
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Assignment badge
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 13,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: AppTheme.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: AppTheme.primary.withValues(alpha: 0.08),
              ),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.auto_awesome_rounded,
                  size: 15,
                  color: AppTheme.primary,
                ),
                SizedBox(width: 7),
                Text(
                  'FLUTTER ASSIGNMENT 07',
                  style: TextStyle(
                    color: AppTheme.primary,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.7,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Heading
          RichText(
            text: TextSpan(
              style: TextStyle(
                fontSize: isMobile ? 34 : 52,
                fontWeight: FontWeight.w800,
                color: AppTheme.textPrimary,
                height: 1.04,
                letterSpacing: -1.7,
              ),
              children: const [
                TextSpan(text: 'Build\nYour Future\nWith '),
                TextSpan(
                  text: 'FormFlow',
                  style: TextStyle(
                    color: AppTheme.primary,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            'A modern Flutter application demonstrating '
            'forms, validation and seamless navigation '
            'across multiple screens.',
            style: TextStyle(
              fontSize: 15,
              height: 1.55,
              color: AppTheme.textSecondary,
            ),
          ),

          const SizedBox(height: 28),

          // Buttons
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _GradientButton(
                label: 'Get Started',
                icon: Icons.arrow_forward_rounded,
                onTap: _openRegistration,
              ),
              _OutlineButton(
                label: 'Learn More',
                icon: Icons.play_arrow_rounded,
                onTap: () {
                  _showLearnMore();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeroVisual(bool isMobile) {
    return SizedBox(
      height: isMobile ? 292 : 350,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          final movement =
              math.sin(_animationController.value * math.pi * 2) * 8;

          return Stack(
            alignment: Alignment.center,
            children: [
              // Large glow
              Container(
                width: isMobile ? 245 : 300,
                height: isMobile ? 245 : 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppTheme.primary.withValues(alpha: 0.16),
                      AppTheme.secondary.withValues(alpha: 0.07),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),

              // Decorative circles
              Positioned(
                top: 18 + movement,
                right: isMobile ? 20 : 30,
                child: _SoftBubble(
                  size: 68,
                  color: AppTheme.primary.withValues(alpha: 0.13),
                ),
              ),

              Positioned(
                bottom: 15 - movement,
                left: isMobile ? 10 : 20,
                child: _SoftBubble(
                  size: 52,
                  color: AppTheme.secondary.withValues(alpha: 0.13),
                ),
              ),

              // Phone
              Transform.translate(
                offset: Offset(0, movement),
                child: Transform.rotate(
                  angle: -0.09,
                  child: _buildPhoneMockup(),
                ),
              ),

              // Floating user icon
              Positioned(
                top: 54 + movement,
                left: isMobile ? 20 : 35,
                child: _FloatingIcon(
                  icon: Icons.person_add_alt_1_rounded,
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFFEEDCFF),
                      Color(0xFFDDE5FF),
                    ],
                  ),
                ),
              ),

              // Floating document icon
              Positioned(
                bottom: 45 - movement,
                left: isMobile ? 38 : 60,
                child: _FloatingIcon(
                  icon: Icons.description_outlined,
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFFE0ECFF),
                      Color(0xFFD8F3FF),
                    ],
                  ),
                ),
              ),

              // Floating check
              Positioned(
                bottom: 38 - movement,
                right: isMobile ? 25 : 50,
                child: Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    gradient: AppTheme.primaryGradient,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primary.withValues(alpha: 0.30),
                        blurRadius: 25,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    color: Colors.white,
                    size: 38,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildPhoneMockup() {
    return Container(
      width: 145,
      height: 280,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF493CFF),
            Color(0xFF8B43FF),
            Color(0xFFE64DFF),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(31),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primary.withValues(alpha: 0.30),
            blurRadius: 35,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF8F9FF),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),

            // Camera
            Container(
              width: 45,
              height: 5,
              decoration: BoxDecoration(
                color: const Color(0xFFD8DAE8),
                borderRadius: BorderRadius.circular(10),
              ),
            ),

            const SizedBox(height: 14),

            // Mini header
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
              ),
              child: Row(
                children: [
                  Container(
                    width: 25,
                    height: 25,
                    decoration: BoxDecoration(
                      gradient: AppTheme.primaryGradient,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.auto_awesome_rounded,
                      size: 13,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 7),
                  const Text(
                    'FormFlow',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            const Text(
              'Create Account',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: AppTheme.textPrimary,
              ),
            ),

            const SizedBox(height: 12),

            _phoneField(Icons.person_outline),
            _phoneField(Icons.email_outlined),
            _phoneField(Icons.lock_outline),

            const SizedBox(height: 6),

            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              height: 24,
              decoration: BoxDecoration(
                gradient: AppTheme.primaryGradient,
                borderRadius: BorderRadius.circular(9),
              ),
              child: const Center(
                child: Text(
                  'Continue',
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            Container(
              width: 35,
              height: 4,
              margin: const EdgeInsets.only(bottom: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFD0D3E0),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _phoneField(IconData icon) {
    return Container(
      height: 30,
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      padding: const EdgeInsets.symmetric(horizontal: 9),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppTheme.border,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 13,
            color: AppTheme.primary,
          ),
          const SizedBox(width: 7),
          Container(
            width: 45,
            height: 5,
            decoration: BoxDecoration(
              color: const Color(0xFFE2E5F1),
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // FEATURES
  // ============================================================

  Widget _buildFeatureSection() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        final isMobile = width < 650;
        final isTablet = width >= 650 && width < 950;

        final cards = [
          _FeatureData(
            icon: Icons.edit_note_rounded,
            title: 'Easy Forms',
            description:
                'Create beautiful forms with Flutter widgets.',
            iconBackground: const Color(0xFFE5EEFF),
            iconColor: AppTheme.primary,
          ),
          _FeatureData(
            icon: Icons.verified_user_outlined,
            title: 'Smart Validation',
            description:
                'Validate required fields, email and password.',
            iconBackground: const Color(0xFFFFE8F1),
            iconColor: const Color(0xFFEC4F82),
          ),
          _FeatureData(
            icon: Icons.send_rounded,
            title: 'Smooth Navigation',
            description:
                'Move between screens using named routes.',
            iconBackground: const Color(0xFFE1F8F0),
            iconColor: AppTheme.success,
          ),
        ];

        if (isMobile) {
          return Column(
            children: [
              for (int i = 0; i < cards.length; i++) ...[
                _buildFeatureCard(cards[i]),
                if (i != cards.length - 1)
                  const SizedBox(height: 12),
              ],
            ],
          );
        }

        return Row(
          children: [
            for (int i = 0; i < cards.length; i++) ...[
              Expanded(
                child: _buildFeatureCard(
                  cards[i],
                  compact: isTablet,
                ),
              ),
              if (i != cards.length - 1)
                const SizedBox(width: 14),
            ],
          ],
        );
      },
    );
  }

  Widget _buildFeatureCard(
    _FeatureData data, {
    bool compact = false,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.96, end: 1),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: child,
        );
      },
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: EdgeInsets.all(
            compact ? 18 : 21,
          ),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.88),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: Colors.white,
            ),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primary.withValues(alpha: 0.045),
                blurRadius: 24,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: data.iconBackground,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(
                  data.icon,
                  color: data.iconColor,
                  size: 24,
                ),
              ),

              const SizedBox(height: 17),

              Text(
                data.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.textPrimary,
                ),
              ),

              const SizedBox(height: 7),

              Text(
                data.description,
                style: const TextStyle(
                  fontSize: 13,
                  height: 1.45,
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // JOURNEY CARD
  // ============================================================

  Widget _buildJourneyCard() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 650;

        return Container(
          width: double.infinity,
          padding: EdgeInsets.all(
            isMobile ? 25 : 32,
          ),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xFFF0EEFF),
                Color(0xFFF8F0FF),
                Color(0xFFEDF4FF),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: Colors.white,
            ),
          ),
          child: isMobile
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _journeyText(),
                    const SizedBox(height: 25),
                    _buildRocket(),
                    const SizedBox(height: 18),
                    _GradientButton(
                      label: 'Start Registration',
                      icon: Icons.arrow_forward_rounded,
                      onTap: _openRegistration,
                    ),
                  ],
                )
              : Row(
                  children: [
                    Expanded(
                      child: _journeyText(),
                    ),
                    const SizedBox(width: 20),
                    _buildRocket(),
                    const SizedBox(width: 25),
                    _GradientButton(
                      label: 'Start Registration',
                      icon: Icons.arrow_forward_rounded,
                      onTap: _openRegistration,
                    ),
                  ],
                ),
        );
      },
    );
  }

  Widget _journeyText() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ready to start\nyour journey?',
          style: TextStyle(
            fontSize: 27,
            fontWeight: FontWeight.w800,
            color: AppTheme.textPrimary,
            height: 1.08,
          ),
        ),
        SizedBox(height: 10),
        Text(
          'Create your account and explore\nthe complete form flow experience.',
          style: TextStyle(
            fontSize: 14,
            height: 1.45,
            color: AppTheme.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildRocket() {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        final movement =
            math.sin(_animationController.value * math.pi * 2) * 6;

        return Transform.translate(
          offset: Offset(0, movement),
          child: Transform.rotate(
            angle: -0.15,
            child: Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Colors.white.withValues(alpha: 0.9),
                    const Color(0xFFE4E6FF),
                  ],
                ),
              ),
              child: const Icon(
                Icons.rocket_launch_rounded,
                size: 62,
                color: AppTheme.primary,
              ),
            ),
          ),
        );
      },
    );
  }

  // ============================================================
  // QUOTE
  // ============================================================

  Widget _buildQuote() {
    return const Column(
      children: [
        Text(
          '“Good design makes complex things simple.”',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.w500,
            color: AppTheme.textSecondary,
          ),
        ),
        SizedBox(height: 7),
        Text(
          '— FormFlow',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: AppTheme.textMuted,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // LEARN MORE
  // ============================================================

  void _showLearnMore() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(26),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(30),
            ),
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 45,
                      height: 45,
                      decoration: BoxDecoration(
                        gradient: AppTheme.primaryGradient,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(
                        Icons.auto_awesome_rounded,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 14),
                    const Text(
                      'About FormFlow',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                const Text(
                  'FormFlow is a Flutter demonstration app '
                  'showcasing multi-screen navigation, form '
                  'handling and input validation.',
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    color: AppTheme.textSecondary,
                  ),
                ),
                const SizedBox(height: 22),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Got it'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ================================================================
// GRADIENT BUTTON
// ================================================================

class _GradientButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _GradientButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  State<_GradientButton> createState() => _GradientButtonState();
}

class _GradientButtonState extends State<_GradientButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) {
        setState(() => _hovered = true);
      },
      onExit: (_) {
        setState(() => _hovered = false);
      },
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(
            horizontal: 21,
            vertical: 15,
          ),
          transform: Matrix4.identity()
            ..scale(_hovered ? 1.03 : 1.0),
          decoration: BoxDecoration(
            gradient: AppTheme.primaryGradient,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primary.withValues(
                  alpha: _hovered ? 0.30 : 0.18,
                ),
                blurRadius: _hovered ? 24 : 16,
                offset: const Offset(0, 9),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 12),
              Icon(
                widget.icon,
                color: Colors.white,
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ================================================================
// OUTLINE BUTTON
// ================================================================

class _OutlineButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _OutlineButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  State<_OutlineButton> createState() => _OutlineButtonState();
}

class _OutlineButtonState extends State<_OutlineButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) {
        setState(() => _hovered = true);
      },
      onExit: (_) {
        setState(() => _hovered = false);
      },
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 14,
          ),
          decoration: BoxDecoration(
            color: _hovered
                ? Colors.white
                : Colors.white.withValues(alpha: 0.55),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: AppTheme.primary.withValues(alpha: 0.25),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                widget.icon,
                color: AppTheme.textPrimary,
                size: 19,
              ),
              const SizedBox(width: 9),
              Text(
                widget.label,
                style: const TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 14,
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

// ================================================================
// GLASS ICON BUTTON
// ================================================================

class _GlassIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _GlassIconButton({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: 0.72),
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Icon(
            icon,
            color: AppTheme.textPrimary,
            size: 21,
          ),
        ),
      ),
    );
  }
}

// ================================================================
// FLOATING ICON
// ================================================================

class _FloatingIcon extends StatelessWidget {
  final IconData icon;
  final Gradient gradient;

  const _FloatingIcon({
    required this.icon,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 54,
      height: 54,
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primary.withValues(alpha: 0.10),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Icon(
        icon,
        color: AppTheme.primary,
        size: 25,
      ),
    );
  }
}

// ================================================================
// SOFT BUBBLE
// ================================================================

class _SoftBubble extends StatelessWidget {
  final double size;
  final Color color;

  const _SoftBubble({
    required this.size,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}

// ================================================================
// FEATURE DATA
// ================================================================

class _FeatureData {
  final IconData icon;
  final String title;
  final String description;
  final Color iconBackground;
  final Color iconColor;

  const _FeatureData({
    required this.icon,
    required this.title,
    required this.description,
    required this.iconBackground,
    required this.iconColor,
  });
}

// ================================================================
// BACKGROUND PAINTER
// ================================================================

class _BackgroundPainter extends CustomPainter {
  final double animationValue;

  const _BackgroundPainter({
    required this.animationValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    final movement =
        math.sin(animationValue * math.pi * 2) * 20;

    // Top-right glow
    paint.shader = RadialGradient(
      colors: [
        AppTheme.primary.withValues(alpha: 0.07),
        Colors.transparent,
      ],
    ).createShader(
      Rect.fromCircle(
        center: Offset(
          size.width * 0.90,
          size.height * 0.10 + movement,
        ),
        radius: 260,
      ),
    );

    canvas.drawCircle(
      Offset(
        size.width * 0.90,
        size.height * 0.10 + movement,
      ),
      260,
      paint,
    );

    // Bottom-left glow
    paint.shader = RadialGradient(
      colors: [
        AppTheme.secondary.withValues(alpha: 0.06),
        Colors.transparent,
      ],
    ).createShader(
      Rect.fromCircle(
        center: Offset(
          size.width * 0.05,
          size.height * 0.88 - movement,
        ),
        radius: 220,
      ),
    );

    canvas.drawCircle(
      Offset(
        size.width * 0.05,
        size.height * 0.88 - movement,
      ),
      220,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _BackgroundPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}