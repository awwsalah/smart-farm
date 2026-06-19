class Tip {
  const Tip({
    required this.id,
    required this.text,
    this.category,
  });

  final int id;
  final String text;
  final String? category;

  factory Tip.fromJson(Map<String, dynamic> json) {
    return Tip(
      id: json['id'] as int,
      text: json['text'] as String,
      category: json['category'] as String?,
    );
  }

  factory Tip.fromMap(Map<String, dynamic> map) {
    return Tip(
      id: map['id'] as int,
      text: map['text'] as String,
      category: map['category'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'category': category,
    };
  }
}