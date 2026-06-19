import 'package:app/config/app_strings.dart';
import 'package:app/config/app_theme.dart';
import 'package:app/config/article_categories.dart';
import 'package:app/data/repositories/article_repository.dart';
import 'package:app/models/article.dart';
import 'package:app/screens/resources/article_detail_screen.dart';
import 'package:app/widgets/article_card.dart';
import 'package:app/widgets/empty_state.dart';
import 'package:app/widgets/staggered_entrance.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ResourcesScreen extends StatefulWidget {
  const ResourcesScreen({super.key});

  @override
  State<ResourcesScreen> createState() => _ResourcesScreenState();
}

class _ResourcesScreenState extends State<ResourcesScreen> {
  final ArticleRepository _repository = ArticleRepository();

  String? _selectedCategoryKey;
  late Future<List<Article>> _articlesFuture;

  @override
  void initState() {
    super.initState();
    _articlesFuture = _loadArticles();
  }

  Future<List<Article>> _loadArticles() {
    if (_selectedCategoryKey == null) {
      return _repository.getAll();
    }
    return _repository.getByCategory(_selectedCategoryKey!);
  }

  void _onCategorySelected(String? categoryKey) {
    setState(() {
      _selectedCategoryKey = categoryKey;
      _articlesFuture = _loadArticles();
    });
  }

  void _openArticleDetail(Article article) {
    final disableAnimations = MediaQuery.disableAnimationsOf(context);
    Navigator.of(context).push(
      PageRouteBuilder<void>(
        pageBuilder: (_, __, ___) =>
            ArticleDetailScreen(articleId: article.id),
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
      appBar: AppTheme.gradientAppBar(title: AppStrings.navResources),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 48,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              itemCount: ArticleCategories.filters.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final filter = ArticleCategories.filters[index];
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
            child: FutureBuilder<List<Article>>(
              future: _articlesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const _LoadingList();
                }

                if (snapshot.hasError) {
                  return const Center(child: Text(AppStrings.error));
                }

                final articles = snapshot.data ?? [];
                if (articles.isEmpty) {
                  return const EmptyState(
                    icon: Icons.menu_book_outlined,
                    message: AppStrings.emptyArticles,
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(12),
                  itemCount: articles.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final article = articles[index];
                    return StaggeredEntrance(
                      index: index,
                      child: ArticleCard(
                        article: article,
                        heroTag: 'article-image-${article.id}',
                        onTap: () => _openArticleDetail(article),
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

class _LoadingList extends StatelessWidget {
  const _LoadingList();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: 4,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: AppColors.sand,
          highlightColor: AppColors.surface,
          child: Container(
            height: 220,
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