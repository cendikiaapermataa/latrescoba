import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/main_controller.dart';
import '../controllers/auth_controller.dart';
import '../controllers/character_controller.dart';
import '../controllers/spell_controller.dart';

class MainPage extends GetView<MainController> {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AuthController authC = Get.find();

    return Scaffold(
      appBar: AppBar(
        title: Obx(
          () => Text(
            controller.currentIndex.value == 0
                ? 'Characters'
                : 'Spells Gallery',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        backgroundColor: Colors.pink[300],
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              // ----- BAGIAN POP-UP CONFIRMATION DIALOG -----
              Get.dialog(
                AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      16,
                    ), // Sudut melengkung modern
                  ),
                  title: const Text(
                    'Logout',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  content: const Text('Apakah Anda yakin ingin logout?'),
                  actions: [
                    // Tombol Batal (Tidak)
                    TextButton(
                      onPressed: () => Get.back(), // Menutup pop-up saja
                      child: Text(
                        'Tidak',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    // Tombol Konfirmasi (Ya) dengan tema Pink
                    ElevatedButton(
                      onPressed: () {
                        Get.back(); // Tutup pop-up dulu
                        authC
                            .logout(); // Jalankan fungsi logout baru pindah halaman
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pink[300],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Ya',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              );
              // ----------------------------------------------
            },
          ),
        ],
      ),
      body: Obx(
        () => IndexedStack(
          index: controller.currentIndex.value,
          children: [_CharacterListTab(), _SpellListTab()],
        ),
      ),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          currentIndex: controller.currentIndex.value,
          onTap: controller.changeTab,
          selectedItemColor: Colors.pink[400],
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

// --- Batas Kelas Utama MainPage ---
// Sisa kode di bawahnya (_CharacterListTab dan _SpellListTab) tetap sama persis seperti sebelumnya.

class _CharacterListTab extends GetView<CharacterController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      return ListView.builder(
        itemCount: controller.characters.length,
        itemBuilder: (context, index) {
          final char = controller.characters[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: char.image.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        char.image,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                        errorBuilder: (c, e, s) =>
                            const Icon(Icons.person, size: 50),
                      ),
                    )
                  : const Icon(Icons.person, size: 50, color: Colors.grey),
              title: Text(
                char.fullName,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(char.hogwartsHouse),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey,
              ),
              onTap: () => Get.toNamed('/detail', arguments: char),
            ),
          );
        },
      );
    });
  }
}

class _SpellListTab extends GetView<SpellController> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton.icon(
            onPressed: () => Get.toNamed('/favorite'),
            icon: const Icon(Icons.favorite, color: Colors.white),
            label: const Text(
              'Ke Halaman Favorite Spell',
              style: TextStyle(color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.pink[400],
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        Expanded(
          child: Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }
            return ListView.builder(
              itemCount: controller.spells.length,
              itemBuilder: (context, index) {
                final spell = controller.spells[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
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
                    trailing: Obx(() {
                      final isFav = controller.isFavorite(spell.spellName);
                      return IconButton(
                        icon: Icon(
                          isFav ? Icons.favorite : Icons.favorite_border,
                          color: isFav ? Colors.red : Colors.grey,
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
