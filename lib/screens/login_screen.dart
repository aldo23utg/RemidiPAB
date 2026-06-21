import 'package:flutter/material.dart';
import 'register_screen.dart'; // Nanti kita buat navigasi ke sini

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: const Center(child: Text("Ini Halaman Login")),
    );
  }
}