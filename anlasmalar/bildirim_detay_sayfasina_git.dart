import 'package:anlasmalar/ListelenecekKategoriler/kategori_detay.dart';
import 'package:anlasmalar/modeller/kullanicilar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

Future<void> direkDetayaGit({
  @required String kategori,
  @required String detayId,
  @required BuildContext context,
  @required String collId,
}) async {
  final db = FirebaseFirestore.instance;
  final doc = await db.collection(collId).doc(detayId).get();
  final kullanici = Kullanici.dokumandanGelen(doc);

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (BuildContext context) {
        return KategoriDetay(
          firmaAdi: kullanici.firmaAdi,
          indirimOrani: kullanici.indirimOrani,
          adres: kullanici.adres,
          fotoUrl: kullanici.fotoUrl,
          telefon: kullanici.telefon,
          aciklama: kullanici.aciklama,
          webAdresi: kullanici.webAdresi,
          googleAdresi: kullanici.googleAdresi,
          kategori: kategori,
        );
      },
    ),
  );
}
