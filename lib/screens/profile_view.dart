import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'register_screen.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final User? currentUser = FirebaseAuth.instance.currentUser;

  // Fungsi memunculkan form edit profil dari bawah (Bottom Sheet)
  void _showEditProfileDialog(BuildContext context, Map<String, dynamic> currentData) {
    final TextEditingController nameController = TextEditingController(text: currentData['name']);
    final TextEditingController instagramController = TextEditingController(text: currentData['instagram']);
    final TextEditingController phoneController = TextEditingController(text: currentData['phone'] ?? '');
    final TextEditingController addressController = TextEditingController(text: currentData['address'] ?? '');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Agar bisa scroll saat keyboard muncul
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom, // Menyesuaikan tinggi keyboard
            left: 24, right: 24, top: 24,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text('Edit Profil', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                const SizedBox(height: 20),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'Nama Lengkap', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), prefixIcon: const Icon(Icons.person)),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: instagramController,
                  decoration: InputDecoration(labelText: 'Instagram', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), prefixIcon: const Icon(Icons.camera_alt)),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(labelText: 'Nomor Telepon', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), prefixIcon: const Icon(Icons.phone)),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: addressController,
                  maxLines: 2,
                  decoration: InputDecoration(labelText: 'Alamat Lengkap', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), prefixIcon: const Icon(Icons.location_on)),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () async {
                    Navigator.pop(context); // Tutup modal dulu
                    try {
                      // Update data di Firestore
                      await FirebaseFirestore.instance.collection('users').doc(currentUser!.uid).update({
                        'name': nameController.text.trim(),
                        'instagram': instagramController.text.trim(),
                        'phone': phoneController.text.trim(),
                        'address': addressController.text.trim(),
                      });
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profil berhasil diperbarui!'), backgroundColor: Colors.green));
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal: $e'), backgroundColor: Colors.red));
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                  child: const Text('Simpan Perubahan', style: TextStyle(fontSize: 16)),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _logout(BuildContext context) async {
    bool? confirmLogout = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Konfirmasi Logout'),
          content: const Text('Apakah Anda yakin ingin keluar?'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(dialogContext, false), child: const Text('Batal', style: TextStyle(color: Colors.grey))),
            ElevatedButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
              child: const Text('Ya, Keluar', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );

    if (confirmLogout != true) return;

    try {
      await FirebaseAuth.instance.signOut();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Logout berhasil.'), backgroundColor: Colors.green));
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const RegisterScreen()), (route) => false);
      }
    } catch (e) {
      if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal logout: $e'), backgroundColor: Colors.red));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (currentUser == null) return const Center(child: Text("Tidak ada user aktif."));

    return Scaffold(
      body: StreamBuilder<DocumentSnapshot>(
        // Menggunakan StreamBuilder agar perubahan data (seperti setelah diedit) langsung tampil tanpa perlu reload
        stream: FirebaseFirestore.instance.collection('users').doc(currentUser!.uid).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          if (snapshot.hasError || !snapshot.hasData || !snapshot.data!.exists) return const Center(child: Text("Data profil tidak ditemukan."));

          final userData = snapshot.data!.data() as Map<String, dynamic>;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                const SizedBox(height: 20),
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    const CircleAvatar(radius: 60, backgroundColor: Colors.blueAccent, child: Icon(Icons.person, size: 60, color: Colors.white)),
                    FloatingActionButton.small(
                      onPressed: () => _showEditProfileDialog(context, userData),
                      child: const Icon(Icons.edit),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Card(
                  elevation: 4,
                  shadowColor: Colors.blue.withOpacity(0.2),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Column(
                      children: [
                        ListTile(leading: const Icon(Icons.badge, color: Colors.blue), title: const Text('Nama Lengkap', style: TextStyle(fontSize: 12, color: Colors.grey)), subtitle: Text(userData['name'] ?? '-', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
                        const Divider(height: 1),
                        ListTile(leading: const Icon(Icons.email, color: Colors.blue), title: const Text('Email', style: TextStyle(fontSize: 12, color: Colors.grey)), subtitle: Text(userData['email'] ?? '-', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
                        const Divider(height: 1),
                        ListTile(leading: const Icon(Icons.camera_alt, color: Colors.blue), title: const Text('Instagram', style: TextStyle(fontSize: 12, color: Colors.grey)), subtitle: Text(userData['instagram'] ?? '-', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
                        const Divider(height: 1),
                        ListTile(leading: const Icon(Icons.phone, color: Colors.blue), title: const Text('Nomor Telepon', style: TextStyle(fontSize: 12, color: Colors.grey)), subtitle: Text(userData['phone'] ?? 'Belum diatur', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
                        const Divider(height: 1),
                        ListTile(leading: const Icon(Icons.location_on, color: Colors.blue), title: const Text('Alamat', style: TextStyle(fontSize: 12, color: Colors.grey)), subtitle: Text(userData['address'] ?? 'Belum diatur', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _logout(context),
                    icon: const Icon(Icons.logout, color: Colors.white),
                    label: const Text('Log Out', style: TextStyle(color: Colors.white, fontSize: 16)),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
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