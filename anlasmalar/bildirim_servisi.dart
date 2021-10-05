import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

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
    //Sadece web platformunda kullanılacak(vapidKey)
    const vapidKey =
        "BCuCkuFoQ9LDopqM8lZdtjWQ2eBM4E5R0qqfkOeKe6H_5vt-OzXnglv8cMKVFedWFml4LZdvXlchtQ1fOs1MYpo";

    final token = await _messaging.getToken(vapidKey: kIsWeb ? vapidKey : null);

    if (token != null) {
      _firestore.collection('users').doc(_auth.currentUser.uid).set(
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
        print(
            'Message also contained a notification: ${message.notification?.title}');
        print(
            'Message also contained a notification: ${message.notification?.body}');
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

  //********************************************************************************
  //********************************************************************************
  // REST API ile bildirim gönderme (Eski Yöntem)
  Future<void> bildirimGonderEski(Map data) async {
    const url = "https://fcm.googleapis.com/fcm/send";

    //Server keyi manuel olarak değişkene atamak (Bu yöntem kesinlikle kullanılmamalı)
    const serverKey =
        "AAAAmj6kNDU:APA91bEDpSoxRix-yxVhU-lK0eOwL7o45PfU3E6GGf-ZqnPcEz2ajWOW589OpCoqqWGkrPDuo63-KhJwmFzCkk9t4PduJ9mNiXofZr6R8TcFbn9rVVtpyxE9B-JmJlGIqKFTiGSV_lvL";

    // tokenleri manuel olarak buradaki listeye ekleyebiliriz
    const tokensExample = [
      "c8KSyhumRdwQztpVg3B9uh:APA91bEZpLyyADCGkCkfYwCipauYY1cSRMl0cebM1fBAnNznEP3QUd83rCf8sM9HAH71Wecz3IG5DJazISCzYqoOyHCiZ38duJXhEy_8Mw2WDw9_haXEjPtaoYNIQnz7XDgVh4PpwLM6"
    ];

    // tokenleri firebase firestore'dan otomatik alma
    final usersDocs = await _firestore.collection('users').get();
    final tokens = usersDocs.docs
        .map((e) => e.data()['fcmTokens'])
        .expand((element) => element)
        .toList();

    print(tokens);

    //Server key'i firebase üzerinden alma
    final fcmServerKey = (await _firestore
            .collection('uygulama-bilgileri')
            .doc('firebase')
            .get())
        .data()['fcm-server-key'];

    http.Response cevap = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$fcmServerKey',
      },
      body: jsonEncode(
        <String, dynamic>{
          // kişilerin jetonlarına göre bildirim gönderme
          "registration_ids": tokens,
          // abone olunan konuya bildirim gönderme
          // "to": "topics/tum-kategoriler"
          "notification": <String, dynamic>{
            "title": data['title'],
            "body": data['body'],
            "sound": "default",
          },
          "priority": "high",
          "collapse_key": "${data['kategori']}",
          "data": {...data, "timestamp": "tarih"},
        },
      ),
      encoding: Encoding.getByName('utf-8'),
    );

    print(cevap);
    print(cevap.body);
    print(cevap.headers);
    print(cevap.statusCode);
  }

  //********************************************************************************
  //********************************************************************************

  // REST ile bildirim gönderme (Yeni Yöntem)
  Future<void> bildirimGonderYeni(Map data) async {
    //id (sendika-fc29d) almak için firebase projesinden proje settings--General--Project ID
    //karşısında yazan id ismini alıyoruz
    const url =
        "https://fcm.googleapis.com/v1/projects/sendika-fc29d/messages:send";

    final accessToken = (await _firestore
            .collection('uygulama-bilgileri')
            .doc('firebase')
            .get())
        .data()['access-token'];

    // tokenleri firebase firestore'dan alma
    final usersDocs = await _firestore.collection('users').get();
    final tokens = usersDocs.docs
        .map((e) {
          if (e.exists && e.data().containsKey('fcmTokens')) {
            return e.data()['fcmTokens'];
          } else {
            return [];
          }
        })
        .expand((element) => element)
        .toList();

    http.Response cevap = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode(
        <String, dynamic>{
          "message": {
            "topic": "tum-kategoriler",
            "data": {...data, "timestamp": "tarih"},
            "notification": {
              "title": "Yeni bir içerik eklendi",
              "body":
                  "${data['kategori']} alanında ${data['firmaAdi']} firmasıyla yeni bir anlaşma yapıldı",
            }
          }
        },
      ),
      encoding: Encoding.getByName('utf-8'),
    );

    print(cevap);
    print(cevap.body);
    print(cevap.headers);
    print(cevap.statusCode);
  }

//********************************************************************************
//********************************************************************************
}
