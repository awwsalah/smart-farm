import 'package:app/config/app_strings.dart';
import 'package:app/data/repositories/article_repository.dart';
import 'package:app/models/article.dart';
import 'package:app/widgets/article_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ArticleDetailScreen extends StatefulWidget {
  const ArticleDetailScreen({
    super.key,
    required this.articleId,
  });

  final int articleId;

  @override
  State<ArticleDetailScreen> createState() => _ArticleDetailScreenState();
}

class _ArticleDetailScreenState extends State<ArticleDetailScreen> {
  final ArticleRepository _repository = ArticleRepository();
  late Future<Article?> _articleFuture;

  @override
  void initState() {
    super.initState();
    _articleFuture = _repository.getById(widget.articleId);
  }

  String? _formatDate(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    try {
      return DateFormat('d MMMM y', 'so').format(DateTime.parse(raw));
    } catch (_) {
      return raw;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.articleDetail),
      ),
      body: FutureBuilder<Article?>(
        future: _articleFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final article = snapshot.data;
          if (article == null) {
            return const Center(child: Text(AppStrings.error));
          }

          final formattedDate = _formatDate(article.createdAt);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: SizedBox(
                    height: 220,
                    child: ArticleImage(
                      article: article,
                      heroTag: 'article-image-${article.id}',
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  article.title,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                if (formattedDate != null) ...[
                  const SizedBox(height: 8),
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
                  article.body,
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