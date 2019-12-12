import 'package:flutter/material.dart';

import 'OMTScreen.dart';
import 'Invoices.dart';
import 'ReportsScreen.dart';
import 'rechargeCategories.dart';
import 'clientsScreen.dart';
import 'phonecategories.dart';
import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'OthersScreen.dart';
import 'EditItems.dart';
import 'accessoriescat.dart';


var currentPage = 0;

class MainScreen extends StatefulWidget {
  static const String id = 'Main_Screen';
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {



  @override
  Widget build(BuildContext context) {
    Widget getwidget() {
      if (currentPage == 0) {
        return Container(
            color: Colors.black54,
            child: Column(children: [

              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: GestureDetector(
                    onTap: (){
                      Navigator.pushNamed(context, phonecategories.id);
                    },
                    child: Card(
                      color: Colors.yellow,
                      borderOnForeground: true,
                      elevation: 20,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.phone_iphone,
                            size: 20,
                            color: Colors.black54,
                          ),
                          Container(
                            child: Center(
                                child: Text(
                              'Phones',
                              style:
                                  TextStyle(fontSize: 22, color: Colors.black),
                            )),
                          ),
                          Text(
                            'Apple,Samsung,Huawei,Used',
                            style: TextStyle(color: Colors.black),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: GestureDetector(
                    onTap: (){
                      Navigator.pushNamed(context, RechargeCategories.id);
                    },
                    child: Card(
                      color: Colors.yellow,
                      elevation: 20,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.calendar_view_day,
                            color: Colors.black54,
                            size: 20,
                          ),
                          Container(
                            child: Center(
                                child: Text(
                              'Recharge',
                              style:
                                  TextStyle(fontSize: 20, color: Colors.black),
                            )),
                          ),
                          Text(
                            'Mtc,Alfa,Days,\$',
                            style: TextStyle(color: Colors.black),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: GestureDetector(
                    onTap: (){
                      Navigator.pushNamed(context, accesscat.id);
                    },
                    child: Card(
                      color: Colors.yellow,
                      elevation: 20,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.mobile_screen_share,
                            color: Colors.black54,
                          ),
                          Container(
                            child: Center(
                                child: Text(
                              'Accessories',
                              style:
                                  TextStyle(fontSize: 22, color: Colors.black),
                            )),
                          ),
                          Text(
                            'Protection,Cover,Speakers,Memory and Others..',
                            style: TextStyle(color: Colors.black),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: GestureDetector(
                    onTap: (){
                      Navigator.pushNamed(context, OMTScreen.id);
                    },
                    child: Card(
                      color: Colors.yellow,
                      elevation: 20,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.attach_money,
                            color: Colors.black54,
                          ),
                          Container(
                            child: Center(
                                child: Text(
                              'OMT',
                              style:
                                  TextStyle(fontSize: 22, color: Colors.black),
                            )),
                          ),
                          Text(
                            'Transfer Money',
                            style: TextStyle(color: Colors.black),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: GestureDetector(
                    onTap: (){
                      Navigator.pushNamed(context, OtherScrenn.id);
                    },
                    child: Card(
                      color: Colors.yellow,
                      elevation: 20,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.cached,
                            color: Colors.black54,
                          ),
                          Container(
                            child: Center(
                                child: Text(
                                  'Others',
                                  style:
                                  TextStyle(fontSize: 22, color: Colors.black),
                                )),
                          ),
                          Text(
                            'Maintenance & Spending',
                            style: TextStyle(color: Colors.black),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: GestureDetector(
                    onTap: (){
                      Navigator.pushNamed(context, ClientsScreen.id);
                    },
                    child: Card(
                      color: Colors.yellow,
                      elevation: 20,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.people,
                            color: Colors.black54,
                          ),
                          Container(
                            child: Center(
                                child: Text(
                              'clients',
                              style:
                                  TextStyle(fontSize: 22, color: Colors.black),
                            )),
                          ),
                          Text(
                            'Report of all Your debt & Clients',
                            style: TextStyle(color: Colors.black),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 35,
              )
            ]));
      }
      if (currentPage == 1) {
        return ReportsScreen();
      }
      if (currentPage == 2) {
        return Invoices();
      } else {
        return EditItems();
      }
    }

    ///////////////////////////////////////////////////////

    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(40),
          child: AppBar(
            title: Text(
              'MNE',
              style: TextStyle(
                  color: Colors.yellow,
                  fontSize: 30,
                  fontWeight: FontWeight.bold),
              
            ),
            backgroundColor: Colors.black54,
            
          ),
        ),
        
        bottomNavigationBar: FancyBottomNavigation(

          tabs: [
            TabData(iconData: Icons.home, title: "Home"),
            TabData(iconData: Icons.report, title: "Reports"),
            TabData(iconData: Icons.receipt, title: "Invoices"),
            TabData(iconData: Icons.edit, title: "Edit")
          ],
          onTabChangedListener: (position) {
            setState(() {
              currentPage = position;
            });
            print(currentPage);
          },
          barBackgroundColor: Colors.black54,
          activeIconColor: Colors.black54,
          inactiveIconColor: Colors.yellow,
          circleColor: Colors.yellow,
          textColor: Colors.yellow,

        ),
        body: getwidget(),
      ),
    );
  }
}
