import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'constants.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
final _firestore = Firestore.instance;
var name = '';
var phonenumber = '';
var now = new DateTime.now();
int day = now.day;
int year = now.year;
int month = now.month;
var description='';
class ClientsScreen extends StatefulWidget {
  static const String id = 'Clients_Screen';
  @override
  _ClientsScreenState createState() => new _ClientsScreenState();
}

class _ClientsScreenState extends State<ClientsScreen> {
  var transaction = [];
  var dtransaction=[];
  TextEditingController _textEditingController1 = TextEditingController();
  TextEditingController _textEditingController2 = TextEditingController();
  TextEditingController _textEditingController3 = TextEditingController();
  TextEditingController _textEditingController4 = TextEditingController();
  TextEditingController _textEditingController5 = TextEditingController();
  TextEditingController _textEditingController6 = TextEditingController();
  String mytext = '';
  String currentText = "";
  var ListOfItems = [];
  var categorieValue = '';
  var itemValue = '';
  var listcat = ['phones', 'recharge', 'accessories'];
  var catlist = [];
  var qtt = -1.0;
  var debt = 0.0;
  var DebtAnalysis = 0.0;

  bool _saving=true;
  var tomorow = new DateTime(year, month, day, 23, 59, 59, 99, 99);
  var startDate =  DateTime(year, month, day, 0, 0, 0, 0, 0);
  var today =  DateTime(year, month, day, 0, 0, 0, 0, 0);
  var endDate = new DateTime(year, month, day, 23, 59, 59, 99, 99);
  Future delay() async{
    await new Future.delayed(new Duration(seconds: 5), ()
    {
      setState(() {
        _saving=false;
      });

    });
  }

  void getcat() {
    catlist.clear();
    for (var i in listcat) {
      catlist.add({
        'display': i,
        'value': i,
      });
    }
  }

  void getcategories(String cat) async {
    setState(() {
      _saving=true;
    });
    ListOfItems.clear();
    if(cat=='phones'){
      final Messages = await _firestore
          .collection('tele')
          .where('categories', isEqualTo: cat)
          .getDocuments();
      for (var msg in Messages.documents) {
        final name = msg.data['phonename'].toString();
        setState(() {
          ListOfItems.add({
            'display': '$name',
            'value': '$name',
          });
          _saving=false;
        });
      }
    }
    if(cat=='accessories'){
      final Messages = await _firestore
          .collection('accessories')
          .where('categories', isEqualTo: cat)
          .getDocuments();
      for (var msg in Messages.documents) {
        final name = msg.data['phonename'].toString();
        setState(() {
          ListOfItems.add({
            'display': '$name',
            'value': '$name',
          });
          _saving=false;
        });
      }
    }
    final Messages = await _firestore
        .collection('phones')
        .where('categories', isEqualTo: cat)
        .getDocuments();
    for (var msg in Messages.documents) {
      final name = msg.data['phonename'].toString();
      setState(() {
        ListOfItems.add({
          'display': '$name',
          'value': '$name',
        });
        _saving=false;
      });
    }
  }

  void gettransactiondate(String name) async {
    setState(() {
      _saving=true;
    });
    final messages = await _firestore
        .collection('transaction')
        .where('client', isEqualTo: name)
        .getDocuments();
    transaction.clear();
    for (var msg in messages.documents) {
      final name =msg.data['client'];
      final debt = msg.data['debt'];
      final product = msg.data['name'];
      final time = msg.data['timestamp'] as Timestamp;
      final ttime = msg.documentID;
      final price = msg.data['price'];
      final description=msg.data['description'];
      setState(() {
        transaction.add({
          'name':name,
          'debt': debt,
          'price':price,

          'product': product,
          'time': time,
          'id': ttime,
          'description':description,
        });
        _saving=false;
      });
    }
  }
  void gettransaction(DateTime start,DateTime end,String name) async {
    setState(() {
      _saving=true;
    });
    final messages = await _firestore
        .collection('transaction').where('timestamp',isGreaterThan: start).where('timestamp',isLessThan: end).where('cat',isEqualTo: 'client')
        .getDocuments();
    dtransaction.clear();
    for (var msg in messages.documents) {
      final name =msg.data['name'];
      final debt = msg.data['debt'];
      final price = msg.data['price'];
      final time = msg.data['timestamp'] as Timestamp;
      final ttime = msg.documentID;
      final qt=msg.data['qtt'];
      final client=msg.data['client'];
      final description=msg.data['description'];
      setState(() {
        dtransaction.add({
          'name':name,
          'debt': debt,
          'price': price,
          'time': time,
          'id': ttime,
          'qtt':qt,
          'client':client,
          'description':description,
        });
        _saving=false;
      });
    }
  }

  GlobalKey<AutoCompleteTextFieldState<String>> key = new GlobalKey();

  _ClientsScreenState() {
    textField = SimpleAutoCompleteTextField(
        key: key,
        controller: TextEditingController(text: mytext),
        suggestions: suggestions,
        textChanged: (text) => currentText = text,
        submitOnSuggestionTap: true,
        textSubmitted: (text) {
          setState(() {
            mytext = text;
          });
          getqtt(mytext);
          gettransactiondate(mytext);
          gettransaction(today, tomorow,mytext);

        });
  }
  Future<double> getqtt(String name) async {
    var qtts = [0.0];

    final messages = await _firestore
        .collection('transaction').where('cat',isEqualTo: 'client')
        .where('client', isEqualTo: name)
        .getDocuments();
    for (var msg in messages.documents) {
      final qtt = msg['debt'];
      final den = msg['price'];
      qtts.add(qtt.toDouble());
      qtts.add(-den.toDouble());
    }
    setState(() {
      _saving=false;
    });

    var result = qtts.reduce((sum, element) => sum + element);
    return new Future(() => result.toDouble());
  }

  List<String> suggestions = [];
  void getclients() async {
    suggestions.clear();
    final messages =
        await _firestore.collection('nameofclients').getDocuments();
    for (var msg in messages.documents) {
      final nn = msg.data['name'].toString();
      final pp = msg.data['phonenumber'];
      setState(() {
        suggestions.add(nn);
        _saving=false;
      });
    }
  }

  SimpleAutoCompleteTextField textField;
  bool showWhichErrorText = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getcat();
    getclients();
    delay();
    gettransaction(today, tomorow, mytext);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: new AppBar(
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.add,
                color: Colors.black,
              ),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        content: Card(
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 8, right: 8, top: 8, bottom: 8),
                                child: TextField(
                                  controller: _textEditingController4,
                                  keyboardType: TextInputType.emailAddress,
                                  textAlign: TextAlign.center,
                                  onChanged: (value) {
                                    setState(() {
                                      name = value;
                                    });
                                  },
                                  decoration:
                                      KTextFieldImputDecoration.copyWith(
                                          hintText: 'Enter Name Of Client'),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 8, right: 8, top: 8, bottom: 8),
                                child: TextField(
                                  controller: _textEditingController5,
                                  keyboardType: TextInputType.emailAddress,
                                  textAlign: TextAlign.center,
                                  onChanged: (value) {
                                    setState(() {
                                      phonenumber = value;

                                    });
                                  },
                                  decoration:
                                      KTextFieldImputDecoration.copyWith(
                                          hintText:
                                              'Enter PhoneNumber Of Client'),
                                ),
                              ),
                              MaterialButton(
                                onPressed: () {
                                  _firestore.collection('nameofclients').add({
                                    'name': name,
                                    'phone': phonenumber,
                                  });
                                  _textEditingController4.clear();
                                  _textEditingController5.clear();
                                  getclients();
                                },
                                child: Text(
                                  'Send',
                                  style: TextStyle(
                                      color: Colors.blue, fontSize: 30),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    });
              })
        ],
        title: new Text(
          'Clients',
          style: TextStyle(color: Colors.yellow),
        ),
        backgroundColor: Colors.black54,
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ModalProgressHUD(
        inAsyncCall: _saving,
        dismissible: true,
        child: Container(
          color: Colors.black54,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              children: <Widget>[
                textField,
                Center(
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          mytext,
                          style: TextStyle(fontSize: 25, color: Colors.yellow),
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
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        'Debt:',
                                        style: TextStyle(
                                            fontSize: 20, color: Colors.yellow),
                                      ),
                                    ),
                                    Text(
                                      '${qttnumbr.data.round()}',
                                      style:
                                          TextStyle(fontSize: 25, color: Colors.blue),
                                    ),
                                  ],
                                ),
                              );
                            },
                            initialData: 0.0,
                            future: getqtt(mytext)),
                      ),
                    ],
                  ),
                ),
                Container(
                  child: DropDownFormField(
                    titleText: 'Select Categorie',
                    hintText: 'Please choose one',
                    value: categorieValue,
                    onSaved: (value) {
                      setState(() {
                        categorieValue = value;
                        getcategories(value);
                        _saving=false;
                      });
                      print(categorieValue);
                    },
                    onChanged: (value) {
                      setState(() {
                        categorieValue = value;
                        getcategories(value);
                        _saving=false;
                      });
                    },
                    dataSource: catlist,
                    textField: 'display',
                    valueField: 'value',
                  ),
                ),
                Container(
                  child: DropDownFormField(

                    titleText: 'Select Item',
                    hintText: 'Please choose one',
                    value: itemValue,
                    onSaved: (value) {
                      setState(() {
                        itemValue = value;
                      });
                    },
                    onChanged: (value) {
                      setState(() {
                        itemValue = value;
                      });
                    },
                    dataSource: ListOfItems,
                    textField: 'display',
                    valueField: 'value',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 40, right: 40, top: 10),
                  child: TextField(
                    controller: _textEditingController1,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    onChanged: (value) {
                      setState(() {
                        qtt = -(double.parse(value));
                      });
                    },
                    decoration: KTextFieldImputDecoration.copyWith(
                        hintText: 'Enter Your Qtt'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 40, right: 40, top: 10),
                  child: TextField(
                    controller: _textEditingController2,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    onChanged: (value) {
                      setState(() {
                        debt = (double.parse(value));
                      });
                    },
                    decoration: KTextFieldImputDecoration.copyWith(hintText: 'Debt'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 40, right: 40, top: 10),
                  child: TextField(
                    controller: _textEditingController3,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    onChanged: (value) {
                      setState(() {
                        DebtAnalysis = (double.parse(value));
                      });
                    },
                    decoration:
                        KTextFieldImputDecoration.copyWith(hintText: 'Debt analysis'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 40, right: 40, top: 10),
                  child: TextField(
                    controller: _textEditingController6,
                    keyboardType: TextInputType.emailAddress,
                    textAlign: TextAlign.center,
                    onChanged: (value) {
                      setState(() {
                       description=value;
                      });
                    },
                    decoration:
                    KTextFieldImputDecoration.copyWith(hintText: 'description'),
                  ),
                ),
                Center(
                  child: MaterialButton(
                    onPressed: () {
                      if(mytext==''){

                      }
                      else {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Are You Sure?'),
                                actions: <Widget>[
                                  MaterialButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('cancel'),
                                  ),
                                  MaterialButton(
                                    onPressed: () {
                                      setState(() {
                                        _saving = true;
                                      });
                                      if (DebtAnalysis == 0) {

                                        _firestore.collection('transaction').add({
                                          'name': itemValue,
                                          'price': 0.0,
                                          'qtt': qtt,
                                          'timestamp': Timestamp.now(),
                                          'currency': 'L.L',
                                          'client':mytext,
                                          'debt': debt,
                                          'cat':'client',
                                          'description':description,


                                        });
                                      }
                                      else {
                                        _firestore.collection('transaction').add({
                                          'client': mytext,
                                          'price': DebtAnalysis,
                                          'timestamp': Timestamp.now(),
                                          'currency': 'L.L',
                                          'debt':0.0,
                                          'name':'cash',
                                          'qtt':0.0,
                                          'cat':'client',
                                          'description':description,
                                        });

                                      }


                                      setState(() {
                                        itemValue='';
                                        qtt = -1.0;
                                        debt = 0.0;
                                        DebtAnalysis = 0.0;
                                        _saving = false;
                                        description='';
                                      });

                                      _textEditingController1.clear();
                                      _textEditingController2.clear();
                                      _textEditingController3.clear();
                                      _textEditingController6.clear();
                                      gettransactiondate(mytext);
                                      gettransaction(today, tomorow, mytext);


                                      Navigator.of(context).pop();

                                    },
                                    child: Text('Yes'),
                                  ),
                                ],
                              );
                            });
                      }
                    },
                    child: Text(
                      'Send',
                      style: TextStyle(color: Colors.yellow, fontSize: 30),
                    ),
                  ),
                ),
                MaterialButton(
                  onPressed: () {
                    gettransactiondate(mytext);
                    print(transaction);
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0))),
                            content: Scaffold(
                              resizeToAvoidBottomPadding: false,
                              appBar: AppBar(
                                title: Text(
                                  mytext.toString(),
                                  style: TextStyle(color: Colors.black),
                                ),
                                backgroundColor: Colors.white,
                              ),
                              body: Container(
                                child: new ListView.builder(
                                    itemCount: transaction.length,
                                    itemBuilder: (BuildContext cntxt, int index) {
                                      return Dismissible(
                                        background: Material(
                                          color: Colors.red,
                                        ),
                                        onDismissed:
                                            (DismissDirection direction)  {
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
                                                                .collection('transaction')
                                                                .document('${transaction[index]['id']}')
                                                                .delete();


                                                            transaction.remove(transaction[index]);
                                                            gettransactiondate(mytext);
                                                            Navigator.of(context)
                                                                .pop();
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
                                        child: Card(
                                          child: Column(
                                            children: <Widget>[
                                              Text('${transaction[index]['description']}'),
                                              ListTile(
                                                title: Text(
                                                  '${formatDate(DateTime.parse(transaction[index]['time'].toDate().toString()), [
                                                    yyyy,
                                                    '-',
                                                    mm,
                                                    '-',
                                                    dd
                                                  ])}',
                                                  style: TextStyle(
                                                      color: Colors.grey, fontSize: 12),
                                                ),
                                                subtitle: Row(
                                                  children: <Widget>[
                                                    Flexible(
                                                      child: Container(
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets.all(8.0),
                                                          child: Text(
                                                            '${transaction[index]['debt'].toString()}',
                                                            style: TextStyle(
                                                                color: Colors.green,
                                                                fontSize: 10),
                                                          ),
                                                        ),
                                                        decoration: BoxDecoration(
                                                            border: Border.all(
                                                                color: Colors.black)),
                                                        width: 70,
                                                      ),
                                                    ),
                                                    Flexible(
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                            border: Border.all(
                                                                color: Colors.black)),
                                                        width: 70,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets.all(8.0),
                                                          child: Text(
                                                            '${transaction[index]['price']}',
                                                            style: TextStyle(
                                                                color: Colors.red,
                                                                fontSize: 10),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Flexible(
                                                      child: Container(
                                                        width: 70,
                                                        decoration: BoxDecoration(
                                                            border: Border.all(
                                                                color: Colors.black)),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets.all(8.0),
                                                          child: Text(
                                                            '${transaction[index]['product'].toString()}',
                                                            style: TextStyle(
                                                                color: Colors.blueAccent,
                                                                fontSize: 10),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
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
                    'Client Report',
                    style: TextStyle(
                      color: Colors.yellow,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                MaterialButton(
                  onPressed: () {
                      gettransaction(today,tomorow,mytext);
                      print(dtransaction);


                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(10.0))),
                            content: Scaffold(
                              appBar: AppBar(
                                title: Text(
                                  '${formatDate(now, [
                                    yyyy,
                                    '-',
                                    mm,
                                    '-',
                                    dd
                                  ])}',
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 12),
                                ),
                              ),

                              body: Container(
                                child: new ListView.builder(
                                    itemCount: dtransaction.length,
                                    itemBuilder: (BuildContext cntxt, int index) {
                                      return Dismissible(
                                        background: Material(
                                          color: Colors.red,
                                        ),
                                        onDismissed:
                                            (DismissDirection direction)  {

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
                                                                .collection('transaction')
                                                                .document('${dtransaction[index]['id']}')
                                                                .delete();
                                                            gettransaction(today,tomorow,mytext);
                                                            dtransaction.remove(dtransaction[index]);
                                                            Navigator.of(context)
                                                                .pop();
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
                                        key: Key(dtransaction[index].toString()),
                                        child: Card(
                                          child: ListTile(
                                            title: Text('${dtransaction[index]['client'].toString()}',
                                              style: TextStyle(
                                                  color: Colors.blue,
                                                  fontSize: 10),),
                                            subtitle: Row(
                                              children: <Widget>[
                                                Flexible(
                                                  child: Container(
                                                    child: Padding(
                                                      padding:
                                                      const EdgeInsets.all(8.0),
                                                      child: Text(
                                                        '${dtransaction[index]['debt'].toString()}',
                                                        style: TextStyle(
                                                            color: Colors.green,
                                                            fontSize: 10),
                                                      ),
                                                    ),
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: Colors.black)),
                                                    width: 70,
                                                  ),
                                                ),
                                                Flexible(
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: Colors.black)),
                                                    width: 70,
                                                    child: Padding(
                                                      padding:
                                                      const EdgeInsets.all(8.0),
                                                      child: Text(
                                                        '${dtransaction[index]['price']}',
                                                        style: TextStyle(
                                                            color: Colors.red,
                                                            fontSize: 10),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Flexible(
                                                  child: Container(
                                                    width: 70,
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: Colors.black)),
                                                    child: Padding(
                                                      padding:
                                                      const EdgeInsets.all(8.0),
                                                      child: Text(
                                                        '${dtransaction[index]['name'].toString()}',
                                                        style: TextStyle(
                                                            color: Colors.blueAccent,
                                                            fontSize: 10),
                                                      ),
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
                    'Daily Report',
                    style: TextStyle(
                      color: Colors.yellow,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Card(
                  color: Colors.white.withOpacity(0.0),
                  child: Column(
                    children: <Widget>[
                      Center(child: Text('Transaction Report',style: TextStyle(color: Colors.black54),)),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Row(
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
                                        style: TextStyle(color: Colors.yellow,fontSize: 15),
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
                                        style: TextStyle(color: Colors.yellow,fontSize: 15),
                                      )),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      MaterialButton(
                        onPressed: () {

                            gettransaction(startDate,endDate,mytext);


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
                                          itemCount: dtransaction.length,
                                          itemBuilder: (BuildContext cntxt, int index) {
                                            return Dismissible(
                                              background: Material(
                                                color: Colors.red,
                                              ),
                                              onDismissed:
                                                  (DismissDirection direction)  {
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
                                                                      .collection('transaction')
                                                                      .document('${dtransaction[index]['id']}')
                                                                      .delete();
                                                                  gettransaction(today,tomorow,mytext);
                                                                  dtransaction.remove(dtransaction[index]);
                                                                  gettransaction(today, tomorow, mytext);
                                                                  Navigator.of(context)
                                                                      .pop();
                                                                },
                                                              )
                                                            ],
                                                          );
                                                        });






                                              },
                                              key: Key(dtransaction[index].toString()),
                                              child: Card(
                                                child: Column(
                                                  children: <Widget>[
                                                Text(
                                                  '${formatDate(DateTime.parse(dtransaction[index]['time'].toDate().toString()), [
                                                    yyyy,
                                                    '-',
                                                    mm,
                                                    '-',
                                                    dd
                                                  ])}',
                                                  style: TextStyle(
                                                      color: Colors.grey, fontSize: 12),
                                              ),
                                                    ListTile(
                                                      title: Text(
                                                        '${dtransaction[index]['client'].toString()}',
                                                        style: TextStyle(
                                                            color: Colors.blue,
                                                            fontSize: 10),),
                                                      subtitle: Row(
                                                        children: <Widget>[
                                                          Flexible(
                                                            child: Container(
                                                              child: Padding(
                                                                padding:
                                                                const EdgeInsets.all(8.0),
                                                                child: Text(
                                                                  '${dtransaction[index]['debt'].toString()}',
                                                                  style: TextStyle(
                                                                      color: Colors.green,
                                                                      fontSize: 10),
                                                                ),
                                                              ),
                                                              decoration: BoxDecoration(
                                                                  border: Border.all(
                                                                      color: Colors.black)),
                                                              width: 70,
                                                            ),
                                                          ),
                                                          Flexible(
                                                            child: Container(
                                                              decoration: BoxDecoration(
                                                                  border: Border.all(
                                                                      color: Colors.black)),
                                                              width: 70,
                                                              child: Padding(
                                                                padding:
                                                                const EdgeInsets.all(8.0),
                                                                child: Text(
                                                                  '${dtransaction[index]['price']}',
                                                                  style: TextStyle(
                                                                      color: Colors.red,
                                                                      fontSize: 10),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          Flexible(
                                                            child: Container(
                                                              width: 70,
                                                              decoration: BoxDecoration(
                                                                  border: Border.all(
                                                                      color: Colors.black)),
                                                              child: Padding(
                                                                padding:
                                                                const EdgeInsets.all(8.0),
                                                                child: Text(
                                                                  '${dtransaction[index]['name'].toString()}',
                                                                  style: TextStyle(
                                                                      color: Colors.blueAccent,
                                                                      fontSize: 10),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
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
                          'Transaction',
                          style: TextStyle(
                            color: Colors.yellow,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),



                    ],

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
