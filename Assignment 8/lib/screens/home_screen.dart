import 'package:flutter/material.dart';

import '../models/post.dart';
import '../services/api_service.dart';
import '../services/cache_service.dart';
import '../utils/app_theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final ApiService _apiService = ApiService();
  final CacheService _cacheService = CacheService();

  late final AnimationController _animationController;
  late Future<List<Post>> _postsFuture;

  bool _showAllPosts = false;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _postsFuture = _loadPosts();

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // ═══════════════════════════════════════════════
  // API + Cache Logic
  // ═══════════════════════════════════════════════

  Future<List<Post>> _loadPosts() async {
    try {
      // First try the live REST API.
      final posts = await _apiService.fetchPosts();

      // Save the successful response locally.
      await _cacheService.savePosts(posts);

      return posts;
    } catch (error) {
      // If API fails, try local cache.
      final cachedPosts = await _cacheService.getCachedPosts();

      if (cachedPosts != null && cachedPosts.isNotEmpty) {
        return cachedPosts;
      }

      // No API and no cache.
      throw Exception(
        'Unable to fetch data and no cached data is available.',
      );
    }
  }

  Future<void> _refreshData() async {
    setState(() {
      _showAllPosts = false;
      _postsFuture = _loadPosts();
    });

    _animationController
      ..reset()
      ..forward();

    try {
      await _postsFuture;

      if (!mounted) {
        return;
      }

      _showMessage(
        'Data refreshed successfully.',
      );
    } catch (_) {
      if (!mounted) {
        return;
      }

      _showMessage(
        'Unable to refresh data.',
      );
    }
  }

  // ═══════════════════════════════════════════════
  // Main Build
  // ═══════════════════════════════════════════════

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const _BackgroundDecorations(),

          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth;

                if (width >= 1100) {
                  return _buildDesktopLayout(context);
                }

                if (width >= 700) {
                  return _buildTabletLayout(context);
                }

                return _buildMobileLayout(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════
  // Desktop Layout
  // ═══════════════════════════════════════════════

  Widget _buildDesktopLayout(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 1280,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 42,
              vertical: 28,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),
                const SizedBox(height: 38),
                _buildHero(context),
                const SizedBox(height: 28),
                _buildDataContent(context, 3),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════
  // Tablet Layout
  // ═══════════════════════════════════════════════

  Widget _buildTabletLayout(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 28,
          vertical: 24,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            const SizedBox(height: 30),
            _buildHero(context),
            const SizedBox(height: 24),
            _buildDataContent(context, 2),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════
  // Mobile Layout
  // ═══════════════════════════════════════════════

  Widget _buildMobileLayout(BuildContext context) {
    return RefreshIndicator(
      color: AppTheme.primary,
      onRefresh: _refreshData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 18,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              const SizedBox(height: 24),
              _buildHero(context),
              const SizedBox(height: 18),
              _buildDataContent(context, 1),
            ],
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════
  // Header
  // ═══════════════════════════════════════════════

  Widget _buildHeader(BuildContext context) {
    final isMobile = MediaQuery.sizeOf(context).width < 700;

    return FadeTransition(
      opacity: CurvedAnimation(
        parent: _animationController,
        curve: const Interval(
          0,
          0.5,
          curve: Curves.easeOut,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: isMobile ? 44 : 48,
            height: isMobile ? 44 : 48,
            decoration: BoxDecoration(
              gradient: AppTheme.primaryGradient,
              borderRadius: BorderRadius.circular(15),
              boxShadow: AppTheme.softShadow,
            ),
            child: const Icon(
              Icons.bolt_rounded,
              color: Colors.white,
              size: 27,
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'PulseAPI',
                style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),
              if (!isMobile)
                const Text(
                  'Live data. Smart cache.',
                  style: TextStyle(
                    color: AppTheme.textMuted,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
            ],
          ),
          const Spacer(),
          _buildHeaderButton(
            icon: Icons.refresh_rounded,
            tooltip: 'Refresh data',
            onTap: _refreshData,
          ),
          const SizedBox(width: 8),
          _buildHeaderButton(
            icon: Icons.more_horiz_rounded,
            tooltip: 'More options',
            onTap: () => _showMoreOptions(context),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderButton({
    required IconData icon,
    required String tooltip,
    required VoidCallback onTap,
  }) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: AppTheme.border,
              ),
            ),
            child: Icon(
              icon,
              color: AppTheme.textPrimary,
              size: 21,
            ),
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════
  // Hero
  // ═══════════════════════════════════════════════

  Widget _buildHero(BuildContext context) {
    final isMobile = MediaQuery.sizeOf(context).width < 700;

    return FadeTransition(
      opacity: CurvedAnimation(
        parent: _animationController,
        curve: const Interval(
          0.1,
          0.7,
          curve: Curves.easeOut,
        ),
      ),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(isMobile ? 22 : 34),
        decoration: BoxDecoration(
          gradient: AppTheme.heroGradient,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.9),
          ),
          boxShadow: AppTheme.softShadow,
        ),
        child: isMobile
            ? _buildMobileHeroContent()
            : _buildDesktopHeroContent(),
      ),
    );
  }

  Widget _buildDesktopHeroContent() {
    return Row(
      children: [
        Expanded(
          flex: 6,
          child: _buildHeroText(),
        ),
        const SizedBox(width: 30),
        Expanded(
          flex: 4,
          child: _buildHeroVisual(),
        ),
      ],
    );
  }

  Widget _buildMobileHeroContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeroText(),
        const SizedBox(height: 24),
        _buildHeroVisual(),
      ],
    );
  }

  Widget _buildHeroText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 7,
          ),
          decoration: BoxDecoration(
            color: AppTheme.primary.withValues(alpha: 0.09),
            borderRadius: BorderRadius.circular(30),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.auto_awesome_rounded,
                color: AppTheme.primary,
                size: 15,
              ),
              SizedBox(width: 7),
              Text(
                'REST API DASHBOARD',
                style: TextStyle(
                  color: AppTheme.primary,
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        const Text(
          'Your data,\n'
          'always within reach.',
          style: TextStyle(
            color: AppTheme.textPrimary,
            fontSize: 38,
            height: 1.08,
            fontWeight: FontWeight.w800,
            letterSpacing: -1.5,
          ),
        ),
        const SizedBox(height: 14),
        const Text(
          'Fetch live information from the API and keep '
          'your latest results available with smart local caching.',
          style: TextStyle(
            color: AppTheme.textSecondary,
            fontSize: 14,
            height: 1.6,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 22),
        Row(
          children: [
            _buildHeroBadge(
              icon: Icons.cloud_done_rounded,
              label: 'REST API',
            ),
            const SizedBox(width: 9),
            _buildHeroBadge(
              icon: Icons.storage_rounded,
              label: 'Local Cache',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHeroBadge({
    required IconData icon,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 11,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: AppTheme.primary,
            size: 16,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════
  // Hero Visual
  // ═══════════════════════════════════════════════

  Widget _buildHeroVisual() {
    return SizedBox(
      height: 235,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 12,
            right: 12,
            child: _buildFloatingBubble(
              icon: Icons.cloud_rounded,
              size: 52,
              color: AppTheme.primary,
            ),
          ),
          Positioned(
            bottom: 10,
            left: 5,
            child: _buildFloatingBubble(
              icon: Icons.storage_rounded,
              size: 46,
              color: AppTheme.accent,
            ),
          ),
          Positioned(
            top: 30,
            left: 28,
            child: _buildSmallDot(),
          ),
          Positioned(
            bottom: 35,
            right: 34,
            child: _buildSmallDot(),
          ),
          _buildApiIllustration(),
        ],
      ),
    );
  }

  Widget _buildApiIllustration() {
    return Container(
      width: 220,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.76),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: Colors.white,
          width: 1.5,
        ),
        boxShadow: AppTheme.softShadow,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  gradient: AppTheme.primaryGradient,
                  borderRadius: BorderRadius.circular(11),
                ),
                child: const Icon(
                  Icons.data_object_rounded,
                  color: Colors.white,
                  size: 19,
                ),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'API RESPONSE',
                      style: TextStyle(
                        color: AppTheme.textMuted,
                        fontSize: 8,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      '200  •  Success',
                      style: TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 9,
                height: 9,
                decoration: const BoxDecoration(
                  color: AppTheme.success,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _buildCodeLine(0.85),
          const SizedBox(height: 7),
          _buildCodeLine(0.65),
          const SizedBox(height: 7),
          _buildCodeLine(0.78),
          const SizedBox(height: 7),
          _buildCodeLine(0.48),
          const SizedBox(height: 14),
          Container(
            height: 34,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: AppTheme.primaryGradient,
              borderRadius: BorderRadius.circular(11),
            ),
            child: const Center(
              child: Text(
                'DATA SYNCED',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.6,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCodeLine(double widthFactor) {
    return Align(
      alignment: Alignment.centerLeft,
      child: FractionallySizedBox(
        widthFactor: widthFactor,
        child: Container(
          height: 7,
          decoration: BoxDecoration(
            color: AppTheme.surfaceSoft,
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingBubble({
    required IconData icon,
    required double size,
    required Color color,
  }) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.14),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Icon(
        icon,
        color: color,
        size: size * 0.42,
      ),
    );
  }

  Widget _buildSmallDot() {
    return Container(
      width: 10,
      height: 10,
      decoration: const BoxDecoration(
        color: AppTheme.secondary,
        shape: BoxShape.circle,
      ),
    );
  }

  // ═══════════════════════════════════════════════
  // FutureBuilder
  // ═══════════════════════════════════════════════

  Widget _buildDataContent(
    BuildContext context,
    int columns,
  ) {
    return FutureBuilder<List<Post>>(
      future: _postsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingState();
        }

        if (snapshot.hasError) {
          return _buildErrorState();
        }

        final posts = snapshot.data ?? [];

        if (posts.isEmpty) {
          return _buildEmptyState();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStats(posts),
            const SizedBox(height: 38),
            _buildSectionHeader(posts),
            const SizedBox(height: 18),
            if (columns == 1)
              _buildPostList(posts)
            else
              _buildPostGrid(posts, columns),
            const SizedBox(height: 36),
            _buildBottomInfo(),
          ],
        );
      },
    );
  }

  // ═══════════════════════════════════════════════
  // Loading
  // ═══════════════════════════════════════════════

  Widget _buildLoadingState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 25,
        vertical: 48,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(23),
        border: Border.all(
          color: AppTheme.border,
        ),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        children: [
          Container(
            width: 62,
            height: 62,
            decoration: BoxDecoration(
              gradient: AppTheme.primaryGradient,
              shape: BoxShape.circle,
              boxShadow: AppTheme.softShadow,
            ),
            child: const Padding(
              padding: EdgeInsets.all(18),
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Fetching fresh data',
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 17,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 7),
          const Text(
            'Connecting to the REST API...',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 22),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: const LinearProgressIndicator(
              minHeight: 4,
              backgroundColor: AppTheme.surfaceSoft,
              valueColor: AlwaysStoppedAnimation<Color>(
                AppTheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════
  // Error
  // ═══════════════════════════════════════════════

  Widget _buildErrorState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 25,
        vertical: 42,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(23),
        border: Border.all(
          color: AppTheme.error.withValues(alpha: 0.25),
        ),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: const BoxDecoration(
              color: AppTheme.errorSoft,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.cloud_off_rounded,
              color: AppTheme.error,
              size: 30,
            ),
          ),
          const SizedBox(height: 18),
          const Text(
            'Unable to fetch data',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 17,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 7),
          const Text(
            'We could not connect to the REST API.\n'
            'Check your connection and try again.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 12,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 22),
          ElevatedButton.icon(
            onPressed: _refreshData,
            icon: const Icon(
              Icons.refresh_rounded,
              size: 18,
            ),
            label: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════
  // Statistics
  // ═══════════════════════════════════════════════

  Widget _buildStats(List<Post> posts) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 500;

        if (isCompact) {
          return Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  icon: Icons.article_rounded,
                  value: '${posts.length}',
                  label: 'Posts',
                  iconColor: AppTheme.primary,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildStatCard(
                  icon: Icons.cloud_done_rounded,
                  value: 'API',
                  label: 'Source',
                  iconColor: AppTheme.accent,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildStatCard(
                  icon: Icons.bolt_rounded,
                  value: 'LIVE',
                  label: 'Status',
                  iconColor: AppTheme.success,
                ),
              ),
            ],
          );
        }

        return Row(
          children: [
            Expanded(
              child: _buildStatCard(
                icon: Icons.article_rounded,
                value: '${posts.length}',
                label: 'Total Posts',
                iconColor: AppTheme.primary,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: _buildStatCard(
                icon: Icons.cloud_done_rounded,
                value: 'REST',
                label: 'Data Source',
                iconColor: AppTheme.accent,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: _buildStatCard(
                icon: Icons.bolt_rounded,
                value: 'LIVE',
                label: 'Connection',
                iconColor: AppTheme.success,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String value,
    required String label,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(19),
        border: Border.all(
          color: AppTheme.border,
        ),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.09),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppTheme.textMuted,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════
  // Section Header
  // ═══════════════════════════════════════════════

  Widget _buildSectionHeader(List<Post> posts) {
    final isMobile = MediaQuery.sizeOf(context).width < 500;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Latest Data',
                style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 23,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Fresh results from your REST endpoint',
                style: TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        if (!isMobile && posts.length > 6)
          TextButton(
            onPressed: () {
              setState(() {
                _showAllPosts = !_showAllPosts;
              });
            },
            child: Text(
              _showAllPosts ? 'Show Less' : 'View All',
            ),
          ),
      ],
    );
  }

  // ═══════════════════════════════════════════════
  // Post Grid
  // ═══════════════════════════════════════════════

  Widget _buildPostGrid(
    List<Post> posts,
    int columns,
  ) {
    final visiblePosts = _getVisiblePosts(posts);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: visiblePosts.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.22,
      ),
      itemBuilder: (context, index) {
        return _buildPostCard(
          visiblePosts[index],
          index,
        );
      },
    );
  }

  // ═══════════════════════════════════════════════
  // Post List
  // ═══════════════════════════════════════════════

  Widget _buildPostList(List<Post> posts) {
    final visiblePosts = _getVisiblePosts(posts);

    return Column(
      children: visiblePosts
          .asMap()
          .entries
          .map(
            (entry) => Padding(
              padding: const EdgeInsets.only(
                bottom: 14,
              ),
              child: SizedBox(
                height: 205,
                child: _buildPostCard(
                  entry.value,
                  entry.key,
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  List<Post> _getVisiblePosts(List<Post> posts) {
    if (_showAllPosts || posts.length <= 6) {
      return posts;
    }

    return posts.take(6).toList();
  }

  // ═══════════════════════════════════════════════
  // Post Card
  // ═══════════════════════════════════════════════

  Widget _buildPostCard(
    Post post,
    int index,
  ) {
    return TweenAnimationBuilder<double>(
      key: ValueKey(post.id),
      tween: Tween(
        begin: 0,
        end: 1,
      ),
      duration: Duration(
        milliseconds: 400 + (index * 70),
      ),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(
              0,
              18 * (1 - value),
            ),
            child: child,
          ),
        );
      },
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(21),
        child: InkWell(
          onTap: () => _showPostDetails(
            context,
            post,
          ),
          borderRadius: BorderRadius.circular(21),
          child: Container(
            padding: const EdgeInsets.all(19),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(21),
              border: Border.all(
                color: AppTheme.border,
              ),
              boxShadow: AppTheme.cardShadow,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                        gradient: AppTheme.primaryGradient,
                        borderRadius: BorderRadius.circular(11),
                      ),
                      child: Center(
                        child: Text(
                          '#${post.id}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.successSoft,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.check_circle_rounded,
                            color: AppTheme.success,
                            size: 11,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'SYNCED',
                            style: TextStyle(
                              color: AppTheme.success,
                              fontSize: 8,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Text(
                  _capitalize(post.title),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 15,
                    height: 1.35,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 9),
                Expanded(
                  child: Text(
                    _capitalize(post.body),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 12,
                      height: 1.55,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 13),
                Row(
                  children: [
                    const Icon(
                      Icons.person_outline_rounded,
                      color: AppTheme.textMuted,
                      size: 15,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      'User ${post.userId}',
                      style: const TextStyle(
                        color: AppTheme.textMuted,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Spacer(),
                    const Icon(
                      Icons.arrow_forward_rounded,
                      color: AppTheme.primary,
                      size: 17,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════
  // Post Details
  // ═══════════════════════════════════════════════

  void _showPostDetails(
    BuildContext context,
    Post post,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.fromLTRB(
            22,
            12,
            22,
            30,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(28),
            ),
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 38,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppTheme.border,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                const SizedBox(height: 22),
                Row(
                  children: [
                    Container(
                      width: 45,
                      height: 45,
                      decoration: BoxDecoration(
                        gradient: AppTheme.primaryGradient,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Center(
                        child: Text(
                          '#${post.id}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Post Details',
                      style: TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 22),
                const Text(
                  'TITLE',
                  style: TextStyle(
                    color: AppTheme.textMuted,
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  _capitalize(post.title),
                  style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 16,
                    height: 1.4,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 18),
                const Text(
                  'CONTENT',
                  style: TextStyle(
                    color: AppTheme.textMuted,
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  _capitalize(post.body),
                  style: const TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 13,
                    height: 1.6,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    _buildDetailChip(
                      Icons.person_outline_rounded,
                      'User ${post.userId}',
                    ),
                    const SizedBox(width: 8),
                    _buildDetailChip(
                      Icons.cloud_done_rounded,
                      'API Data',
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailChip(
    IconData icon,
    String label,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: AppTheme.surfaceSoft,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: AppTheme.primary,
            size: 14,
          ),
          const SizedBox(width: 5),
          Text(
            label,
            style: const TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 10,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════
  // Empty State
  // ═══════════════════════════════════════════════

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 25,
        vertical: 38,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: AppTheme.border,
        ),
      ),
      child: const Column(
        children: [
          Icon(
            Icons.cloud_download_outlined,
            color: AppTheme.primary,
            size: 42,
          ),
          SizedBox(height: 12),
          Text(
            'No data available',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 6),
          Text(
            'The API returned an empty result.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════
  // Bottom Information
  // ═══════════════════════════════════════════════

  Widget _buildBottomInfo() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppTheme.darkGradient,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          Container(
            width: 43,
            height: 43,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(13),
            ),
            child: const Icon(
              Icons.storage_rounded,
              color: Colors.white,
              size: 21,
            ),
          ),
          const SizedBox(width: 13),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Smart caching enabled',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Your latest successful API response is saved '
                  'locally for offline access.',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 10,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════
  // More Options
  // ═══════════════════════════════════════════════

  void _showMoreOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.fromLTRB(
            22,
            12,
            22,
            25,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(28),
            ),
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 38,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppTheme.border,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                const SizedBox(height: 20),
                _buildOptionTile(
                  icon: Icons.refresh_rounded,
                  title: 'Refresh Data',
                  subtitle: 'Fetch the latest API response',
                  onTap: () {
                    Navigator.pop(context);
                    _refreshData();
                  },
                ),
                _buildOptionTile(
                  icon: Icons.storage_rounded,
                  title: 'Local Cache',
                  subtitle: 'View your saved API data',
                  onTap: () {
                    Navigator.pop(context);
                    _showMessage(
                      'Your latest API response is cached locally.',
                    );
                  },
                ),
                _buildOptionTile(
                  icon: Icons.info_outline_rounded,
                  title: 'About PulseAPI',
                  subtitle: 'REST API + FutureBuilder + caching',
                  onTap: () {
                    Navigator.pop(context);
                    _showMessage(
                      'Built with Flutter, REST API and SharedPreferences.',
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildOptionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(
        vertical: 4,
      ),
      leading: Container(
        width: 43,
        height: 43,
        decoration: BoxDecoration(
          color: AppTheme.surfaceSoft,
          borderRadius: BorderRadius.circular(13),
        ),
        child: Icon(
          icon,
          color: AppTheme.primary,
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: AppTheme.textPrimary,
          fontSize: 13,
          fontWeight: FontWeight.w800,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          color: AppTheme.textMuted,
          fontSize: 10,
        ),
      ),
      trailing: const Icon(
        Icons.chevron_right_rounded,
        color: AppTheme.textMuted,
      ),
    );
  }

  void _showMessage(String message) {
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          duration: const Duration(seconds: 2),
        ),
      );
  }

  String _capitalize(String value) {
    if (value.isEmpty) {
      return value;
    }

    return value[0].toUpperCase() + value.substring(1);
  }
}

// ═══════════════════════════════════════════════
// Background Decorations
// ═══════════════════════════════════════════════

class _BackgroundDecorations extends StatelessWidget {
  const _BackgroundDecorations();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        children: [
          Positioned(
            top: -110,
            right: -90,
            child: _bubble(
              260,
              AppTheme.primary.withValues(alpha: 0.07),
            ),
          ),
          Positioned(
            top: 330,
            left: -130,
            child: _bubble(
              280,
              AppTheme.secondary.withValues(alpha: 0.045),
            ),
          ),
          Positioned(
            bottom: -120,
            right: -100,
            child: _bubble(
              300,
              AppTheme.accent.withValues(alpha: 0.045),
            ),
          ),
        ],
      ),
    );
  }

  Widget _bubble(
    double size,
    Color color,
  ) {
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