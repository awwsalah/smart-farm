import 'package:app/config/app_strings.dart';
import 'package:app/models/product.dart';
import 'package:app/widgets/optimized_asset_image.dart';
import 'package:app/widgets/pressable_scale.dart';
import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
    this.heroTag,
  });

  final Product product;
  final VoidCallback onTap;
  final String? heroTag;

  String get _priceLabel =>
      '${product.price.toStringAsFixed(2)} ${product.currency}';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return PressableScale(
      onTap: onTap,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ProductImage(
                product: product,
                heroTag: heroTag,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _priceLabel,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (!product.inStock) ...[
                    const SizedBox(height: 4),
                    Text(
                      AppStrings.outOfStock,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.error,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductImage extends StatelessWidget {
  const ProductImage({
    super.key,
    required this.product,
    this.heroTag,
  });

  final Product product;
  final String? heroTag;

  @override
  Widget build(BuildContext context) {
    final image = product.imageAsset;

    Widget child;
    if (image == null || image.isEmpty) {
      child = _placeholder(context);
    } else {
      child = LayoutBuilder(
        builder: (context, constraints) {
          return OptimizedAssetImage(
            assetPath: image,
            fit: BoxFit.cover,
            width: constraints.maxWidth,
            height: constraints.maxHeight,
          );
        },
      );
    }

    if (heroTag != null) {
      child = Hero(tag: heroTag!, child: child);
    }

    return child;
  }

  Widget _placeholder(BuildContext context) {
    return ColoredBox(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Center(
        child: Icon(
          Icons.agriculture,
          size: 40,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}