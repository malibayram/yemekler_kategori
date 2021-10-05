import 'package:anlasmalar/servisler/bildirim_detay_sayfasina_git.dart';
import 'package:anlasmalar/servisler/etkinlik_detay_sayfasina_git.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import '../ListelenecekKategoriler/alisveris_listele.dart';
import '../ListelenecekKategoriler/arac_listele.dart';
import '../ListelenecekKategoriler/diger_listele.dart';
import '../ListelenecekKategoriler/egitim_listele.dart';
import '../ListelenecekKategoriler/etkinlik_listele.dart';
import '../ListelenecekKategoriler/giyim_listele.dart';
import '../ListelenecekKategoriler/saglik_liste.dart';
import '../ListelenecekKategoriler/seyahat_liste.dart';
import '../ListelenecekKategoriler/yemek_liste.dart';
import '../main_inherited.dart';
import 'eposta.dart';
import 'yonetim_kurulu.dart';
import 'yonlendirme.dart';

class AnaSayfa extends StatefulWidget {
  @override
  State<AnaSayfa> createState() => _AnaSayfaState();
}

class _AnaSayfaState extends State<AnaSayfa> {
  String url;

  // Bu alttaki metot uygulamanın ilk Widgetı içine yerleştirilecek ve sadece bir sefer yazılacak
  // Burada bildirimi yakalayabilmek için beklemeye başlıyoruz

  //*********************************************************************************
  Future<void> gelenBildirimiYakala() async {
    print("gelenBildirimiYakala + ${DateTime.now()}");
    // Uygulama terminated (ölü) durumunda ise bildirime tıklanması sonucu uygulama dirilecek
    // ve bildirim mesajını bu şekilde yakalayacağız
    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();

    // uygulama bildirimden değil de normal bir şekilde açıldıysa herhangi birşey yakalayamayacağız
    // o zaman bildirimi işlemeye gerek yok
    if (initialMessage != null) {
      _bildirimiIsle(initialMessage);
    }

    // Burada da uygulama arkaplanda çalışıyorken gelen bildirime tıklanarak açıldıysa bildirimi yakalıyoruz
    // ve işleme fonksiyonuna iletiyoruz.
    FirebaseMessaging.onMessageOpenedApp.listen(_bildirimiIsle);
    print("gelenBildirimiYakala + ${DateTime.now()}");
  }

//*********************************************************************************
  // Yukarıdaki metodun (gelenBildirimiYakala) yakaladığı mesajı biz alttaki metotta işliyoruz.
  void _bildirimiIsle(RemoteMessage bildirim) {
    print("_bildirimiIsle + ${DateTime.now()}");
    // gelen her bildirimin data kısmında tip anahtarına bağlı bir değer olduğunu varsayıyoruz
    if (bildirim.data['kategori'] != null) {
      final detayId = bildirim.data['detay-id'];
      final collId = bildirim.data['coll-id'];
      final bildirimTipi = bildirim.data['bildirim-tipi'];

      if (detayId != null) {
        // Yöntem 1: bunu burada kullanınca kullanıcı geri butonuna basarsa anasayfaya döner
        if (bildirimTipi == 'anlasma') {
          direkDetayaGit(
            kategori: bildirim.data['kategori'],
            detayId: detayId,
            context: context,
            collId: collId,
          );
        } else if (bildirimTipi == 'etkinlik') {
          direkEtkinlikDetayaGit(
            kategori: "Etkinlik",
            detayId: detayId,
            context: context,
            collId: collId,
          );
        }
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) {
              if (bildirim.data['kategori'] == "Alışveriş") {
                return AlisVerisListele(detayId: detayId);
              } else if (bildirim.data['kategori'] == "Araç") {
                return AracListele(detayId: detayId);
              } else if (bildirim.data['kategori'] == "Diğer") {
                return DigerListele(detayId: detayId);
              } else if (bildirim.data['kategori'] == "Giyim") {
                return GiyimListele(detayId: detayId);
              } else if (bildirim.data['kategori'] == "Sağlık") {
                return SaglikListele(detayId: detayId);
              } else if (bildirim.data['kategori'] == "Seyahat") {
                return SeyahatListele(detayId: detayId);
              } else if (bildirim.data['kategori'] == "Yemek") {
                return YemekListele(detayId: detayId);
              } else if (bildirim.data['kategori'] == "Etkinlik") {
                return EtkinlikListele(detayId: detayId);
              } else {
                return EgitimListele(detayId: detayId);
              }
            },
          ),
        );
      }
    }
    print("_bildirimiIsle + ${DateTime.now()}");
    print("bildirim.data");
    print(bildirim.data);
  }
//*********************************************************************************

  @override
  void initState() {
    super.initState();

    gelenBildirimiYakala();
  }

  @override
  Widget build(BuildContext context) {
    final bildirimServisi = MainInherited.of(context).bildirimServisi;

    return StreamBuilder<User>(
        stream: FirebaseAuth.instance.authStateChanges(),
        // ignore: missing_return
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                title: Center(
                  child: const Text("Eskişehir Eğitim Birsen Anlaşmaları"),
                ),
                backgroundColor: Colors.indigo.shade900,
              ),
              body: ListView(
                children: [
                  Container(
                    child: Image.asset("images/memursen.jpg"),
                  ),
                  Center(
                    child: Text(
                      "Anlaşmalar",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo.shade900,
                        shadows: [
                          Shadow(color: Colors.black12, offset: Offset(5, 5)),
                          Shadow(
                              color: Colors.indigo,
                              blurRadius: 15,
                              offset: Offset(10, 10))
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    EgitimListele(),
                              ),
                            );
                          },
                          child: buildCircleAvatar(context,
                              yazi: "EĞİTİM", icon: Icons.date_range),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    SaglikListele(),
                              ),
                            );
                          },
                          child: buildCircleAvatar(context,
                              yazi: "SAĞLIK",
                              icon: Icons.airline_seat_individual_suite_sharp),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    GiyimListele(),
                              ),
                            );
                          },
                          child: buildCircleAvatar(context,
                              yazi: "GİYİM", icon: Icons.dry_cleaning),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    AlisVerisListele(),
                              ),
                            );
                          },
                          child: buildCircleAvatar(context,
                              yazi: "ALIŞVERİŞ", icon: Icons.shopping_cart),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    YemekListele(),
                              ),
                            );
                          },
                          child: buildCircleAvatar(context,
                              yazi: "YEMEK", icon: Icons.restaurant_menu),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    AracListele(),
                              ),
                            );
                          },
                          child: buildCircleAvatar(context,
                              yazi: "ARAÇ", icon: Icons.car_repair),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    SeyahatListele(),
                              ),
                            );
                          },
                          child: buildCircleAvatar(context,
                              yazi: "SEYAHAT", icon: Icons.card_travel),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    EtkinlikListele(),
                              ),
                            );
                          },
                          child: buildCircleAvatar(context,
                              yazi: "ETKİNLİKLER", icon: Icons.card_travel),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    DigerListele(),
                              ),
                            );
                          },
                          child: buildCircleAvatar(context,
                              yazi: "DİĞER", icon: Icons.north_east),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              drawer: Drawer(
                child: Column(
                  children: <Widget>[
                    Container(
                      color: Colors.indigo.shade900,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 40),
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: MediaQuery.of(context).size.width / 9,
                              child: Image.asset(
                                "images/logo2.png",
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Center(
                            child: Text(
                              "ESKİŞEHİR EĞİTİM BİR SEN",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                        ],
                      ),
                    ),

                    //Menünün oluşturulduğu kısım
                    Expanded(
                      child: ListView(
                        children: <Widget>[
                          ListTile(
                            leading: Image.asset(
                              "images/egitimbirsen_logo.jpg",
                              height: 40,
                              width: 40,
                            ),
                            title: Text(
                              "Yönetim Kurulu",
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => YonetimKurulu()));
                            },
                          ),
                          Divider(
                            color: Colors.grey,
                          ),
                          buildListTile(
                              isim: "Instagram",
                              logo: "images/instagram_logo.png",
                              url: 'https://www.instagram.com/memursenkonf/'),
                          Divider(
                            color: Colors.grey,
                          ),
                          buildListTile(
                              isim: "Twitter",
                              logo: "images/twitter_logo1.png",
                              url: "https://twitter.com/EgitimBirSen"),
                          Divider(
                            color: Colors.grey,
                          ),
                          buildListTile(
                              isim: "Facebook",
                              logo: "images/face_logo.png",
                              url: "https://www.facebook.com/egitimbirsen"),
                          Divider(
                            color: Colors.grey,
                          ),
                          buildListTile(
                              isim: "Telefon",
                              logo: "images/telefon_logo1.png",
                              url: "tel:+90 5055760948"),
                          Divider(
                            color: Colors.grey,
                          ),
                          //Email
                          ListTile(
                            leading: Image.asset(
                              "images/eposta_logo.png",
                              height: 40,
                              width: 40,
                            ),
                            title: Text(
                              "Email",
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => EmailSender()));
                            },
                          ),
                          Divider(
                            color: Colors.grey,
                          ),
                          ListTile(
                            leading: Image.asset(
                              "images/harita_logo.png",
                              height: 40,
                              width: 40,
                            ),
                            title: Text(
                              "Adres",
                            ),
                            onTap: () {
                              //position: LatLng(39.770404, 30.5167063),
                              /* Navigator.push(context, MaterialPageRoute(
                                  builder: (context) => Maps()));*/
                              launch("https://goo.gl/maps/68ABeX4rEVV96DwM6");
                            },
                          ),
                          Divider(
                            color: Colors.grey,
                          ),

                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Container(
                                  child: Text(
                                    "Designed by Oğuz Rakıcı",
                                    textAlign: TextAlign.end,
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.indigo.shade900),
                                  ),
                                ),
                                SizedBox(
                                  height: 3,
                                ),
                                Container(
                                  child: Text(
                                    "İletişim: 0505 576 09 48",
                                    textAlign: TextAlign.end,
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.indigo.shade900),
                                  ),
                                )
                              ],
                            ),
                          ),

                          SizedBox(
                            height: 200,
                          ),
                          ListTile(
                            leading: Image.asset("images/admin_logo.png"),
                            title: Text("Yönetici Girişi"),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Yonlendirme(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            if (FirebaseAuth.instance.currentUser == null) {
              FirebaseAuth.instance.signInAnonymously();
            } else {
              bildirimServisi.izinAl();

              // kişiler oturum açarak uygulamayı kullanmıyorsa alt satırdaki kod TAMAMEN gereksiz
              bildirimServisi.jetonAlKaydet();

              bildirimServisi.bildirimSistemineAboneOl();

              if (!kIsWeb) {
                bildirimServisi.konuyaAboneOl('tum-kategoriler');
              }
            }
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        });
  }

  Widget buildListTile({String isim, String logo, String url}) {
    return ListTile(
      title: Text(
        isim,
        style: TextStyle(fontSize: 15),
      ),
      onTap: () {
        launchURL(url: url);
      },
      leading: Image.asset(
        logo,
        height: 40,
        width: 40,
      ),
    );
  }

  Widget buildCircleAvatar(BuildContext context, {String yazi, IconData icon}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(70)),
        boxShadow: [
          BoxShadow(
              color: Colors.indigo, offset: Offset(15, 15), blurRadius: 20)
        ],
      ),
      child: CircleAvatar(
        radius: MediaQuery.of(context).size.width / 8,
        backgroundColor: Colors.indigo.shade900,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon),
            SizedBox(
              height: 5,
            ),
            Text(
              yazi,
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Future<String> linkAl() async {
    var link;
    link = await http.get(Uri.parse("https://www.instagram.com/memursenkonf/"));
    setState(() {
      url = link;
      print(url);
    });
    return url;
  }

  Future<void> launchURL({String url}) async =>
      await canLaunch(url) ? await launch(url) : print("Bir sorun oluştu");
}
