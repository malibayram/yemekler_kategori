import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'admin_page.dart';
import 'yemek_partlar/ana_yemekler.dart';
import 'yemek_partlar/sulu_yemekler.dart';
import 'yemek_partlar/tatlilar.dart';

class FoodMain extends StatefulWidget {
  const FoodMain({Key? key}) : super(key: key);

  @override
  _FoodMainState createState() => _FoodMainState();
}

class _FoodMainState extends State<FoodMain> {
  int partIndex = 0;

  final partlar = [
    const AnaYemekler(),
    const SuluYemekler(),
    const Tatlilar(),
  ];

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
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
        } else {
          if (FirebaseAuth.instance.currentUser == null) {
            FirebaseAuth.instance.signInAnonymously();
          }

          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
