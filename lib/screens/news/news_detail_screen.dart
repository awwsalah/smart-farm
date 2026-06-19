import 'package:app/config/app_strings.dart';
import 'package:app/data/repositories/news_repository.dart';
import 'package:app/models/news_item.dart';
import 'package:app/widgets/news_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewsDetailScreen extends StatefulWidget {
  const NewsDetailScreen({
    super.key,
    required this.newsId,
  });

  final int newsId;

  @override
  State<NewsDetailScreen> createState() => _NewsDetailScreenState();
}

class _NewsDetailScreenState extends State<NewsDetailScreen> {
  final NewsRepository _repository = NewsRepository();
  late Future<NewsItem?> _newsFuture;

  @override
  void initState() {
    super.initState();
    _newsFuture = _repository.getById(widget.newsId);
  }

  String? _formatDate(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    try {
      return DateFormat('d MMMM y').format(DateTime.parse(raw));
    } catch (_) {
      return raw;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.newsDetail),
      ),
      body: FutureBuilder<NewsItem?>(
        future: _newsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final item = snapshot.data;
          if (item == null) {
            return const Center(child: Text(AppStrings.error));
          }

          final formattedDate = _formatDate(item.publishedAt);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: SizedBox(
                    height: 220,
                    child: NewsImage(
                      item: item,
                      heroTag: 'news-image-${item.id}',
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  item.title,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 10),
                if (item.source != null && item.source!.isNotEmpty)
                  Text(
                    '${AppStrings.newsSource}: ${item.source}',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                if (formattedDate != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    formattedDate,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color:
                              Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                ],
                const SizedBox(height: 16),
                Text(
                  item.summary ?? '',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        height: 1.6,
                      ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}