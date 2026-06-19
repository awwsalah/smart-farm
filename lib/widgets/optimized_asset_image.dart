import 'package:flutter/material.dart';

/// Decodes bundled images at display size to reduce memory on low-end devices.
class OptimizedAssetImage extends StatelessWidget {
  const OptimizedAssetImage({
    super.key,
    required this.assetPath,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
  });

  final String assetPath;
  final BoxFit fit;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final dpr = MediaQuery.devicePixelRatioOf(context);

    int? cacheWidth;
    int? cacheHeight;

    if (width != null) {
      cacheWidth = (width! * dpr).round();
    }
    if (height != null) {
      cacheHeight = (height! * dpr).round();
    }

    return Image.asset(
      assetPath,
      fit: fit,
      width: width,
      height: height,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
      errorBuilder: (_, __, ___) => const SizedBox.shrink(),
    );
  }
}