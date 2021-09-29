import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class YemekDetay extends StatelessWidget {
  final String yemekId;
  const YemekDetay({Key? key, required this.yemekId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Yemek Detay"),
      ),
      body: Center(
        child: FutureBuilder<DocumentSnapshot<Map>>(
          future: FirebaseFirestore.instance
              .collection('yemekler')
              .doc(yemekId)
              .get(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Text(snapshot.data!.data()!['baslik']!);
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}
