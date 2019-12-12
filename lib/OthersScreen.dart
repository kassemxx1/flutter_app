import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'constants.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
final _firestore = Firestore.instance;
var now = new DateTime.now();
int day = now.day;
int year = now.year;
int month = now.month;

class OtherScrenn extends StatefulWidget {
  static const String id='Other_screnn';
  @override
  _OtherScrennState createState() => _OtherScrennState();
}

class _OtherScrennState extends State<OtherScrenn> {
  TextEditingController _textEditingController1 = TextEditingController();
  TextEditingController _textEditingController2 = TextEditingController();
  TextEditingController _textEditingController3 = TextEditingController();
  TextEditingController _textEditingController4 = TextEditingController();
  var spendprice=0.0;
  var spendDescription='';
  var maintenanceDescription='';
  var maintenanceprice=0.0;
  var _saving=false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('others',style: TextStyle(color: Colors.yellow),),
      backgroundColor: Colors.black54,
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back, color: Colors.yellow),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      backgroundColor: Colors.black54,
      body: ModalProgressHUD(
        inAsyncCall:_saving ,
        child: Column(
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Card(
                  color: Colors.yellow,
                  elevation: 20,
                  child:Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('Spending',style: TextStyle(color: Colors.black,fontSize: 20),),
                      Padding(
                        padding: const EdgeInsets.only(left: 40, right: 40, top: 10),
                        child: TextField(
                          controller: _textEditingController1,
                          keyboardType: TextInputType.emailAddress,
                          textAlign: TextAlign.center,
                          onChanged: (value) {
                            setState(() {
                              spendDescription = value;
                            });
                          },
                          decoration: KTextFieldImputDecoration.copyWith(
                              hintText: 'Enter Description'),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 40, right: 40, top: 10),
                        child: TextField(
                          controller: _textEditingController2,
                          keyboardType: TextInputType.emailAddress,
                          textAlign: TextAlign.center,
                          onChanged: (value) {
                            setState(() {
                              spendprice = (double.parse(value));
                            });
                          },
                          decoration: KTextFieldImputDecoration.copyWith(
                              hintText: 'Enter price'),
                        ),
                      ),
                      MaterialButton(onPressed: (){
                        setState(() {
                          _saving=true;
                        });
                        _firestore.collection('others').add({
                          'name':'spending',
                          'timestamp':now,
                          'description':spendDescription,
                          'price':-spendprice,
                          'currency':'L.L'

                        });
                        setState(() {
                          _saving=false;
                        });
                        _textEditingController1.clear();
                        _textEditingController2.clear();


                      },
                        color: Colors.black54,
                      child: Text('Send',style: TextStyle(color: Colors.yellow),),
                      )

                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Card(
                  color: Colors.yellow,
                  elevation: 20,
                  child:Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('Maintenace',style: TextStyle(color: Colors.black,fontSize: 20),),
                      Padding(
                        padding: const EdgeInsets.only(left: 40, right: 40, top: 10),
                        child: TextField(
                          controller: _textEditingController3,
                          keyboardType: TextInputType.emailAddress,
                          textAlign: TextAlign.center,
                          onChanged: (value) {
                            setState(() {
                              maintenanceDescription = value;
                            });
                          },
                          decoration: KTextFieldImputDecoration.copyWith(
                              hintText: 'Enter Description'),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 40, right: 40, top: 10),
                        child: TextField(
                          controller: _textEditingController4,
                          keyboardType: TextInputType.emailAddress,
                          textAlign: TextAlign.center,
                          onChanged: (value) {
                            setState(() {
                              maintenanceprice = (double.parse(value));
                            });
                          },
                          decoration: KTextFieldImputDecoration.copyWith(
                              hintText: 'Enter price'),
                        ),
                      ),
                      MaterialButton(onPressed: (){
                        setState(() {
                          _saving=true;
                        });
                        _firestore.collection('others').add({
                          'name':'maintenance',
                          'timestamp':now,
                          'description':maintenanceDescription,
                          'price':maintenanceprice,
                          'currency':'L.L'

                        });
                        setState(() {
                          _saving=false;
                        });
                        _textEditingController3.clear();
                        _textEditingController4.clear();
                      },
                        color: Colors.black54,
                        child: Text('Send',style: TextStyle(color: Colors.yellow),),
                      )

                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
