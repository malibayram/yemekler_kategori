import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../main_inherited.dart';

class AnaYemekler extends StatelessWidget {
  const AnaYemekler({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bildirimServisi = MainInherited.of(context).bildirimServisi;
    return Column(
      children: [
        const Center(child: Text("Ana Yemekler")),
        Expanded(
          child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: FirebaseFirestore.instance
                .collection('yemekler')
                .where('tip', isEqualTo: 'Ana Yemekler')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    for (final doc in snapshot.data!.docs)
                      Card(
                        child: ListTile(
                          onTap: () {
                            // print("haritayı aç");
                          },
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
        if (!kIsWeb)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                OutlinedButton(
                  onPressed: () {
                    bildirimServisi.konuyaAboneliktenCik('ana-yemekler');
                  },
                  child: const Text("Abonelikten Çık"),
                ),
                const Spacer(),
                OutlinedButton(
                  onPressed: () {
                    bildirimServisi.konuyaAboneOl('ana-yemekler');
                  },
                  child: const Text("Abone Ol"),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
