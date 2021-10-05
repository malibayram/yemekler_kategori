import 'package:anlasmalar/modeller/kullanicilar.dart';
import 'package:anlasmalar/servisler/bildirim_detay_sayfasina_git.dart';
import 'package:anlasmalar/servisler/yetki_sayfasi.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'kategori_detay.dart';

class AlisVerisListele extends StatefulWidget {
  final String detayId;

  const AlisVerisListele({Key key, this.detayId}) : super(key: key);
  @override
  _AlisVerisListeleState createState() => _AlisVerisListeleState();
}

class _AlisVerisListeleState extends State<AlisVerisListele> {
  final db = FirebaseFirestore.instance;
  String firmaAdi = "";
  String indirimOrani = "";
  String adres = "";
  String fotoUrl = "";
  String telefon = "";
  String aciklama = "";
  int indirimSayisi;
  int indirimSayisi1;
  String googleAdresi;
  String webAdresi;
  int count;

  // eğer detay id gelmişse direk detay sayfasına yönlendirelim
  @override
  void didChangeDependencies() {
    if (widget.detayId != null) {
      // Yöntem 2: bunu burada kullanınca kullanıcı geri butonuna basarsa kategorinin listesine döner
      direkDetayaGit(
        kategori: "Alışveriş",
        detayId: widget.detayId,
        context: context,
        collId: 'alisveris',
      );
    }

    super.didChangeDependencies();
  }

  @override
  void initState() {
    toplamKayit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _yetkiServisi =
        Provider.of<YetkilendirmeServisi>(context, listen: false);
    return count == null
        ? Scaffold(body: CircularProgressIndicator())
        : Scaffold(
            appBar: AppBar(
              centerTitle: true,
              backgroundColor: Colors.indigo.shade900,
              title: Text(
                "Alışveriş Anlaşma Sayısı " + count.toString(),
                style: TextStyle(color: Colors.white),
              ),
            ),
            body: StreamBuilder<QuerySnapshot<Map>>(
              stream: db
                  .collection("alisveris")
                  .snapshots(), //Tüm Dokumanları getir
              builder: (context, snapshot) {
                //Veriler yoksa
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                //Dokumandan Obje oluşturma fonksiyonuna gönderildi ve liste olarak alındı
                List<Kullanici> kullanicilar = snapshot.data.docs
                    .map((doc) => Kullanici.dokumandanGelen(doc))
                    .toList();

                return ListView.builder(
                  padding: EdgeInsets.all(10),
                  itemCount: kullanicilar.length,
                  itemBuilder: (context, index) {
                    return alisverisListe(index, context, kullanicilar);
                  },
                );
              },
            ),
          );
  }

  Widget alisverisListe(int index, BuildContext context, kullanicilar) {
    String kategori = "Alışveriş";
    return Container(
      height: 120,
      child: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.indigo.shade500,
            border: Border.all(
              style: BorderStyle.none,
            ),
            borderRadius: BorderRadius.all(Radius.circular(8)),
            boxShadow: [
              BoxShadow(
                  color: Colors.blueAccent, offset: Offset(3, 3), blurRadius: 5)
            ],
          ),
          child: Center(
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => KategoriDetay(
                      firmaAdi: kullanicilar[index].firmaAdi,
                      indirimOrani: kullanicilar[index].indirimOrani,
                      adres: kullanicilar[index].adres,
                      fotoUrl: kullanicilar[index].fotoUrl,
                      telefon: kullanicilar[index].telefon,
                      aciklama: kullanicilar[index].aciklama,
                      webAdresi: kullanicilar[index].webAdresi,
                      googleAdresi: kullanicilar[index].googleAdresi,
                      kategori: kategori,
                    ),
                  ),
                );
              },
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 60,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(80),
                    child: Image.network(kullanicilar[index].fotoUrl,
                        fit: BoxFit.cover, width: 60, height: 60),
                  ),
                ),
                trailing: Icon(
                  Icons.chevron_right,
                  size: 40,
                  color: Colors.white,
                ),
                title: Text(
                  kullanicilar[index].firmaAdi,
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                subtitle: Text(
                  "İndirim Oranı: %" + kullanicilar[index].indirimOrani,
                  style: TextStyle(color: Colors.red, fontSize: 20),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future toplamKayit() async {
    var sorgu =
        FirebaseFirestore.instance.collection('alisveris').where('firmaAdi');
    var QuerySnapshot = await sorgu.get();
    var toplam = QuerySnapshot.docs.length;
    setState(() {
      count = toplam;
    });
  }
}
