import 'package:date_format/date_format.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:esc_pos_printer/esc_pos_printer.dart';

var now = new DateTime.now();
int day = now.day;
int year = now.year;
int month = now.month;
final _firestore = Firestore.instance;

class ReportsScreen extends StatefulWidget {
  static const String id = 'Reports_Screen';
  @override
  _ReportsScreenState createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  var transaction = [];
  var Mtransaction = [];
  var Stransaction = [];
  var tomorow = new DateTime(year, month, day, 23, 59, 59, 99, 99);
  var startDate = DateTime(year, month, day, 0, 0, 0, 0, 0);
  var endDate = new DateTime(year, month, day, 23, 59, 59, 99, 99);
  bool _saving = true;
  Future delay() async {
    await new Future.delayed(new Duration(seconds: 5), () {
      setState(() {
        _saving = false;
      });
    });
  }

  Future<double> getTodayIn(
      DateTime start, DateTime end, List list, String currency) async {
    list.clear();

    final messsages = await _firestore
        .collection('transaction')
        .where('currency', isEqualTo: currency)
        .where('timestamp', isGreaterThan: start)
        .where('timestamp', isLessThan: end)
        .getDocuments();
    final messages2 = await _firestore
        .collection('others')
        .where('currency', isEqualTo: currency)
        .where('timestamp', isGreaterThan: start)
        .where('timestamp', isLessThan: end)
        .getDocuments();
    for (var msg in messsages.documents) {
      final price = msg.data['price'];
      setState(() {
        list.add(
          price,
        );
      });
    }

    for (var msg in messages2.documents) {
      final price = msg.data['price'];
      setState(() {
        list.add(
          price,
        );
      });
    }
    var result = list.reduce((sum, element) => sum + element);
    return new Future(() => result);
  }

  void getmaintenance(
      DateTime s, DateTime e, String name, List Otransaction) async {
    final messages = await _firestore
        .collection('others')
        .where('timestamp', isGreaterThan: s)
        .where('timestamp', isLessThan: e)
        .where('name', isEqualTo: name)
        .getDocuments();
    Otransaction.clear();
    for (var msg in messages.documents) {
      final des = msg.data['description'];
      final price = msg.data['price'];
      final id = msg.documentID;
      final time = msg.data['timestamp'];
      setState(() {
        Otransaction.add(
            {'description': des, 'price': price, 'id': id, 'time': time});
      });
    }
  }

  Future<double> getqtt(String name) async {
    var qtts = [0.0];

    final messages = await _firestore
        .collection('transaction')
        .where('name', isEqualTo: name)
        .getDocuments();
    for (var msg in messages.documents) {
      final qtt = msg['qtt'];

      qtts.add(qtt);

      print(qtt);
    }

    var result = qtts.reduce((sum, element) => sum + element);
    return new Future(() => result);
  }

  void gettransactiondate(DateTime start, DateTime end) async {
    final messages = await _firestore
        .collection('transaction')
        .where('timestamp', isGreaterThan: start)
        .where('timestamp', isLessThan: end)
        .getDocuments();
    transaction.clear();
    for (var msg in messages.documents) {
      final name = msg.data['name'];
      final price = msg.data['price'];
      final ccurency = msg.data['currency'];
      final ttime = msg.documentID;
      final time = msg.data['timestamp'];
      final qtt = msg.data['qtt'];
      setState(() {
        transaction.add({
          'name': name,
          'price': price,
          'curency': ccurency,
          'id': ttime,
          'time': time,
          'qtt': qtt,
        });
        _saving = false;
      });
    }
  }

  Future<double> getqttmtc(String name) async {
    var qtts = [0.0];

    final messages = await _firestore
        .collection('transaction')
        .where('name', isEqualTo: name)
        .getDocuments();
    for (var msg in messages.documents) {
      final qtt = msg['qtt'];

      qtts.add(qtt);

      print(qtt);
    }

    var result = qtts.reduce((sum, element) => sum + element);
    return new Future(() => result);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    now = DateTime.now();
    gettransactiondate(startDate, endDate);
    getmaintenance(startDate, endDate, 'maintenance', Mtransaction);
    getmaintenance(startDate, endDate, 'spending', Stransaction);
    delay();
  }

  @override
  Widget build(BuildContext context) {
    var today = new DateTime(year, month, day, 0, 0, 0, 0, 0);

    var IN$ = [];
    var INLL = [];
    var rangeIn$ = [];
    var rangeInLL = [];
    return Scaffold(
        backgroundColor: Colors.black54,
        body: ModalProgressHUD(
          inAsyncCall: _saving,
          dismissible: true,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 20, left: 20, top: 20),
                child: Card(
                  color: Colors.white.withOpacity(0.0),
                  elevation: 20,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Center(
                          child: Text(
                        'Daily Report',
                        style: TextStyle(color: Colors.black54),
                      )),
                      Center(
                        child: FutureBuilder(
                          builder: (BuildContext context,
                              AsyncSnapshot<double> qttnumbr) {
                            return Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text('\$  '),
                                  Text(
                                    '${qttnumbr.data}',
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.yellow),
                                  ),
                                ],
                              ),
                            );
                          },
                          initialData: 0.0,
                          future: getTodayIn(today, tomorow, IN$, '\$'),
                        ),
                      ),
                      Center(
                        child: FutureBuilder(
                          builder: (BuildContext context,
                              AsyncSnapshot<double> qttnumbr) {
                            return Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text('L.L  '),
                                  Text(
                                    '${qttnumbr.data}',
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.yellow),
                                  ),
                                ],
                              ),
                            );
                          },
                          initialData: 0.0,
                          future: getTodayIn(today, tomorow, INLL, 'L.L'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 20, left: 20, top: 20),
                child: Card(
                  color: Colors.white.withOpacity(0.0),
                  elevation: 20,
                  child: Column(
                    children: <Widget>[
                      Center(
                          child: Text(
                        'Monthly Report',
                        style: TextStyle(color: Colors.black54),
                      )),
                      Row(children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text('start Date:'),
                            FlatButton(
                                onPressed: () {
                                  DatePicker.showDatePicker(context,
                                      showTitleActions: true,
                                      minTime: DateTime(2019, 1, 1),
                                      maxTime: DateTime(2025, 6, 7),
                                      onChanged: (date) {}, onConfirm: (date) {
                                    setState(() {
                                      startDate = date;
                                    });

                                    print(startDate);
                                  },
                                      currentTime: DateTime.now(),
                                      locale: LocaleType.en);
                                },
                                child: Text(
                                  '${formatDate(startDate, [
                                    yyyy,
                                    '-',
                                    mm,
                                    '-',
                                    dd
                                  ])}',
                                  style: TextStyle(color: Colors.yellow),
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
                                      maxTime: DateTime(2025, 6, 7),
                                      onChanged: (date) {}, onConfirm: (date) {
                                    setState(() {
                                      endDate = date.add(new Duration(
                                          hours: 23, minutes: 59, seconds: 59));
                                    });
                                  },
                                      currentTime: DateTime.now(),
                                      locale: LocaleType.en);
                                },
                                child: Text(
                                  '${formatDate(endDate, [
                                    yyyy,
                                    '-',
                                    mm,
                                    '-',
                                    dd
                                  ])}',
                                  style: TextStyle(color: Colors.yellow),
                                )),
                          ],
                        ),
                      ]),
                      FutureBuilder(
                        builder: (BuildContext context,
                            AsyncSnapshot<double> qttnumbr) {
                          return Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text('\$  '),
                                Text(
                                  '${qttnumbr.data}',
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.yellow),
                                ),
                              ],
                            ),
                          );
                        },
                        initialData: 0.0,
                        future: getTodayIn(startDate, endDate, rangeIn$, '\$'),
                      ),
                      FutureBuilder(
                        builder: (BuildContext context,
                            AsyncSnapshot<double> qttnumbr) {
                          return Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text('L.L  '),
                                Text(
                                  '${qttnumbr.data}',
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.yellow),
                                ),
                              ],
                            ),
                          );
                        },
                        initialData: 0.0,
                        future:
                            getTodayIn(startDate, endDate, rangeInLL, 'L.L'),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 20, left: 20, top: 20),
                child: Card(
                  color: Colors.white.withOpacity(0.0),
                  elevation: 20,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Recharge Report',
                        style: TextStyle(color: Colors.black54),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: FutureBuilder(
                              builder: (BuildContext context,
                                  AsyncSnapshot<double> qttnumbr) {
                                return Center(
                                  child: Row(
                                    children: <Widget>[
                                      Text(
                                        'alfa 9\$',
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 15),
                                      ),
                                      Text(
                                        '${qttnumbr.data}',
                                        style: TextStyle(
                                            fontSize: 15, color: Colors.yellow),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              initialData: 0.0,
                              future: getqtt('alfa9\$'),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: FutureBuilder(
                              builder: (BuildContext context,
                                  AsyncSnapshot<double> qttnumbr) {
                                return Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        'alfa 22\$',
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 15),
                                      ),
                                      Text(
                                        '${qttnumbr.data}',
                                        style: TextStyle(
                                            fontSize: 15, color: Colors.yellow),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              initialData: 0.0,
                              future: getqtt('alfa22\$'),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: FutureBuilder(
                              builder: (BuildContext context,
                                  AsyncSnapshot<double> qttnumbr) {
                                return Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        'alfa \$\$',
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 15),
                                      ),
                                      Text(
                                        '${qttnumbr.data}',
                                        style: TextStyle(
                                            fontSize: 15, color: Colors.yellow),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              initialData: 0.0,
                              future: getqtt('alfa\$\$\$'),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: FutureBuilder(
                              builder: (BuildContext context,
                                  AsyncSnapshot<double> qttnumbr) {
                                return Center(
                                  child: Row(
                                    children: <Widget>[
                                      Text(
                                        'MTC 12\$',
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 15),
                                      ),
                                      Text(
                                        '${qttnumbr.data}',
                                        style: TextStyle(
                                            fontSize: 15, color: Colors.yellow),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              initialData: 0.0,
                              future: getqtt('MTC 12\$'),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: FutureBuilder(
                              builder: (BuildContext context,
                                  AsyncSnapshot<double> qttnumbr) {
                                return Center(
                                  child: Row(
                                    children: <Widget>[
                                      Text(
                                        'MTC 22\$',
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 15),
                                      ),
                                      Text(
                                        '${qttnumbr.data}',
                                        style: TextStyle(
                                            fontSize: 15, color: Colors.yellow),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              initialData: 0.0,
                              future: getqttmtc('mtc 22\$'),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: FutureBuilder(
                              builder: (BuildContext context,
                                  AsyncSnapshot<double> qttnumbr) {
                                return Center(
                                  child: Row(
                                    children: <Widget>[
                                      Text(
                                        'MTC \$\$',
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 15),
                                      ),
                                      Text(
                                        '${qttnumbr.data.toStringAsFixed(2)}',
                                        style: TextStyle(
                                            fontSize: 15, color: Colors.yellow),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              initialData: 0.0,
                              future: getqtt('mtc\$\$\$'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0))),
                          content: Scaffold(
                            body: Container(
                              child: new ListView.builder(
                                  itemCount: transaction.length,
                                  itemBuilder: (BuildContext cntxt, int index) {
                                    return Dismissible(
                                      background: Material(
                                          color: Colors.red,
                                          child: Center(
                                            child: Stack(
                                              children: <Widget>[
                                                Positioned(
                                                    right: 8,
                                                    top: 15,
                                                    child: Center(
                                                        child: Text(
                                                      'Delete',
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ))),
                                              ],
                                            ),
                                          )),
                                      onDismissed:
                                          (DismissDirection direction) {
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
                                                      print(
                                                          '${transaction[index]['id']}');
                                                      print(transaction[index]);
                                                      await _firestore
                                                          .collection(
                                                              'transaction')
                                                          .document(
                                                              '${transaction[index]['id']}')
                                                          .delete();
                                                      gettransactiondate(
                                                          startDate, endDate);
                                                      transaction.remove(
                                                          transaction[index]);
                                                      Navigator.of(context).pop();
                                                    },
                                                  )
                                                ],
                                              );
                                            });
                                      },
                                      key: Key(transaction[index].toString()),
                                      child: Card(
                                        child: ListTile(
                                          title: Text(
                                            '${formatDate(DateTime.parse(transaction[index]['time'].toDate().toString()), [
                                              yyyy,
                                              '-',
                                              mm,
                                              '-',
                                              dd
                                            ])}',
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 12),
                                          ),
                                          subtitle: Row(
                                            children: <Widget>[
                                              Container(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: AutoSizeText(
                                                    '${transaction[index]['name'].toString()}',
                                                    style: TextStyle(
                                                      color: Colors.green,
                                                    ),
                                                    minFontSize: 5,
                                                  ),
                                                ),
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                  color: Colors.black,
                                                )),
                                                width: 60,
                                                height: 30,
                                              ),
                                              Container(
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: Colors.black)),
                                                width: 60,
                                                height: 30,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: AutoSizeText(
                                                    '${transaction[index]['price'].toString()}',
                                                    style: TextStyle(
                                                      color: Colors.red,
                                                    ),
                                                    minFontSize: 5,
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: Colors.black)),
                                                width: 30,
                                                height: 30,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: AutoSizeText(
                                                    '${transaction[index]['curency'].toString()}',
                                                    style: TextStyle(
                                                      color: Colors.blueAccent,
                                                    ),
                                                    minFontSize: 5,
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: Colors.black)),
                                                width: 40,
                                                height: 30,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: AutoSizeText(
                                                    '${(-transaction[index]['qtt']).toString()}',
                                                    style: TextStyle(
                                                      color: Colors.blueAccent,
                                                    ),
                                                    minFontSize: 5,
                                                  ),
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
                      });
                },
                child: Text(
                  'Transaction Report',
                  style: TextStyle(
                    color: Colors.yellow,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              MaterialButton(
                onPressed: () {
                  getmaintenance(
                      startDate, endDate, 'maintenance', Mtransaction);
                  print(transaction);
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0))),
                          content: Scaffold(
                            body: Container(
                              child: new ListView.builder(
                                  itemCount: Mtransaction.length,
                                  itemBuilder: (BuildContext cntxt, int index) {
                                    return Dismissible(
                                      background: Material(
                                        color: Colors.red,
                                      ),
                                      onDismissed:
                                          (DismissDirection direction) {
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
                                                      await _firestore
                                                          .collection('others')
                                                          .document(
                                                              '${Mtransaction[index]['id']}')
                                                          .delete();
                                                      getmaintenance(
                                                          startDate,
                                                          endDate,
                                                          'maintenance',
                                                          Mtransaction);
                                                      Mtransaction.remove(
                                                          Mtransaction[index]);
                                                      Navigator.of(context).pop();
                                                    },
                                                  )
                                                ],
                                              );
                                            });
                                      },
                                      key: Key(Mtransaction[index].toString()),
                                      child: Card(
                                        child: ListTile(
                                          title: Text(
                                            '${formatDate(DateTime.parse(Mtransaction[index]['time'].toDate().toString()), [
                                              yyyy,
                                              '-',
                                              mm,
                                              '-',
                                              dd
                                            ])}',
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 12),
                                          ),
                                          subtitle: Row(
                                            children: <Widget>[
                                              Container(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    '${Mtransaction[index]['description'].toString()}',
                                                    style: TextStyle(
                                                        color: Colors.green,
                                                        fontSize: 10),
                                                  ),
                                                ),
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                  color: Colors.black,
                                                )),
                                                width: 70,
                                              ),
                                              Container(
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: Colors.black)),
                                                width: 70,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    '${Mtransaction[index]['price'].toString()}',
                                                    style: TextStyle(
                                                        color: Colors.red,
                                                        fontSize: 10),
                                                  ),
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
                      });
                },
                child: Text(
                  'Maintenance Report',
                  style: TextStyle(
                    color: Colors.yellow,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              MaterialButton(
                onPressed: () {
                  getmaintenance(startDate, endDate, 'spending', Stransaction);
                  print(transaction);
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0))),
                          content: Scaffold(
                            body: Container(
                              child: new ListView.builder(
                                  itemCount: Stransaction.length,
                                  itemBuilder: (BuildContext cntxt, int index) {
                                    return Dismissible(
                                      background: Material(
                                        color: Colors.red,
                                      ),
                                      onDismissed:
                                          (DismissDirection direction) {
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
                                                      await _firestore
                                                          .collection('others')
                                                          .document(
                                                              '${Stransaction[index]['id']}')
                                                          .delete();
                                                      getmaintenance(
                                                          startDate,
                                                          endDate,
                                                          'spending',
                                                          Stransaction);
                                                      Stransaction.remove(
                                                          Stransaction[index]);
                                                      Navigator.of(context).pop();
                                                    },
                                                  )
                                                ],
                                              );
                                            });

//                                        await _firestore
//                                            .collection('others')
//                                            .document(
//                                                '${Stransaction[index]['id']}')
//                                            .delete();
//                                        getmaintenance(startDate, endDate,
//                                            'spending', Stransaction);
//                                        Stransaction.remove(
//                                            Stransaction[index]);
                                      },
                                      key: Key(Stransaction[index].toString()),
                                      child: Card(
                                        child: ListTile(
                                          title: Text(
                                            '${formatDate(DateTime.parse(Stransaction[index]['time'].toDate().toString()), [
                                              yyyy,
                                              '-',
                                              mm,
                                              '-',
                                              dd
                                            ])}',
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 12),
                                          ),
                                          subtitle: Row(
                                            children: <Widget>[
                                              Container(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    '${Stransaction[index]['description'].toString()}',
                                                    style: TextStyle(
                                                        color: Colors.green,
                                                        fontSize: 10),
                                                  ),
                                                ),
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                  color: Colors.black,
                                                )),
                                                width: 70,
                                              ),
                                              Container(
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: Colors.black)),
                                                width: 70,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    '${Stransaction[index]['price'].toString()}',
                                                    style: TextStyle(
                                                        color: Colors.red,
                                                        fontSize: 10),
                                                  ),
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
                      });
                },
                child: Text(
                  'Spending Report',
                  style: TextStyle(
                    color: Colors.yellow,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              MaterialButton(
                child: Text('Print'),
                onPressed: () {
                  Printer.connect('192.168.168.6', port: 9100)
                      .then((printer) {});
                },
              )
            ],
          ),
        ));
  }
}
