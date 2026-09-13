import 'dart:math' as math;

import 'package:flutter/material.dart';
import '../utils/app_theme.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen>
    with TickerProviderStateMixin {
  late final AnimationController _entranceController;
  late final AnimationController _floatController;

  late final Animation<double> _scaleAnimation;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat(reverse: true);

    _scaleAnimation = CurvedAnimation(
      parent: _entranceController,
      curve: Curves.elasticOut,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(
        0.25,
        1,
        curve: Curves.easeOut,
      ),
    );

    _entranceController.forward();
  }

  @override
  void dispose() {
    _entranceController.dispose();
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context)?.settings.arguments
            as Map<String, dynamic>?;

    final name =
        arguments?['name']?.toString() ?? 'Guest User';

    final email =
        arguments?['email']?.toString() ?? 'No email provided';

    final registrationDate = _formatDate(DateTime.now());

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Stack(
        children: [
          // Animated background
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _floatController,
              builder: (context, child) {
                return CustomPaint(
                  painter: _SuccessBackgroundPainter(
                    animationValue: _floatController.value,
                  ),
                );
              },
            ),
          ),

          // Confetti
          Positioned.fill(
            child: IgnorePointer(
              child: AnimatedBuilder(
                animation: _floatController,
                builder: (context, child) {
                  return CustomPaint(
                    painter: _ConfettiPainter(
                      animationValue: _floatController.value,
                    ),
                  );
                },
              ),
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
                    maxWidth: 850,
                  ),
                  child: Column(
                    children: [
                      _buildTopBar(),

                      const SizedBox(height: 35),

                      _buildSuccessHeader(),

                      const SizedBox(height: 30),

                      _buildDetailsCard(
                        name: name,
                        email: email,
                        date: registrationDate,
                      ),

                      const SizedBox(height: 20),

                      _buildSuccessMessage(),

                      const SizedBox(height: 22),

                      _buildActionButtons(),

                      const SizedBox(height: 35),

                      _buildQuote(),

                      const SizedBox(height: 20),
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
        _GlassCircleButton(
          icon: Icons.arrow_back_rounded,
          onTap: () {
            Navigator.pop(context);
          },
        ),

        const SizedBox(width: 14),

        Container(
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
        ),

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

        _GlassCircleButton(
          icon: Icons.home_outlined,
          onTap: () {
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/',
              (route) => false,
            );
          },
        ),
      ],
    );
  }

  // ============================================================
  // SUCCESS HEADER
  // ============================================================

  Widget _buildSuccessHeader() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Column(
        children: [
          ScaleTransition(
            scale: _scaleAnimation,
            child: AnimatedBuilder(
              animation: _floatController,
              builder: (context, child) {
                final movement =
                    math.sin(
                      _floatController.value * math.pi * 2,
                    ) *
                    4;

                return Transform.translate(
                  offset: Offset(0, movement),
                  child: child,
                );
              },
              child: _buildSuccessIcon(),
            ),
          ),

          const SizedBox(height: 25),

          const Text(
            'Welcome Aboard!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.w800,
              color: AppTheme.textPrimary,
              letterSpacing: -1,
            ),
          ),

          const SizedBox(height: 9),

          const Text(
            'Your account has been created successfully.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              color: AppTheme.textSecondary,
            ),
          ),

          const SizedBox(height: 5),

          const Text(
            'Thank you for joining FormFlow!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessIcon() {
    return Container(
      width: 126,
      height: 126,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppTheme.success.withValues(alpha: 0.08),
        boxShadow: [
          BoxShadow(
            color: AppTheme.success.withValues(alpha: 0.08),
            blurRadius: 35,
            spreadRadius: 15,
          ),
        ],
      ),
      child: Center(
        child: Container(
          width: 92,
          height: 92,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [
                Color(0xFF25CA84),
                Color(0xFF13A96C),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: AppTheme.success.withValues(alpha: 0.28),
                blurRadius: 22,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: const Icon(
            Icons.check_rounded,
            color: Colors.white,
            size: 52,
          ),
        ),
      ),
    );
  }

  // ============================================================
  // DETAILS CARD
  // ============================================================

  Widget _buildDetailsCard({
    required String name,
    required String email,
    required String date,
  }) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.92),
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
        child: Column(
          children: [
            // Card heading
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFFE9DEFF),
                        Color(0xFFE0E8FF),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Icon(
                    Icons.person_outline_rounded,
                    color: AppTheme.primary,
                    size: 25,
                  ),
                ),

                const SizedBox(width: 13),

                const Expanded(
                  child: Text(
                    'Your Details',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.successSoft,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.circle,
                        size: 8,
                        color: AppTheme.success,
                      ),
                      SizedBox(width: 7),
                      Text(
                        'Account Created',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.success,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            _buildDetailItem(
              icon: Icons.person_outline_rounded,
              label: 'Full Name',
              value: name,
            ),

            _buildDivider(),

            _buildDetailItem(
              icon: Icons.email_outlined,
              label: 'Email Address',
              value: email,
            ),

            _buildDivider(),

            _buildDateItem(
              date: date,
            ),

            _buildDivider(),

            _buildStatusItem(),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 7,
      ),
      child: Row(
        children: [
          _detailIcon(icon),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppTheme.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateItem({
    required String date,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 7,
      ),
      child: Row(
        children: [
          _detailIcon(
            Icons.calendar_month_outlined,
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Registration Date',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppTheme.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  date,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusItem() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 7,
      ),
      child: Row(
        children: [
          _detailIcon(
            Icons.verified_user_outlined,
          ),

          const SizedBox(width: 14),

          const Expanded(
            child: Text(
              'Status',
              style: TextStyle(
                fontSize: 11,
                color: AppTheme.textSecondary,
              ),
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: AppTheme.successSoft,
              borderRadius: BorderRadius.circular(30),
            ),
            child: const Text(
              'Registered',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: AppTheme.success,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _detailIcon(IconData icon) {
    return Container(
      width: 43,
      height: 43,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFFF0E9FF),
            Color(0xFFEAF0FF),
          ],
        ),
        borderRadius: BorderRadius.circular(13),
      ),
      child: Icon(
        icon,
        color: AppTheme.primary,
        size: 21,
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(
      height: 1,
      color: AppTheme.border,
    );
  }

  // ============================================================
  // SUCCESS MESSAGE
  // ============================================================

  Widget _buildSuccessMessage() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(19),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color(0xFFE5FAF2),
              Color(0xFFEAF9F6),
            ],
          ),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: Colors.white,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.75),
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Icon(
                Icons.celebration_rounded,
                color: AppTheme.success,
                size: 27,
              ),
            ),

            const SizedBox(width: 14),

            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "You're all set!",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF0B8E5C),
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'You can now explore the app and experience '
                    'smooth navigation with named routes.',
                    style: TextStyle(
                      fontSize: 12,
                      height: 1.4,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // ACTION BUTTONS
  // ============================================================

  Widget _buildActionButtons() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 560;

        if (isMobile) {
          return Column(
            children: [
              _buildHomeButton(),
              const SizedBox(height: 12),
              _buildRegisterAgainButton(),
            ],
          );
        }

        return Row(
          children: [
            Expanded(
              child: _buildHomeButton(),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: _buildRegisterAgainButton(),
            ),
          ],
        );
      },
    );
  }

  Widget _buildHomeButton() {
    return SizedBox(
      height: 54,
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () {
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/',
            (route) => false,
          );
        },
        icon: const Icon(
          Icons.home_outlined,
          size: 19,
        ),
        label: const Text('Go to Home'),
      ),
    );
  }

  Widget _buildRegisterAgainButton() {
    return SizedBox(
      height: 54,
      width: double.infinity,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: AppTheme.primaryGradient,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primary.withValues(alpha: 0.20),
              blurRadius: 20,
              offset: const Offset(0, 9),
            ),
          ],
        ),
        child: ElevatedButton.icon(
          onPressed: () {
            Navigator.pushNamed(
              context,
              '/form',
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
          ),
          icon: const Icon(
            Icons.refresh_rounded,
            size: 19,
          ),
          label: const Text('Register Again'),
        ),
      ),
    );
  }

  // ============================================================
  // QUOTE
  // ============================================================

  Widget _buildQuote() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: const Column(
        children: [
          Text(
            '“The best way to predict the future is to build it.”',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              fontStyle: FontStyle.italic,
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
      ),
    );
  }

  // ============================================================
  // DATE
  // ============================================================

  String _formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}

// ================================================================
// GLASS BUTTON
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
        child: Padding(
          padding: const EdgeInsets.all(11),
          child: Icon(
            icon,
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

class _SuccessBackgroundPainter extends CustomPainter {
  final double animationValue;

  const _SuccessBackgroundPainter({
    required this.animationValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final movement =
        math.sin(animationValue * math.pi * 2) * 18;

    final paint = Paint();

    // Purple glow
    paint.shader = RadialGradient(
      colors: [
        AppTheme.secondary.withValues(alpha: 0.08),
        Colors.transparent,
      ],
    ).createShader(
      Rect.fromCircle(
        center: Offset(
          size.width * 0.88,
          size.height * 0.12 + movement,
        ),
        radius: 270,
      ),
    );

    canvas.drawCircle(
      Offset(
        size.width * 0.88,
        size.height * 0.12 + movement,
      ),
      270,
      paint,
    );

    // Blue glow
    paint.shader = RadialGradient(
      colors: [
        AppTheme.primary.withValues(alpha: 0.055),
        Colors.transparent,
      ],
    ).createShader(
      Rect.fromCircle(
        center: Offset(
          size.width * 0.08,
          size.height * 0.88 - movement,
        ),
        radius: 250,
      ),
    );

    canvas.drawCircle(
      Offset(
        size.width * 0.08,
        size.height * 0.88 - movement,
      ),
      250,
      paint,
    );
  }

  @override
  bool shouldRepaint(
    covariant _SuccessBackgroundPainter oldDelegate,
  ) {
    return oldDelegate.animationValue != animationValue;
  }
}

// ================================================================
// CONFETTI PAINTER
// ================================================================

class _ConfettiPainter extends CustomPainter {
  final double animationValue;

  const _ConfettiPainter({
    required this.animationValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final random = math.Random(7);

    final colors = [
      AppTheme.primary,
      AppTheme.secondary,
      const Color(0xFFFFB84D),
      AppTheme.success,
      const Color(0xFFFF6FAE),
    ];

    for (int i = 0; i < 18; i++) {
      final x = random.nextDouble() * size.width;
      final baseY = size.height * 0.10 +
          random.nextDouble() * size.height * 0.30;

      final movement =
          math.sin(
                animationValue * math.pi * 2 + i,
              ) *
              12;

      final y = baseY + movement;

      final paint = Paint()
        ..color = colors[i % colors.length]
        ..style = PaintingStyle.fill;

      final confettiSize =
          4 + random.nextDouble() * 4;

      if (i % 3 == 0) {
        canvas.drawCircle(
          Offset(x, y),
          confettiSize,
          paint,
        );
      } else {
        canvas.save();

        canvas.translate(x, y);

        canvas.rotate(
          animationValue * math.pi + i,
        );

        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromCenter(
              center: Offset.zero,
              width: confettiSize * 1.5,
              height: confettiSize * 2.8,
            ),
            Radius.circular(confettiSize),
          ),
          paint,
        );

        canvas.restore();
      }
    }
  }

  @override
  bool shouldRepaint(
    covariant _ConfettiPainter oldDelegate,
  ) {
    return oldDelegate.animationValue != animationValue;
  }
}