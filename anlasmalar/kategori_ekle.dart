import 'dart:io';

import 'package:anlasmalar/servisler/fire_store_servisi.dart';
import 'package:anlasmalar/servisler/yetki_sayfasi.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../main_inherited.dart';

class KategoriEkle extends StatefulWidget {
  final String kategoriAl;
  final String appBarAl;

  KategoriEkle({this.kategoriAl, this.appBarAl});
  @override
  _KategoriEkleState createState() => _KategoriEkleState();
}

class _KategoriEkleState extends State<KategoriEkle> {
  final db = FirebaseFirestore.instance;
  TextEditingController _indirimOrani = TextEditingController();
  TextEditingController _adres = TextEditingController();
  TextEditingController _telefon = TextEditingController();
  TextEditingController _aciklama = TextEditingController();
  //TextEditingController _enlem = TextEditingController();
  //TextEditingController _boylam = TextEditingController();
  TextEditingController _webAdresi = TextEditingController();
  TextEditingController _googleAdresi = TextEditingController();
  TextEditingController _firmaAdi = TextEditingController();
  //final String kategori="alisveris";
  final _formaAnahtari = GlobalKey<FormState>();
  //String numara = "";
  File dosya;
  String dosyaYolu;
  bool yukleniyor = false;

  @override
  Widget build(BuildContext context) {
    final _yetkiServisi =
        Provider.of<YetkilendirmeServisi>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.appBarAl + " Kategorisinde Ekleme",
        ),
        backgroundColor: Colors.indigo.shade900,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          sayfaElemanlari(),
          yuklemeAnimasyonu(),
        ],
      ),
    );
  }

  //*** SAYFA ELEMANLARI ***

  Widget sayfaElemanlari() {
    final bildirimServisi = MainInherited.of(context).bildirimServisi;
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Form(
        key: _formaAnahtari,
        child: Padding(
          padding: const EdgeInsets.only(top: 30),
          child: ListView(
            children: [
              //*****************************************************************
              //***FİRMA ADI GİRİŞİ
              TextFormField(
                controller: _firmaAdi,
                decoration: InputDecoration(
                  hintText: "Firma Adı Girin",
                  labelText: "Firma Adı",
                  border: OutlineInputBorder(),
                ),
                validator: (girilenDeger) {
                  if (girilenDeger.isEmpty) {
                    return "Firma Adı Giriniz";
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 15,
              ),

              //*****************************************************************
              // İNDİRİM ORANI GİRİŞİ
              TextFormField(
                controller: _indirimOrani,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: "İndirim Oranı Girin",
                  labelText: "İndirim Oranı",
                  border: OutlineInputBorder(),
                ),
                validator: (girilenDeger) {
                  if (girilenDeger.isEmpty) {
                    return "Oran Giriniz";
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 15,
              ),

              //*****************************************************************
              // ADRES GİRİŞİ
              TextFormField(
                controller: _adres,
                decoration: InputDecoration(
                  hintText: "Adres Bilgisini Girin",
                  labelText: "Adres Bilgisi",
                  border: OutlineInputBorder(),
                ),
                validator: (girilenDeger) {
                  if (girilenDeger.isEmpty) {
                    return "Adres Bilgisi Giriniz";
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 15,
              ),
              //*****************************************************************
              // GOOGLE MAPS ADRESİ
              TextFormField(
                controller: _googleAdresi,
                decoration: InputDecoration(
                  hintText: "Google Maps Adresini Girin",
                  labelText: "Google Maps Adresi",
                  border: OutlineInputBorder(),
                ),
                validator: (girilenDeger) {
                  if (girilenDeger.isEmpty) {
                    return "Google Maps Adresini Giriniz";
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 15,
              ),
              //*****************************************************************
              //WEB SİTESİ
              TextFormField(
                controller: _webAdresi,
                decoration: InputDecoration(
                  hintText: "Web Sitesini Girin",
                  labelText: "Web Sitesi",
                  border: OutlineInputBorder(),
                ),
                validator: (girilenDeger) {
                  if (girilenDeger.isEmpty) {
                    return null;
                  }
                  return null;
                },
              ),

              SizedBox(
                height: 15,
              ),

              //*****************************************************************
              // TELEFON GİRİŞİ
              TextFormField(
                controller: _telefon,
                decoration: InputDecoration(
                  hintText: "Telefon Giriniz",
                  labelText: "Telefon Bilgisi",
                  border: OutlineInputBorder(),
                ),
                validator: (girilenDeger) {
                  if (girilenDeger.isEmpty) {
                    return "Telefon Giriniz";
                  }
                  return null;
                },
                keyboardType: TextInputType.number,
              ),
              SizedBox(
                height: 15,
              ),

              //*****************************************************************
              // AÇIKLAMA GİRİŞİ
              TextFormField(
                keyboardType: TextInputType.multiline,
                maxLines: 6,
                controller: _aciklama,
                decoration: InputDecoration(
                  hintText: "Açıklama Giriniz",
                  labelText: "Açıklama",
                  border: OutlineInputBorder(),
                ),
                validator: (girilenDeger) {
                  if (girilenDeger.isEmpty) {
                    return "Açıklama Giriniz";
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 15,
              ),

              // FOTOĞRAF SEÇİM ALANI
              Container(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: GestureDetector(
                        onTap: () {
                          fotografSec();
                        },
                        /*Fotoğraf seçimi yapıldıysa görünecek kısım*/
                        child: dosya != null
                            ? Container(
                                height: MediaQuery.of(context).size.width / 3,
                                width: MediaQuery.of(context).size.width / 3,
                                child: Image.file(
                                  dosya,
                                  fit: BoxFit.cover,
                                ),
                              )
                            /*Fotoğraf seçimi yapılmadan önce görünecek kısım*/
                            : Container(
                                height: 200,
                                width: double.infinity,
                                child: Icon(
                                  Icons.add_a_photo,
                                  color: Colors.black,
                                  size: 50,
                                ),
                              ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),

              //*****************************************************************
              // KAYDET BUTONU
              ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(primary: Colors.indigo.shade900),
                  child: Text(
                    "Kaydet",
                    style: TextStyle(fontSize: 20),
                  ),
                  onPressed: () {
                    final data = {
                      'title': "Yeni Anlaşma Eklendi",
                      'body':
                          "${widget.appBarAl} alanında ${_firmaAdi.text} firmasıyla yeni bir anlaşma yapıldı",
                      'bildirim-tipi': "anlasma",
                      'kategori': widget.appBarAl,
                      'firmaAdi': _firmaAdi.text,
                      'coll-id': widget.kategoriAl,
                      'detay-id': _firmaAdi.text,
                    };

                    bildirimServisi.bildirimGonderEski(data);

                    if (_formaAnahtari.currentState.validate()) {
                      setState(() {
                        yukleniyor = true;
                        kayit();
                      });
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }

  //**************************************************************************
  //SNACKBAR İLE KAYIT İŞLEMİNİ TAMAMLAMA
  kayit() async {
    var sayi = await FireStoreSevisi().kategoriKayit(
        _firmaAdi,
        _indirimOrani,
        _adres,
        _webAdresi,
        _googleAdresi,
        _telefon,
        _aciklama,
        dosya,
        widget.kategoriAl,
        widget.appBarAl);
    setState(() {
      yukleniyor = false;
    });
    if (sayi != 0) {
      final snackBar = SnackBar(
        action: SnackBarAction(
          label: '',
          onPressed: () {
            // Some code to undo the change.
          },
        ),
        content: Text(
          "Kayıt İşlemi Tamamlandı",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else if (sayi == 0) {
      final snackBar = SnackBar(
        action: SnackBarAction(
          label: '',
          onPressed: () {
            // Some code to undo the change.
          },
        ),
        content: Text(
          "Bu isimde şirket mevcut ",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      final snackBar = SnackBar(
        action: SnackBarAction(
          label: '',
          onPressed: () {
            // Some code to undo the change.
          },
        ),
        content: Text(
          "Hata Oluştu ",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  //**************************************************************************
  //*** FOTOĞRAF SEÇİMİ İÇİN DİALOG PENCERESİNİN AÇILMASI ***
  fotografSec() {
    return showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: Text("Gönderi Oluştur"),
          children: [
            SimpleDialogOption(
              child: Text("Fotoğraf Çek"),
              onPressed: () {
                fotoCek();
                Navigator.of(context).pop();
              },
            ),
            SimpleDialogOption(
              child: Text("Galeriden Yükle"),
              onPressed: () {
                galeridenSec();
                Navigator.of(context).pop();
              },
            ),
            SimpleDialogOption(
              child: Text("İptal"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  //**************************************************************************
  //*** KAMERA KULLANARAK FOTOĞRAF ÇEKME ***
  fotoCek() async {
    //Fotoğraf çek seçeneğine tıklandığında dialog penceresinin kapanmasını sağlar

    /* ImageSource.camera: Fotoğrafın kamera çekimiyle geleceğini belirtir.
    maxWidth: Fotoğrafın maksimum genişliği
    maxHeight: Fotoğrafın maksimum boyu
    imageQualityFotoğrafın kalitesi(0-100 arası değer alır.
    değer yükseldikçe fotoğraf kalitesi artar)
    */
    var image = await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 80);

    setState(() {
      dosya = File(image.path);
    });
  }

  //**************************************************************************
  //*** GALERİDEN FOTOĞRAF SEÇME ***
  galeridenSec() async {
    var image = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 80);

    setState(() {
      dosya = File(image.path);
    });
  }

  //**************************************************************************
  // *** YÜKLEME ANİMASYONU ***
  Widget yuklemeAnimasyonu() {
    if (yukleniyor) {
      return Center(
          child: CircularProgressIndicator(
        backgroundColor: Colors.blue,
      ));
    } else {
      return SizedBox(
        height: 0,
      );
    }
  }
}
