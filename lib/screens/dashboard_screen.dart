import 'package:flutter/material.dart';
import 'home_view.dart'; // Menghubungkan ke file home_view.dart yang berisi feed berita

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // Index untuk melacak menu tab mana yang sedang aktif
  int _currentIndex = 0;

  // Daftar tampilan halaman yang akan berganti saat BottomNavigationBar diklik
  final List<Widget> _pages = [
    const HomeView(), // Sekarang halaman pertamanya menggunakan HomeView asli dari API
    const Center(child: Text("Halaman Favorite akan di sini")),
    const Center(child: Text("Halaman Notification akan di sini")),
    const Center(child: Text("Halaman Profile akan di sini")),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SpaceNews Core'),
        automaticallyImplyLeading: false, // Menghilangkan tombol back default agar tidak bisa kembali ke login
      ),
      body: _pages[_currentIndex], // Menampilkan halaman sesuai index yang dipilih
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index; // Mengubah halaman aktif saat tab diklik
          });
        },
        type: BottomNavigationBarType.fixed, // Memastikan semua teks dan ikon muncul
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorite',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notification',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}