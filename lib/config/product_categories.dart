import 'package:app/config/app_strings.dart';

class ProductCategoryFilter {
  const ProductCategoryFilter({
    required this.label,
    this.key,
  });

  final String label;
  final String? key;
}

abstract final class ProductCategories {
  static const filters = <ProductCategoryFilter>[
    ProductCategoryFilter(label: AppStrings.allCategories),
    ProductCategoryFilter(key: 'iniino', label: AppStrings.categoryIniino),
    ProductCategoryFilter(key: 'qalab', label: AppStrings.categoryQalab),
    ProductCategoryFilter(key: 'bacrimin', label: AppStrings.categoryBacrimin),
    ProductCategoryFilter(key: 'sun', label: AppStrings.categorySun),
    ProductCategoryFilter(key: 'waraabin', label: AppStrings.categoryWaraabin),
  ];
}