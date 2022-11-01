import 'dart:io';

import 'package:fiacre_driver_app/configMaps.dart';
import 'package:fiacre_driver_app/main.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

class PushNotificationService {
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  Future initialize() async {
    //onMessage
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("onMassage: $message");
    });

    //onLaunch
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      print("onMassage: $initialMessage");
    }

    //onResume
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("onResume: $message");
    });
  }

  Future<String?> getToken() async {
    String? token = await firebaseMessaging.getToken();
    print("This is Token:");
    print(token);
    driversRef.child(currentfirebaseUser!.uid).child("token").set(token);
    firebaseMessaging.subscribeToTopic("alldrivers");
    firebaseMessaging.subscribeToTopic("allusers");
  }
}
