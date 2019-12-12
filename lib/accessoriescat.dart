import 'package:flutter/material.dart';
import 'Accessories_Screen.dart';
class accesscat extends StatefulWidget {
  static const String id='acces_cat';
  @override
  _accesscatState createState() => _accesscatState();
}

class _accesscatState extends State<accesscat> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: Text('Categories',style: TextStyle(color: Colors.yellow),),
          backgroundColor: Colors.black54,
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back, color: Colors.yellow),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Container(
          color: Colors.black54,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(

              children: <Widget>[
                Expanded(
                  child: Card(
                    elevation: 20,
                    color: Colors.yellow,
                    child: MaterialButton(
                      child: Container(
                        child: Center(child: Text('Protection',style: TextStyle(color: Colors.black,fontSize: 30),)),
                      ),
                      onPressed: (){
                        setState(() {
                          AccessoriesScreen.accesscat='Protection';
                        });
                        Navigator.pushNamed(context, AccessoriesScreen.id);
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: Card(
                    elevation: 20,
                    color: Colors.yellow,
                    child: MaterialButton(
                      child: Container(
                        child: Center(child: Text('Cover',style: TextStyle(color: Colors.black,fontSize: 30),)),
                      ),
                      onPressed: (){
                        setState(() {
                          AccessoriesScreen.accesscat='Cover';
                        });
                        Navigator.pushNamed(context, AccessoriesScreen.id);

                      },
                    ),
                  ),
                ),
                Expanded(
                  child: Card(
                    elevation: 20,
                    color: Colors.yellow,
                    child: MaterialButton(
                      child: Container(
                        child: Center(child: Text('Hoco',style: TextStyle(color: Colors.black,fontSize: 30),)),
                      ),
                      onPressed: (){
                        setState(() {
                          AccessoriesScreen.accesscat='Holo';
                        });
                        Navigator.pushNamed(context, AccessoriesScreen.id);

                      },
                    ),
                  ),
                ),
                Expanded(
                  child: Card(
                    elevation: 20,
                    color: Colors.yellow,
                    child: MaterialButton(
                      child: Container(
                        child: Center(child: Text('Moxom',style: TextStyle(color: Colors.black,fontSize: 30),)),
                      ),
                      onPressed: (){
                        setState(() {
                          AccessoriesScreen.accesscat='Moxom';
                        });
                        Navigator.pushNamed(context, AccessoriesScreen.id);

                      },
                    ),
                  ),
                ),
                Expanded(
                  child: Card(
                    elevation: 20,
                    color: Colors.yellow,
                    child: MaterialButton(
                      child: Container(
                        child: Center(child: Text('Powerbank',style: TextStyle(color: Colors.black,fontSize: 30),)),
                      ),
                      onPressed: (){
                        setState(() {
                          AccessoriesScreen.accesscat='Powerbank';
                        });
                        Navigator.pushNamed(context, AccessoriesScreen.id);

                      },
                    ),
                  ),
                ),
                Expanded(
                  child: Card(
                    elevation: 20,
                    color: Colors.yellow,
                    child: MaterialButton(
                      child: Container(
                        child: Center(child: Text('Earphones',style: TextStyle(color: Colors.black,fontSize: 30),)),
                      ),
                      onPressed: (){
                        setState(() {
                          AccessoriesScreen.accesscat='Earphones';
                        });
                        Navigator.pushNamed(context, AccessoriesScreen.id);

                      },
                    ),
                  ),
                ),
                Expanded(
                  child: Card(
                    elevation: 20,
                    color: Colors.yellow,
                    child: MaterialButton(
                      child: Container(
                        child: Center(child: Text('Speakers',style: TextStyle(color: Colors.black,fontSize: 30),)),
                      ),
                      onPressed: (){
                        setState(() {
                          AccessoriesScreen.accesscat='Speakers';
                        });
                        Navigator.pushNamed(context, AccessoriesScreen.id);

                      },
                    ),
                  ),
                ),
                Expanded(
                  child: Card(
                    elevation: 20,
                    color: Colors.yellow,
                    child: MaterialButton(
                      child: Container(
                        child: Center(child: Text('Micro sd',style: TextStyle(color: Colors.black,fontSize: 30),)),
                      ),
                      onPressed: (){
                        setState(() {
                          AccessoriesScreen.accesscat='Micro sd';
                        });
                        Navigator.pushNamed(context, AccessoriesScreen.id);

                      },
                    ),
                  ),
                ),
                Expanded(
                  child: Card(
                    elevation: 20,
                    color: Colors.yellow,
                    child: MaterialButton(
                      child: Container(
                        child: Center(child: Text('Flash Memory',style: TextStyle(color: Colors.black,fontSize: 30),)),
                      ),
                      onPressed: (){
                        setState(() {
                          AccessoriesScreen.accesscat='Flash Memory';
                        });
                        Navigator.pushNamed(context, AccessoriesScreen.id);

                      },
                    ),
                  ),
                ),
                Expanded(
                  child: Card(
                    elevation: 20,
                    color: Colors.yellow,
                    child: MaterialButton(
                      child: Container(

                        child: Center(child: Text('Mararoko',style: TextStyle(color: Colors.black,fontSize: 30),)),
                      ),
                      onPressed: (){
                        setState(() {
                          AccessoriesScreen.accesscat='Mararoko';
                        });
                        Navigator.pushNamed(context, AccessoriesScreen.id);

                      },
                    ),
                  ),
                ),
                Expanded(
                  child: Card(
                    elevation: 20,
                    color: Colors.yellow,
                    child: MaterialButton(
                      child: Container(
                        child: Center(child: Text('Acc',style: TextStyle(color: Colors.black,fontSize: 30),)),
                      ),
                      onPressed: (){
                        setState(() {
                          AccessoriesScreen.accesscat='Acc';
                        });
                        Navigator.pushNamed(context, AccessoriesScreen.id);

                      },
                    ),
                  ),
                ),
                Expanded(
                  child: Card(
                    elevation: 20,
                    color: Colors.yellow,
                    child: MaterialButton(
                      child: Container(
                        child: Center(child: Text('Home',style: TextStyle(color: Colors.black,fontSize: 30),)),
                      ),
                      onPressed: (){
                        setState(() {
                          AccessoriesScreen.accesscat='Home';
                        });
                        Navigator.pushNamed(context, AccessoriesScreen.id);

                      },
                    ),
                  ),
                ),
                Expanded(
                  child: Card(
                    elevation: 20,
                    color: Colors.yellow,
                    child: MaterialButton(
                      child: Container(
                        child: Center(child: Text('Others',style: TextStyle(color: Colors.black,fontSize: 30),)),
                      ),
                      onPressed: (){
                        setState(() {
                          AccessoriesScreen.accesscat='Others';
                        });
                        Navigator.pushNamed(context, AccessoriesScreen.id);

                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
