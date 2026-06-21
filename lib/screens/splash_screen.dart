import 'package:flutter/material.dart';
import 'dart:async'; // Dibutuhkan untuk Future.delayed
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Membuat delay tepat 3 detik sesuai spesifikasi
    Future.delayed(const Duration(seconds: 3), () {
      // Navigasi ke halaman Login dan hapus Splash Screen dari tumpukan (stack)
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Nanti icon ini diganti dengan Logo E-Commerce dari Freepik
            const Icon(
              Icons.language, // Ikon sementara
              size: 100,
              color: Colors.blue,
            ),
            const SizedBox(height: 20),
            const Text(
              'SpaceNews Core',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 40),
            // Menampilkan loading indikator di tengah layar
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}