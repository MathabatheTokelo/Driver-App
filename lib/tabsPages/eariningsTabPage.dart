import 'package:fiacre_driver_app/tabsPages/homeTabPage.dart';
import 'package:flutter/material.dart';

class EarningTabPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return EarningsView();
  }
}

class EarningsView extends StatefulWidget {
  @override
  _EarningsViewState createState() => _EarningsViewState();
}

const kExpandedHeight = 300.0;

class _EarningsViewState extends State<EarningsView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: 560,
        child: Stack(
          alignment: Alignment.topCenter,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: 280,
              decoration: BoxDecoration(
                color: Colors.black,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          SizedBox(
                            width: 10,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Earnings",
                            style: TextStyle(color: Colors.white, fontSize: 28),
                          )
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.only(right: 20),
                        child: Icon(
                          Icons.help,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Text(
                    "This week",
                    style: TextStyle(color: Colors.white, fontSize: 22),
                  ),
                  SizedBox(
                    height: 14,
                  ),
                  Text(
                    "\R64.80",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 44,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 30),
                width: double.infinity,
                height: 320,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black12,
                        blurRadius: 11,
                        offset: Offset(3.0, 4.0))
                  ],
                ),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: ListTile(
                        onTap: () =>
                            Navigator.pushNamed(context, "/earnings_details"),
                        title: Text("Earning Details",
                            style: TextStyle(fontSize: 20)),
                        subtitle: Container(
                            margin: EdgeInsets.only(top: 10),
                            child: Text("Oct 31 - Nov 05",
                                style: TextStyle(fontSize: 16))),
                        leading: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                              color: Colors.black, shape: BoxShape.circle),
                          child: Icon(
                            Icons.lightbulb_outline,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                        trailing: Icon(Icons.chevron_right,
                            color: Colors.black, size: 20),
                      ),
                    ),
                    Divider(),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: ListTile(
                        onTap: () =>
                            Navigator.pushNamed(context, "/recent_transations"),
                        title: Text("Recent transactions",
                            style: TextStyle(fontSize: 20)),
                        subtitle: Container(
                            margin: EdgeInsets.only(top: 10),
                            child: Text("\R405.30 balance",
                                style: TextStyle(fontSize: 16))),
                        leading: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                              color: Colors.black, shape: BoxShape.circle),
                          child: Icon(
                            Icons.credit_card,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                        trailing: Icon(Icons.chevron_right,
                            color: Colors.black, size: 20),
                      ),
                    ),
                    Divider(),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: ListTile(
                        onTap: () =>
                            Navigator.pushNamed(context, "/promotions"),
                        title:
                            Text("Promotions", style: TextStyle(fontSize: 20)),
                        subtitle: Container(
                            margin: EdgeInsets.only(top: 10),
                            child: Text("See what's available",
                                style: TextStyle(fontSize: 16))),
                        leading: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                              color: Colors.black, shape: BoxShape.circle),
                          child: Icon(
                            Icons.card_membership,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                        trailing: Icon(Icons.chevron_right,
                            color: Colors.black, size: 20),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
