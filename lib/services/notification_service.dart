import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Fungsi untuk inisialisasi awal saat aplikasi pertama kali dibuka
  static Future<void> init() async {
    // Pengaturan icon notifikasi untuk Android (menggunakan icon bawaan aplikasi)
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await _notificationsPlugin.initialize(settings: initializationSettings);

    // Meminta izin (permission) otomatis untuk Android 13 ke atas
    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();
  }

  // Fungsi Reusable untuk memicu Notifikasi Sistem secara instan
  static Future<void> showImmediateNotification({
    required String title,
    required String body,
  }) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
          'harry_potter_channel_id', // ID Channel bebas
          'Harry Potter Spells', // Nama Channel yang terlihat di pengaturan HP
          channelDescription: 'Notifikasi saat menghapus spell favorit',
          importance: Importance.max,
          priority: Priority.high,
          ticker: 'ticker',
        );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    // Memicu notifikasi sistem dengan ID unik berdasarkan timestamp
    await _notificationsPlugin.show(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title: title,
      body: body,
      notificationDetails: platformChannelSpecifics,
    );
  }
}
