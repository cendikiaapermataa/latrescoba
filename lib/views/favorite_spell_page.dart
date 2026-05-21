import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/spell_controller.dart';

class FavoriteSpellPage extends GetView<SpellController> {
  const FavoriteSpellPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Favorite Spell',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.pink[300],
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Obx(() {
        if (controller.favSpells.isEmpty) {
          return Center(
            child: Text(
              'Belum ada sihir favorit yang ditambahkan.',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
          );
        }

        return ListView.builder(
          itemCount: controller.favSpells.length,
          itemBuilder: (context, index) {
            final spell = controller.favSpells[index];

            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                title: Text(
                  spell.spellName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(spell.use),
                // Tombol tong sampah Sesuai Poin 4 PDF
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    // Ini akan memicu hapus dari Hive + Immediate Notification
                    controller.toggleFavorite(spell);
                  },
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
