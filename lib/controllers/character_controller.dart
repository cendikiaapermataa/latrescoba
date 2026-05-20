import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../models/character.dart';

class CharacterController extends GetxController {
  final RxList<Character> characters = <Character>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Dihapus dari onInit agar tidak bertabrakan dengan animasi perpindahan layar
  }

  @override
  void onReady() {
    super.onReady();
    // onReady dipanggil ketika tampilan widget selesai dirender ke layar.
    // Beri jeda kecil ekstra untuk memastikan transisi layar Get.offAllNamed benar-benar selesai
    Future.delayed(const Duration(milliseconds: 200), () {
      fetchCharacters();
    });
  }

  Future<void> fetchCharacters() async {
    isLoading.value = true;
    try {
      final response = await http.get(
        Uri.parse('https://potterapi-fedeperin.vercel.app/en/characters'),
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        characters.assignAll(data.map((e) => Character.fromJson(e)).toList());
      }
    } catch (e) {
      Get.snackbar('Error', 'Gagal mengambil data character');
    } finally {
      isLoading.value = false;
    }
  }
}
