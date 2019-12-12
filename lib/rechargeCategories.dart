import 'package:flutter/material.dart';
import 'MtcScreen.dart';
import 'alfaAcreen.dart';
import 'fanytelScreen.dart';
class RechargeCategories extends StatefulWidget {
  static const String id='Recharge_categories';
  @override
  _RechargeCategoriesState createState() => _RechargeCategoriesState();
}

class _RechargeCategoriesState extends State<RechargeCategories> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Card(
          color: Colors.white.withOpacity(.0),
          elevation: 20,
          child: Text('Recharge',style: TextStyle(color: Colors.black,fontSize: 30,fontWeight: FontWeight.bold),
          ),
        ),backgroundColor: Colors.white,leading: new IconButton(
          icon: new Icon(Icons.arrow_back, color: Colors.black54),
          onPressed: () => Navigator.of(context).pop(),
        ),),
        body:Container(
          color: Colors.white,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      elevation: 20,

                      color: Colors.yellow.withOpacity(.0),
                      child: GestureDetector(
                        child: Container(
                          width: 200,
                          child: Image.asset('assets/images/MTC.png'),

                        ),
                        onTap: (){
                          Navigator.pushNamed(context, MtcScreen.id);

                        },
                      ),
                    ),
                  ),
                ),
                Flexible(
                  child: Card(

                    color: Colors.yellow.withOpacity(.0),
                    elevation: 20,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        child: Container(
                          width: 200,
                          child: Image.asset('assets/images/ALFA.png'),
                        ),
                        onTap: (){
                          Navigator.pushNamed(context, AlfaScreen.id);

                        },
                      ),
                    ),
                  ),
                ),
                Flexible(
                  child: Card(
                    elevation: 20,
                    color: Colors.yellow.withOpacity(.0),
                    child: GestureDetector(
                      child: Container(
                        width: 200,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8,left: 8,top: 8,bottom: 8),
                          child: Image.asset('assets/images/fanytel.jpg',),
                        ),
                      ),
                      onTap: (){
                        Navigator.pushNamed(context, FanytelScreen.id);

                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      ),
    );
  }
}
