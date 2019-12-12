import 'package:flutter/material.dart';
import 'PhoneList.dart';

class phonecat extends StatefulWidget {
  static const String id='phone_cat';
  @override
  _phonecatState createState() => _phonecatState();
}

class _phonecatState extends State<phonecat> {
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
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Card(
                        color: Colors.yellow,
                        child: MaterialButton(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.phone_iphone,color: Colors.black54,size: 30,),
                              Container(
                                child: Center(child: Text('Apple',style: TextStyle(color: Colors.black,fontSize: 30),)),
                              ),
                              Text('Iphone,Ipad and Apple watch',style: TextStyle(color: Colors.black),),
                            ],
                          ),
                          onPressed: (){
                            setState(() {
                              PhonesList.subcat='Apple';
                            });
                            Navigator.pushNamed(context, PhonesList.id);
                          },
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Card(
                        color: Colors.yellow,
                        child: MaterialButton(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.phone_android,color: Colors.black54,size: 30,),
                              Container(
                                child: Center(child: Text('Samsung',style: TextStyle(color: Colors.black,fontSize: 30),)),
                              ),
                              Text('Galaxy,Note,A series,Tablets and others',style: TextStyle(color: Colors.black),),
                            ],
                          ),
                          onPressed: (){
                            setState(() {
                              PhonesList.subcat='Samsung';
                            });
                            Navigator.pushNamed(context, PhonesList.id);

                          },
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Card(
                        color: Colors.yellow,
                        child: MaterialButton(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.smartphone,color: Colors.black54,size: 30,),
                              Container(
                                child: Center(child: Text('huawei',style: TextStyle(color: Colors.black,fontSize: 30),)),
                              ),
                              Text('Y series,Nova,Yab and Others',style: TextStyle(color: Colors.black),),
                            ],
                          ),
                          onPressed: (){
                            setState(() {
                              PhonesList.subcat='huawei';
                            });
                            Navigator.pushNamed(context, PhonesList.id);

                          },
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
