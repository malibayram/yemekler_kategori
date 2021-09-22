import 'package:flutter/material.dart';
import 'package:yemekler/yemek_main.dart';

void main() {
  runApp(const YemekApp());
}

class YemekApp extends StatelessWidget {
  const YemekApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: YemekMain(),
    );
  }
}
