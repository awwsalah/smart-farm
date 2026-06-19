import 'package:app/config/app_strings.dart';
import 'package:app/data/repositories/news_repository.dart';
import 'package:app/models/news_item.dart';
import 'package:app/screens/news/news_detail_screen.dart';
import 'package:app/widgets/empty_state.dart';
import 'package:app/widgets/news_card.dart';
import 'package:app/widgets/staggered_entrance.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  final NewsRepository _repository = NewsRepository();
  late Future<List<NewsItem>> _newsFuture;

  @override
  void initState() {
    super.initState();
    _newsFuture = _repository.fetchNews();
  }

  Future<void> _refresh() async {
    setState(() {
      _newsFuture = _repository.fetchNews();
    });
    await _newsFuture;
  }

  void _openNewsDetail(NewsItem item) {
    final disableAnimations = MediaQuery.disableAnimationsOf(context);
    Navigator.of(context).push(
      PageRouteBuilder<void>(
        pageBuilder: (_, __, ___) => NewsDetailScreen(newsId: item.id),
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
      appBar: AppBar(
        title: const Text(AppStrings.navNews),
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: FutureBuilder<List<NewsItem>>(
          future: _newsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _LoadingList();
            }

            if (snapshot.hasError) {
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: const [
                  SizedBox(height: 120),
                  Center(child: Text(AppStrings.error)),
                ],
              );
            }

            final items = snapshot.data ?? [];
            if (items.isEmpty) {
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: const [
                  SizedBox(height: 80),
                  EmptyState(
                    icon: Icons.newspaper_outlined,
                    message: AppStrings.emptyNews,
                  ),
                ],
              );
            }

            return ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(12),
              itemCount: items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final item = items[index];
                return StaggeredEntrance(
                  index: index,
                  child: NewsCard(
                    item: item,
                    heroTag: 'news-image-${item.id}',
                    onTap: () => _openNewsDetail(item),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _LoadingList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: 4,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Theme.of(context).colorScheme.surfaceContainerHighest,
          highlightColor: Theme.of(context).colorScheme.surface,
          child: Card(
            child: SizedBox(
              height: 260,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(child: Container(color: Colors.white)),
                  Container(
                    height: 14,
                    margin: const EdgeInsets.all(14),
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}