class Article {
  final String title;
  final String abstract;

  Article({
    required this.title,
    required this.abstract,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      title: json['title'] ?? '',
      abstract: json['abstract'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'abstract': abstract,
    };
  }
}
