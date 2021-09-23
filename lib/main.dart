import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'yemek_main.dart';

void main() async {
  await Firebase.initializeApp();

  runApp(const YemekApp());
}

class YemekApp extends StatelessWidget {
  const YemekApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FoodMain(),
    );
  }
}
