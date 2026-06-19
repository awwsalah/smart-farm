import 'package:app/config/app_strings.dart';

class ArticleCategoryFilter {
  const ArticleCategoryFilter({
    required this.label,
    this.key,
  });

  final String label;
  final String? key;
}

abstract final class ArticleCategories {
  static const filters = <ArticleCategoryFilter>[
    ArticleCategoryFilter(label: AppStrings.allCategories),
    ArticleCategoryFilter(key: 'dalag', label: AppStrings.categoryDalag),
    ArticleCategoryFilter(key: 'cayayaan', label: AppStrings.categoryCayayaan),
    ArticleCategoryFilter(
      key: 'waraabin',
      label: AppStrings.categoryWaraabinArticles,
    ),
    ArticleCategoryFilter(
      key: 'bacrimin',
      label: AppStrings.categoryBacriminArticles,
    ),
    ArticleCategoryFilter(key: 'xilliyo', label: AppStrings.categoryXilliyo),
  ];
}