importScripts(
  "https://www.gstatic.com/firebasejs/10.7.0/firebase-app-compat.js"
);

importScripts(
  "https://www.gstatic.com/firebasejs/10.7.0/firebase-messaging-compat.js"
);

firebase.initializeApp({
  apiKey: "AIzaSyA1vIE_5UdhHrd7o1Sb8tIoiXscUMmBq9w",
  authDomain: "flutter-projectse1-d670f.firebaseapp.com",
  projectId: "flutter-projectse1-d670f",
  storageBucket: "flutter-projectse1-d670f.firebasestorage.app",
  messagingSenderId: "1098959539670",
  appId: "1:1098959539670:web:0799fce4dd83468654a877",
});

const messaging = firebase.messaging();

messaging.onBackgroundMessage((payload) => {
  console.log("Background message received:", payload);
});