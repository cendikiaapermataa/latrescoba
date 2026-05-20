import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'bindings/auth_binding.dart';
import 'bindings/main_binding.dart';
import 'views/login_page.dart';
import 'views/main_page.dart';
import 'views/character_detail_page.dart';
import 'views/favorite_spell_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Hive.initFlutter();
  await Hive.openBox('favorite_spells');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Harry Potter App',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        fontFamily: 'Roboto',
      ),
      initialRoute: '/login',
      getPages: [
        GetPage(
          name: '/login', 
          page: () => const LoginPage(),
          binding: AuthBinding(), // <-- Menempelkan AuthBinding disini
        ),
        GetPage(
          name: '/main', 
          page: () => const MainPage(),
          binding: MainBinding(), // <-- Menempelkan MainBinding disini
        ),
        GetPage(name: '/detail', page: () => const CharacterDetailPage()),
        GetPage(name: '/favorite', page: () => const FavoriteSpellPage()),
      ],
    );
  }
}