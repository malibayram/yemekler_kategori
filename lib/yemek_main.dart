import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:yemekler/main_inherited.dart';

import 'admin_page.dart';
import 'yemek_detay.dart';
import 'yemek_partlar/ana_yemekler.dart';
import 'yemek_partlar/sulu_yemekler.dart';
import 'yemek_partlar/tatlilar.dart';

class FoodMain extends StatefulWidget {
  const FoodMain({Key? key}) : super(key: key);

  @override
  _FoodMainState createState() => _FoodMainState();
}

class _FoodMainState extends State<FoodMain> {
  // Bu alttaki metot uygulamanın ilk Widgetı içine yerleştirilecek ve sadece bir sefer yazılacak
  // Burada bildirimi yakalayabilmek için beklemeye başlıyoruz
  Future<void> gelenBildirimiYakala() async {
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
  }

  // Yukarıdaki metodun yakaladığı mesajı biz alttaki metotta işliyoruz.
  void _bildirimiIsle(RemoteMessage bildirim) {
    // gelen her bildirimin data kısmında tip anahtarına bağlı bir değer olduğunu varsayıyoruz
    if (bildirim.data['tip'] == 'Ana Yemekler') {
      /* Navigator.pushNamed(
        context,
        '/chat',
        arguments: ChatArguments(bildirim),
      ); */
      partIndex = 0;
    } else if (bildirim.data['tip'] == 'Sulu Yemekler') {
      partIndex = 1;
    } else if (bildirim.data['tip'] == 'Tatlılar') {
      partIndex = 2;
    }

    setState(() {});

    // Sayfaya yönlenmek istiyorsan alttakini yorumdan çıkar
    if (bildirim.data['tip'] != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) {
            if (bildirim.data.containsKey('yemek-id')) {
              return YemekDetay(yemekId: bildirim.data['yemek-id']);
            } else {
              return AnaYemekler(
                kategori: bildirim.data['tip'],
                mesaj: bildirim,
              );
            }
          },
        ),
      );
    }

    /* final tipler = [
      "Ana Yemekler",
      "Sulu Yemekler",
      "Tatlılar",
    ];

    partIndex = tipler.indexOf(bildirim.data['tip']); */

    /* switch (bildirim.data['tip']) {
      case 'Ana Yemekler':
        partIndex = 0;
        break;
      case 'Sulu Yemekler':
        partIndex = 1;
        break;
      case 'Tatlılar':
        partIndex = 2;
        break;

      default:
    } */
  }

  int partIndex = 0;

  final partlar = [
    const AnaYemekler(),
    const SuluYemekler(),
    const Tatlilar(),
  ];

  /* @override
  void didChangeDependencies() {
    gelenBildirimiYakala();

    super.didChangeDependencies();
  } */

  @override
  void initState() {
    gelenBildirimiYakala();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bildirimServisi = MainInherited.of(context).bildirimServisi;

    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("Yemekler"),
              actions: [
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AdminPage(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.android_sharp),
                ),
              ],
            ),
            body: partlar[partIndex],
            bottomNavigationBar: BottomNavigationBar(
              onTap: (i) => setState(() => partIndex = i),
              currentIndex: partIndex,
              items: const [
                BottomNavigationBarItem(
                  label: "Ana Yemekler",
                  icon: Icon(Icons.food_bank),
                ),
                BottomNavigationBarItem(
                  label: "Sulu Yemekler",
                  icon: Icon(Icons.food_bank_rounded),
                ),
                BottomNavigationBarItem(
                  label: "Tatlılar",
                  icon: Icon(Icons.food_bank_outlined),
                ),
              ],
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

            // c8KSyhumRdwQztpVg3B9uh:APA91bEZpLyyADCGkCkfYwCipauYY1cSRMl0cebM1fBAnNznEP
            // 3QUd83rCf8sM9HAH71Wecz3IG5DJazISCzYqoOyHCiZ38duJXhEy_8Mw2WDw9_haXEjPtaoYNIQnz7XDgVh4PpwLM6
          }

          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
