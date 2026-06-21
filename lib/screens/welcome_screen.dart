import 'package:flutter/material.dart';
import 'dashboard_screen.dart'; // Menambahkan import Dashboard

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Gambar ilustrasi jurnalisme
                Image.asset(
                  'assets/images/illustration.jpg',
                  height: 250,
                  errorBuilder: (context, error, stackTrace) => const Icon(Icons.image, size: 100),
                ),
                const SizedBox(height: 40),
                const Text(
                  'Welcome to Space News Core Application',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () {
                    // Navigasi yang sebenarnya ke halaman Dashboard
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const DashboardScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  ),
                  child: const Text('Lanjut ke Dashboard', style: TextStyle(fontSize: 18)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}