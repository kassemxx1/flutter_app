import 'package:flutter/material.dart';
import 'PhoneList.dart';
import 'phonecat.dart';

class phonecategories extends StatefulWidget {
  static const String id='phone_categories';
  @override
  _phonecategoriesState createState() => _phonecategoriesState();
}

class _phonecategoriesState extends State<phonecategories> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Categories',style: TextStyle(color: Colors.black),),
          backgroundColor: Colors.yellow,
          leading: new IconButton(
        icon: new Icon(Icons.arrow_back, color: Colors.black54),
        onPressed: () => Navigator.of(context).pop(),
      ),
        ),
        body: Container(
          color: Colors.black54,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              color: Colors.black54,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,


                children: <Widget>[
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: Card(
                        elevation: 50,
                        color: Colors.yellow,
                        child: Center(
                          child: MaterialButton(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(Icons.mobile_screen_share,color: Colors.black54,size: 30,),
                                Text('New',style: TextStyle(color: Colors.black,fontSize: 30),),
                                Text('Apple,Samsung,Huwaei and Others',style: TextStyle(color: Colors.black),),
                              ],
                            ),
                            onPressed: (){
                              Navigator.pushNamed(context, phonecat.id);
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: Card(
                        elevation: 50,
                        color: Colors.yellow,
                        child: Center(
                          child: MaterialButton(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(Icons.phonelink_setup,color: Colors.black54,size: 30,),
                                Text('Used',style: TextStyle(color: Colors.black,fontSize: 30),),
                                Text('Apple,Samsung,Huwaei and Others',style: TextStyle(color: Colors.black),),

                              ],
                            ),
                            onPressed: (){
                              setState(() {
                                PhonesList.subcat='used';
                              });
                              Navigator.pushNamed(context, PhonesList.id);

                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
