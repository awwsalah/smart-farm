import 'package:app/config/app_strings.dart';
import 'package:app/config/app_theme.dart';
import 'package:app/models/news_item.dart';
import 'package:app/widgets/optimized_asset_image.dart';
import 'package:app/widgets/pressable_scale.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewsCard extends StatelessWidget {
  const NewsCard({
    super.key,
    required this.item,
    required this.onTap,
    this.heroTag,
  });

  final NewsItem item;
  final VoidCallback onTap;
  final String? heroTag;

  String? get _formattedDate {
    final raw = item.publishedAt;
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
              height: 180,
              child: NewsImage(
                item: item,
                heroTag: heroTag,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDark,
                      fontSize: 16,
                    ),
                  ),
                  if (item.summary != null && item.summary!.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      item.summary!,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 14,
                      ),
                    ),
                  ],
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      if (item.source != null && item.source!.isNotEmpty) ...[
                        Expanded(
                          child: Text(
                            '${AppStrings.newsSource}: ${item.source}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ] else
                        const Spacer(),
                      if (_formattedDate != null)
                        Text(
                          _formattedDate!,
                          style: const TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 13,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 6),
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

class NewsImage extends StatelessWidget {
  const NewsImage({
    super.key,
    required this.item,
    this.heroTag,
  });

  final NewsItem item;
  final String? heroTag;

  @override
  Widget build(BuildContext context) {
    final image = item.imageAsset;

    Widget child;
    if (image == null || image.isEmpty) {
      child = _placeholder(context);
    } else {
      child = OptimizedAssetImage(
        assetPath: image,
        fit: BoxFit.cover,
        width: double.infinity,
        height: 180,
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
          Icons.newspaper_outlined,
          size: 48,
          color: AppColors.primary.withValues(alpha: 0.7),
        ),
      ),
    );
  }
}