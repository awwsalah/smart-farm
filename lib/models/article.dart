class Article {
  const Article({
    required this.id,
    required this.title,
    required this.category,
    required this.body,
    this.imageAsset,
    this.createdAt,
  });

  final int id;
  final String title;
  final String category;
  final String body;
  final String? imageAsset;
  final String? createdAt;

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['id'] as int,
      title: json['title'] as String,
      category: json['category'] as String,
      body: json['body'] as String,
      imageAsset: json['image_asset'] as String?,
      createdAt: json['created_at'] as String?,
    );
  }

  factory Article.fromMap(Map<String, dynamic> map) {
    return Article(
      id: map['id'] as int,
      title: map['title'] as String,
      category: map['category'] as String,
      body: map['body'] as String,
      imageAsset: map['image_asset'] as String?,
      createdAt: map['created_at'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'body': body,
      'image_asset': imageAsset,
      'created_at': createdAt,
    };
  }
}