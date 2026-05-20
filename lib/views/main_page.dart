import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/main_controller.dart';
import '../controllers/auth_controller.dart';
import '../controllers/character_controller.dart';
import '../controllers/spell_controller.dart';

class MainPage extends GetView<MainController> {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authCtrl = Get.find<AuthController>();

    // Simpan view di dalam list
    final List<Widget> pages = [_CharacterView(), _SpellsView()];

    return Scaffold(
      backgroundColor: const Color(0xFFFFF0F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Obx(
          () => Text(
            controller.currentIndex.value == 0
                ? 'Characters'
                : 'Spells Gallery',
            style: TextStyle(
              color: Colors.pink.shade800,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.redAccent),
            onPressed: authCtrl.logout,
          ),
        ],
      ),
      // --- REVISI DI SINI ---
      // Menggunakan IndexedStack agar tab tidak reload (anti glitch)
      body: Obx(
        () =>
            IndexedStack(index: controller.currentIndex.value, children: pages),
      ),
      // ----------------------
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          backgroundColor: Colors.white,
          selectedItemColor: Colors.pink.shade400,
          unselectedItemColor: Colors.grey.shade400,
          currentIndex: controller.currentIndex.value,
          onTap: controller.changeTab,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.people),
              label: 'Characters',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.auto_fix_high),
              label: 'Spells',
            ),
          ],
        ),
      ),
    );
  }
}

class _CharacterView extends GetView<CharacterController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return Center(
          child: CircularProgressIndicator(color: Colors.pink.shade300),
        );
      }
      return ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: controller.characters.length,
        itemBuilder: (context, index) {
          final char = controller.characters[index];
          return Card(
            elevation: 0,
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(12),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  char.image.isNotEmpty
                      ? char.image
                      : 'https://via.placeholder.com/150',
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                  // Memperhalus loading gambar dari internet
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const SizedBox(
                      width: 50,
                      height: 50,
                      child: Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    );
                  },
                  errorBuilder: (c, e, s) =>
                      const Icon(Icons.person, size: 50, color: Colors.grey),
                ),
              ),
              title: Text(
                char.fullName,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(char.hogwartsHouse),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.pinkAccent,
              ),
              onTap: () => Get.toNamed('/detail', arguments: char),
            ),
          );
        },
      );
    });
  }
}

class _SpellsView extends GetView<SpellController> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.pink.shade600,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              minimumSize: const Size.fromHeight(50),
            ),
            icon: const Icon(Icons.favorite),
            label: const Text('Ke Halaman Favorite Spell'),
            onPressed: () => Get.toNamed('/favorite'),
          ),
        ),
        Expanded(
          child: Obx(() {
            if (controller.isLoading.value)
              return Center(
                child: CircularProgressIndicator(color: Colors.pink.shade300),
              );
            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: controller.spells.length,
              itemBuilder: (context, index) {
                final spell = controller.spells[index];

                return Card(
                  elevation: 0,
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.pink.shade50,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.book, color: Colors.pink.shade300),
                    ),
                    title: Text(
                      spell.spellName,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(spell.use),
                    trailing: Obx(() {
                      final isFav = controller.isFavorite(spell.spellName);
                      return IconButton(
                        icon: Icon(
                          isFav ? Icons.favorite : Icons.favorite_border,
                          color: isFav ? Colors.red : Colors.grey.shade400,
                        ),
                        onPressed: () => controller.toggleFavorite(spell),
                      );
                    }),
                  ),
                );
              },
            );
          }),
        ),
      ],
    );
  }
}
