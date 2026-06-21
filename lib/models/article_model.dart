class Article {
  final int id;
  final String title;
  final String imageUrl;
  final String newsSite;
  final String summary;
  final String publishedAt;

  Article({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.newsSite,
    required this.summary,
    required this.publishedAt,
  });

  // Fungsi ini bertugas mengubah data JSON mentah dari internet menjadi objek Dart yang rapi
  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['id'] ?? 0,
      title: json['title'] ?? 'No Title',
      // API SpaceNews menggunakan key 'image_url' untuk gambar
      imageUrl: json['image_url'] ?? '',
      newsSite: json['news_site'] ?? 'Unknown Publisher',
      summary: json['summary'] ?? 'No summary available.',
      publishedAt: json['published_at'] ?? '',
    );
  }
}