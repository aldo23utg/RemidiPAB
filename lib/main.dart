import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Package utama Firebase
import 'firebase_options.dart'; // File konfigurasi yang baru saja dibuat oleh CLI
import 'screens/splash_screen.dart';

void main() async {
  // Wajib ditambahkan agar inisialisasi asynchronous berjalan lancar sebelum runApp
  WidgetsFlutterBinding.ensureInitialized();
  
  // Menginisialisasi Firebase berdasarkan platform yang sedang berjalan (Web/Android)
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SpaceNews App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false, // Menghilangkan banner debug
      home: const SplashScreen(), // Halaman pertama tetap Splash Screen
    );
  }
}