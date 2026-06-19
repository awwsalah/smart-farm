import 'package:app/config/app_strings.dart';
import 'package:app/config/app_theme.dart';
import 'package:app/models/article.dart';
import 'package:app/widgets/optimized_asset_image.dart';
import 'package:app/widgets/pressable_scale.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ArticleCard extends StatelessWidget {
  const ArticleCard({
    super.key,
    required this.article,
    required this.onTap,
    this.heroTag,
  });

  final Article article;
  final VoidCallback onTap;
  final String? heroTag;

  String? get _formattedDate {
    final raw = article.createdAt;
    if (raw == null || raw.isEmpty) return null;
    try {
      return DateFormat('d MMM y').format(DateTime.parse(raw));
    } catch (_) {
      return raw;
    }
  }

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
            SizedBox(
              height: 160,
              child: ArticleImage(
                article: article,
                heroTag: heroTag,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDark,
                      fontSize: 16,
                    ),
                  ),
                  if (_formattedDate != null) ...[
                    const SizedBox(height: 6),
                    Text(
                      _formattedDate!,
                      style: const TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 13,
                      ),
                    ),
                  ],
                  const SizedBox(height: 8),
                  const Text(
                    AppStrings.readMore,
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ArticleImage extends StatelessWidget {
  const ArticleImage({
    super.key,
    required this.article,
    this.heroTag,
  });

  final Article article;
  final String? heroTag;

  @override
  Widget build(BuildContext context) {
    final image = article.imageAsset;

    Widget child;
    if (image == null || image.isEmpty) {
      child = _placeholder(context);
    } else {
      child = OptimizedAssetImage(
        assetPath: image,
        fit: BoxFit.cover,
        width: double.infinity,
        height: 160,
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
          Icons.menu_book_outlined,
          size: 48,
          color: AppColors.primary.withValues(alpha: 0.7),
        ),
      ),
    );
  }
}