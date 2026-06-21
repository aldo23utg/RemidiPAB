import 'package:flutter/material.dart';
import 'login_screen.dart'; // Pastikan file login_screen.dart yang kita buat sebelumnya ada di folder yang sama

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // Controller untuk menangkap teks yang diketik pengguna
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),
              // Menampilkan Logo dari folder assets
              Image.asset(
                'assets/images/logo.jpg',
                height: 120,
              ),
              const SizedBox(height: 40),
              const Text(
                'Buat Akun Baru',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              // Input Nama Lengkap
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nama',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 16),
              // Input Email
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              // Input Password
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true, // Menyembunyikan teks password
              ),
              const SizedBox(height: 24),
              // Tombol Daftar
              ElevatedButton(
                onPressed: () {
                  // TODO: Nanti kita hubungkan ke Firebase Auth di sini
                  print("Tombol Daftar ditekan!");
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Daftar', style: TextStyle(fontSize: 18)),
              ),
              const SizedBox(height: 16),
              // Tombol Navigasi ke Login
              TextButton(
                onPressed: () {
                  // Membuka halaman login dan menutup halaman daftar
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                  );
                },
                child: const Text('Apakah sudah punya akun? Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}