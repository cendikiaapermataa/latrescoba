import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  final usernameCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('isLogged') == true) {
      Get.offAllNamed('/main');
    }
  }

  Future<void> login() async {
    if (usernameCtrl.text == 'admin' && passwordCtrl.text == 'admin') {
      isLoading.value = true;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLogged', true);

      // 1. PINDAH HALAMAN DULU agar layar login dihancurkan dengan aman
      Get.offAllNamed('/main');

      // 2. BERI JEDA SEDIKIT, baru tampilkan Snackbar di halaman baru
      Future.delayed(const Duration(milliseconds: 300), () {
        Get.snackbar(
          'Success',
          'Login Berhasil!',
          backgroundColor: Colors.pink.shade300,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
          margin: const EdgeInsets.all(12),
        );
      });

      return; // Wajib agar kodingan di bawahnya tidak tereksekusi
    } else {
      Get.snackbar(
        'Failed',
        'Username atau Password salah!',
        backgroundColor: Colors.red.shade400,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(12),
      );
    }

    isLoading.value = false;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLogged');
    usernameCtrl.clear();
    passwordCtrl.clear();

    // 1. PINDAH KE LOGIN DULU
    Get.offAllNamed('/login');

    // 2. BERI JEDA SEDIKIT, baru tampilkan Snackbar
    Future.delayed(const Duration(milliseconds: 300), () {
      Get.snackbar(
        'Logout',
        'Sesi anda telah berakhir',
        backgroundColor: Colors.grey.shade400,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(12),
      );
    });
  }
}
