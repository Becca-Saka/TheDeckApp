import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:thedeck/app/locator.dart';
import 'package:thedeck/myapp.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _appInitialization();

  runApp(const MyApp());
}

Future<void> _appInitialization() async {
  await Firebase.initializeApp();
  if (useEmulator) {
    await _connectToFirebaseEmulator();
  }
  setupLocator();
  _askNotifPermission();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    log('Got a message whilst in the foreground!');
    log('Message data: ${message.data}');

    if (message.notification != null) {
      log('Message also contained a notification: ${message.notification}');
    }
  });
}

const bool useEmulator = false;

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async =>
    log(" message Handling a background message: ${message.messageId}");

Future<void> _askNotifPermission() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  messaging.getNotificationSettings().then((settings) async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      criticalAlert: true,
    );

    if (settings.authorizationStatus != AuthorizationStatus.authorized ||
        settings.authorizationStatus != AuthorizationStatus.provisional) {
      await messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
    }
  });
}

Future<void> _connectToFirebaseEmulator() async {
  const firestorePort = '8080';
  const authPort = 9099;
  const storagePort = 9199;
  final localHost = Platform.isAndroid ? '10.0.2.2' : '127.0.0.1';
  FirebaseFirestore.instance.settings = Settings(
    host: '$localHost:$firestorePort',
    sslEnabled: false,
  );
  await FirebaseAuth.instance.useAuthEmulator(localHost, authPort);
  await FirebaseStorage.instance.useStorageEmulator(localHost, storagePort);
  log('Connected to Firebase emulator');
  log('Firestore: ${FirebaseFirestore.instance.settings.host}');
}
