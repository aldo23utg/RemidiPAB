import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/article_model.dart';

class DetailScreen extends StatefulWidget {
  final Article article;

  // Meminta data artikel saat halaman ini dipanggil
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

  // Mengecek apakah artikel ini sudah ada di koleksi "favorites" Firestore
  Future<void> _checkIfFavorite() async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('favorites')
          .doc(widget.article.id.toString())
          .get();

      if (mounted) {
        setState(() {
          _isFavorite = doc.exists;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
      print("Error checking favorite: $e");
    }
  }

  // Fungsi untuk menambah atau menghapus dari Favorite
  Future<void> _toggleFavorite() async {
    final docRef = FirebaseFirestore.instance
        .collection('favorites')
        .doc(widget.article.id.toString());

    try {
      if (_isFavorite) {
        // Jika sudah favorit, hapus dari Firestore
        await docRef.delete();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Dihapus dari Favorite')),
        );
      } else {
        // Jika belum, simpan ID dan Judul ke Firestore (sesuai spesifikasi)
        await docRef.set({
          'article_id': widget.article.id,
          'title': widget.article.title,
          'image_url': widget.article.imageUrl, // Ditambahkan agar UI Favorite nanti lebih bagus
          'news_site': widget.article.newsSite,
          'saved_at': FieldValue.serverTimestamp(),
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Berhasil ditambahkan ke Favorite')),
        );
      }

      // Ubah status ikon hati
      setState(() {
        _isFavorite = !_isFavorite;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memperbarui Favorite: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Artikel'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context), // Tombol Back kembali ke Home
        ),
        actions: [
          _isLoading
              ? const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Center(child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))),
                )
              : IconButton(
                  icon: Icon(
                    _isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: _isFavorite ? Colors.red : null, // Berubah jadi merah jika favorit
                  ),
                  onPressed: _toggleFavorite,
                ),
        ],
      ),
      body: SingleChildScrollView( // Layout vertikal yang dapat digulir
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Foto berita ukuran besar
            Image.network(
              widget.article.imageUrl,
              width: double.infinity,
              height: 250,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => const SizedBox(
                height: 250,
                child: Center(child: Icon(Icons.broken_image, size: 100, color: Colors.grey)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Judul Lengkap
                  Text(
                    widget.article.title,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  // Media Penerbit
                  Row(
                    children: [
                      const Icon(Icons.business, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        widget.article.newsSite,
                        style: const TextStyle(fontSize: 14, color: Colors.blueAccent, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  const Divider(height: 30, thickness: 1),
                  // Teks Ringkasan (Summary)
                  const Text(
                    'Ringkasan Berita:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.article.summary,
                    style: const TextStyle(fontSize: 16, height: 1.5),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}