import 'package:flutter/material.dart';

import '../models/product_model.dart';
import '../utils/app_theme.dart';

class CartScreen extends StatefulWidget {
  final List<Product> cart;
  final ValueChanged<Product> onRemove;
  final VoidCallback onContinueShopping;

  const CartScreen({
    super.key,
    required this.cart,
    required this.onRemove,
    required this.onContinueShopping,
  });

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late List<Product> _cart;

  @override
  void initState() {
    super.initState();
    _cart = List<Product>.from(widget.cart);
  }

  double get subtotal {
    return _cart.fold(
      0,
      (sum, product) => sum + product.price,
    );
  }

  double get delivery {
    if (_cart.isEmpty) return 0;
    return subtotal >= 5000 ? 0 : 99;
  }

  double get total {
    return subtotal + delivery;
  }

  double get remainingForFreeDelivery {
    return (5000 - subtotal).clamp(0, 5000).toDouble();
  }

  double get deliveryProgress {
    return (subtotal / 5000).clamp(0, 1).toDouble();
  }

  void _removeProduct(Product product) {
    setState(() {
      _cart.removeWhere(
        (item) => item.id == product.id,
      );
    });

    widget.onRemove(product);

    _showMessage(
      '${product.name} removed from cart',
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
          margin: const EdgeInsets.all(18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
  }

  void _showCheckoutDialog() {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppTheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          title: const Row(
            children: [
              Icon(
                Icons.lock_outline_rounded,
                color: AppTheme.primary,
              ),
              SizedBox(width: 10),
              Text(
                'Checkout',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  color: AppTheme.textPrimary,
                ),
              ),
            ],
          ),
          content: Text(
            'Your order total is ₹${total.toStringAsFixed(0)}. '
            'Payment and delivery integration can be connected here.',
            style: const TextStyle(
              fontSize: 12,
              height: 1.5,
              color: AppTheme.textSecondary,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(dialogContext);

                _showMessage(
                  'Order checkout started successfully!',
                );
              },
              style: FilledButton.styleFrom(
                backgroundColor: AppTheme.primary,
                foregroundColor: Colors.white,
              ),
              child: const Text(
                'Confirm',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 800;

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: _cart.isEmpty
            ? _buildEmptyCart()
            : CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child: _buildHeader(isMobile),
                  ),
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: isMobile ? 20 : 28,
                    ),
                  ),
                  SliverPadding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isMobile ? 18 : 42,
                    ),
                    sliver: SliverToBoxAdapter(
                      child: isMobile
                          ? _buildMobileLayout()
                          : _buildDesktopLayout(),
                    ),
                  ),
                  const SliverToBoxAdapter(
                    child: SizedBox(height: 45),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildHeader(bool isMobile) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        isMobile ? 18 : 42,
        22,
        isMobile ? 18 : 42,
        0,
      ),
      child: Row(
        children: [
          Material(
            color: AppTheme.primary,
            borderRadius: BorderRadius.circular(14),
            child: InkWell(
              onTap: widget.onContinueShopping,
              borderRadius: BorderRadius.circular(14),
              child: const SizedBox(
                width: 46,
                height: 46,
                child: Icon(
                  Icons.arrow_back_rounded,
                  color: Colors.white,
                  size: 22,
                ),
              ),
            ),
          ),
          const SizedBox(width: 13),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'SHOPLY',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1,
                  color: AppTheme.textPrimary,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'Shopping Cart',
                style: TextStyle(
                  fontSize: 10,
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 11,
              vertical: 7,
            ),
            decoration: BoxDecoration(
              color: AppTheme.surface,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: AppTheme.border,
              ),
            ),
            child: Text(
              '${_cart.length} ${_cart.length == 1 ? 'item' : 'items'}',
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                color: AppTheme.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 7,
          child: _buildCartItems(),
        ),
        const SizedBox(width: 24),
        Expanded(
          flex: 4,
          child: _buildOrderSummary(),
        ),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildCartItems(),
        const SizedBox(height: 22),
        _buildOrderSummary(),
      ],
    );
  }

  Widget _buildCartItems() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Your Cart',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w900,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 5),
        const Text(
          'Review the products you selected.',
          style: TextStyle(
            fontSize: 11,
            color: AppTheme.textSecondary,
          ),
        ),
        const SizedBox(height: 18),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppTheme.border,
            ),
          ),
          child: Column(
            children: [
              ..._cart.map(
                (product) => Padding(
                  padding: const EdgeInsets.only(
                    bottom: 10,
                  ),
                  child: _CartProductTile(
                    product: product,
                    onRemove: () => _removeProduct(product),
                  ),
                ),
              ),
              const SizedBox(height: 4),
              InkWell(
                onTap: widget.onContinueShopping,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    vertical: 13,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.background,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppTheme.border,
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.arrow_back_rounded,
                        size: 17,
                        color: AppTheme.textPrimary,
                      ),
                      SizedBox(width: 7),
                      Text(
                        'Continue Shopping',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOrderSummary() {
    final freeDelivery = delivery == 0;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppTheme.border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Order Summary',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 18),

          _SummaryRow(
            label: 'Subtotal',
            value: '₹${subtotal.toStringAsFixed(0)}',
          ),

          const SizedBox(height: 11),

          _SummaryRow(
            label: 'Delivery',
            value: freeDelivery
                ? 'FREE'
                : '₹${delivery.toStringAsFixed(0)}',
            valueColor: freeDelivery
                ? AppTheme.success
                : AppTheme.textPrimary,
          ),

          const SizedBox(height: 16),

          const Divider(
            color: AppTheme.border,
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              const Text(
                'Total',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
                  color: AppTheme.textPrimary,
                ),
              ),
              const Spacer(),
              Text(
                '₹${total.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: AppTheme.primary,
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          _buildDeliveryProgress(),

          const SizedBox(height: 18),

          SizedBox(
            width: double.infinity,
            height: 50,
            child: FilledButton.icon(
              onPressed: _showCheckoutDialog,
              icon: const Icon(
                Icons.lock_outline_rounded,
                size: 18,
              ),
              label: const Text(
                'Proceed to Checkout',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                ),
              ),
              style: FilledButton.styleFrom(
                backgroundColor: AppTheme.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13),
                ),
              ),
            ),
          ),

          const SizedBox(height: 13),

          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.verified_user_outlined,
                size: 14,
                color: AppTheme.success,
              ),
              SizedBox(width: 5),
              Text(
                'Secure checkout',
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDeliveryProgress() {
    final free = deliveryProgress >= 1;

    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: free
            ? AppTheme.success.withValues(alpha: 0.07)
            : AppTheme.primary.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(13),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                free
                    ? Icons.check_circle_outline_rounded
                    : Icons.local_shipping_outlined,
                size: 18,
                color: free
                    ? AppTheme.success
                    : AppTheme.primary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  free
                      ? 'You unlocked free delivery!'
                      : 'Add ₹${remainingForFreeDelivery.toStringAsFixed(0)} more for free delivery.',
                  style: const TextStyle(
                    fontSize: 9.5,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          if (!free) ...[
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: LinearProgressIndicator(
                value: deliveryProgress,
                minHeight: 6,
                backgroundColor: AppTheme.border,
                valueColor: const AlwaysStoppedAnimation<Color>(
                  AppTheme.primary,
                ),
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Free delivery on orders above ₹5,000',
              style: TextStyle(
                fontSize: 8,
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 115,
              height: 115,
              decoration: BoxDecoration(
                color: AppTheme.primary.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.shopping_bag_outlined,
                size: 52,
                color: AppTheme.primary,
              ),
            ),
            const SizedBox(height: 25),
            const Text(
              'Your cart is empty',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w900,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Looks like you haven\'t added anything yet.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 25),
            FilledButton.icon(
              onPressed: widget.onContinueShopping,
              icon: const Icon(
                Icons.shopping_bag_outlined,
              ),
              label: const Text(
                'Start Shopping',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                ),
              ),
              style: FilledButton.styleFrom(
                backgroundColor: AppTheme.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CartProductTile extends StatelessWidget {
  final Product product;
  final VoidCallback onRemove;

  const _CartProductTile({
    required this.product,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(11),
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
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              product.imageUrl,
              width: 82,
              height: 82,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 82,
                  height: 82,
                  color: const Color(0xFFF0ECE7),
                  child: const Icon(
                    Icons.image_not_supported_outlined,
                    color: AppTheme.textSecondary,
                  ),
                );
              },
            ),
          ),

          const SizedBox(width: 13),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.category.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 7.5,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1,
                    color: AppTheme.textSecondary,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  product.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 7),
                Row(
                  children: [
                    const Icon(
                      Icons.star_rounded,
                      size: 14,
                      color: Color(0xFFFFAA27),
                    ),
                    const SizedBox(width: 3),
                    Text(
                      product.rating.toStringAsFixed(1),
                      style: const TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 7),
                Text(
                  '₹${product.price.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                    color: AppTheme.primary,
                  ),
                ),
              ],
            ),
          ),

          IconButton(
            tooltip: 'Remove from cart',
            onPressed: onRemove,
            icon: const Icon(
              Icons.delete_outline_rounded,
              size: 20,
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: AppTheme.textSecondary,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            color: valueColor ?? AppTheme.textPrimary,
          ),
        ),
      ],
    );
  }
}