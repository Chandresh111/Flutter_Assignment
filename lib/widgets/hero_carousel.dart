import 'dart:async';

import 'package:flutter/material.dart';

import '../models/product_model.dart';
import '../utils/app_theme.dart';

class HeroCarousel extends StatefulWidget {
  final List<Product> products;
  final ValueChanged<Product>? onAddToCart;
  final ValueChanged<Product>? onWishlist;
  final Set<String> cartProductIds;
  final Set<String> wishlistProductIds;

  const HeroCarousel({
    super.key,
    required this.products,
    this.onAddToCart,
    this.onWishlist,
    this.cartProductIds = const {},
    this.wishlistProductIds = const {},
  });

  @override
  State<HeroCarousel> createState() =>
      _HeroCarouselState();
}

class _HeroCarouselState extends State<HeroCarousel> {
  late final PageController _pageController;

  Timer? _autoPlayTimer;

  int _currentIndex = 0;

  bool _isHovering = false;

  List<Product> get _featuredProducts {
    final featured = widget.products
        .where((product) => product.isFeatured)
        .toList();

    if (featured.isNotEmpty) {
      return featured;
    }

    return widget.products.take(5).toList();
  }

  @override
  void initState() {
    super.initState();

    _pageController = PageController();

    _startAutoPlay();
  }

  @override
  void dispose() {
    _autoPlayTimer?.cancel();
    _pageController.dispose();

    super.dispose();
  }

  void _startAutoPlay() {
    _autoPlayTimer?.cancel();

    _autoPlayTimer = Timer.periodic(
      const Duration(seconds: 4),
      (_) {
        if (!mounted ||
            _isHovering ||
            _featuredProducts.length <= 1) {
          return;
        }

        final nextIndex =
            (_currentIndex + 1) %
                _featuredProducts.length;

        _goToPage(nextIndex);
      },
    );
  }

  void _goToPage(int index) {
    if (!_pageController.hasClients) {
      return;
    }

    _pageController.animateToPage(
      index,
      duration:
          const Duration(milliseconds: 500),
      curve: Curves.easeInOutCubic,
    );
  }

  void _previousPage() {
    if (_featuredProducts.isEmpty) return;

    final previousIndex =
        _currentIndex == 0
            ? _featuredProducts.length - 1
            : _currentIndex - 1;

    _goToPage(previousIndex);
  }

  void _nextPage() {
    if (_featuredProducts.isEmpty) return;

    final nextIndex =
        (_currentIndex + 1) %
            _featuredProducts.length;

    _goToPage(nextIndex);
  }

  void _showProductDetails(Product product) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return _ProductDetailsSheet(
          product: product,
          isInCart:
              widget.cartProductIds.contains(
            product.id,
          ),
          isWishlisted:
              widget.wishlistProductIds.contains(
            product.id,
          ),
          onAddToCart: widget.onAddToCart == null
              ? null
              : () {
                  widget.onAddToCart!(product);
                  Navigator.pop(context);
                },
          onWishlist: widget.onWishlist == null
              ? null
              : () {
                  widget.onWishlist!(product);
                  Navigator.pop(context);
                },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final products = _featuredProducts;

    if (products.isEmpty) {
      return const SizedBox.shrink();
    }

    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 700;

    return MouseRegion(
      onEnter: (_) {
        setState(() {
          _isHovering = true;
        });
      },
      onExit: (_) {
        setState(() {
          _isHovering = false;
        });
      },
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: isMobile ? 18 : 42,
        ),
        height: isMobile ? 380 : 330,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: const Color(0xFF302A27),
          borderRadius:
              BorderRadius.circular(26),
        ),
        child: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              itemCount: products.length,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              itemBuilder: (context, index) {
                final product = products[index];

                return _HeroProduct(
                  product: product,
                  isMobile: isMobile,
                  isInCart:
                      widget.cartProductIds.contains(
                    product.id,
                  ),
                  isWishlisted:
                      widget.wishlistProductIds.contains(
                    product.id,
                  ),
                  onDetails: () {
                    _showProductDetails(product);
                  },
                  onAddToCart:
                      widget.onAddToCart == null
                          ? null
                          : () {
                              widget.onAddToCart!(
                                product,
                              );
                            },
                  onWishlist:
                      widget.onWishlist == null
                          ? null
                          : () {
                              widget.onWishlist!(
                                product,
                              );
                            },
                );
              },
            ),

            // PREVIOUS BUTTON
            if (products.length > 1)
              Positioned(
                left: 14,
                top: 0,
                bottom: 0,
                child: Center(
                  child: _CarouselButton(
                    icon:
                        Icons.chevron_left_rounded,
                    onTap: _previousPage,
                  ),
                ),
              ),

            // NEXT BUTTON
            if (products.length > 1)
              Positioned(
                right: 14,
                top: 0,
                bottom: 0,
                child: Center(
                  child: _CarouselButton(
                    icon:
                        Icons.chevron_right_rounded,
                    onTap: _nextPage,
                  ),
                ),
              ),

            // INDICATORS
            if (products.length > 1)
              Positioned(
                left: 0,
                right: 0,
                bottom: 15,
                child: Row(
                  mainAxisAlignment:
                      MainAxisAlignment.center,
                  children: List.generate(
                    products.length,
                    (index) {
                      final active =
                          index == _currentIndex;

                      return AnimatedContainer(
                        duration:
                            const Duration(
                          milliseconds: 220,
                        ),
                        margin:
                            const EdgeInsets.symmetric(
                          horizontal: 3,
                        ),
                        width:
                            active ? 22 : 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: active
                              ? Colors.white
                              : Colors.white38,
                          borderRadius:
                              BorderRadius.circular(
                            20,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// HERO PRODUCT
// =============================================================================

class _HeroProduct extends StatelessWidget {
  final Product product;
  final bool isMobile;
  final bool isInCart;
  final bool isWishlisted;
  final VoidCallback onDetails;
  final VoidCallback? onAddToCart;
  final VoidCallback? onWishlist;

  const _HeroProduct({
    required this.product,
    required this.isMobile,
    required this.isInCart,
    required this.isWishlisted,
    required this.onDetails,
    required this.onAddToCart,
    required this.onWishlist,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // BACKGROUND IMAGE
        Positioned.fill(
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
            errorBuilder:
                (
                  context,
                  error,
                  stackTrace,
                ) {
              return Container(
                color: const Color(0xFF302A27),
              );
            },
          ),
        ),

        // DARK GRADIENT
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  const Color(0xFF171311)
                      .withValues(alpha: 0.92),
                  const Color(0xFF171311)
                      .withValues(alpha: 0.70),
                  const Color(0xFF171311)
                      .withValues(alpha: 0.18),
                ],
              ),
            ),
          ),
        ),

        // CONTENT
        Padding(
          padding: EdgeInsets.fromLTRB(
            isMobile ? 42 : 62,
            isMobile ? 32 : 42,
            isMobile ? 42 : 62,
            40,
          ),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            mainAxisAlignment:
                MainAxisAlignment.center,
            children: [
              // CATEGORY
              Container(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 9,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.primary
                      .withValues(alpha: 0.92),
                  borderRadius:
                      BorderRadius.circular(8),
                ),
                child: Text(
                  product.category
                      .toUpperCase(),
                  style: const TextStyle(
                    fontSize: 8,
                    fontWeight:
                        FontWeight.w900,
                    letterSpacing: 1,
                    color: Colors.white,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // PRODUCT NAME
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth:
                      isMobile ? 260 : 390,
                ),
                child: Text(
                  product.name,
                  maxLines: 2,
                  overflow:
                      TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize:
                        isMobile ? 27 : 36,
                    height: 1.05,
                    fontWeight:
                        FontWeight.w900,
                    letterSpacing: -0.8,
                    color: Colors.white,
                  ),
                ),
              ),

              const SizedBox(height: 9),

              // DESCRIPTION
              if (!isMobile)
                ConstrainedBox(
                  constraints:
                      const BoxConstraints(
                    maxWidth: 390,
                  ),
                  child: Text(
                    product.description,
                    maxLines: 2,
                    overflow:
                        TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 11,
                      height: 1.5,
                      color: Colors.white70,
                    ),
                  ),
                ),

              if (!isMobile)
                const SizedBox(height: 12),

              // RATING
              Row(
                children: [
                  const Icon(
                    Icons.star_rounded,
                    size: 17,
                    color:
                        Color(0xFFFFAA27),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    product.rating
                        .toStringAsFixed(1),
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight:
                          FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    '${product.reviewCount} reviews',
                    style: const TextStyle(
                      fontSize: 9,
                      color: Colors.white60,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // PRICE
              Text(
                '₹${product.price.toStringAsFixed(0)}',
                style: TextStyle(
                  fontSize:
                      isMobile ? 22 : 25,
                  fontWeight:
                      FontWeight.w900,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 14),

              // ACTIONS
              Row(
                children: [
                  FilledButton.icon(
                    onPressed: onAddToCart,
                    icon: Icon(
                      isInCart
                          ? Icons.check_rounded
                          : Icons
                              .shopping_bag_outlined,
                      size: 17,
                    ),
                    label: Text(
                      isInCart
                          ? 'In Cart'
                          : 'Add to Cart',
                    ),
                    style: FilledButton.styleFrom(
                      backgroundColor:
                          AppTheme.primary,
                      foregroundColor:
                          Colors.white,
                      padding:
                          const EdgeInsets
                              .symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(
                          11,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 8),

                  Material(
                    color: Colors.white
                        .withValues(alpha: 0.13),
                    shape:
                        const CircleBorder(),
                    child: InkWell(
                      onTap: onWishlist,
                      customBorder:
                          const CircleBorder(),
                      child: Padding(
                        padding:
                            const EdgeInsets.all(
                          11,
                        ),
                        child: Icon(
                          isWishlisted
                              ? Icons
                                  .favorite_rounded
                              : Icons
                                  .favorite_border_rounded,
                          size: 19,
                          color:
                              Colors.white,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 8),

                  OutlinedButton(
                    onPressed: onDetails,
                    style:
                        OutlinedButton.styleFrom(
                      foregroundColor:
                          Colors.white,
                      side:
                          const BorderSide(
                        color: Colors.white38,
                      ),
                      padding:
                          const EdgeInsets
                              .symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(
                          11,
                        ),
                      ),
                    ),
                    child: const Text(
                      'View',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight:
                            FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// =============================================================================
// CAROUSEL BUTTON
// =============================================================================

class _CarouselButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CarouselButton({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withValues(
        alpha: 0.28,
      ),
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Icon(
            icon,
            size: 22,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// PRODUCT DETAILS SHEET
// =============================================================================

class _ProductDetailsSheet
    extends StatelessWidget {
  final Product product;
  final bool isInCart;
  final bool isWishlisted;
  final VoidCallback? onAddToCart;
  final VoidCallback? onWishlist;

  const _ProductDetailsSheet({
    required this.product,
    required this.isInCart,
    required this.isWishlisted,
    required this.onAddToCart,
    required this.onWishlist,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile =
        MediaQuery.of(context).size.width < 700;

    return Container(
      height:
          MediaQuery.of(context).size.height *
              (isMobile ? 0.78 : 0.68),
      decoration: const BoxDecoration(
        color: AppTheme.surface,
        borderRadius:
            BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 10),

          Container(
            width: 42,
            height: 4,
            decoration: BoxDecoration(
              color: AppTheme.border,
              borderRadius:
                  BorderRadius.circular(20),
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding:
                  const EdgeInsets.all(22),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius:
                        BorderRadius.circular(20),
                    child: AspectRatio(
                      aspectRatio: 1.8,
                      child: Image.network(
                        product.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder:
                            (
                              context,
                              error,
                              stackTrace,
                            ) {
                          return Container(
                            color:
                                const Color(
                              0xFFF0ECE7,
                            ),
                            child:
                                const Icon(
                              Icons
                                  .image_not_supported_outlined,
                              size: 40,
                              color: AppTheme
                                  .textSecondary,
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Text(
                    product.category
                        .toUpperCase(),
                    style: const TextStyle(
                      fontSize: 8,
                      fontWeight:
                          FontWeight.w900,
                      letterSpacing: 1.2,
                      color: AppTheme
                          .textSecondary,
                    ),
                  ),

                  const SizedBox(height: 7),

                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight:
                          FontWeight.w900,
                      color: AppTheme
                          .textPrimary,
                    ),
                  ),

                  const SizedBox(height: 9),

                  Text(
                    product.description,
                    style: const TextStyle(
                      fontSize: 12,
                      height: 1.5,
                      color: AppTheme
                          .textSecondary,
                    ),
                  ),

                  const SizedBox(height: 15),

                  Row(
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        size: 18,
                        color:
                            Color(0xFFFFAA27),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        product.rating
                            .toStringAsFixed(1),
                        style:
                            const TextStyle(
                          fontSize: 11,
                          fontWeight:
                              FontWeight.w900,
                          color: AppTheme
                              .textPrimary,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        '${product.reviewCount} reviews',
                        style:
                            const TextStyle(
                          fontSize: 10,
                          color: AppTheme
                              .textSecondary,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 13),

                  Text(
                    '₹${product.price.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight:
                          FontWeight.w900,
                      color:
                          AppTheme.primary,
                    ),
                  ),

                  const SizedBox(height: 20),

                  Row(
                    children: [
                      Expanded(
                        child: FilledButton.icon(
                          onPressed:
                              onAddToCart,
                          icon: Icon(
                            isInCart
                                ? Icons
                                    .check_rounded
                                : Icons
                                    .shopping_bag_outlined,
                            size: 17,
                          ),
                          label: Text(
                            isInCart
                                ? 'Already in Cart'
                                : 'Add to Cart',
                            style:
                                const TextStyle(
                              fontSize: 10,
                              fontWeight:
                                  FontWeight.w900,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 9),

                      SizedBox(
                        width: 52,
                        height: 50,
                        child: OutlinedButton(
                          onPressed:
                              onWishlist,
                          style:
                              OutlinedButton.styleFrom(
                            padding:
                                EdgeInsets.zero,
                            side:
                                const BorderSide(
                              color:
                                  AppTheme.border,
                            ),
                            shape:
                                RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius
                                      .circular(
                                13,
                              ),
                            ),
                          ),
                          child: Icon(
                            isWishlisted
                                ? Icons
                                    .favorite_rounded
                                : Icons
                                    .favorite_border_rounded,
                            size: 20,
                            color:
                                AppTheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}