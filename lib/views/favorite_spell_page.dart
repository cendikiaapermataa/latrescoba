import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/spell_controller.dart';

class FavoriteSpellPage extends GetView<SpellController> {
  const FavoriteSpellPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF0F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.pink.shade800),
        title: Text('Favorite Spells', style: TextStyle(color: Colors.pink.shade800, fontWeight: FontWeight.bold)),
      ),
      body: Obx(() {
        if (controller.favSpells.isEmpty) {
          return Center(child: Text('Belum ada sihir favorit', style: TextStyle(color: Colors.grey.shade600)));
        }
        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: controller.favSpells.length,
          itemBuilder: (context, index) {
            final spell = controller.favSpells[index];
            return Card(
              elevation: 0,
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: Colors.pink.shade50, shape: BoxShape.circle),
                  child: Icon(Icons.bookmark, color: Colors.pink.shade400),
                ),
                title: Text(spell.spellName, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(spell.use),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                  onPressed: () => controller.toggleFavorite(spell),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}