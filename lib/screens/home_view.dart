import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/article_model.dart';
import 'detail_screen.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List<Article> articles = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchArticles();
  }

  Future<void> fetchArticles() async {
    const String apiUrl = 'https://api.spaceflightnewsapi.net/v4/articles/?limit=20';
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> results = data['results'];
        if (mounted) {
          setState(() {
            articles = results.map((json) => Article.fromJson(json)).toList();
            isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) return const Center(child: CircularProgressIndicator());
    if (articles.isEmpty) return const Center(child: Text("Tidak ada berita saat ini."));

    final headlineArticle = articles[0];
    final feedArticles = articles.sublist(1);

    return RefreshIndicator(
      onRefresh: fetchArticles,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(padding: EdgeInsets.all(16.0), child: Text('Headline News', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
            GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => DetailScreen(article: headlineArticle)));
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16.0),
                height: 200,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 4))]),
                child: Stack(
                  children: [
                    // Menggunakan Hero Animation
                    Hero(
                      tag: 'articleImage_${headlineArticle.id}',
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.network(headlineArticle.imageUrl, width: double.infinity, height: double.infinity, fit: BoxFit.cover),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: LinearGradient(colors: [Colors.black.withOpacity(0.8), Colors.transparent], begin: Alignment.bottomCenter, end: Alignment.topCenter),
                      ),
                    ),
                    Positioned(
                      bottom: 16, left: 16, right: 16,
                      child: Text(headlineArticle.title, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold), maxLines: 2, overflow: TextOverflow.ellipsis),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Padding(padding: EdgeInsets.symmetric(horizontal: 16.0), child: Text('Latest News', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: feedArticles.length,
              itemBuilder: (context, index) {
                final article = feedArticles[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    leading: Hero(
                      tag: 'articleImage_${article.id}', // Pasangan Hero animation
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(article.imageUrl, width: 80, height: 80, fit: BoxFit.cover, errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image, size: 80)),
                      ),
                    ),
                    title: Text(article.title, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(article.newsSite, style: const TextStyle(color: Colors.blueAccent)),
                    ),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => DetailScreen(article: article)));
                    },
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}