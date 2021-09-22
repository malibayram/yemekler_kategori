import 'package:flutter/material.dart';
import 'package:yemekler/admin_page.dart';

import 'yemek_partlar/ana_yemekler.dart';
import 'yemek_partlar/sulu_yemekler.dart';
import 'yemek_partlar/tatlilar.dart';

class YemekMain extends StatefulWidget {
  const YemekMain({Key? key}) : super(key: key);

  @override
  _YemekMainState createState() => _YemekMainState();
}

class _YemekMainState extends State<YemekMain> {
  int partIndex = 0;

  final partlar = [
    const AnaYemekler(),
    const SuluYemekler(),
    const Tatlilar(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Yemekler"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const AdminPage(),
                ),
              );
            },
            icon: const Icon(Icons.android_sharp),
          ),
        ],
      ),
      body: partlar[partIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: (i) => setState(() => partIndex = i),
        currentIndex: partIndex,
        items: const [
          BottomNavigationBarItem(
            label: "Ana Yemekler",
            icon: Icon(Icons.food_bank),
          ),
          BottomNavigationBarItem(
            label: "Sulu Yemekler",
            icon: Icon(Icons.food_bank_rounded),
          ),
          BottomNavigationBarItem(
            label: "Tatlılar",
            icon: Icon(Icons.food_bank_outlined),
          ),
        ],
      ),
    );
  }
}
