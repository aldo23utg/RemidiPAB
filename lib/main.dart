import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Tambahkan ini
import 'firebase_options.dart'; // Tambahkan ini
import 'screens/splash_screen.dart';

void main() async {
  // Tambahkan 2 baris ini wajib sebelum runApp
  WidgetsFlutterBinding.ensureInitialized();
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
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}