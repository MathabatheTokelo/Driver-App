import 'package:fiacre_driver_app/DataHandler/appData.dart';
import 'package:fiacre_driver_app/Screens/RegistrationScreen.dart';
import 'package:fiacre_driver_app/Screens/carDetailsScreen.dart';
import 'package:fiacre_driver_app/Screens/loginscreen.dart';
import 'package:fiacre_driver_app/Screens/mainscreen.dart';
import 'package:fiacre_driver_app/configMaps.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

DatabaseReference usersRef =
    FirebaseDatabase.instance.reference().child("users");
DatabaseReference driversRef =
    FirebaseDatabase.instance.reference().child("drivers");
DatabaseReference rideRequestRef = FirebaseDatabase.instance
    .reference()
    .child("drivers")
    .child(currentfirebaseUser!.uid)
    .child("newRide");

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppData(),
      child: MaterialApp(
        title: 'Fiacre Driver App',
        theme: ThemeData(
          fontFamily: "Border Bold",
          primarySwatch: Colors.blueGrey,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: FirebaseAuth.instance.currentUser == null
            ? LoginScreen.idScreen
            : MainScreen.idscreen,
        routes: {
          RegistrationScreenn.idScreen: (context) => RegistrationScreenn(),
          LoginScreen.idScreen: (context) => LoginScreen(),
          MainScreen.idscreen: (context) => MainScreen(),
          carDetailsSCreen.idScreen: (context) => carDetailsSCreen(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
