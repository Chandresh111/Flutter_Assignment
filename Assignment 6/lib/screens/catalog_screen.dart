import 'package:flutter/material.dart';

import '../data/product_data.dart';
import '../models/product_model.dart';
import '../utils/app_theme.dart';
import '../widgets/hero_carousel.dart';
import '../widgets/shoply_footer.dart';
import 'cart_screen.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  final TextEditingController _searchController =
      TextEditingController();

  final List<Product> _cart = [];
  final List<Product> _wishlist = [];

  String _selectedCategory = 'All';
  String _selectedSort = 'Featured';
  String _searchQuery = '';

  final List<String> _categories = [
    'All',
    'Electronics',
    'Fashion',
    'Books',
    'Accessories',
  ];

  final List<String> _sortOptions = [
    'Featured',
    'Price: Low to High',
    'Price: High to Low',
    'Rating',
    'Newest',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Product> get _filteredProducts {
    List<Product> products =
        List<Product>.from(ProductData.products);

    if (_searchQuery.trim().isNotEmpty) {
      final query = _searchQuery.toLowerCase().trim();

      products = products.where((product) {
        return product.name.toLowerCase().contains(query) ||
            product.category.toLowerCase().contains(query) ||
            product.description.toLowerCase().contains(query);
      }).toList();
    }

    if (_selectedCategory != 'All') {
      products = products
          .where(
            (product) =>
                product.category == _selectedCategory,
          )
          .toList();
    }

    switch (_selectedSort) {
      case 'Price: Low to High':
        products.sort(
          (a, b) => a.price.compareTo(b.price),
        );
        break;

      case 'Price: High to Low':
        products.sort(
          (a, b) => b.price.compareTo(a.price),
        );
        break;

      case 'Rating':
        products.sort(
          (a, b) => b.rating.compareTo(a.rating),
        );
        break;

      case 'Newest':
        products.sort((a, b) {
          if (a.isNew == b.isNew) return 0;
          return a.isNew ? -1 : 1;
        });
        break;

      case 'Featured':
      default:
        products.sort((a, b) {
          if (a.isFeatured == b.isFeatured) return 0;
          return a.isFeatured ? -1 : 1;
        });
    }

    return products;
  }

  bool _isInWishlist(Product product) {
    return _wishlist.any(
      (item) => item.id == product.id,
    );
  }

  bool _isInCart(Product product) {
    return _cart.any(
      (item) => item.id == product.id,
    );
  }

  void _toggleWishlist(Product product) {
    final alreadyAdded = _isInWishlist(product);

    setState(() {
      if (alreadyAdded) {
        _wishlist.removeWhere(
          (item) => item.id == product.id,
        );
      } else {
        _wishlist.add(product);
      }
    });

    _showMessage(
      alreadyAdded
          ? '${product.name} removed from wishlist'
          : '${product.name} added to wishlist',
    );
  }

  void _addToCart(Product product) {
    if (_isInCart(product)) {
      _showMessage('${product.name} is already in your cart');
      return;
    }

    setState(() {
      _cart.add(product);
    });

    _showMessage('${product.name} added to cart');
  }

  void _removeFromCart(Product product) {
    setState(() {
      _cart.removeWhere(
        (item) => item.id == product.id,
      );
    });

    _showMessage('${product.name} removed from cart');
  }

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            message,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
          margin: const EdgeInsets.all(18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      );
  }

  void _openCartPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CartScreen(
          cart: List<Product>.from(_cart),
          onRemove: _removeFromCart,
          onContinueShopping: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  void _showWishlist() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return _WishlistSheet(
          wishlist: List<Product>.from(_wishlist),
          onRemove: (product) {
            _toggleWishlist(product);
            Navigator.pop(context);
          },
          onAddToCart: _addToCart,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final products = _filteredProducts;
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 700;

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: _buildHeader(context, isMobile),
            ),

            const SliverToBoxAdapter(
              child: SizedBox(height: 24),
            ),

            SliverToBoxAdapter(
              child: HeroCarousel(
                products: ProductData.products,
                cartProductIds:
                    _cart.map((product) => product.id).toSet(),
                wishlistProductIds:
                    _wishlist.map((product) => product.id).toSet(),
                onAddToCart: _addToCart,
                onWishlist: _toggleWishlist,
              ),
            ),

            const SliverToBoxAdapter(
              child: SizedBox(height: 28),
            ),

            SliverToBoxAdapter(
              child: _buildSearchBar(context, isMobile),
            ),

            const SliverToBoxAdapter(
              child: SizedBox(height: 16),
            ),

            SliverToBoxAdapter(
              child: _buildCategoryFilters(
                context,
                isMobile,
              ),
            ),

            const SliverToBoxAdapter(
              child: SizedBox(height: 28),
            ),

            SliverToBoxAdapter(
              child: _buildProductsHeader(
                context,
                products.length,
                isMobile,
              ),
            ),

            const SliverToBoxAdapter(
              child: SizedBox(height: 18),
            ),

            if (products.isEmpty)
              SliverToBoxAdapter(
                child: _buildEmptyState(isMobile),
              )
            else
              SliverPadding(
                padding: EdgeInsets.fromLTRB(
                  isMobile ? 18 : 42,
                  0,
                  isMobile ? 18 : 42,
                  34,
                ),
                sliver: SliverLayoutBuilder(
                  builder: (context, constraints) {
                    final availableWidth =
                        constraints.crossAxisExtent;

                    int columns;

                    if (availableWidth >= 1250) {
                      columns = 4;
                    } else if (availableWidth >= 850) {
                      columns = 3;
                    } else if (availableWidth >= 550) {
                      columns = 2;
                    } else {
                      columns = 1;
                    }

                    return SliverGrid(
                      delegate:
                          SliverChildBuilderDelegate(
                        (context, index) {
                          final product = products[index];

                          return _ProductCard(
                            key: ValueKey(product.id),
                            product: product,
                            isWishlisted:
                                _isInWishlist(product),
                            isInCart:
                                _isInCart(product),
                            onWishlist: () =>
                                _toggleWishlist(product),
                            onAddToCart: () =>
                                _addToCart(product),
                          );
                        },
                        childCount: products.length,
                      ),
                      gridDelegate:
                          SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: columns,
                        crossAxisSpacing:
                            columns == 1 ? 0 : 18,
                        mainAxisSpacing: 18,
                        childAspectRatio:
                            columns == 1 ? 0.84 : 0.72,
                      ),
                    );
                  },
                ),
              ),

            const SliverToBoxAdapter(
              child: ShoplyFooter(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    bool isMobile,
  ) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        isMobile ? 18 : 42,
        20,
        isMobile ? 18 : 42,
        0,
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: AppTheme.primary,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primary.withValues(
                    alpha: 0.18,
                  ),
                  blurRadius: 18,
                  offset: const Offset(0, 7),
                ),
              ],
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
              fontSize: 20,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.1,
              color: AppTheme.textPrimary,
            ),
          ),
          const Spacer(),

          if (!isMobile)
            _HeaderAction(
              icon: Icons.favorite_border_rounded,
              label: _wishlist.isEmpty
                  ? 'Wishlist'
                  : 'Wishlist ${_wishlist.length}',
              onTap: _showWishlist,
              badgeCount: _wishlist.length,
            ),

          if (!isMobile)
            const SizedBox(width: 8),

          _HeaderAction(
            icon: Icons.shopping_bag_outlined,
            label: _cart.isEmpty
                ? 'Cart'
                : 'Cart ${_cart.length}',
            onTap: _openCartPage,
            badgeCount: _cart.length,
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(
    BuildContext context,
    bool isMobile,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 18 : 42,
      ),
      child: Container(
        height: 54,
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppTheme.border,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(
                alpha: 0.025,
              ),
              blurRadius: 18,
              offset: const Offset(0, 7),
            ),
          ],
        ),
        child: TextField(
          controller: _searchController,
          onChanged: (value) {
            setState(() {
              _searchQuery = value;
            });
          },
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary,
          ),
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText:
                'Search products, categories...',
            hintStyle: const TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 12,
            ),
            prefixIcon: const Icon(
              Icons.search_rounded,
              color: AppTheme.textSecondary,
            ),
            suffixIcon: _searchQuery.isNotEmpty
                ? IconButton(
                    onPressed: () {
                      _searchController.clear();

                      setState(() {
                        _searchQuery = '';
                      });
                    },
                    icon: const Icon(
                      Icons.close_rounded,
                      size: 19,
                      color: AppTheme.textSecondary,
                    ),
                  )
                : const Icon(
                    Icons.tune_rounded,
                    size: 19,
                    color: AppTheme.textSecondary,
                  ),
            contentPadding:
                const EdgeInsets.symmetric(
              vertical: 16,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryFilters(
    BuildContext context,
    bool isMobile,
  ) {
    return SizedBox(
      height: 43,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 18 : 42,
        ),
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: _categories.length,
        separatorBuilder: (_, __) =>
            const SizedBox(width: 9),
        itemBuilder: (context, index) {
          final category = _categories[index];
          final selected =
              category == _selectedCategory;

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedCategory = category;
              });
            },
            child: AnimatedContainer(
              duration:
                  const Duration(milliseconds: 220),
              curve: Curves.easeOut,
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 15,
              ),
              decoration: BoxDecoration(
                color: selected
                    ? AppTheme.primary
                    : AppTheme.surface,
                borderRadius:
                    BorderRadius.circular(13),
                border: Border.all(
                  color: selected
                      ? AppTheme.primary
                      : AppTheme.border,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedSwitcher(
                    duration:
                        const Duration(milliseconds: 180),
                    child: selected
                        ? const Padding(
                            key: ValueKey('selected'),
                            padding: EdgeInsets.only(
                              right: 6,
                            ),
                            child: Icon(
                              Icons.check_rounded,
                              size: 15,
                              color: Colors.white,
                            ),
                          )
                        : const SizedBox(
                            key: ValueKey('normal'),
                            width: 0,
                          ),
                  ),
                  Text(
                    category,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: selected
                          ? Colors.white
                          : AppTheme.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductsHeader(
    BuildContext context,
    int productCount,
    bool isMobile,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 18 : 42,
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.end,
        children: [
          Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                '$productCount Products',
                style: const TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.w900,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 3),
              const Text(
                'Explore our collection',
                style: TextStyle(
                  fontSize: 10,
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
          const Spacer(),
          _SortDropdown(
            value: _selectedSort,
            options: _sortOptions,
            onChanged: (value) {
              setState(() {
                _selectedSort = value;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(bool isMobile) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 18 : 42,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 80,
          horizontal: 20,
        ),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: AppTheme.border,
          ),
        ),
        child: Column(
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppTheme.surfaceSoft,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.search_off_rounded,
                size: 34,
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'No products found',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Try another search or category.',
              style: TextStyle(
                fontSize: 11,
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 20),
            OutlinedButton(
              onPressed: () {
                _searchController.clear();

                setState(() {
                  _searchQuery = '';
                  _selectedCategory = 'All';
                  _selectedSort = 'Featured';
                });
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.primary,
                side: const BorderSide(
                  color: AppTheme.primary,
                ),
              ),
              child: const Text('Clear Filters'),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeaderAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final int badgeCount;

  const _HeaderAction({
    required this.icon,
    required this.label,
    required this.onTap,
    this.badgeCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(13),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 9,
          vertical: 9,
        ),
        child: Row(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(
                  icon,
                  size: 20,
                  color: AppTheme.textPrimary,
                ),
                if (badgeCount > 0)
                  Positioned(
                    right: -8,
                    top: -8,
                    child: Container(
                      constraints:
                          const BoxConstraints(
                        minWidth: 15,
                        minHeight: 15,
                      ),
                      padding:
                          const EdgeInsets.symmetric(
                        horizontal: 3,
                      ),
                      decoration: const BoxDecoration(
                        color: AppTheme.primary,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '$badgeCount',
                          style: const TextStyle(
                            fontSize: 8,
                            fontWeight:
                                FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                color: AppTheme.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SortDropdown extends StatelessWidget {
  final String value;
  final List<String> options;
  final ValueChanged<String> onChanged;

  const _SortDropdown({
    required this.value,
    required this.options,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 42,
      padding:
          const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(
          color: AppTheme.border,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            size: 18,
            color: AppTheme.textSecondary,
          ),
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w800,
            color: AppTheme.textPrimary,
          ),
          items: options.map((option) {
            return DropdownMenuItem<String>(
              value: option,
              child: Text(option),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              onChanged(value);
            }
          },
        ),
      ),
    );
  }
}

class _ProductCard extends StatefulWidget {
  final Product product;
  final bool isWishlisted;
  final bool isInCart;
  final VoidCallback onWishlist;
  final VoidCallback onAddToCart;

  const _ProductCard({
    super.key,
    required this.product,
    required this.isWishlisted,
    required this.isInCart,
    required this.onWishlist,
    required this.onAddToCart,
  });

  @override
  State<_ProductCard> createState() =>
      _ProductCardState();
}

class _ProductCardState extends State<_ProductCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) {
        setState(() {
          _hovered = true;
        });
      },
      onExit: (_) {
        setState(() {
          _hovered = false;
        });
      },
      child: AnimatedContainer(
        duration:
            const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        transform: Matrix4.translationValues(
          0,
          _hovered ? -5 : 0,
          0,
        ),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _hovered
                ? AppTheme.primary.withValues(
                    alpha: 0.30,
                  )
                : AppTheme.border,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(
                alpha: _hovered ? 0.09 : 0.035,
              ),
              blurRadius: _hovered ? 24 : 12,
              offset: Offset(
                0,
                _hovered ? 12 : 5,
              ),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 6,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    AnimatedScale(
                      scale: _hovered ? 1.035 : 1,
                      duration: const Duration(
                        milliseconds: 350,
                      ),
                      curve: Curves.easeOut,
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
                                const Color(0xFFF0ECE7),
                            child: const Center(
                              child: Icon(
                                Icons
                                    .image_not_supported_outlined,
                                size: 34,
                                color: AppTheme
                                    .textSecondary,
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    if (product.isNew)
                      Positioned(
                        left: 11,
                        top: 11,
                        child: Container(
                          padding:
                              const EdgeInsets.symmetric(
                            horizontal: 9,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black
                                    .withValues(
                                  alpha: 0.06,
                                ),
                                blurRadius: 8,
                              ),
                            ],
                          ),
                          child: const Text(
                            'NEW',
                            style: TextStyle(
                              fontSize: 8,
                              fontWeight:
                                  FontWeight.w900,
                              color:
                                  AppTheme.textPrimary,
                            ),
                          ),
                        ),
                      ),

                    Positioned(
                      right: 11,
                      top: 11,
                      child: Material(
                        color: Colors.white.withValues(
                          alpha: 0.94,
                        ),
                        shape:
                            const CircleBorder(),
                        child: InkWell(
                          onTap: widget.onWishlist,
                          customBorder:
                              const CircleBorder(),
                          child: Padding(
                            padding:
                                const EdgeInsets.all(9),
                            child: AnimatedSwitcher(
                              duration:
                                  const Duration(
                                milliseconds: 220,
                              ),
                              transitionBuilder:
                                  (
                                child,
                                animation,
                              ) {
                                return ScaleTransition(
                                  scale: animation,
                                  child: child,
                                );
                              },
                              child: Icon(
                                widget.isWishlisted
                                    ? Icons
                                        .favorite_rounded
                                    : Icons
                                        .favorite_border_rounded,
                                key: ValueKey(
                                  widget.isWishlisted,
                                ),
                                size: 19,
                                color: widget
                                        .isWishlisted
                                    ? AppTheme.primary
                                    : AppTheme
                                        .textPrimary,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    Positioned(
                      left: 12,
                      bottom: 12,
                      child: AnimatedOpacity(
                        opacity: _hovered ? 1 : 0,
                        duration:
                            const Duration(
                          milliseconds: 180,
                        ),
                        child: Container(
                          padding:
                              const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black
                                .withValues(
                              alpha: 0.72,
                            ),
                            borderRadius:
                                BorderRadius.circular(9),
                          ),
                          child: const Row(
                            mainAxisSize:
                                MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.visibility_outlined,
                                size: 13,
                                color: Colors.white,
                              ),
                              SizedBox(width: 5),
                              Text(
                                'Quick view',
                                style: TextStyle(
                                  fontSize: 8,
                                  fontWeight:
                                      FontWeight.w800,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                flex: 4,
                child: Padding(
                  padding:
                      const EdgeInsets.fromLTRB(
                    13,
                    12,
                    13,
                    11,
                  ),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.category.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 7.5,
                          fontWeight:
                              FontWeight.w900,
                          letterSpacing: 1,
                          color:
                              AppTheme.textSecondary,
                        ),
                      ),

                      const SizedBox(height: 5),

                      Text(
                        product.name,
                        maxLines: 1,
                        overflow:
                            TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight:
                              FontWeight.w800,
                          color:
                              AppTheme.textPrimary,
                        ),
                      ),

                      const Spacer(),

                      Row(
                        children: [
                          const Icon(
                            Icons.star_rounded,
                            size: 15,
                            color: Color(0xFFFFAA27),
                          ),
                          const SizedBox(width: 3),
                          Text(
                            product.rating
                                .toStringAsFixed(1),
                            style:
                                const TextStyle(
                              fontSize: 9,
                              fontWeight:
                                  FontWeight.w800,
                              color: AppTheme
                                  .textPrimary,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '(${product.reviewCount})',
                            style:
                                const TextStyle(
                              fontSize: 8,
                              color: AppTheme
                                  .textSecondary,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      Row(
                        children: [
                          Text(
                            '₹${product.price.toStringAsFixed(0)}',
                            style:
                                const TextStyle(
                              fontSize: 16,
                              fontWeight:
                                  FontWeight.w900,
                              color: AppTheme
                                  .textPrimary,
                            ),
                          ),
                          const Spacer(),

                          Material(
                            color: widget.isInCart
                                ? AppTheme.success
                                : AppTheme.primary,
                            shape:
                                const CircleBorder(),
                            child: InkWell(
                              onTap:
                                  widget.onAddToCart,
                              customBorder:
                                  const CircleBorder(),
                              child: Padding(
                                padding:
                                    const EdgeInsets.all(
                                  9,
                                ),
                                child: AnimatedSwitcher(
                                  duration:
                                      const Duration(
                                    milliseconds: 220,
                                  ),
                                  transitionBuilder:
                                      (
                                    child,
                                    animation,
                                  ) {
                                    return ScaleTransition(
                                      scale: animation,
                                      child: child,
                                    );
                                  },
                                  child: Icon(
                                    widget.isInCart
                                        ? Icons
                                            .check_rounded
                                        : Icons
                                            .add_rounded,
                                    key: ValueKey(
                                      widget.isInCart,
                                    ),
                                    size: 19,
                                    color:
                                        Colors.white,
                                  ),
                                ),
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
        ),
      ),
    );
  }
}

class _WishlistSheet extends StatelessWidget {
  final List<Product> wishlist;
  final ValueChanged<Product> onRemove;
  final ValueChanged<Product> onAddToCart;

  const _WishlistSheet({
    required this.wishlist,
    required this.onRemove,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    final height =
        MediaQuery.of(context).size.height;

    return Container(
      height: height * 0.72,
      decoration: const BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(26),
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
          Padding(
            padding: const EdgeInsets.fromLTRB(
              22,
              20,
              22,
              17,
            ),
            child: Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: AppTheme.primary
                        .withValues(alpha: 0.10),
                    borderRadius:
                        BorderRadius.circular(13),
                  ),
                  child: const Icon(
                    Icons.favorite_rounded,
                    color: AppTheme.primary,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        'My Wishlist',
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight:
                              FontWeight.w900,
                          color:
                              AppTheme.textPrimary,
                        ),
                      ),
                      SizedBox(height: 3),
                      Text(
                        'Products you want to remember.',
                        style: TextStyle(
                          fontSize: 10,
                          color:
                              AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  '${wishlist.length}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: AppTheme.primary,
                  ),
                ),
              ],
            ),
          ),
          const Divider(
            height: 1,
            color: AppTheme.border,
          ),
          Expanded(
            child: wishlist.isEmpty
                ? const _EmptyWishlist()
                : ListView.separated(
                    padding:
                        const EdgeInsets.all(18),
                    itemCount: wishlist.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final product =
                          wishlist[index];

                      return _WishlistItem(
                        product: product,
                        onRemove: () =>
                            onRemove(product),
                        onAddToCart: () =>
                            onAddToCart(product),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _WishlistItem extends StatelessWidget {
  final Product product;
  final VoidCallback onRemove;
  final VoidCallback onAddToCart;

  const _WishlistItem({
    required this.product,
    required this.onRemove,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppTheme.background,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: AppTheme.border,
        ),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius:
                BorderRadius.circular(11),
            child: Image.network(
              product.imageUrl,
              width: 68,
              height: 68,
              fit: BoxFit.cover,
              errorBuilder:
                  (context, error, stackTrace) {
                return Container(
                  width: 68,
                  height: 68,
                  color: AppTheme.surfaceSoft,
                  child: const Icon(
                    Icons.image_outlined,
                    color:
                        AppTheme.textSecondary,
                  ),
                );
              },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  maxLines: 1,
                  overflow:
                      TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color:
                        AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '₹${product.price.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                    color: AppTheme.primary,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Add to cart',
            onPressed: onAddToCart,
            icon: const Icon(
              Icons.shopping_bag_outlined,
              size: 20,
            ),
          ),
          IconButton(
            tooltip: 'Remove from wishlist',
            onPressed: onRemove,
            icon: const Icon(
              Icons.delete_outline_rounded,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyWishlist extends StatelessWidget {
  const _EmptyWishlist();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.favorite_border_rounded,
              size: 58,
              color: AppTheme.textSecondary,
            ),
            SizedBox(height: 16),
            Text(
              'Your wishlist is empty',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w900,
                color: AppTheme.textPrimary,
              ),
            ),
            SizedBox(height: 6),
            Text(
              'Tap the heart on any product to save it here.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10,
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}