import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'constants.dart';
import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:date_format/date_format.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
final _firestore = Firestore.instance;
var now = new DateTime.now();
int day = now.day;
int year = now.year;
int month = now.month;
var out = 0.0;
var IN = 0.0;
var opening=0.0;
var currency = 'L.L.';

TextEditingController _textEditingController1 = TextEditingController();
TextEditingController _textEditingController2 = TextEditingController();
TextEditingController _textEditingController3 = TextEditingController();



class OMTScreen extends StatefulWidget {
  static const String id = 'OMT_Screen';
  @override
  _OMTScreenState createState() => _OMTScreenState();
}

class _OMTScreenState extends State<OMTScreen> {
  var transaction = [];
  var startDate = DateTime(
      year,
      month,
      day,
      0,
      0,
      0,
      0,
      0);
  var tomorow = new DateTime(year, month, day, 23, 59, 59, 99, 99);
  var endDate = new DateTime(year, month, day, 23, 59, 59, 99, 99);
  bool _saving=true;




    void getopen() async {
      final messages = await _firestore.collection('oppening').getDocuments();
      for (var msg in messages.documents) {
        setState(() {
          opening = msg.data['openning'];
          _saving=false;
        });
      }
    }

    void gettransaction() async {
      final messages = await _firestore.collection('omt').where(
          'timestamp', isGreaterThan: startDate).getDocuments();
      transaction.clear();
      for (var msg in messages.documents) {
        final IIN = msg.data['in'];
        final oout = msg.data['out'];
        final ccurency = msg.data['currency'];
        final ttime = msg.documentID;
        final time = msg.data['timestamp'];
        setState(() {
          transaction.add({
            'in': IIN,
            'out': oout,
            'curency': ccurency,
            'id': ttime,
            'time':time,
          });
          print(transaction);
          _saving=false;

        });
      }
    }
  void gettransactiondate(DateTime start, DateTime end) async {
    final messages = await _firestore.collection('omt').where(
        'timestamp', isGreaterThan: start).where('timestamp',isLessThan: end).getDocuments();
    transaction.clear();
    for (var msg in messages.documents) {
      final IIN = msg.data['in'];
      final oout = msg.data['out'];
      final ccurency = msg.data['currency'];
      final ttime = msg.documentID;
      final time = msg.data['timestamp'];
      setState(() {
        transaction.add({
          'in': IIN,
          'out': oout,
          'curency': ccurency,
          'id': ttime,
          'time':time,
        });
        print(transaction);
      });
    }
  }

    Future<double> getqtt(String name, DateTime today, String currencyy) async {
      var qtts = [0.0];

      final messages = await _firestore
          .collection('omt').where('currency', isEqualTo: currencyy)
          .where('timestamp', isGreaterThan: today)
          .getDocuments();
      for (var msg in messages.documents) {
        final qtt = msg[name];
        setState(() {
          qtts.add(qtt);
        });
      }

      var result = qtts.reduce((sum, element) => sum + element);
      return new Future(() => result);
    }
    Future<double> getsum(DateTime today, String currencyy) async {
      var qtts = [0.0];

      final messages = await _firestore
          .collection('omt').where('currency', isEqualTo: currencyy)
          .where('timestamp', isGreaterThan: today)
          .getDocuments();
      for (var msg in messages.documents) {
        final iin = msg['in'];
        final outt = -msg['out'];
        setState(() {
          qtts.add(iin);
          qtts.add(outt);
        });
      }

      var result = qtts.reduce((sum, element) => sum + element);
      return new Future(() => result);
    }
    @override
    void initState() {
      super.initState();
      getopen();
      gettransaction();
      print(transaction);
    }
    @override
    Widget build(BuildContext context) {
      var open = 0.0;


      return Scaffold(
        resizeToAvoidBottomPadding: false,
        backgroundColor: Colors.white,

        appBar: AppBar(
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),

          title: Text(
            'OMT', style: TextStyle(color: Colors.yellow, fontSize: 30),),
          backgroundColor: Colors.black54,
        ),
        body: ModalProgressHUD(
          inAsyncCall: _saving,
          dismissible: true,
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Container(
              color: Colors.black54,
              child: ListView(

                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      color: Colors.white.withOpacity(0.0),
                      elevation: 20,
                      child: Column(
                        children: <Widget>[
                          MaterialButton(
                            onPressed: () async {
                              showDialog(context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      content: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[

                                          Text('Enter Opening Balance',style: TextStyle(color: Colors.black),),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 40, right: 40, top: 10),
                                            child: new TextField(

                                              controller: _textEditingController3,
                                              decoration: KTextFieldImputDecoration
                                                  .copyWith(
                                                  hintText: 'Opening Balance'),
                                              keyboardType: TextInputType.number,
                                              onChanged: (value) async {
                                                setState(() {
                                                  open = double.parse(value);
                                                });
                                              },
                                            ),
                                          ),
                                          MaterialButton(
                                            onPressed: () async {
                                              _firestore.collection('oppening')
                                                  .document('open')
                                                  .updateData({
                                                'openning': open,
                                              });
                                              _textEditingController3.clear();
                                              Navigator.of(context).pop();
                                              getopen();
                                            },
                                            child: Text('Done'),
                                          ),

                                        ],
                                      ),

                                    );
                                  }
                              );
                            },
                            child: Text('Enter Opening Balance', style: TextStyle(
                              color: Colors.yellow, fontSize: 20,),),
                            color: Colors.black54,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text('Opening Balance =  ',
                                style: TextStyle(color: Colors.black,),),
                              Text('$opening L.L',
                                style: TextStyle(color: Colors.black, fontSize: 20),),

                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomRadioButton(
                      buttonColor: Colors.black54,
                      buttonLables: [

                        'L.L.',
                        '\$',

                      ],
                      buttonValues: [
                        'L.L.',
                        '\$',
                      ],
                      radioButtonValue: (value) {
                        setState(() {
                          currency = value;
                        });
                      },
                      selectedColor:Colors.yellow,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 50, right: 50, top: 10),
                    child: new TextField(
                      controller: _textEditingController1,
                      decoration: KTextFieldImputDecoration.copyWith(
                          hintText: 'IN'),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        setState(() {
                          IN = double.parse(value);
                        });
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 50, right: 50, top: 10),
                    child: new TextField(
                      decoration: KTextFieldImputDecoration.copyWith(
                          hintText: 'Out'),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        setState(() {
                          out = double.parse(value);
                        });
                        print(out);
                      },
                      controller: _textEditingController2,
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: MaterialButton(
                      child: Text('Send',style: TextStyle(color: Colors.yellow,fontSize: 20,fontWeight: FontWeight.bold),),
                      color: Colors.black54,


                      onPressed: () async {
                        setState(() {
                          _saving=true;
                        });
                        await _firestore.collection('omt').add({
                          'in': IN,
                          'out': out,
                          'timestamp': Timestamp.now(),
                          'currency': currency,
                        });
                        _textEditingController1.clear();
                        _textEditingController2.clear();
                        setState(() {
                          out = 0.0;
                          IN = 0.0;
                        });
                        getqtt('in', startDate, 'L.L.');
                        getqtt('in', startDate, '\$');
                        gettransaction();
                        FocusScope.of(context).unfocus();
                      },

                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      color: Colors.white.withOpacity(0.0),
                      elevation: 20,
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: FutureBuilder(
                                    builder:
                                        (BuildContext context, AsyncSnapshot<
                                        double> qttnumbr) {
                                      return Center(
                                        child: Text(
                                          'In  : ${qttnumbr.data.round()} L.L',
                                          style: TextStyle(
                                              color: Colors.black, fontSize: 18),
                                        ),
                                      );
                                    },
                                    initialData: 1.0,
                                    future: getqtt('in', startDate, 'L.L.')),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: FutureBuilder(
                                    builder:
                                        (BuildContext context, AsyncSnapshot<
                                        double> qttnumbr) {
                                      return Center(
                                        child: Text(
                                          'Out  : ${qttnumbr.data.round()} L.L',
                                          style: TextStyle(
                                              color: Colors.black, fontSize: 18),
                                        ),
                                      );
                                    },
                                    initialData: 1.0,
                                    future: getqtt('out', startDate, 'L.L.')),
                              ),

                            ],
                          ),
                          FutureBuilder(
                              builder:
                                  (BuildContext context, AsyncSnapshot<double> qttnumbr) {
                                return Center(
                                  child: Text(
                                    'Tolal  : ${qttnumbr.data.round() } L.L',
                                    style: TextStyle(color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                );
                              },
                              initialData: 1.0,
                              future: getsum(startDate, 'L.L.')),
                        ],
                      ),
                    ),
                  ),


                  SizedBox(height: 20,),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      color: Colors.white.withOpacity(0.0),
                      elevation: 20,
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: FutureBuilder(
                                    builder:
                                        (BuildContext context, AsyncSnapshot<
                                        double> qttnumbr) {
                                      return Center(
                                        child: Text(
                                          'In  : ${qttnumbr.data} \$', style: TextStyle(
                                            color: Colors.black, fontSize: 18),
                                        ),
                                      );
                                    },
                                    initialData: 1.0,
                                    future: getqtt('in', startDate, '\$')),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: FutureBuilder(
                                    builder:
                                        (BuildContext context, AsyncSnapshot<
                                        double> qttnumbr) {
                                      return Center(
                                        child: Text(
                                          'Out  : ${qttnumbr.data} \$', style: TextStyle(
                                            color: Colors.black, fontSize: 18),
                                        ),
                                      );
                                    },
                                    initialData: 1.0,
                                    future: getqtt('out', startDate, '\$')),
                              ),
                            ],
                          ),
                          FutureBuilder(
                              builder:
                                  (BuildContext context, AsyncSnapshot<double> qttnumbr) {
                                return Center(
                                  child: Text(
                                    'Tolal  : ${qttnumbr.data} \$',
                                    style: TextStyle(color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                );
                              },
                              initialData: 1.0,
                              future: getsum(startDate, '\$')),
                        ],
                      ),
                    ),
                  ),


                  MaterialButton(
                    onPressed: () {
                      gettransaction();
                      print(transaction);
                      showDialog(

                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(10.0))
                              ),
                              content: Scaffold(
                                body: Container(
                                  child: new ListView.builder(
                                      itemCount: transaction.length,

                                      itemBuilder: (BuildContext cntxt,
                                          int index) {
                                        return Dismissible(
                                          background: Material(
                                            color: Colors.red,
                                          ),
                                          onDismissed: (
                                              DismissDirection direction)  {
                                            return showDialog(
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return AlertDialog(
                                                    title: Text(
                                                        'Are You Sure To delete ?'),
                                                    actions: <Widget>[
                                                      MaterialButton(
                                                        child: Text('Cancel'),
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                      ),
                                                      MaterialButton(
                                                        child: Text('Yes'),
                                                        onPressed: () async {
                                                          print('${transaction[index]['id']}');
                                                          print(transaction[index]);
                                                          await _firestore.collection('omt')
                                                              .document(
                                                              '${transaction[index]['id']}')
                                                              .delete();
                                                          gettransaction();
                                                          transaction.remove(
                                                              transaction[index]);
                                                        },
                                                      )
                                                    ],
                                                  );
                                                });




//                                    await _firestore.collection('messages').getDocuments().then((snapshot) {
//                                      for (DocumentSnapshot ds in snapshot.documents){
//                                        ds.reference.delete();
//                                      });
//                                    }


                                          },
                                          key: Key(transaction[index].toString()),

                                          child: Row(
                                            children: <Widget>[
                                              Container(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      8.0),
                                                  child: Text(
                                                    '${transaction[index]['in']
                                                        .toString()}',
                                                    style: TextStyle(
                                                        color: Colors.green),),
                                                ),
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: Colors.black)),
                                                width: 85,
                                              ),
                                              Container(
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: Colors.black)),
                                                width: 85,
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      8.0),
                                                  child: Text(
                                                    '${transaction[index]['out']
                                                        .toString()}',
                                                    style: TextStyle(
                                                        color: Colors.red),),
                                                ),
                                              ),
                                              Container(
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: Colors.black)),
                                                width: 50,
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      8.0),
                                                  child: Text(
                                                    '${transaction[index]['curency']
                                                        .toString()}',
                                                    style: TextStyle(color: Colors
                                                        .blueAccent),),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }),
                                ),
                              ),

                            );
                          }
                      );
                    },
                    child: Text('Daily Report', style: TextStyle(
                      color: Colors.yellow,
                      backgroundColor: Colors.black54,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),),

                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Card(
                        color: Colors.white.withOpacity(0.0),
                        child: Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Text('start Date:'),
                                    FlatButton(
                                        onPressed: () {
                                          DatePicker.showDatePicker(context,
                                              showTitleActions: true,
                                              minTime: DateTime(2019, 1, 1),
                                              maxTime: DateTime(2025, 6, 7), onChanged: (date) {

                                              }, onConfirm: (date) {
                                                setState(() {
                                                  startDate =date;
                                                });



                                                print(startDate);
                                              }, currentTime: DateTime.now(), locale: LocaleType.en);
                                        },
                                        child: Text(
                                          '${formatDate(startDate, [yyyy, '-', mm, '-', dd])}',
                                          style: TextStyle(color: Colors.yellow,fontSize: 11),
                                        )),
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Text('End Date:'),
                                    FlatButton(
                                        onPressed: () {
                                          DatePicker.showDatePicker(context,
                                              showTitleActions: true,
                                              minTime: DateTime(2019, 1, 1),
                                              maxTime: DateTime(2025, 6, 7), onChanged: (date) {

                                              }, onConfirm: (date) {
                                                setState(() {
                                                  endDate =date.add(new Duration(hours: 23,minutes: 59,seconds: 59));
                                                });




                                              }, currentTime: DateTime.now(), locale: LocaleType.en);
                                        },
                                        child: Text(
                                          '${formatDate(endDate, [yyyy, '-', mm, '-', dd])}',
                                          style: TextStyle(color: Colors.yellow,fontSize: 11),
                                        )),
                                  ],
                                ),
                              ],
                            ),
                            MaterialButton(
                              onPressed: () {
                                gettransactiondate(startDate, endDate);
                                print(transaction);
                                showDialog(

                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10.0))
                                        ),
                                        content: Scaffold(
                                          body: Container(
                                            child: new ListView.builder(
                                                itemCount: transaction.length,

                                                itemBuilder: (BuildContext cntxt,
                                                    int index) {
                                                  return Dismissible(
                                                    background: Material(
                                                      color: Colors.red,
                                                    ),
                                                    onDismissed: (
                                                        DismissDirection direction)  {

                                                      return showDialog(
                                                          context: context,
                                                          builder: (BuildContext context) {
                                                            return AlertDialog(
                                                              title: Text(
                                                                  'Are You Sure To delete ?'),
                                                              actions: <Widget>[
                                                                MaterialButton(
                                                                  child: Text('Cancel'),
                                                                  onPressed: () {
                                                                    Navigator.of(context)
                                                                        .pop();
                                                                  },
                                                                ),
                                                                MaterialButton(
                                                                  child: Text('Yes'),
                                                                  onPressed: () async {
                                                                    print('${transaction[index]['id']}');
                                                                    print(transaction[index]);
                                                                    await _firestore.collection('omt')
                                                                        .document(
                                                                        '${transaction[index]['id']}')
                                                                        .delete();
                                                                    gettransaction();
                                                                    transaction.remove(
                                                                        transaction[index]);
                                                                  },
                                                                )
                                                              ],
                                                            );
                                                          });



                                                    },
                                                    key: Key(transaction[index].toString()),

                                                    child: Card(
                                                      child: ListTile(
                                                        title: Text('${formatDate(DateTime.parse(transaction[index]['time'].toDate().toString()), [yyyy, '-', mm, '-', dd])}',style: TextStyle(color: Colors.grey,fontSize: 12),),
                                                        subtitle: Row(
                                                          children: <Widget>[
                                                            Container(
                                                              child: Padding(
                                                                padding: const EdgeInsets.all(
                                                                    8.0),
                                                                child: Text(
                                                                  '${transaction[index]['in']
                                                                      .toString()}',
                                                                  style: TextStyle(
                                                                      color: Colors.green,fontSize: 10),),
                                                              ),
                                                              decoration: BoxDecoration(
                                                                  border: Border.all(
                                                                    color: Colors.black,)),
                                                              width: 70,
                                                            ),
                                                            Container(
                                                              decoration: BoxDecoration(
                                                                  border: Border.all(
                                                                      color: Colors.black)),
                                                              width: 70,
                                                              child: Padding(
                                                                padding: const EdgeInsets.all(
                                                                    8.0),
                                                                child: Text(
                                                                  '${transaction[index]['out']
                                                                      .toString()}',
                                                                  style: TextStyle(
                                                                      color: Colors.red,fontSize: 10),),
                                                              ),
                                                            ),
                                                            Container(
                                                              decoration: BoxDecoration(
                                                                  border: Border.all(
                                                                      color: Colors.black)),
                                                              width: 50,
                                                              child: Padding(
                                                                padding: const EdgeInsets.all(
                                                                    8.0),
                                                                child: Text(
                                                                  '${transaction[index]['curency']
                                                                      .toString()}',
                                                                  style: TextStyle(color: Colors
                                                                      .blueAccent,fontSize: 10),),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                }),
                                          ),
                                        ),

                                      );
                                    }
                                );
                              },
                              child: Text('Transaction Report', style: TextStyle(
                                color: Colors.yellow,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),),

                            ),
                          ],
                        ),
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

