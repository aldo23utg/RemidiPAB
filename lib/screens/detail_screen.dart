import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/article_model.dart';

class DetailScreen extends StatefulWidget {
  final Article article;

  const DetailScreen({super.key, required this.article});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  bool _isFavorite = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkIfFavorite();
  }

  Future<void> _checkIfFavorite() async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance.collection('favorites').doc(widget.article.id.toString()).get();
      if (mounted) setState(() { _isFavorite = doc.exists; _isLoading = false; });
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _toggleFavorite() async {
    final docRef = FirebaseFirestore.instance.collection('favorites').doc(widget.article.id.toString());
    try {
      if (_isFavorite) {
        await docRef.delete();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Dihapus dari Favorite'), backgroundColor: Colors.grey));
      } else {
        await docRef.set({
          'article_id': widget.article.id,
          'title': widget.article.title,
          'image_url': widget.article.imageUrl,
          'news_site': widget.article.newsSite,
          'saved_at': FieldValue.serverTimestamp(),
        });
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Berhasil ditambahkan ke Favorite'), backgroundColor: Colors.green));
      }
      setState(() => _isFavorite = !_isFavorite);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal: $e'), backgroundColor: Colors.red));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Artikel', style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
        actions: [
          _isLoading
              ? const Padding(padding: EdgeInsets.symmetric(horizontal: 16.0), child: Center(child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))))
              : IconButton(
                  icon: Icon(_isFavorite ? Icons.favorite : Icons.favorite_border, color: _isFavorite ? Colors.red : Colors.grey, size: 28),
                  onPressed: _toggleFavorite,
                ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Pasangan Hero Animation di sini
            Hero(
              tag: 'articleImage_${widget.article.id}',
              child: Image.network(
                widget.article.imageUrl,
                width: double.infinity,
                height: 280,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const SizedBox(height: 250, child: Center(child: Icon(Icons.broken_image, size: 100, color: Colors.grey))),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.article.title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, height: 1.3)),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(color: Colors.blueAccent.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
                        child: Row(
                          children: [
                            const Icon(Icons.business, size: 16, color: Colors.blueAccent),
                            const SizedBox(width: 6),
                            Text(widget.article.newsSite, style: const TextStyle(fontSize: 14, color: Colors.blueAccent, fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 40, thickness: 1),
                  const Text('Ringkasan Berita:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Text(widget.article.summary, style: const TextStyle(fontSize: 16, height: 1.6, color: Colors.black87)),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}