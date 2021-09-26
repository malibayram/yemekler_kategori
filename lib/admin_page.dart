import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'main_inherited.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({Key? key}) : super(key: key);

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final _txtCtrlr = TextEditingController();
  final _tipler = [
    "Ana Yemekler",
    "Sulu Yemekler",
    "Tatlılar",
  ];

  String _tip = "Ana Yemekler";

  @override
  Widget build(BuildContext context) {
    final bildirimServisi = MainInherited.of(context).bildirimServisi;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Page"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            const SizedBox(height: 16),
            TextField(
              controller: _txtCtrlr,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Başlık",
              ),
            ),
            const Divider(),
            SizedBox(
              height: 48,
              child: DropdownButton<String>(
                onChanged: (v) => setState(() => _tip = v!),
                value: _tip,
                items: _tipler
                    .map(
                      (e) => DropdownMenuItem<String>(
                        value: e,
                        child: Text(e),
                      ),
                    )
                    .toList(),
              ),
            ),
            const Divider(),
            ElevatedButton(
              onPressed: () {
                if (_txtCtrlr.text.isNotEmpty) {
                  final data = {
                    'baslik': _txtCtrlr.text,
                    'tip': _tip,
                    'timestamp': FieldValue.serverTimestamp(),
                  };

                  String? id;

                  bildirimServisi.bildirimGonderYeni(data);

                  FirebaseFirestore.instance
                      .collection('yemekler')
                      .add(data)
                      .then((docRef) {
                    print(docRef.id);
                    // 21:49
                    id = docRef.id;
                  });
                  // 21:48
                  print(id);

                  _txtCtrlr.clear();
                }

                if (mounted) {
                  setState(() {});
                }
              },
              child: const Text("Ekle"),
            ),
            const Divider(),
          ],
        ),
      ),
    );
  }
}


/* 
SizedBox(
  height: 48,
  child: DropdownButton<String>(
    onChanged: (v) => setState(() => _tip = v!),
    value: _tip,
    items: _tipler
        .map(
          (e) => DropdownMenuItem<String>(
            value: e,
            child: Text(e),
          ),
        )
        .toList(),
  ),
),
*/