import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'main_inherited.dart';
import 'sayfalar/anasayfa.dart';
import 'servisler/bildirim_servisi.dart';
import 'servisler/yetki_sayfasi.dart';


Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
}


void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {


//********************************************************
  /*Future<void> gelenBildirimiYakala() async {
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
  }*/
 //***********************************************************************************************

  /*void _bildirimiIsle(RemoteMessage bildirim) {
    // gelen her bildirimin data kısmında tip anahtarına bağlı bir değer olduğunu varsayıyoruz
    if(bildirim.data['kategori']!=null) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) {
              if (bildirim.data['kategori'] == "Alışveriş") {
                return AlisVerisListele();
              }else if (bildirim.data['kategori'] == "Araç") {
                return AracListele();
              }else if (bildirim.data['kategori'] == "Diğer") {
                return DigerListele();
              }else if (bildirim.data['kategori'] == "Giyim") {
                return GiyimListele();
              }else if (bildirim.data['kategori'] == "Sağlık") {
                return SaglikListele();
              }else if (bildirim.data['kategori'] == "Seyahat") {
                return SeyahatListele();
              }else if (bildirim.data['kategori'] == "Yemek") {
                return YemekListele();
              }else if (bildirim.data['kategori'] == "Etkinlik") {
                return EtkinlikListele();
              }else  {
                return EgitimListele();
              }
            }

        ),
      );
    }
  }*/

  //***********************************************************************************************


  @override
  void initState() {
    super.initState();

    /*NotificationApi.init();
    listenNotifications();*/
  }

  /*void listenNotifications() =>
      NotificationApi.onNotifications.stream.listen(null);*/
  @override
  Widget build(BuildContext context) {
    return Provider<YetkilendirmeServisi>(//Paylaşıma açılan servis
      create: (_)=> YetkilendirmeServisi(),
      child: MainInherited(
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
        home: AnaSayfa(),
        ),
        bildirimServisi: BildirimServisi(),
      ),
    );
  }
}

/*
SplashScreen(
          seconds: 5,
          navigateAfterSeconds: AnaSayfa(),
          title: Text(
            'Eskişehir ESB İndirim',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
          ),
          image: Image.asset(
              'images/egitimbirsen_logo.jpg'),
          backgroundColor: Colors.white,
          styleTextUnderTheLoader: TextStyle(),
          photoSize: 200.0,
          loaderColor: Colors.black),
          */