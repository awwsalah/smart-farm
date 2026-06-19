class Product {
  const Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.currency,
    this.description,
    this.imageAsset,
    this.inStock = true,
  });

  final int id;
  final String name;
  final String category;
  final double price;
  final String currency;
  final String? description;
  final String? imageAsset;
  final bool inStock;

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int,
      name: json['name'] as String,
      category: json['category'] as String,
      price: (json['price'] as num).toDouble(),
      currency: json['currency'] as String? ?? 'USD',
      description: json['description'] as String?,
      imageAsset: json['image_asset'] as String?,
      inStock: (json['in_stock'] as int? ?? 1) == 1,
    );
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] as int,
      name: map['name'] as String,
      category: map['category'] as String,
      price: (map['price'] as num).toDouble(),
      currency: map['currency'] as String? ?? 'USD',
      description: map['description'] as String?,
      imageAsset: map['image_asset'] as String?,
      inStock: (map['in_stock'] as int? ?? 1) == 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'price': price,
      'currency': currency,
      'description': description,
      'image_asset': imageAsset,
      'in_stock': inStock ? 1 : 0,
    };
  }
}