const functions = require("firebase-functions");

const admin = require('firebase-admin');
admin.initializeApp(functions.config().firebase);

const db = admin.firestore();
const fcm = admin.messaging();

exports.yemekEklendi = functions.firestore.document('yemekler/{baslik}').onCreate(async doc => {
    const baslik = doc.data().baslik;
    const tip = doc.data().tip;
    const yemekResmi = doc.data().yemekResmi;

    const usersDocs = await db.collection('users').get();
    let tokens = [];
    usersDocs.docs.forEach(e => {
        if (e.exists && e.data().fcmTokens !== null) {
            e.data().fcmTokens.forEach(t => {
                tokens.push(t);
            });
        }
    });

    // bildirim nesnesi
    const bildirim = {
        /* topic: "tum-kategoriler", */
        tokens: tokens,
        data: { baslik: baslik, tip: tip },
        notification: {
            title: "Yeni bir içerik eklendi",
            body: `${tip} kategorisine ${baslik} başlıklı yeni bir yemek eklendi`,
            imageUrl: yemekResmi,
        }
    };

    return await fcm.send(bildirim);
});