import 'dart:async';

import 'package:fiacre_driver_app/DataHandler/Models/allUsers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';

String mapKey = "AIzaSyAqNTyL2pxuryBOnkNApWU257me8961uKQ";
User? firebaseUser;
Users? userCurrentInfo;
StreamSubscription<Position>? homeTabPageStreamSubscription;
User? currentfirebaseUser;
