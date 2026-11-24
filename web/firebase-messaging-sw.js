
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

// Menangani klik notifikasi.
self.addEventListener("notificationclick", (event) => {
  console.log("Notification clicked:", event.notification);

  event.notification.close();

  const notificationData = {
    title: event.notification.title || "-",
    body: event.notification.body || "-",
    ...(event.notification.data || {}),
  };

  const targetUrl = self.location.origin + self.location.pathname;

  event.waitUntil(
    clients.matchAll({
      type: "window",
      includeUncontrolled: true,
    }).then((clientList) => {
      for (const client of clientList) {
        if ("focus" in client) {
          return client.focus().then((focusedClient) => {
            focusedClient.postMessage({
              type: "FCM_NOTIFICATION_CLICK",
              data: notificationData,
            });

            return focusedClient;
          });
        }
      }

      return clients.openWindow(
        targetUrl +
        "?notification=" +
        encodeURIComponent(JSON.stringify(notificationData))
      );
    })
  );
});
