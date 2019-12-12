import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'constants.dart';
import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
final _firestore = Firestore.instance;
class FanytelScreen extends StatefulWidget {
  static const String id = 'fanytel_Screen';
  @override
  _FanytelScreenState createState() => _FanytelScreenState();
}

class _FanytelScreenState extends State<FanytelScreen> {


  Future<double> getqtt(String name) async {
    var qtts = [0.0];

    final messages = await _firestore
        .collection('transaction')
        .where('name', isEqualTo: name)
        .getDocuments();
    for (var msg in messages.documents) {
      final qtt = msg['qtt'];
      qtts.add(qtt.toDouble());


    }

    var result = qtts.reduce((sum, element) => sum + element);
    return new Future(() => result.toDouble());
  }



  @override
  Widget build(BuildContext context) {
    var _n=0.0;
    var price=0.0;
    var currency='L.L';
    return Scaffold(
      appBar: AppBar(title: Text('Fanytel',style: TextStyle(color: Colors.black),),backgroundColor: Colors.white,
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: <Widget>[
          Flexible(
            child: Container(
              child: Image.asset('assets/images/fanytel.jpg'),

            ),
          ),
          FutureBuilder(
              builder: (BuildContext context,
                  AsyncSnapshot<double> qttnumbr) {
                return Center(
                  child: Row(
                    mainAxisAlignment:
                    MainAxisAlignment.center,
                    children: <Widget>[
                      Text('Available:'),
                      Text(
                        '${qttnumbr.data.round()}',
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.blueAccent),
                      ),
                    ],
                  ),
                );
              },
              initialData: 1.0,
              future:
              getqtt('fanytel')),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton(icon: Icon(Icons.arrow_upward,color: Colors.blue,) , onPressed: (){
                    showDialog(context: context,
                    builder: (BuildContext context){
                      return AlertDialog(
                        content: Form(

                            child: Column(
                              children: <Widget>[
                                TextField(
                                  keyboardType: TextInputType
                                      .number,
                                  textAlign: TextAlign.center,
                                  onChanged: (value) {
                                    setState(() {
                                      _n = double.parse(value);
                                    });
                                  },
                                  decoration:
                                  KTextFieldImputDecoration
                                      .copyWith(
                                      hintText:
                                      'Enter Your Qtt'),
                                ),
                                MaterialButton(onPressed: (){
                                  _firestore.collection('transaction').add({
                                    'name':'fanytel',
                                    'qtt':_n,

                                  });
                                  setState(() {
                                    getqtt('funytel');
                                    Navigator.of(context)
                                        .pop();
                                  });
                                },
                                child: Text('Send'),
                                ),

                              ],

                            )),

                      );
                    }
                    );

                  }),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton(icon: Icon(Icons.arrow_downward,color: Colors.blue,) , onPressed: (){
                    showDialog(context: context,
                        builder: (BuildContext context){
                          return AlertDialog(
                            content: Form(

                                child: Column(
                                  children: <Widget>[
                                    TextField(
                                      keyboardType: TextInputType
                                          .number,
                                      textAlign: TextAlign.center,
                                      onChanged: (value) {
                                        setState(() {
                                          _n = -(double.parse(value));
                                        });
                                      },
                                      decoration:
                                      KTextFieldImputDecoration
                                          .copyWith(
                                          hintText:
                                          'Enter Your Qtt'),
                                    ),
                                    Padding(
                                      padding:
                                      const EdgeInsets.all(8.0),
                                      child: CustomRadioButton(
                                        buttonColor: Theme.of(context)
                                            .canvasColor,
                                        buttonLables: [

                                          'L.L',
                                          '\$',
                                        ],
                                        buttonValues: [
                                          'L.L',
                                          '\$',
                                        ],
                                        radioButtonValue: (value) {
                                          setState(() {
                                            currency = value;
                                          });
                                        },
                                        selectedColor:
                                        Theme.of(context)
                                            .accentColor,
                                      ),
                                    ),
                                    TextField(
                                      keyboardType: TextInputType
                                          .number,
                                      textAlign: TextAlign.center,
                                      onChanged: (value) {
                                        setState(() {
                                          price = double.parse(value);
                                        });
                                      },
                                      decoration:
                                      KTextFieldImputDecoration
                                          .copyWith(
                                          hintText:
                                          'Enter Your price'),
                                    ),
                                    MaterialButton(onPressed: (){
                                      _firestore.collection('transaction').add({
                                        'name':'fanytel',
                                        'qtt':_n,
                                        'timestamp':Timestamp.now(),
                                        'currency':currency,
                                        'price':price,

                                      });
                                      setState(() {
                                        getqtt('funytel');
                                        Navigator.of(context)
                                            .pop();
                                      });
                                    },
                                      child: Text('Send'),
                                    ),

                                  ],

                                )),

                          );
                        }
                    );

                  }),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
