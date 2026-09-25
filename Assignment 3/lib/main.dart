import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDark = false;

  void toggleTheme() {
    setState(() {
      isDark = !isDark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Profile Card',
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,

      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF4F1FF),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6750A4),
          brightness: Brightness.light,
        ),
      ),

      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF15131A),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF9B7DDB),
          brightness: Brightness.dark,
        ),
      ),

      home: ProfilePage(
        isDark: isDark,
        onThemeToggle: toggleTheme,
      ),
    );
  }
}

class ProfilePage extends StatefulWidget {
  final bool isDark;
  final VoidCallback onThemeToggle;

  const ProfilePage({
    super.key,
    required this.isDark,
    required this.onThemeToggle,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> fadeAnimation;
  late Animation<Offset> slideAnimation;

  bool isFollowing = false;

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    fadeAnimation = CurvedAnimation(
      parent: animationController,
      curve: Curves.easeOut,
    );

    slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.easeOutCubic,
      ),
    );

    animationController.forward();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(
          'My Profile',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Change theme',
            onPressed: widget.onThemeToggle,
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Icon(
                widget.isDark
                    ? Icons.light_mode_rounded
                    : Icons.dark_mode_rounded,
                key: ValueKey(widget.isDark),
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),

      body: FadeTransition(
        opacity: fadeAnimation,
        child: SlideTransition(
          position: slideAnimation,
          child: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Container(
                  constraints: const BoxConstraints(
                    maxWidth: 850,
                  ),
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.12),
                        blurRadius: 30,
                        offset: const Offset(0, 15),
                      ),
                    ],
                  ),

                  child: Column(
                    children: [

                      // -------------------------
                      // HEADER
                      // -------------------------

                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.fromLTRB(
                          28,
                          30,
                          28,
                          35,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              colors.primary,
                              colors.secondary,
                            ],
                          ),
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(30),
                          ),
                        ),

                        child: Column(
                          children: [

                            // Avatar
                            Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 15,
                                  ),
                                ],
                              ),
                              child: CircleAvatar(
                                radius: 55,
                                backgroundColor:
                                    colors.primaryContainer,
                                child: Icon(
                                  Icons.person_rounded,
                                  size: 65,
                                  color: colors.primary,
                                ),
                              ),
                            ),

                            const SizedBox(height: 18),

                            const Text(
                              'Chandresh Dubey',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 6),

                            Text(
                              'Computer Science Student',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.85),
                                fontSize: 15,
                              ),
                            ),

                            const SizedBox(height: 18),

                            // Online status
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 7,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.18),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.circle,
                                    color: Colors.greenAccent,
                                    size: 10,
                                  ),
                                  SizedBox(width: 7),
                                  Text(
                                    'Available for opportunities',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      // -------------------------
                      // CONTENT
                      // -------------------------

                      Padding(
                        padding: const EdgeInsets.all(28),

                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            // Bio
                            Text(
                              'About Me',
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 8),

                            Text(
                              'Passionate about software development, '
                              'machine learning and building useful '
                              'technology projects.',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                height: 1.5,
                              ),
                            ),

                            const SizedBox(height: 25),

                            // Contact information
                            Text(
                              'Contact Information',
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 15),

                            Row(
                              children: [
                                _infoIcon(
                                  context,
                                  Icons.location_on_rounded,
                                ),
                                const SizedBox(width: 14),
                                const Expanded(
                                  child: Text('Mumbai, India'),
                                ),
                              ],
                            ),

                            const SizedBox(height: 14),

                            Row(
                              children: [
                                _infoIcon(
                                  context,
                                  Icons.email_rounded,
                                ),
                                const SizedBox(width: 14),
                                const Expanded(
                                  child: Text(
                                    'chandreshdubey98@gmail.com',
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 14),

                            Row(
                              children: [
                                _infoIcon(
                                  context,
                                  Icons.phone_rounded,
                                ),
                                const SizedBox(width: 14),
                                const Expanded(
                                  child: Text('+91 83560 31853'),
                                ),
                              ],
                            ),

                            const SizedBox(height: 28),

                            // Skills
                            Text(
                              'Skills',
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 14),

                            Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              children: [
                                _skillChip(context, 'Flutter'),
                                _skillChip(context, 'Dart'),
                                _skillChip(context, 'Python'),
                                _skillChip(context, 'Machine Learning'),
                                _skillChip(context, 'Git'),
                              ],
                            ),

                            const SizedBox(height: 30),

                            // Statistics
                            Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 20,
                              ),
                              decoration: BoxDecoration(
                                color: colors.primaryContainer
                                    .withOpacity(0.45),
                                borderRadius: BorderRadius.circular(20),
                              ),

                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  _stat(
                                    context,
                                    '12',
                                    'Projects',
                                  ),
                                  _divider(context),
                                  _stat(
                                    context,
                                    '8',
                                    'Skills',
                                  ),
                                  _divider(context),
                                  _stat(
                                    context,
                                    '3',
                                    'Years',
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 28),

                            // Buttons
                            Row(
                              children: [

                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      setState(() {
                                        isFollowing = !isFollowing;
                                      });

                                      showMessage(
                                        isFollowing
                                            ? 'You are now following Chandresh!'
                                            : 'Unfollowed Chandresh.',
                                      );
                                    },
                                    icon: Icon(
                                      isFollowing
                                          ? Icons.check_rounded
                                          : Icons.person_add_rounded,
                                    ),
                                    label: Text(
                                      isFollowing
                                          ? 'Following'
                                          : 'Follow',
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 15,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15),
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(width: 12),

                                Expanded(
                                  child: OutlinedButton.icon(
                                    onPressed: () {
                                      showMessage(
                                        'Message feature selected.',
                                      );
                                    },
                                    icon: const Icon(
                                      Icons.message_rounded,
                                    ),
                                    label: const Text('Message'),
                                    style: OutlinedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 15,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
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

  // -------------------------
  // Helper: Info Icon
  // -------------------------

  Widget _infoIcon(
    BuildContext context,
    IconData icon,
  ) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: colors.primaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        icon,
        color: colors.primary,
        size: 21,
      ),
    );
  }

  // -------------------------
  // Helper: Skill Chip
  // -------------------------

  Widget _skillChip(
    BuildContext context,
    String skill,
  ) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 9,
      ),
      decoration: BoxDecoration(
        color: colors.secondaryContainer,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        skill,
        style: TextStyle(
          color: colors.onSecondaryContainer,
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
      ),
    );
  }

  // -------------------------
  // Helper: Statistics
  // -------------------------

  Widget _stat(
    BuildContext context,
    String number,
    String label,
  ) {
    final colors = Theme.of(context).colorScheme;

    return Column(
      children: [
        Text(
          number,
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: colors.primary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  // -------------------------
  // Helper: Divider
  // -------------------------

  Widget _divider(BuildContext context) {
    return Container(
      width: 1,
      height: 40,
      color: Theme.of(context)
          .colorScheme
          .outline
          .withOpacity(0.3),
    );
  }
}