import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'register_screen.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  // Fungsi untuk Log Out
  Future<void> _logout(BuildContext context) async {
    // 1. Sign out dari Firebase
    await FirebaseAuth.instance.signOut();

    // 2. Menghapus status session login di SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    // 3. Membersihkan seluruh tumpukan halaman dan kembali ke Halaman Daftar
    if (context.mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const RegisterScreen()),
        (route) => false, // false berarti semua history route sebelumnya dihapus
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Mendapatkan User ID (UID) yang sedang login saat ini
    final User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return const Center(child: Text("Tidak ada user yang aktif."));
    }

    return Scaffold(
      body: FutureBuilder<DocumentSnapshot>(
        // Mengambil data spesifik user dari Firestore koleksi "users"
        future: FirebaseFirestore.instance.collection('users').doc(currentUser.uid).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text("Gagal memuat profil."));
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text("Data profil tidak ditemukan di database."));
          }

          // Parsing data Firestore
          final userData = snapshot.data!.data() as Map<String, dynamic>;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                // Foto Profil Dummy (Icon)
                const CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.blueAccent,
                  child: Icon(Icons.person, size: 60, color: Colors.white),
                ),
                const SizedBox(height: 24),
                
                // Menampilkan Nama Lengkap
                ListTile(
                  leading: const Icon(Icons.badge, color: Colors.blue),
                  title: const Text('Nama Lengkap', style: TextStyle(fontSize: 14, color: Colors.grey)),
                  subtitle: Text(userData['name'] ?? '-', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
                ),
                const Divider(),
                
                // Menampilkan Email
                ListTile(
                  leading: const Icon(Icons.email, color: Colors.blue),
                  title: const Text('Email', style: TextStyle(fontSize: 14, color: Colors.grey)),
                  subtitle: Text(userData['email'] ?? '-', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
                ),
                const Divider(),
                
                // Menampilkan Akun Instagram
                ListTile(
                  leading: const Icon(Icons.camera_alt, color: Colors.blue),
                  title: const Text('Instagram', style: TextStyle(fontSize: 14, color: Colors.grey)),
                  subtitle: Text(userData['instagram'] ?? '-', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
                ),
                const SizedBox(height: 40),
                
                // Tombol Log Out
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _logout(context),
                    icon: const Icon(Icons.logout, color: Colors.white),
                    label: const Text('Log Out', style: TextStyle(color: Colors.white, fontSize: 16)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}