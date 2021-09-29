import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:yemekler/yemek_detay.dart';

import '../main_inherited.dart';

class AnaYemekler extends StatefulWidget {
  final String? kategori;
  final RemoteMessage? mesaj;
  const AnaYemekler({Key? key, this.kategori, this.mesaj}) : super(key: key);

  @override
  State<AnaYemekler> createState() => _AnaYemeklerState();
}

class _AnaYemeklerState extends State<AnaYemekler> {
  @override
  void didChangeDependencies() {
    if (widget.mesaj != null && widget.mesaj!.data.containsKey('yemek-id')) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => YemekDetay(yemekId: widget.mesaj!.data['yemek-id']),
        ),
      );
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final bildirimServisi = MainInherited.of(context).bildirimServisi;
    return Scaffold(
      appBar: widget.kategori == null
          ? null
          : AppBar(title: Text("${widget.kategori}")),
      body: Column(
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
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => YemekDetay(yemekId: doc.id),
                                ),
                              );
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
      ),
    );
  }
}
