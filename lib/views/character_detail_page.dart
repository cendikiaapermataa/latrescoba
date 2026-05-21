import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/character.dart';

class CharacterDetailPage extends StatelessWidget {
  const CharacterDetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Menerima data dari list yang di-klik
    final Character char = Get.arguments;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Detail Character',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.pink[300],
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Area Gambar Karakter
            Container(
              height: 200,
              width: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: char.image.isNotEmpty
                    ? Image.network(char.image, fit: BoxFit.cover)
                    : Container(
                        color: Colors.grey[200],
                        child: const Icon(
                          Icons.person,
                          size: 80,
                          color: Colors.grey,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 24),

            // Text Nama Utama
            Text(
              char.fullName,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // Kotak-kotak properti (Sesuai Poin 2 PDF)
            _buildInfoCard('Panggilan', char.nickname),
            _buildInfoCard('Hogwarts House', char.hogwartsHouse),
            _buildInfoCard('Tanggal Lahir', char.birthdate),
            _buildInfoCard('Pemeran', char.interpretedBy),
            _buildInfoCard(
              'Anak',
              char.children.isEmpty ? '-' : char.children.join(', '),
            ),
          ],
        ),
      ),
    );
  }

  // Fungsi pembantu agar kodingan kotak tidak diulang-ulang
  Widget _buildInfoCard(String title, String value) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 120,
              child: Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.pink[800],
                ),
              ),
            ),
            const Text(':  '),
            Expanded(child: Text(value, style: const TextStyle(fontSize: 16))),
          ],
        ),
      ),
    );
  }
}
