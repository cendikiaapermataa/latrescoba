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

    // --- PERBAIKAN DI SINI ---
    // Tambahkan pengecekan Get.currentRoute == '/login'
    // Mencegah INFINITE LOOP agar saat di MainPage, fungsi ini tidak me-reset layar
    if (prefs.getBool('isLogged') == true && Get.currentRoute == '/login') {
      Get.offAllNamed('/main');
    }
  }

  Future<void> login() async {
    if (usernameCtrl.text == 'admin' && passwordCtrl.text == 'admin') {
      isLoading.value = true;

      // JEDA UNTUK UI
      await Future.delayed(const Duration(milliseconds: 400));

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLogged', true);

      Get.offAllNamed('/main');

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

      return;
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

    Get.offAllNamed('/login');

    Future.delayed(const Duration(milliseconds: 300), () {
      Get.snackbar(
        'Logout',
        'Sesi anda telah berakhir',
        backgroundColor: Colors.grey.shade600,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(12),
      );
    });
  }
}
