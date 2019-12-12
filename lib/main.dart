import 'package:flutter/material.dart';
import 'MainScreen.dart';
import 'Selling.dart';
import 'PhoneList.dart';
import 'Invoices.dart';
import 'Accessories_Screen.dart';
import 'ReportsScreen.dart';
import 'OMTScreen.dart';
import 'rechargeCategories.dart';
import 'MtcScreen.dart';
import 'alfaAcreen.dart';
import 'fanytelScreen.dart';
import 'clientsScreen.dart';
import 'phonecategories.dart';
import 'phonecat.dart';
import 'accessoriescat.dart';
import 'EditItems.dart';
import 'OthersScreen.dart';
void main() => runApp(phone_sotre());

class phone_sotre extends StatefulWidget {
  @override
  _phone_sotreState createState() => _phone_sotreState();
}

class _phone_sotreState extends State<phone_sotre> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: MainScreen.id,
      routes: {
        MainScreen.id : (context) => MainScreen(),
        PhonesScreen.id : (context) => PhonesScreen(),
        PhonesList.id :(context) => PhonesList(),
        Invoices.id:(context) => Invoices(),
        AccessoriesScreen.id:(context) => AccessoriesScreen(),
        ReportsScreen.id:(context) => ReportsScreen(),
        OMTScreen.id:(context) =>OMTScreen(),
        RechargeCategories.id:(context) => RechargeCategories(),
        MtcScreen.id:(context) => MtcScreen(),
        AlfaScreen.id:(context) => AlfaScreen(),
        FanytelScreen.id:(context) =>FanytelScreen(),
        ClientsScreen.id:(context) =>ClientsScreen(),
        phonecategories.id:(context) =>phonecategories(),
        phonecat.id:(context) =>phonecat(),
        accesscat.id:(context) =>accesscat(),
        EditItems.id:(context) =>EditItems(),
        OtherScrenn.id:(context) =>OtherScrenn(),
      },
    );
  }
}