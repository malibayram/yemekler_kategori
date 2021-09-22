import 'package:flutter/material.dart';

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

  String _baslik = "";
  String _tip = "Ana Yemekler";

  @override
  Widget build(BuildContext context) {
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
              onChanged: (v) {
                _baslik = v;
              },
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
              onPressed: () async {
                _baslik = "";
                _txtCtrlr.clear();

                await Future.delayed(Duration(seconds: 3));
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