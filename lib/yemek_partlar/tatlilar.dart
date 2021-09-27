import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Tatlilar extends StatelessWidget {
  const Tatlilar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Center(
          child: Text("Tatlilar"),
        ),
        Expanded(
          child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: FirebaseFirestore.instance
                .collection('yemekler')
                .where('tip', isEqualTo: 'Tatlılar')
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
      ],
    );
  }
}
