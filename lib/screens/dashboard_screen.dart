import 'package:flutter/material.dart';
import 'home_view.dart';
import 'favorite_view.dart';
import 'notification_view.dart';
import 'profile_view.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomeView(),
    const FavoriteView(),
    const NotificationView(),
    const ProfileView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Menambahkan Logo di Header berdampingan dengan Teks
        title: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                'assets/images/logo.jpg',
                height: 32,
                width: 32,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Icon(Icons.language),
              ),
            ),
            const SizedBox(width: 12),
            const Text('SpaceNews Core', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        automaticallyImplyLeading: false, 
        elevation: 2,
        shadowColor: Colors.black26,
      ),
      body: AnimatedSwitcher(
        // Menambahkan animasi fade halus saat berpindah tab
        duration: const Duration(milliseconds: 300),
        child: _pages[_currentIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index; 
          });
        },
        type: BottomNavigationBarType.fixed, 
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey.shade400,
        showUnselectedLabels: true,
        elevation: 10,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite_rounded), label: 'Favorite'),
          BottomNavigationBarItem(icon: Icon(Icons.notifications_rounded), label: 'Notification'),
          BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: 'Profile'),
        ],
      ),
    );
  }
}