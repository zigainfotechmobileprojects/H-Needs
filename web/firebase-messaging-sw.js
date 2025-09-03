importScripts("https://www.gstatic.com/firebasejs/8.10.1/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/8.10.1/firebase-messaging.js");

firebase.initializeApp({
    apiKey: "AIzaSyD_enklb-zEU463fNn5pWtq_3lsNjG5IVU",
    authDomain: "h-needs.firebaseapp.com",
    projectId: "h-needs",
    storageBucket: "h-needs.firebasestorage.app",
    messagingSenderId: "421155415173",
    appId: "1:421155415173:web:616b091aad716eb75e75ec",
    measurementId: "G-KCKXJ4VKPH"
    // apiKey: "AIzaSyBCtDfdfPqxXDO6rDNlmQC1Otuyo3w",
    // authDomain: "gem-b5006.firebaseapp.com",
    // projectId: "gem-b5006",
    // storageBucket: "gem-b5006.appspot.com",
    // messagingSenderId: "384321080318",
    // appId: "1:384321080318:web:9cf2ec90f41dfb8a2c0eaf",
    // measurementId: "G-RQ899NQVHN",
});

const messaging = firebase.messaging();

messaging.setBackgroundMessageHandler(function (payload) {
    const promiseChain = clients
        .matchAll({
            type: "window",
            includeUncontrolled: true
        })
        .then(windowClients => {
            for (let i = 0; i < windowClients.length; i++) {
                const windowClient = windowClients[i];
                windowClient.postMessage(payload);
            }
        })
        .then(() => {
            const title = payload.notification.title;
            const options = {
                body: payload.notification.score
              };
            return registration.showNotification(title, options);
        });
    return promiseChain;
});
self.addEventListener('notificationclick', function (event) {
    console.log('notification received: ', event)
});