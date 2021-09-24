import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

class BildirimServisi {
  final _messaging = FirebaseMessaging.instance;
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  Future<void> izinAl() async {
    if (kIsWeb || Platform.isIOS) {
      final settings = await _messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );
      print('User granted permission: ${settings.authorizationStatus}');
    }
  }

  Future<void> jetonAlKaydet() async {
    const vapidKey =
        "BCuCkuFoQ9LDopqM8lZdtjWQ2eBM4E5R0qqfkOeKe6H_5vt-OzXnglv8cMKVFedWFml4LZdvXlchtQ1fOs1MYpo";

    final token = await _messaging.getToken(vapidKey: kIsWeb ? vapidKey : null);

    if (token != null) {
      _firestore.collection('users').doc(_auth.currentUser!.uid).set(
        {
          'fcmTokens': FieldValue.arrayUnion([token])
        },
      );
    }
  }

  Future<void> bildirimSistemineAboneOl() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });
  }

  Future<void> konuyaAboneOl(String konu) async {
    // subscribe to topic on each app start-up
    await FirebaseMessaging.instance.subscribeToTopic(konu);
  }

  Future<void> konuyaAboneliktenCik(String konu) async {
    // subscribe to topic on each app start-up
    await FirebaseMessaging.instance.subscribeToTopic(konu);
  }
}
