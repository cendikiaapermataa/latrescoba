import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../models/character.dart';

class CharacterController extends GetxController {
  final RxList<Character> characters = <Character>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    fetchCharacters();
    super.onInit();
  }

  Future<void> fetchCharacters() async {
    isLoading.value = true;
    try {
      final response = await http.get(Uri.parse('https://potterapi-fedeperin.vercel.app/en/characters'));
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