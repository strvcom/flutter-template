importScripts("https://www.gstatic.com/firebasejs/11.7.0/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/11.7.0/firebase-messaging.js");

firebase.initializeApp({
    apiKey: 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX',
    authDomain: 'helu-flutter-template.firebaseapp.com',
    projectId: 'helu-flutter-template',
    storageBucket: 'helu-flutter-template.appspot.com',
    messagingSenderId: 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX',
    appId: 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX',
    measurementId: 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX',
});

const messaging = firebase.messaging();

messaging.onBackgroundMessage(function (payload) {
    console.log('Received background message ', payload);
})
