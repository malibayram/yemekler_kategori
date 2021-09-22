import 'package:flutter/material.dart';

class SuluYemekler extends StatelessWidget {
  const SuluYemekler({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        Center(child: Text("Sulu Yemekler")),
        Card(
          child: ListTile(
            title: Text("Çorba"),
          ),
        ),
      ],
    );
  }
}
