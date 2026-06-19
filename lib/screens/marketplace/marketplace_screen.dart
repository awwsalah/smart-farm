import 'package:app/config/app_strings.dart';
import 'package:app/config/product_categories.dart';
import 'package:app/data/repositories/product_repository.dart';
import 'package:app/models/product.dart';
import 'package:app/providers/cart_provider.dart';
import 'package:app/screens/marketplace/cart_screen.dart';
import 'package:app/screens/marketplace/product_detail_screen.dart';
import 'package:app/widgets/cart_badge_icon.dart';
import 'package:app/widgets/product_card.dart';
import 'package:app/widgets/staggered_entrance.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class MarketplaceScreen extends StatefulWidget {
  const MarketplaceScreen({super.key});

  @override
  State<MarketplaceScreen> createState() => _MarketplaceScreenState();
}

class _MarketplaceScreenState extends State<MarketplaceScreen> {
  final ProductRepository _repository = ProductRepository();

  String? _selectedCategoryKey;
  late Future<List<Product>> _productsFuture;

  @override
  void initState() {
    super.initState();
    _productsFuture = _loadProducts();
  }

  Future<List<Product>> _loadProducts() {
    if (_selectedCategoryKey == null) {
      return _repository.getAll();
    }
    return _repository.getByCategory(_selectedCategoryKey!);
  }

  void _onCategorySelected(String? categoryKey) {
    setState(() {
      _selectedCategoryKey = categoryKey;
      _productsFuture = _loadProducts();
    });
  }

  void _openProductDetail(Product product) {
    final disableAnimations = MediaQuery.disableAnimationsOf(context);
    Navigator.of(context).push(
      PageRouteBuilder<void>(
        pageBuilder: (_, __, ___) =>
            ProductDetailScreen(productId: product.id),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: disableAnimations
            ? Duration.zero
            : const Duration(milliseconds: 280),
      ),
    );
  }

  void _openCart() {
    final disableAnimations = MediaQuery.disableAnimationsOf(context);
    Navigator.of(context).push(
      PageRouteBuilder<void>(
        pageBuilder: (_, __, ___) => const CartScreen(),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: disableAnimations
            ? Duration.zero
            : const Duration(milliseconds: 280),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cartCount = context.watch<CartProvider>().itemCount;

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.navMarket),
        actions: [
          CartBadgeIcon(
            count: cartCount,
            onPressed: _openCart,
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 48,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              itemCount: ProductCategories.filters.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final filter = ProductCategories.filters[index];
                final isSelected = _selectedCategoryKey == filter.key;

                return FilterChip(
                  label: Text(filter.label),
                  selected: isSelected,
                  onSelected: (_) => _onCategorySelected(filter.key),
                );
              },
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Product>>(
              future: _productsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return _LoadingGrid();
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text(AppStrings.error),
                  );
                }

                final products = snapshot.data ?? [];
                if (products.isEmpty) {
                  return Center(
                    child: Text(AppStrings.emptyProducts),
                  );
                }

                return GridView.builder(
                  padding: const EdgeInsets.all(12),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.72,
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return StaggeredEntrance(
                      index: index,
                      child: ProductCard(
                        product: product,
                        heroTag: 'product-image-${product.id}',
                        onTap: () => _openProductDetail(product),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _LoadingGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.72,
      ),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Theme.of(context).colorScheme.surfaceContainerHighest,
          highlightColor: Theme.of(context).colorScheme.surface,
          child: Card(
            child: Column(
              children: [
                Expanded(
                  child: Container(color: Colors.white),
                ),
                const SizedBox(height: 12),
                Container(
                  height: 12,
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                  color: Colors.white,
                ),
                const SizedBox(height: 8),
                Container(
                  height: 12,
                  width: 60,
                  margin: const EdgeInsets.only(left: 12, bottom: 12),
                  color: Colors.white,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}