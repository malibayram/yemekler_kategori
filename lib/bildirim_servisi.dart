import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
        Fluttertoast.showToast(
          msg: "${message.notification?.title}\n${message.notification?.body}",
          timeInSecForIosWeb: 1,
          toastLength: Toast.LENGTH_SHORT,
        );

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

  // REST API ile bildirim gönderme
  Future<void> bildirimGonderEski(Map data) async {
    const url = "https://fcm.googleapis.com/fcm/send";

    // TODO :: bunu bu şekilde kesinlikle kullanmamak gerekiyor.
    // reverse engineering
    const serverKey =
        "AAAAc9LBiNc:APA91bGx4J-_wHnup6pN0rR_o_-0Zo3w0L4qRQooIfimgm-p1_cDThnnUq_IPt6I_-Az9bh8XV8QBzyVPyvKouctqrRoNWI_He0SAeLLrhqyoqz_VzySzG157tM05Ez36Z3OZVYxF6qO";

    final fcmServerKey = (await _firestore
            .collection('uygulama-bilgileri')
            .doc('firebase')
            .get())
        .data()!['fcm-server-key'];

    // tokenleri manuel olarak buradaki listeye ekleyebiliriz
    const tokensExample = [
      "c8KSyhumRdwQztpVg3B9uh:APA91bEZpLyyADCGkCkfYwCipauYY1cSRMl0cebM1fBAnNznEP3QUd83rCf8sM9HAH71Wecz3IG5DJazISCzYqoOyHCiZ38duJXhEy_8Mw2WDw9_haXEjPtaoYNIQnz7XDgVh4PpwLM6"
    ];

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

    print("tokens");
    print(tokens);

    // network tracking
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
            "title": "Yeni bir içerik eklendi",
            "body":
                "${data['tip']} kategorisine ${data['baslik']} başlıklı yeni bir yemek eklendi",
            "sound": "default",
          },
          "priority": "high",
          "collapse_key": "${data['tip']}",
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

  // REST API ile bildirim gönderme
  Future<void> bildirimGonderYeni(Map data) async {
    const url =
        "https://fcm.googleapis.com/v1/projects/yemekkategori/messages:send";

    const accessToken =
        "ya29.c.Kp8BEQj2xXv-w_pmFsmcxZH8TPV9nqsuhloKNeaIx3vUBmyxtm6_M4r2ZyFqWgfPMGtqC1WYVt6pDdz0a4mv9p_oe4653RV1-bVrwsiuYXhxnyIOuJG5JIa21bPMdWDE3Ap_suo_4e7WsygvvSqijDcO5myRJGgQTGyp2oQp-7i3HCk5MjUcuvUiBCnC7pBqIjR1D34o159C9bCQXLUcNogq";

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
                  "${data['tip']} kategorisine ${data['baslik']} başlıklı yeni bir yemek eklendi",
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
}
