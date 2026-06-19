class NewsItem {
  const NewsItem({
    required this.id,
    required this.title,
    this.summary,
    this.source,
    this.imageAsset,
    this.publishedAt,
  });

  final int id;
  final String title;
  final String? summary;
  final String? source;
  final String? imageAsset;
  final String? publishedAt;

  factory NewsItem.fromJson(Map<String, dynamic> json) {
    return NewsItem(
      id: json['id'] as int,
      title: json['title'] as String,
      summary: json['summary'] as String?,
      source: json['source'] as String?,
      imageAsset: json['image_asset'] as String?,
      publishedAt: json['published_at'] as String?,
    );
  }

  factory NewsItem.fromMap(Map<String, dynamic> map) {
    return NewsItem(
      id: map['id'] as int,
      title: map['title'] as String,
      summary: map['summary'] as String?,
      source: map['source'] as String?,
      imageAsset: map['image_asset'] as String?,
      publishedAt: map['published_at'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'summary': summary,
      'source': source,
      'image_asset': imageAsset,
      'published_at': publishedAt,
    };
  }
}