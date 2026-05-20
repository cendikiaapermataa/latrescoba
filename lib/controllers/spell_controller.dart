import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import '../models/spell.dart';

class SpellController extends GetxController {
  final RxList<Spell> spells = <Spell>[].obs;
  final RxList<Spell> favSpells = <Spell>[].obs;
  final RxBool isLoading = false.obs;

  late Box favBox;

  @override
  void onInit() {
    super.onInit();
    favBox = Hive.box('favorite_spells');
    // Load local data cepat, bisa taruh di onInit
    loadFavorites();
  }

  @override
  void onReady() {
    super.onReady();
    // Memuat data API (lambat) saat UI selesai tampil agar transisi mulus
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
      Get.snackbar('Error', 'Gagal mengambil data spell');
    } finally {
      isLoading.value = false;
    }
  }

  void loadFavorites() {
    final data = favBox.values
        .map((e) => Spell.fromJson(Map<String, dynamic>.from(e)))
        .toList();
    favSpells.assignAll(data);
  }

  bool isFavorite(String spellName) {
    return favSpells.any((spell) => spell.spellName == spellName);
  }

  void toggleFavorite(Spell spell) {
    if (isFavorite(spell.spellName)) {
      favBox.delete(spell.spellName);
      Get.snackbar(
        'Removed',
        '${spell.spellName} dihapus dari favorit',
        backgroundColor: Colors.red.shade400,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(10),
      );
    } else {
      favBox.put(spell.spellName, spell.toJson());
      Get.snackbar(
        'Added',
        '${spell.spellName} ditambahkan ke favorit',
        backgroundColor: Colors.green.shade400,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(10),
      );
    }
    loadFavorites();
  }
}
