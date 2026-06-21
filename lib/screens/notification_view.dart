import 'package:flutter/material.dart';

class NotificationView extends StatelessWidget {
  const NotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    // Daftar dummy notifikasi
    final List<Map<String, String>> notifications = [
      {"title": "Selamat datang di SpaceNews!", "time": "Baru saja", "body": "Terima kasih telah mendaftar di aplikasi portal berita luar angkasa kami."},
      {"title": "Berita Baru: Peluncuran Roket", "time": "2 jam yang lalu", "body": "SpaceX baru saja meluncurkan satelit terbaru mereka. Cek beritanya sekarang!"},
      {"title": "Pembaruan Aplikasi", "time": "1 hari yang lalu", "body": "Versi terbaru SpaceNews Core sudah tersedia."},
    ];

    return Scaffold(
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: const CircleAvatar(
              backgroundColor: Colors.blueAccent,
              child: Icon(Icons.notifications, color: Colors.white),
            ),
            title: Text(notifications[index]['title']!, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(notifications[index]['body']!),
                const SizedBox(height: 4),
                Text(notifications[index]['time']!, style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
            isThreeLine: true,
          );
        },
      ),
    );
  }
}