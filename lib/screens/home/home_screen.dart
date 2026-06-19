import 'package:app/config/app_strings.dart';
import 'package:app/config/app_theme.dart';
import 'package:app/data/repositories/article_repository.dart';
import 'package:app/data/repositories/product_repository.dart';
import 'package:app/data/repositories/tips_repository.dart';
import 'package:app/models/product.dart';
import 'package:app/models/tip.dart';
import 'package:app/providers/connectivity_provider.dart';
import 'package:app/providers/weather_provider.dart';
import 'package:app/screens/marketplace/product_detail_screen.dart';
import 'package:app/screens/resources/article_detail_screen.dart';
import 'package:app/screens/support/support_screen.dart';
import 'package:app/widgets/empty_state.dart';
import 'package:app/widgets/pressable_scale.dart';
import 'package:app/widgets/product_card.dart';
import 'package:app/widgets/staggered_entrance.dart';
import 'package:app/widgets/tip_card.dart';
import 'package:app/widgets/weather_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TipsRepository _tipsRepository = TipsRepository();
  final ProductRepository _productRepository = ProductRepository();
  final ArticleRepository _articleRepository = ArticleRepository();

  late Future<List<Tip>> _tipsFuture;
  late Future<List<Product>> _productsFuture;

  @override
  void initState() {
    super.initState();
    _reload();
  }

  void _reload() {
    _tipsFuture = _tipsRepository.getLatest(limit: 8);
    _productsFuture = _productRepository.getPopular(limit: 6);
  }

  Future<void> _refresh() async {
    setState(_reload);
    await Future.wait([
      _tipsFuture,
      _productsFuture,
      context.read<WeatherProvider>().refresh(),
      context.read<ConnectivityProvider>().check(),
    ]);
  }

  void _openSupport() {
    final disableAnimations = MediaQuery.disableAnimationsOf(context);
    Navigator.of(context).push(
      PageRouteBuilder<void>(
        pageBuilder: (_, __, ___) => const SupportScreen(),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: disableAnimations
            ? Duration.zero
            : const Duration(milliseconds: 280),
      ),
    );
  }

  Future<void> _onTipTap(Tip tip) async {
    final category = tip.category;
    if (category == null || category.isEmpty || category == 'guud') {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(tip.text)),
      );
      return;
    }

    final articles = await _articleRepository.getByCategory(category);
    if (!mounted) return;

    if (articles.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(AppStrings.tipNoArticle)),
      );
      return;
    }

    final disableAnimations = MediaQuery.disableAnimationsOf(context);
    Navigator.of(context).push(
      PageRouteBuilder<void>(
        pageBuilder: (_, __, ___) =>
            ArticleDetailScreen(articleId: articles.first.id),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: disableAnimations
            ? Duration.zero
            : const Duration(milliseconds: 280),
      ),
    );
  }

  void _openProduct(Product product) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppTheme.gradientAppBar(title: AppStrings.navHome),
      body: RefreshIndicator(
        onRefresh: _refresh,
        color: AppColors.primary,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          children: [
            const WeatherCard(),
            const SizedBox(height: 24),
            Text(
              AppStrings.latestTips,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                  ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 150,
              child: FutureBuilder<List<Tip>>(
                future: _tipsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return _HorizontalShimmer(cardWidth: 260, cardHeight: 150);
                  }
                  final tips = snapshot.data ?? [];
                  if (tips.isEmpty) {
                    return const EmptyState(
                      icon: Icons.lightbulb_outline,
                      message: AppStrings.emptyTips,
                    );
                  }
                  return ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: tips.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      final tip = tips[index];
                      return StaggeredEntrance(
                        index: index,
                        child: TipCard(
                          tip: tip,
                          onTap: () => _onTipTap(tip),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
            PressableScale(
              onTap: _openSupport,
              child: FilledButton.icon(
                onPressed: _openSupport,
                icon: const Icon(Icons.support_agent),
                label: const Text(AppStrings.quickSupport),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              AppStrings.popularProducts,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                  ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 230,
              child: FutureBuilder<List<Product>>(
                future: _productsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return _HorizontalShimmer(cardWidth: 160, cardHeight: 230);
                  }
                  final products = snapshot.data ?? [];
                  if (products.isEmpty) {
                    return const EmptyState(
                      icon: Icons.store_outlined,
                      message: AppStrings.emptyProducts,
                    );
                  }
                  return ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: products.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return StaggeredEntrance(
                        index: index,
                        child: SizedBox(
                          width: 160,
                          child: ProductCard(
                            product: product,
                            onTap: () => _openProduct(product),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _HorizontalShimmer extends StatelessWidget {
  const _HorizontalShimmer({
    required this.cardWidth,
    required this.cardHeight,
  });

  final double cardWidth;
  final double cardHeight;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: 3,
      separatorBuilder: (_, __) => const SizedBox(width: 12),
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: AppColors.sand,
          highlightColor: AppColors.surface,
          child: Container(
            width: cardWidth,
            height: cardHeight,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        );
      },
    );
  }
}