import 'package:fiacre_driver_app/tabsPages/eariningsTabPage.dart';
import 'package:fiacre_driver_app/tabsPages/homeTabPage.dart';
import 'package:fiacre_driver_app/tabsPages/profilePage.dart';
import 'package:fiacre_driver_app/tabsPages/ratingTabPage.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  @override
  MainScreen({Key? key}) : super(key: key);
  static const String idscreen = "mainScreen";

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  int selectedIndex = 0;
  void onItemClicked(int index) {
    setState(() {
      selectedIndex = index;
      tabController.index = selectedIndex;
    });
  }

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        physics: NeverScrollableScrollPhysics(),
        controller: tabController,
        children: [
          HomeTabPage(),
          EarningTabPage(),
          RatingTabPage(),
          ProfileTabPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: Colors.white,
            ),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.credit_card,
              color: Colors.white,
            ),
            label: "Earnings",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.star,
              color: Colors.white,
            ),
            label: "Ratings",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              color: Colors.white,
            ),
            label: "Profile",
          ),
        ],
        unselectedItemColor: Colors.black54,
        selectedItemColor: Colors.blueAccent,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: TextStyle(
          fontSize: 12.0,
        ),
        showUnselectedLabels: true,
        currentIndex: selectedIndex,
        onTap: onItemClicked,
      ),
    );
  }
}
