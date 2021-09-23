import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SuluYemekler extends StatelessWidget {
  const SuluYemekler({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Center(child: Text("Sulu Yemekler")),
        Expanded(
          child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: FirebaseFirestore.instance
                .collection('yemekler')
                .where('tip', isEqualTo: 'Sulu Yemekler')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView(
                  children: [
                    for (final doc in snapshot.data!.docs)
                      Card(
                        child: ListTile(
                          title: Text(doc.data()['baslik']),
                          subtitle: Text(doc.data()['tip']),
                        ),
                      ),
                  ],
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
      ],
    );
  }
}
