import 'package:flutter/material.dart';

import '../utils/app_theme.dart';

class ShoplyFooter extends StatefulWidget {
  const ShoplyFooter({super.key});

  @override
  State<ShoplyFooter> createState() => _ShoplyFooterState();
}

class _ShoplyFooterState extends State<ShoplyFooter> {
  final TextEditingController _emailController =
      TextEditingController();

  bool _subscribed = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _subscribe() {
    final email = _emailController.text.trim();

    if (email.isEmpty || !email.contains('@')) {
      _showMessage('Please enter a valid email address.');
      return;
    }

    setState(() {
      _subscribed = true;
    });

    _emailController.clear();
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(18),
          duration: const Duration(seconds: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(13),
          ),
        ),
      );
  }

  void _comingSoon(String section) {
    _showMessage('$section is coming soon.');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      color: const Color(0xFF282321),
      child: Column(
        children: [
          _buildMainFooter(context),
          _buildTrustSection(context),
          _buildBottomBar(context),
        ],
      ),
    );
  }

  Widget _buildMainFooter(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 760;

        return Padding(
          padding: EdgeInsets.fromLTRB(
            isMobile ? 22 : 52,
            48,
            isMobile ? 22 : 52,
            42,
          ),
          child: isMobile
              ? Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    _buildBrandBlock(),
                    const SizedBox(height: 38),
                    _buildLinkSections(isMobile),
                    const SizedBox(height: 38),
                    _buildNewsletter(isMobile),
                  ],
                )
              : Row(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 4,
                      child: _buildBrandBlock(),
                    ),
                    const SizedBox(width: 45),
                    Expanded(
                      flex: 4,
                      child: _buildLinkSections(isMobile),
                    ),
                    const SizedBox(width: 45),
                    Expanded(
                      flex: 4,
                      child: _buildNewsletter(isMobile),
                    ),
                  ],
                ),
        );
      },
    );
  }

  Widget _buildBrandBlock() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: AppTheme.primary,
                borderRadius:
                    BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.shopping_bag_outlined,
                color: Colors.white,
                size: 23,
              ),
            ),
            const SizedBox(width: 13),
            const Text(
              'SHOPLY',
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.2,
                color: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        const Text(
          'Thoughtfully selected products for '
          'your everyday life.',
          style: TextStyle(
            fontSize: 12,
            height: 1.6,
            color: Colors.white60,
          ),
        ),
        const SizedBox(height: 22),
        Row(
          children: [
            _SocialButton(
              icon: Icons.camera_alt_outlined,
              onTap: () => _comingSoon('Instagram'),
            ),
            const SizedBox(width: 8),
            _SocialButton(
              icon: Icons.facebook_outlined,
              onTap: () => _comingSoon('Facebook'),
            ),
            const SizedBox(width: 8),
            _SocialButton(
              icon: Icons.alternate_email_rounded,
              onTap: () => _comingSoon('Twitter'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLinkSections(bool isMobile) {
    return Wrap(
      spacing: isMobile ? 45 : 35,
      runSpacing: 30,
      children: [
        _FooterLinkGroup(
          title: 'SHOP',
          links: [
            'All Products',
            'New Arrivals',
            'Featured',
            'Best Sellers',
          ],
          onTap: _comingSoon,
        ),
        _FooterLinkGroup(
          title: 'HELP',
          links: [
            'Shipping',
            'Returns',
            'FAQ',
            'Contact Us',
          ],
          onTap: _comingSoon,
        ),
        _FooterLinkGroup(
          title: 'COMPANY',
          links: [
            'About Shoply',
            'Careers',
            'Privacy',
            'Terms',
          ],
          onTap: _comingSoon,
        ),
      ],
    );
  }

  Widget _buildNewsletter(bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'STAY IN THE LOOP',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.1,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'Get product drops, exclusive offers '
          'and Shoply news.',
          style: TextStyle(
            fontSize: 11,
            height: 1.5,
            color: Colors.white60,
          ),
        ),
        const SizedBox(height: 18),
        AnimatedSwitcher(
          duration:
              const Duration(milliseconds: 250),
          child: _subscribed
              ? _buildSubscribedState()
              : _buildEmailForm(isMobile),
        ),
      ],
    );
  }

  Widget _buildEmailForm(bool isMobile) {
    return Column(
      key: const ValueKey('email-form'),
      children: [
        Container(
          height: 48,
          decoration: BoxDecoration(
            color: Colors.white.withValues(
              alpha: 0.07,
            ),
            borderRadius:
                BorderRadius.circular(13),
            border: Border.all(
              color: Colors.white12,
            ),
          ),
          child: TextField(
            controller: _emailController,
            keyboardType:
                TextInputType.emailAddress,
            style: const TextStyle(
              fontSize: 11,
              color: Colors.white,
            ),
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: 'Your email address',
              hintStyle: TextStyle(
                fontSize: 11,
                color: Colors.white38,
              ),
              contentPadding:
                  EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 15,
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          height: 46,
          child: FilledButton(
            onPressed: _subscribe,
            style: FilledButton.styleFrom(
              backgroundColor:
                  AppTheme.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(13),
              ),
            ),
            child: const Text(
              'Subscribe',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubscribedState() {
    return Container(
      key: const ValueKey('subscribed'),
      width: double.infinity,
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: AppTheme.success.withValues(
          alpha: 0.12,
        ),
        borderRadius:
            BorderRadius.circular(13),
        border: Border.all(
          color: AppTheme.success.withValues(
            alpha: 0.30,
          ),
        ),
      ),
      child: const Row(
        children: [
          Icon(
            Icons.check_circle_rounded,
            color: AppTheme.success,
            size: 21,
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'You are subscribed! Welcome to Shoply.',
              style: TextStyle(
                fontSize: 10,
                height: 1.4,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrustSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 22,
        vertical: 25,
      ),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Colors.white10,
          ),
          bottom: BorderSide(
            color: Colors.white10,
          ),
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile =
              constraints.maxWidth < 650;

          final items = [
            const _TrustItem(
              icon: Icons.verified_user_outlined,
              title: 'Secure Payments',
              subtitle: 'Protected checkout',
            ),
            const _TrustItem(
              icon: Icons.local_shipping_outlined,
              title: 'Fast Delivery',
              subtitle: 'Quick doorstep delivery',
            ),
            const _TrustItem(
              icon: Icons.assignment_return_outlined,
              title: 'Easy Returns',
              subtitle: 'Simple return process',
            ),
          ];

          if (isMobile) {
            return Column(
              children: [
                for (int i = 0; i < items.length; i++) ...[
                  items[i],
                  if (i != items.length - 1)
                    const SizedBox(height: 18),
                ],
              ],
            );
          }

          return Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceAround,
            children: items,
          );
        },
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        22,
        20,
        22,
        22,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile =
              constraints.maxWidth < 600;

          if (isMobile) {
            return const Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  '© 2026 Shoply. Built with Flutter.',
                  style: TextStyle(
                    fontSize: 9,
                    color: Colors.white38,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Made for better everyday shopping.',
                  style: TextStyle(
                    fontSize: 9,
                    color: Colors.white24,
                  ),
                ),
              ],
            );
          }

          return const Row(
            children: [
              Text(
                '© 2026 Shoply. Built with Flutter.',
                style: TextStyle(
                  fontSize: 9,
                  color: Colors.white38,
                ),
              ),
              Spacer(),
              Text(
                'Made for better everyday shopping.',
                style: TextStyle(
                  fontSize: 9,
                  color: Colors.white24,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _FooterLinkGroup extends StatelessWidget {
  final String title;
  final List<String> links;
  final ValueChanged<String> onTap;

  const _FooterLinkGroup({
    required this.title,
    required this.links,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 125,
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w900,
              letterSpacing: 1,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 14),
          ...links.map(
            (link) => Padding(
              padding:
                  const EdgeInsets.only(bottom: 10),
              child: InkWell(
                onTap: () => onTap(link),
                borderRadius:
                    BorderRadius.circular(5),
                child: Text(
                  link,
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.white54,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _SocialButton({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(
        alpha: 0.07,
      ),
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Padding(
          padding: const EdgeInsets.all(9),
          child: Icon(
            icon,
            size: 17,
            color: Colors.white70,
          ),
        ),
      ),
    );
  }
}

class _TrustItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _TrustItem({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppTheme.primary.withValues(
              alpha: 0.12,
            ),
            borderRadius:
                BorderRadius.circular(11),
          ),
          child: Icon(
            icon,
            size: 19,
            color: AppTheme.primary,
          ),
        ),
        const SizedBox(width: 11),
        Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 8,
                color: Colors.white38,
              ),
            ),
          ],
        ),
      ],
    );
  }
}