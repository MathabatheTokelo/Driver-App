import 'dart:async';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:fiacre_driver_app/Assistants/assistantMethods.dart';
import 'package:fiacre_driver_app/DataHandler/Models/directionDetails.dart';
import 'package:fiacre_driver_app/DataHandler/appData.dart';
import 'package:fiacre_driver_app/Screens/loginscreen.dart';
import 'package:fiacre_driver_app/Screens/searchScreen.dart';
import 'package:fiacre_driver_app/Widgets/progressDialog.dart';
import 'package:fiacre_driver_app/configMaps.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  static const String idScreen = "mainScreen";
  MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreen();
}

class _MainScreen extends State<MainScreen> with TickerProviderStateMixin {
  Completer<GoogleMapController> _controllerGoogleMap = Completer();
  late GoogleMapController newGoogleMapController;

  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  var tripDirectionDetails;

  List<LatLng> plineCoordinates = [];
  Set<Polyline> polylineSet = {};
  Position? currentPosition;
  var geoLocator = Geolocator();
  double bottomPaddingOfMap = 0;

  Set<Marker> markersSet = {};
  Set<Circle> circlesSet = {};

  static const colorizeColors = [
    Colors.purple,
    Colors.blue,
    Colors.yellow,
    Colors.red,
    Colors.green,
  ];

  static const colorizeTextStyle = TextStyle(
    fontSize: 40.0,
    fontFamily: 'Horizon',
  );

  double rideDetailsContainerHeight = 0;
  double searchContainerHeight = 300;
  double requestRideContainerHeight = 0;

  bool drawerOpen = true;

  late DatabaseReference rideRequestReference;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    AssistantMethods.getCurrentOnLineUserInfo();
  }

  void saveRideRequest() {
    rideRequestReference =
        FirebaseDatabase.instance.reference().child("Ride Request");
    var pickUp = Provider.of<AppData>(context, listen: false).pickUpLocation;
    var dropOff = Provider.of<AppData>(context, listen: false).dropOffLocation;
    Map pickUpLocationMap = {
      "latitude": pickUp!.latitude.toString(),
      "longitudde": pickUp.longitude.toString(),
    };

    Map dropOffLocationMap = {
      "latitude": dropOff!.latitude.toString(),
      "longitudde": dropOff.longitude.toString(),
    };

    Map rideInfoMap = {
      "driver_id": "waiting",
      "payment_method": "cash",
      "pickup": pickUpLocationMap,
      "dropOff": dropOffLocationMap,
      "created_at": DateTime.now().toString(),
      "rider_name": userCurrentInfo!.name,
      "rider_phone": userCurrentInfo!.phone,
      "pickup_address": pickUp.placeName,
      "dropoff address": dropOff.placeName,
    };
    rideRequestReference.push().set(rideInfoMap);
  }

  void cancelRideRequest() {
    rideRequestReference.remove();
  }

  void displayRequestContainer() {
    setState(() {
      requestRideContainerHeight = 250;
      rideDetailsContainerHeight = 0;
      bottomPaddingOfMap = 230;
      drawerOpen = true;
    });
    saveRideRequest();
  }

  resetApp() {
    setState(() {
      drawerOpen = true;
      searchContainerHeight = 0;
      rideDetailsContainerHeight = 0;
      requestRideContainerHeight = 0;
      bottomPaddingOfMap = 230.0;
      polylineSet.clear();
      markersSet.clear();
      circlesSet.clear();
      plineCoordinates.clear();
    });
    locatePosition();
  }

  void displayRideDetailsContainer() async {
    await getPlaceDirection();
    setState(() {
      searchContainerHeight = 0;
      rideDetailsContainerHeight = 240.0;
      bottomPaddingOfMap = 230.0;
      drawerOpen = false;
    });
  }

  void locatePosition() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;

    LatLng latLngPosition = LatLng(position.latitude, position.longitude);
    CameraPosition cameraPosition =
        new CameraPosition(target: latLngPosition, zoom: 14);
    newGoogleMapController
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    String address =
        await AssistantMethods.searchCoordinateAddress(position, context);
    print("This is your Address :: " + address);
  }

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(title: const Text("Fiacre")),
      drawer: Container(
        color: Colors.white,
        width: 255.0,
        child: Drawer(
            child: ListView(
          children: [
            Container(
              height: 165.0,
              child: DrawerHeader(
                decoration: BoxDecoration(color: Colors.white),
                child: Row(
                  children: [
                    Image.asset(
                      "images/user_icon.png",
                      height: 65.0,
                      width: 65.0,
                    ),
                    SizedBox(
                      width: 16.0,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Profile Name",
                          style: TextStyle(
                              fontSize: 16.0, fontFamily: "Brand Bold"),
                        ),
                        SizedBox(
                          height: 6.0,
                        ),
                        Text("Visit Profile"),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Divider(),

            SizedBox(
              height: 12.0,
            ),
            //
            ListTile(
              leading: Icon(Icons.history),
              title: Text(
                "History",
                style: TextStyle(fontSize: 15.0),
              ),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text(
                "Visit Profile",
                style: TextStyle(fontSize: 15.0),
              ),
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: Text(
                "About",
                style: TextStyle(fontSize: 15.0),
              ),
            ),
            GestureDetector(
              onTap: () {
                FirebaseAuth.instance.signOut();
                Navigator.pushNamedAndRemoveUntil(
                    context, LoginScreen.idScreen, (route) => false);
              },
              child: ListTile(
                leading: Icon(Icons.logout),
                title: Text(
                  "Sign Out",
                  style: TextStyle(fontSize: 15.0),
                ),
              ),
            ),
          ],
        )),
      ),
      body: Stack(
        children: [
          GoogleMap(
            padding: EdgeInsets.only(bottom: bottomPaddingOfMap),
            mapType: MapType.normal,
            myLocationButtonEnabled: true,
            initialCameraPosition: _kGooglePlex,
            myLocationEnabled: true,
            zoomGesturesEnabled: true,
            zoomControlsEnabled: true,
            polylines: polylineSet,
            markers: markersSet,
            circles: circlesSet,
            onMapCreated: (GoogleMapController controller) {
              _controllerGoogleMap.complete(controller);
              newGoogleMapController = controller;
              setState(() {
                bottomPaddingOfMap = 400.0;
              });
              locatePosition();
            },
          ),

          //draw button

          Positioned(
            top: 38.0,
            left: 22.0,
            child: GestureDetector(
              onTap: () {
                if (drawerOpen = true) {
                  scaffoldKey.currentState!.openDrawer();
                } else {
                  resetApp();
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22.0),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black,
                        blurRadius: 6.0,
                        spreadRadius: 0.5,
                        offset: Offset(0.7, 0.7))
                  ],
                ),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon((drawerOpen) ? Icons.menu : Icons.close,
                      color: Colors.black),
                  radius: 20.0,
                ),
              ),
            ),
          ),

          //requesting container
        ],
      ),
    );
  }

  Future<void> getPlaceDirection() async {
    var initialPos =
        Provider.of<AppData>(context, listen: false).pickUpLocation;
    var finalPos = Provider.of<AppData>(context, listen: false).dropOffLocation;
    var pickUpLatLng = LatLng(initialPos!.latitude, initialPos.longitude);
    var dropOffLatLng = LatLng(finalPos!.latitude, finalPos.longitude);

    showDialog(
        context: context,
        builder: (BuildContext context) => ProgressDialog(
              message: "Please wait..",
            ));
    var details = await AssistantMethods.obtainPlaceDirectionDetails(
        pickUpLatLng, dropOffLatLng);
    setState(() {
      tripDirectionDetails = details;
    });
    Navigator.pop(context);
    print("THis is encoded Points :: ");
    print(details?.encodedPoints);

    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> decodePolyLinePointsResult =
        polylinePoints.decodePolyline(details!.encodedPoints);

    plineCoordinates.clear();
    if (decodePolyLinePointsResult.isNotEmpty) {
      decodePolyLinePointsResult.forEach((PointLatLng pointLatLng) {
        plineCoordinates.add(
          LatLng(pointLatLng.latitude, pointLatLng.longitude),
        );
      });
    }

    polylineSet.clear();
    setState(() {
      Polyline polyline = Polyline(
        color: Colors.pink,
        polylineId: PolylineId("PolylineID"),
        jointType: JointType.round,
        points: plineCoordinates,
        width: 5,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        geodesic: true,
      );
      polylineSet.add(polyline);
    });
    LatLngBounds latLngBounds;
    if (pickUpLatLng.latitude > dropOffLatLng.latitude &&
        pickUpLatLng.longitude > dropOffLatLng.longitude) {
      latLngBounds =
          LatLngBounds(southwest: dropOffLatLng, northeast: pickUpLatLng);
    } else if (pickUpLatLng.longitude > dropOffLatLng.longitude) {
      LatLngBounds(
          southwest: LatLng(pickUpLatLng.latitude, dropOffLatLng.longitude),
          northeast: LatLng(dropOffLatLng.latitude, pickUpLatLng.longitude));
    } else if (pickUpLatLng.latitude > dropOffLatLng.latitude) {
      LatLngBounds(
          southwest: LatLng(dropOffLatLng.latitude, pickUpLatLng.longitude),
          northeast: LatLng(pickUpLatLng.latitude, dropOffLatLng.longitude));
    } else {
      latLngBounds =
          LatLngBounds(southwest: pickUpLatLng, northeast: dropOffLatLng);
      newGoogleMapController.animateCamera(
        CameraUpdate.newLatLngBounds(latLngBounds, 70),
      );
      Marker pickUpLocMarker = Marker(
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        infoWindow:
            InfoWindow(title: initialPos.placeName, snippet: "my Location"),
        position: pickUpLatLng,
        markerId: MarkerId("pickUpId"),
      );

      Marker dropOffLocMarker = Marker(
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        infoWindow:
            InfoWindow(title: finalPos.placeName, snippet: "Drop-Off Location"),
        position: dropOffLatLng,
        markerId: MarkerId("dropOffId"),
      );
      setState(() {
        markersSet.add(pickUpLocMarker);
        markersSet.add(dropOffLocMarker);
      });

      Circle pickUpCirlce = Circle(
        fillColor: Colors.yellow,
        center: pickUpLatLng,
        radius: 12,
        strokeColor: Colors.yellowAccent,
        circleId: CircleId("pickUpId"),
      );

      Circle dropOffCirlce = Circle(
        fillColor: Colors.red,
        center: pickUpLatLng,
        radius: 12,
        strokeColor: Colors.red,
        circleId: CircleId("dropOffId"),
      );

      setState(() {
        circlesSet.add(pickUpCirlce);
        circlesSet.add(dropOffCirlce);
      });
    }
  }
}
