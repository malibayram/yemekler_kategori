importScripts("https://www.gstatic.com/firebasejs/8.6.1/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/8.6.1/firebase-messaging.js");

var firebaseConfig = {
    apiKey: "AIzaSyBVUfWhjoSz9e-9DtuKhzrBfHWr_MFOTNE",
    authDomain: "yemekkategori.firebaseapp.com",
    projectId: "yemekkategori",
    storageBucket: "yemekkategori.appspot.com",
    messagingSenderId: "497457137879",
    appId: "1:497457137879:web:885094ebb871b043150892",
    measurementId: "G-656CFWRRYW",
};

// Initialize Firebase
firebase.initializeApp(firebaseConfig);
// Necessary to receive background messages:
const messaging = firebase.messaging();

// Optional:
messaging.onBackgroundMessage((m) => {
    console.log("onBackgroundMessage", m);
});