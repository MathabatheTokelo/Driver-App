import 'package:fiacre_driver_app/Screens/RegistrationScreen.dart';
import 'package:fiacre_driver_app/Screens/mainscreen.dart';
import 'package:fiacre_driver_app/configMaps.dart';
import 'package:fiacre_driver_app/main.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class carDetailsSCreen extends StatelessWidget {
  static const String idScreen = "carInfo";
  TextEditingController carModelTextEditingController = TextEditingController();
  TextEditingController carNumberTextEditingController =
      TextEditingController();
  TextEditingController carColourTextEditingController =
      TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 22.0,
            ),
            Image.asset(
              "images/logo.png",
              width: 390.0,
              height: 250.0,
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(22.0, 22.0, 22.0, 32.0),
              child: Column(
                children: [
                  SizedBox(
                    height: 12.0,
                  ),
                  Text(
                    "Enter CAr Details",
                    style: TextStyle(fontFamily: "Brand-Bold", fontSize: 24.0),
                  ),
                  SizedBox(
                    height: 26.0,
                  ),
                  TextField(
                    controller: carModelTextEditingController,
                    decoration: InputDecoration(
                        labelText: "Car Model",
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 10.0,
                        )),
                    style: TextStyle(fontSize: 15.0),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  TextField(
                    controller: carNumberTextEditingController,
                    decoration: InputDecoration(
                        labelText: "Car Number",
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 10.0,
                        )),
                    style: TextStyle(fontSize: 15.0),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  TextField(
                    controller: carColourTextEditingController,
                    decoration: InputDecoration(
                        labelText: "Car Colour",
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 10.0,
                        )),
                    style: TextStyle(fontSize: 15.0),
                  ),
                  SizedBox(
                    height: 42.0,
                  ),
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: RaisedButton(
                        onPressed: () {
                          if (carModelTextEditingController.text.isEmpty) {
                            displayToastMessage(
                                "Please enter car Model", context);
                          } else if (carNumberTextEditingController
                              .text.isEmpty) {
                            displayToastMessage(
                                "Please enter car Number", context);
                          } else if (carColourTextEditingController
                              .text.isEmpty) {
                            displayToastMessage(
                                "Please enter car colour", context);
                          } else {
                            saveCarDetails(context);
                          }
                        },
                        color: Theme.of(context).accentColor,
                        child: Padding(
                          padding: EdgeInsets.all(17.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "NEXT",
                                style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              Icon(
                                Icons.arrow_forward,
                                color: Colors.white,
                                size: 26.0,
                              )
                            ],
                          ),
                        ),
                      ))
                ],
              ),
            )
          ],
        ),
      )),
    );
  }

  void saveCarDetails(context) {
    String userId = currentfirebaseUser!.uid;
    Map carInfoMap = {
      "car_colour": carColourTextEditingController.text,
      "car_number": carNumberTextEditingController.text,
      "car_model": carModelTextEditingController.text,
    };

    driversRef.child(userId).child("car_details").set(carInfoMap);
    Navigator.pushNamedAndRemoveUntil(
        context, MainScreen.idScreen, (route) => false);
  }
}
