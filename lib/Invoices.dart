import 'package:flutter/material.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';
import 'constants.dart';

final _firestore = Firestore.instance;
var listofInvoice = [];

class Invoices extends StatefulWidget {
  static const String id = 'Invoices_id';
  @override
  _InvoicesState createState() => _InvoicesState();
}

class _InvoicesState extends State<Invoices> {
  TextEditingController _textEditingController = TextEditingController();
  var ListOfItems = [];
  var categorieValue = '';
  var itemValue = '';
  var listcat = ['phones', 'recharge', 'accessories'];
  var catlist = [];
  var qtt = 0.0;

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
        });
        ListOfItems.sort((a, b) {
          return a['display'].toLowerCase().compareTo(b['display'].toLowerCase());
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
        });
        ListOfItems.sort((a, b) {
          return a['display'].toLowerCase().compareTo(b['display'].toLowerCase());
        });
      }
    }
    else{
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
        });
      }
      ListOfItems.sort((a, b) {
        return a['display'].toLowerCase().compareTo(b['display'].toLowerCase());
      });
    }


  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getcat();

    listofInvoice.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      body: Container(
        child: ListView.builder(
          itemCount: listofInvoice.length + 5,
          itemBuilder: (BuildContext context, int index) {
            if (index == 0) {
              return Container(
                child: DropDownFormField(
                  titleText: 'Select Categorie',
                  hintText: 'Please choose one',
                  value: categorieValue,
                  onSaved: (value) {
                    setState(() {
                      categorieValue = value;
                      getcategories(value);
                    });
                  },
                  onChanged: (value) {
                    setState(() {
                      categorieValue = value;
                      getcategories(value);
                    });
                  },
                  dataSource: catlist,
                  textField: 'display',
                  valueField: 'value',

                ),
              );
            }
            if (index == 1) {
              return Container(
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
              );
            }
            if (index == 2) {
              return Padding(
                padding: const EdgeInsets.only(left: 40, right: 40, top: 10),
                child: TextField(
                  controller: _textEditingController,
                  keyboardType: TextInputType.emailAddress,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    setState(() {
                      qtt = (double.parse(value));
                    });
                  },
                  decoration: KTextFieldImputDecoration.copyWith(
                      hintText: 'Enter Your Qtt'),
                ),
              );
            }
            if (index == 3) {
              return MaterialButton(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    color: Colors.yellow,
                    child: Text(
                      'Add',
                      style: TextStyle(color: Colors.black, fontSize: 35),
                    ),
                  ),
                ),
                onPressed: () {
                  if (itemValue == '' ||
                      categorieValue == '' ||
                      _textEditingController == null) {
                  } else {
                    setState(() {
                      listofInvoice.add({
                        'phonename': itemValue,
                        'categorie': categorieValue,
                        'inout': 'in',
                        'qtt': qtt,
                      });
                      itemValue = '';

                      qtt = 0.0;
                      _textEditingController.clear();
                    });
                  }
                },
              );
            }
            if (index == 4) {
              return MaterialButton(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    color: Colors.yellow,
                    child: Text(
                      'Send',
                      style: TextStyle(color: Colors.black, fontSize: 35),
                    ),
                  ),
                ),
                onPressed: () {
                  for (var i in listofInvoice) {
                    _firestore.collection('transaction').add({
                      'name': i['phonename'],
                      'categorie': i['categorie'],
                      'inout': 'in',
                      'qtt': i['qtt'],
                    });
                  }
                  setState(() {
                    listofInvoice.clear();
                  });
                },
              );
            } else {
              return Container(
                height: 40,
                child: Dismissible(
                    background: Material(
                      color: Colors.red,
                    ),
                    onDismissed: (DismissDirection direction) {
                      listofInvoice.remove(listofInvoice[index - 5]);
                      print(listofInvoice);
                    },
                    key: Key(listofInvoice[index - 5].toString()),
                    child: Center(
                      child: Container(
                        color: Colors.blueAccent[50],
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black)),
                        child: Row(children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                                child: Center(
                                    child: Text(
                              listofInvoice[index - 5]['phonename'],
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ))),
                          ),
                          SizedBox(
                            width: 40,
                          ),
                          Container(
                              child: Center(
                                  child: Text(
                            listofInvoice[index - 5]['qtt'].toString(),
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.yellow),
                          )))
                        ]),
                      ),
                    )),
              );
            }
          },
        ),
      ),
    );
  }
}
