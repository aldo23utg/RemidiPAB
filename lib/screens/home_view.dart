import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/article_model.dart';
import 'detail_screen.dart'; // Menambahkan import Halaman Detail

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
      } else {
        throw Exception('Gagal memuat berita');
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
      print('Error fetching articles: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (articles.isEmpty) {
      return const Center(child: Text("Tidak ada berita saat ini."));
    }

    final headlineArticle = articles[0];
    final feedArticles = articles.sublist(1);

    return RefreshIndicator(
      onRefresh: fetchArticles,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: const Text('Headline News', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            GestureDetector(
              onTap: () {
                // Aksi Klik Headline menuju Detail Page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DetailScreen(article: headlineArticle)),
                );
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16.0),
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    image: NetworkImage(headlineArticle.imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
                alignment: Alignment.bottomLeft,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(12), bottomRight: Radius.circular(12)),
                    color: Colors.black.withOpacity(0.6),
                  ),
                  child: Text(
                    headlineArticle.title,
                    style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: const Text('Latest News', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: feedArticles.length,
              itemBuilder: (context, index) {
                final article = feedArticles[index];
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      article.imageUrl,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image, size: 80),
                    ),
                  ),
                  title: Text(article.title, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(article.newsSite),
                  onTap: () {
                    // Aksi Klik Feed menuju Detail Page
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DetailScreen(article: article)),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}