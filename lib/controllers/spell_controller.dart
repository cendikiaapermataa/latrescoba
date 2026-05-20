import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import '../models/spell.dart';
import '../services/notification_service.dart';

class SpellController extends GetxController {
  final RxList<Spell> spells = <Spell>[].obs;
  final RxList<Spell> favSpells = <Spell>[].obs;
  final RxBool isLoading = false.obs;

  late Box favBox;

  @override
  void onInit() {
    super.onInit();
    favBox = Hive.box('favorite_spells');
    // Load local data (Hive) cepat, aman ditaruh di onInit
    loadFavorites();
  }

  @override
  void onReady() {
    super.onReady();
    // Memuat data API (internet) ditunda sedikit saat UI selesai tampil agar transisi mulus
    Future.delayed(const Duration(milliseconds: 300), () {
      fetchSpells();
    });
  }

  Future<void> fetchSpells() async {
    isLoading.value = true;
    try {
      final response = await http.get(
        Uri.parse('https://potterapi-fedeperin.vercel.app/en/spells'),
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        spells.assignAll(data.map((e) => Spell.fromJson(e)).toList());
      }
    } catch (e) {
      Get.snackbar(
        'Error', 
        'Gagal mengambil data spell',
        backgroundColor: Colors.red.shade400,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void loadFavorites() {
    // Membaca semua data dari Hive dan mengkonversinya kembali menjadi Object Spell
    final data = favBox.values
        .map((e) => Spell.fromJson(Map<String, dynamic>.from(e)))
        .toList();
    favSpells.assignAll(data);
  }

  // Fungsi pengecekan yang sangat reaktif karena membaca dari favSpells (RxList)
  bool isFavorite(String spellName) {
    return favSpells.any((spell) => spell.spellName == spellName);
  }

  void toggleFavorite(Spell spell) {
    if (isFavorite(spell.spellName)) {
      // 1. HAPUS DARI DATABASE LOKAL (HIVE)
      favBox.delete(spell.spellName);

      // 2. TAMPILKAN NOTIFIKASI SISTEM ASLI (Immediate Notifications dari PDF Poin 4)
      NotificationService.showImmediateNotification(
        title: 'Spell Dihapus 🪄',
        body: 'Sihir "${spell.spellName}" telah dikeluarkan dari daftar favorit kamu.',
      );

      // 3. TAMPILKAN SNACKBAR (Feedback UI di dalam aplikasi)
      Get.snackbar(
        'Removed',
        '${spell.spellName} dihapus dari favorit',
        backgroundColor: Colors.red.shade400,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(10),
      );
    } else {
      // 1. TAMBAH KE DATABASE LOKAL (HIVE)
      favBox.put(spell.spellName, spell.toJson());

      // 2. TAMPILKAN SNACKBAR (Feedback UI di dalam aplikasi)
      Get.snackbar(
        'Added',
        '${spell.spellName} ditambahkan ke favorit',
        backgroundColor: Colors.green.shade400,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(10),
      );
    }
    
    // Perbarui state UI setelah ada perubahan
    loadFavorites();
  }
}