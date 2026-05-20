import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/character.dart';

class CharacterDetailPage extends StatelessWidget {
  const CharacterDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Character char = Get.arguments;

    return Scaffold(
      backgroundColor: const Color(0xFFFFF0F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.pink.shade800),
        title: Text(char.fullName, style: TextStyle(color: Colors.pink.shade800, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 250,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
                boxShadow: [BoxShadow(color: Colors.pink.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))]
              ),
              child: char.image.isNotEmpty
                  ? Image.network(char.image, fit: BoxFit.contain)
                  : const Icon(Icons.person, size: 100, color: Colors.grey),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _buildDetailTile('Nama Lengkap', char.fullName),
                  _buildDetailTile('Panggilan', char.nickname),
                  _buildDetailTile('Asrama (House)', char.hogwartsHouse),
                  _buildDetailTile('Tanggal Lahir', char.birthdate),
                  _buildDetailTile('Pemeran', char.interpretedBy),
                  _buildDetailTile('Anak', char.children.isEmpty ? '-' : char.children.join(', ')),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildDetailTile(String title, String value) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(color: Colors.pink.shade300, fontSize: 12, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 16, color: Colors.black87, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}