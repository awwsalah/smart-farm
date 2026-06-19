import 'package:app/models/product.dart';
import 'package:app/widgets/optimized_asset_image.dart';
import 'package:app/widgets/pressable_scale.dart';
import 'package:flutter/material.dart';

class HomeProductTile extends StatelessWidget {
  const HomeProductTile({
    super.key,
    required this.product,
    required this.onTap,
  });

  final Product product;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final image = product.imageAsset;

    return PressableScale(
      onTap: onTap,
      child: SizedBox(
        width: 150,
        child: Card(
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 100,
                child: image != null && image.isNotEmpty
                    ? OptimizedAssetImage(
                        assetPath: image,
                        fit: BoxFit.cover,
                        width: 150,
                        height: 100,
                      )
                    : _placeholder(context),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${product.price.toStringAsFixed(2)} ${product.currency}',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _placeholder(BuildContext context) {
    return ColoredBox(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Center(
        child: Icon(
          Icons.agriculture,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}