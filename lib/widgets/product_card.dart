import 'package:app/config/app_strings.dart';
import 'package:app/config/app_theme.dart';
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
    return PressableScale(
      onTap: onTap,
      child: Container(
        decoration: AppTheme.softCardDecoration(),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            AspectRatio(
              aspectRatio: 1.2,
              child: ProductImage(
                product: product,
                heroTag: heroTag,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDark,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _priceLabel,
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  if (!product.inStock) ...[
                    const SizedBox(height: 4),
                    Text(
                      AppStrings.outOfStock,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
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
      color: AppColors.sand,
      child: Center(
        child: Icon(
          Icons.agriculture,
          size: 40,
          color: AppColors.primary.withValues(alpha: 0.7),
        ),
      ),
    );
  }
}