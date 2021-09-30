const functions = require("firebase-functions");

const admin = require('firebase-admin');
admin.initializeApp(functions.config().firebase);

const db = admin.firestore();
const fcm = admin.messaging();

exports.yemekEklendi = functions.firestore.document('yemekler/{baslik}').onCreate(async doc => {
    const baslik = doc.data().baslik;
    const tip = doc.data().tip;
    const yemekResmi = doc.data().yemekResmi;

    /* const usersDocs = await db.collection('users').get();
    let tokens = [];
    usersDocs.docs.forEach(e => {
        if (e.exists && e.data().fcmTokens !== null) {
            e.data().fcmTokens.forEach(t => {
                tokens.push(t);
            });
        }
    }); */

    // bildirim nesnesi
    const bildirim = {
        topic: "tum-kategoriler",
        /* tokens: tokens, */
        data: { baslik: baslik, tip: tip, 'yemek-id': doc.id },
        notification: {
            title: "Yeni bir içerik eklendi",
            body: `${tip} kategorisine ${baslik} başlıklı yeni bir yemek eklendi`,
            imageUrl: yemekResmi,
        }
    };

    return await fcm.send(bildirim);
});

/*
Data  kısmı aşağıdaki örneğe göre yapılacak
final data = {
            'kategori': widget.appBarAl,
            'firmaAdi': _firmaAdi.text,
            'coll-id': widget.kategoriAl,
            'detay-id': _firmaAdi.text,
        };
 */


// 1. bildirimle 2. sayfaya push olma
// 2. Bulut İşlemleri kurulumu
// 3. web butonunu gösterme

// firebase functions kurulum adımları

/*
1. chocolatey kurulumu =>
  PowerShell'i yönetici olarak açıyoruz.
  https://chocolatey.org/install =>
  bu satırın devamını kopyalayıp PowerShell'e yapıştırıyoruz:
  - Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
2. nodejs kurulumu => bu satırın devamını kopyalayıp PowerShell'e yapıştırıyoruz:
  - choco install nodejs
3. firebase'i global olarak kurma => bu satırın devamını kopyalayıp PowerShell'e yapıştırıyoruz:
  - npm install -g firebase-tools
4. Bulut İşlemleriları oluşturuyoruz biz firebase isminde oluşturmuştuk.
  terminalden klasöre giderek ilk defa kullanıyorsak
  - firebase login
  sonrasında
  - firebase init
  Bulut İşlemleriları kullanacağımız projeyi seçiyoruz (exists projects seçeneği). sonrasında ok tuşları ile aşağı inip functions seçeneğini space tuşu ile işaretleyip enter'a basıyoruz.
  javascript seçip devam ediyoruz.

5. Bütün işlem kodlarını yazdıktan sonra işlemleri buluta göndermek için terminalde
  - firebase deploy
  Yazıp enter'a basıyoruz.
*/