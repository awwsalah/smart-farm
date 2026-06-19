import 'package:app/config/app_strings.dart';
import 'package:app/config/app_theme.dart';
import 'package:app/data/repositories/product_repository.dart';
import 'package:app/models/product.dart';
import 'package:app/providers/cart_provider.dart';
import 'package:app/widgets/app_background.dart';
import 'package:app/widgets/pressable_scale.dart';
import 'package:app/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({
    super.key,
    required this.productId,
  });

  final int productId;

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final ProductRepository _repository = ProductRepository();
  late Future<Product?> _productFuture;
  int _quantity = 1;

  @override
  void initState() {
    super.initState();
    _productFuture = _repository.getById(widget.productId);
  }

  Future<void> _addToCart(Product product) async {
    if (!product.inStock) return;

    await context.read<CartProvider>().addProduct(product, quantity: _quantity);

    if (!mounted) return;

    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        duration: const Duration(milliseconds: 2200),
        content: Row(
          children: [
            Icon(
              Icons.check_circle_outline,
              color: Theme.of(context).colorScheme.onInverseSurface,
            ),
            const SizedBox(width: 10),
            const Expanded(child: Text(AppStrings.addedToCart)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppTheme.gradientAppBar(title: AppStrings.productDetail),
      body: AppBackground(
        child: FutureBuilder<Product?>(
          future: _productFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final product = snapshot.data;
            if (product == null) {
              return const Center(child: Text(AppStrings.error));
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: SizedBox(
                      height: 220,
                      child: ProductImage(
                        product: product,
                        heroTag: 'product-image-${product.id}',
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    product.name,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${product.price.toStringAsFixed(2)} ${product.currency}',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  if (!product.inStock) ...[
                    const SizedBox(height: 8),
                    Text(
                      AppStrings.outOfStock,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),
                  Text(
                    product.description ?? '',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    AppStrings.quantity,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      IconButton.filledTonal(
                        onPressed: product.inStock && _quantity > 1
                            ? () => setState(() => _quantity--)
                            : null,
                        icon: const Icon(Icons.remove),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          '$_quantity',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                      IconButton.filledTonal(
                        onPressed: product.inStock
                            ? () => setState(() => _quantity++)
                            : null,
                        icon: const Icon(Icons.add),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  PressableScale(
                    onTap: product.inStock ? () => _addToCart(product) : null,
                    child: FilledButton.icon(
                      onPressed:
                          product.inStock ? () => _addToCart(product) : null,
                      icon: const Icon(Icons.add_shopping_cart),
                      label: const Text(AppStrings.addToCart),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}