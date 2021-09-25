import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'bildirim_servisi.dart';
import 'main_inherited.dart';
import 'yemek_main.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(const YemekApp());
}

class YemekApp extends StatelessWidget {
  const YemekApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MainInherited(
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: FoodMain(),
      ),
      bildirimServisi: BildirimServisi(),
    );
  }
}
