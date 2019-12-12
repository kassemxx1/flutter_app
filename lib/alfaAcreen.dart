import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'constants.dart';
import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
//import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:modal_progress_hud/modal_progress_hud.dart';

final _firestore = Firestore.instance;
FirebaseStorage _storage = FirebaseStorage.instance;

class AlfaScreen extends StatefulWidget {
  static const String id = 'alfa_Screen';
  @override
  _AlfaScreenState createState() => _AlfaScreenState();
}

class _AlfaScreenState extends State<AlfaScreen> {
  var ListOfPhones = [];
  var ListOfItems = [];
  var ImageLink;
  var upload = 'Choose the Item Image';
  var nameOfItem = '';
  var PriceOfItem = '';
  bool _saving = true;
  var msg = 0.4;
  void getcost(double _n) {
    if (10 < -_n && -_n <= 20) {
      setState(() {
        msg = msg * 2;
      });
    }
    if (20 < -_n && -_n <= 30) {
      setState(() {
        msg = msg * 3;
      });
    }
    if (40 < -_n && -_n <= 50) {
      setState(() {
        msg = msg * 4;
      });
    }
    if (50 < -_n && -_n <= 60) {
      setState(() {
        msg = msg * 5;
      });
    }
    if (60 < -_n && -_n <= 70) {
      setState(() {
        msg = msg * 6;
      });
    } else {
      setState(() {
        msg = 0.4;
      });
    }
  }

  Future delay() async {
    await new Future.delayed(new Duration(seconds: 5), () {
      setState(() {
        _saving = false;
      });
    });
  }

  Future<String> uploadPic() async {
    //Get the file from the image picker and store it
    File image = await ImagePicker.pickImage(source: ImageSource.gallery);

    //Create a reference to the location you want to upload to in firebase
    StorageReference reference = _storage.ref().child('images/');

    //Upload the file to firebase
    StorageUploadTask uploadTask = reference.putFile(image);

    // Waits till the file is uploaded then stores the download url
    String location =
        await (await uploadTask.onComplete).ref.getDownloadURL() as String;
    print(location);
    setState(() {
      upload = 'Uploade';
      ImageLink = location;
    });

    //returns the download url
    return location;
  }

  void getPhonesList() async {
    ListOfPhones.clear();
    final messages = await _firestore
        .collection('phones')
        .where('categories', isEqualTo: 'recharge')
        .where('sub', isEqualTo: 'alfa')
        .getDocuments();
    for (var msg in messages.documents) {
      final name = msg['phonename'].toString();
      final price = msg['price'];
      final image = msg['image'].toString();
      setState(() {
        ListOfPhones.add({'phonename': name, 'price': price, 'image': image});
        _saving = false;
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
      qtts.add(qtt.toDouble());
    }

    var result = qtts.reduce((sum, element) => sum + element);
    return new Future(() => result.toDouble());
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPhonesList();
    delay();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white24,
        child: ModalProgressHUD(
          inAsyncCall: _saving,
          dismissible: true,
          child: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                title: Text(
                  'Recharge',
                  style: TextStyle(color: Colors.black),
                ),
                backgroundColor: Colors.white,
                leading: new IconButton(
                  icon: new Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Card(
                          elevation: 20,
                          child: Container(
                            child: Column(
                              children: <Widget>[
                                Expanded(
                                  child: Container(
                                    child: ImageLink(
                                      imageUrl: ListOfPhones[index]['image'],
                                    ),
                                  ),
                                ),
                                Text(
                                  ListOfPhones[index]['phonename'],
                                  style: TextStyle(fontSize: 20),
                                ),
                                Text(
                                  '${ListOfPhones[index]['price'].toString()} \$',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.green),
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
                                              '${ListOfPhones[index]['phonename'] == 'alfa\$\$\$' ? qttnumbr.data.toStringAsFixed(2) : qttnumbr.data.round()}',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.blueAccent),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                    initialData: 0.0,
                                    future: getqtt(
                                        ListOfPhones[index]['phonename'])),
                                MaterialButton(
                                  child: Text(
                                    'Sell',
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.blueAccent,
                                    ),
                                  ),
                                  onPressed: () {
                                    var _n = -1.0;
                                    var _price = 0.0;
                                    var currency = 'L.L';
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            content: Form(
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: <Widget>[
                                                  Expanded(
                                                    child: Container(
                                                      child: ImageLink(
                                                        imageUrl:
                                                            ListOfPhones[index]
                                                                ['image'],
                                                      ),
                                                    ),
                                                  ),
                                                  Text(
                                                    ListOfPhones[index]
                                                        ['phonename'],
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Text(
                                                    '${ListOfPhones[index]['price'].toString()} \$',
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.green),
                                                  ),
                                                  FutureBuilder(
                                                      builder: (BuildContext
                                                              context,
                                                          AsyncSnapshot<double>
                                                              qttnumbr) {
                                                        return Center(
                                                          child: Text(
                                                            'Available : ${qttnumbr.data}',
                                                          ),
                                                        );
                                                      },
                                                      initialData: 1.0,
                                                      future: getqtt(
                                                          ListOfPhones[index]
                                                              ['phonename'])),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 40,
                                                            right: 40,
                                                            top: 10),
                                                    child: TextField(
                                                      keyboardType:
                                                          TextInputType
                                                              .emailAddress,
                                                      textAlign:
                                                          TextAlign.center,
                                                      onChanged: (value) {
                                                        setState(() {
                                                          _n = -(double.parse(
                                                              value));
                                                        });
                                                      },
                                                      decoration:
                                                          KTextFieldImputDecoration
                                                              .copyWith(
                                                                  hintText:
                                                                      'Enter Your Qtt'),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 40,
                                                            right: 40,
                                                            top: 10),
                                                    child: TextField(
                                                      keyboardType:
                                                          TextInputType
                                                              .emailAddress,
                                                      textAlign:
                                                          TextAlign.center,
                                                      onChanged: (value) {
                                                        setState(() {
                                                          _price =
                                                              (double.parse(
                                                                  value));
                                                        });
                                                      },
                                                      decoration:
                                                          KTextFieldImputDecoration
                                                              .copyWith(
                                                                  hintText:
                                                                      'Enter Your Price'),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: CustomRadioButton(
                                                      buttonColor:
                                                          Theme.of(context)
                                                              .canvasColor,
                                                      buttonLables: [
                                                        'L.L',
                                                        '\$',
                                                      ],
                                                      buttonValues: [
                                                        'L.L',
                                                        '\$',
                                                      ],
                                                      radioButtonValue:
                                                          (value) {
                                                        setState(() {
                                                          currency = value;
                                                        });
                                                      },
                                                      selectedColor:
                                                          Theme.of(context)
                                                              .accentColor,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 10,
                                                            bottom: 10),
                                                    child: MaterialButton(
                                                      child: Text(
                                                        'Sell',
                                                        style: TextStyle(
                                                            fontSize: 30,
                                                            color: Colors
                                                                .blueAccent,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      onPressed: () {
                                                        return showDialog(
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    conext) {
                                                              return AlertDialog(
                                                                title: Text(
                                                                    'Are You Sure to Sell ${-_n} ${ListOfPhones[index]['phonename']}?'),
                                                                actions: <
                                                                    Widget>[
                                                                  MaterialButton(
                                                                    child: Text(
                                                                        'cancel'),
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                    },
                                                                  ),
                                                                  MaterialButton(
                                                                    child: Text(
                                                                        'yes'),
                                                                    onPressed:
                                                                        () {
                                                                      if (ListOfPhones[index]['phonename'] ==
                                                                              'alfa Days' ||
                                                                          ListOfPhones[index]['phonename'] ==
                                                                              'alfa\$\$\$') {
                                                                        if (ListOfPhones[index]['phonename'] ==
                                                                            'alfa Days') {
                                                                          _firestore
                                                                              .collection('transaction')
                                                                              .add({
                                                                            'name':
                                                                                'alfa22\$',
                                                                            'qtt':
                                                                                -1.0,
                                                                            'price':
                                                                                _price,
                                                                            'timestamp':
                                                                                DateTime.now(),
                                                                            'currency':
                                                                                currency,
                                                                          });
                                                                          _firestore
                                                                              .collection('transaction')
                                                                              .add({
                                                                            'name':
                                                                                'alfa\$\$\$',
                                                                            'qtt':
                                                                                -(_n),
                                                                            'timestamp':
                                                                                DateTime.now(),
                                                                          });

                                                                          setState(
                                                                              () {
                                                                            getqtt('alfa22\$');
                                                                            getqtt('alfa\$\$\$');
                                                                          });
                                                                          Navigator.of(context)
                                                                              .pop();
                                                                        } else {
                                                                          if (-_n > 10.0 &&
                                                                              -_n < 20.0) {
                                                                            _firestore.collection('transaction').add({
                                                                              'name': ListOfPhones[index]['phonename'],
                                                                              'qtt': (_n - .8),
                                                                              'price': _price,
                                                                              'timestamp': DateTime.now(),
                                                                              'currency': currency,
                                                                            });
                                                                          }
                                                                          if (-_n > 20.0 &&
                                                                              -_n < 30.0) {
                                                                            _firestore.collection('transaction').add({
                                                                              'name': ListOfPhones[index]['phonename'],
                                                                              'qtt': (_n - 1.2),
                                                                              'price': _price,
                                                                              'timestamp': DateTime.now(),
                                                                              'currency': currency,
                                                                            });
                                                                          }
                                                                          if (-_n > 30.0 &&
                                                                              -_n < 40.0) {
                                                                            _firestore.collection('transaction').add({
                                                                              'name': ListOfPhones[index]['phonename'],
                                                                              'qtt': (_n - 1.6),
                                                                              'price': _price,
                                                                              'timestamp': DateTime.now(),
                                                                              'currency': currency,
                                                                            });
                                                                            //                                                                          _firestore

                                                                          }
                                                                          if (-_n > 40.0 &&
                                                                              -_n < 50.0) {
                                                                            _firestore.collection('transaction').add({
                                                                              'name': ListOfPhones[index]['phonename'],
                                                                              'qtt': (_n - 2.0),
                                                                              'price': _price,
                                                                              'timestamp': DateTime.now(),
                                                                              'currency': currency,
                                                                            });
                                                                          }
                                                                          if (-_n > 50.0 &&
                                                                              -_n < 60.0) {
                                                                            _firestore.collection('transaction').add({
                                                                              'name': ListOfPhones[index]['phonename'],
                                                                              'qtt': (_n - 2.4),
                                                                              'price': _price,
                                                                              'timestamp': DateTime.now(),
                                                                              'currency': currency,
                                                                            });
                                                                            //                                                                          _firestore

                                                                          }
                                                                          if (-_n > 60.0 &&
                                                                              -_n < 70.0) {
                                                                            _firestore.collection('transaction').add({
                                                                              'name': ListOfPhones[index]['phonename'],
                                                                              'qtt': (_n - 2.8),
                                                                              'price': _price,
                                                                              'timestamp': DateTime.now(),
                                                                              'currency': currency,
                                                                            });
                                                                          }
                                                                          if (-_n > 00.0 &&
                                                                              -_n < 10.0) {
                                                                            _firestore.collection('transaction').add({
                                                                              'name': ListOfPhones[index]['phonename'],
                                                                              'qtt': (_n - .4),
                                                                              'price': _price,
                                                                              'timestamp': DateTime.now(),
                                                                              'currency': currency,
                                                                            });
                                                                          }

//                                                                          _firestore
//                                                                              .collection('transaction')
//                                                                              .add({
//                                                                            'name':
//                                                                                ListOfPhones[index]['phonename'],
//                                                                            'qtt':
//                                                                                (_n - msg),
//                                                                            'price':
//                                                                                _price,
//                                                                            'timestamp':
//                                                                                DateTime.now(),
//                                                                            'currency':
//                                                                                currency,
//                                                                          });
                                                                          setState(
                                                                              () {
                                                                            getqtt(ListOfPhones[index]['phonename']);
                                                                          });
                                                                          Navigator.of(context)
                                                                              .pop();
                                                                          Navigator.of(context)
                                                                              .pop();
                                                                        }
                                                                      } else {
                                                                        _firestore
                                                                            .collection('transaction')
                                                                            .add({
                                                                          'name':
                                                                              ListOfPhones[index]['phonename'],
                                                                          'qtt':
                                                                              _n,
                                                                          'price':
                                                                              _price,
                                                                          'timestamp':
                                                                              DateTime.now(),
                                                                          'currency':
                                                                              currency,
                                                                        });
                                                                        setState(
                                                                            () {
                                                                          getqtt(ListOfPhones[index]
                                                                              [
                                                                              'phonename']);
                                                                        });
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                      }
                                                                    },
                                                                  )
                                                                ],
                                                              );
                                                            });

//                                                        if (ListOfPhones[index]
//                                                        ['phonename'] ==
//                                                            'alfa Days' ||
//                                                            ListOfPhones[index]
//                                                            ['phonename'] ==
//                                                                'alfa\$\$\$') {
//                                                          if (ListOfPhones[index]
//                                                          ['phonename'] ==
//                                                              'alfa Days') {
//                                                            _firestore
//                                                                .collection(
//                                                                'transaction')
//                                                                .add({
//                                                              'name': 'alfa22\$',
//                                                              'qtt': -1.0,
//                                                              'price': _price,
//                                                              'timestamp':
//                                                              DateTime.now(),
//                                                              'currency': currency,
//                                                            });
//                                                            _firestore
//                                                                .collection(
//                                                                'transaction')
//                                                                .add({
//                                                              'name': 'alfa\$\$\$',
//                                                              'qtt': -(_n),
//                                                              'timestamp':
//                                                              DateTime.now(),
//                                                            });
//
//                                                            setState(() {
//                                                              getqtt('alfa22\$');
//                                                              getqtt('alfa\$\$\$');
//                                                            });
//                                                            Navigator.of(context)
//                                                                .pop();
//                                                          } else {
//                                                            _firestore
//                                                                .collection(
//                                                                'transaction')
//                                                                .add({
//                                                              'name':
//                                                              ListOfPhones[index]
//                                                              ['phonename'],
//                                                              'qtt': (_n-0.4),
//                                                              'price': _price,
//                                                              'timestamp':
//                                                              DateTime.now(),
//                                                              'currency': currency,
//                                                            });
//                                                            setState(() {
//                                                              getqtt(
//                                                                  ListOfPhones[index]
//                                                                  ['phonename']);
//                                                            });
//                                                            Navigator.of(context)
//                                                                .pop();
//                                                          }
//                                                        }
//
//
//                                                        else {
//                                                          _firestore
//                                                              .collection(
//                                                              'transaction')
//                                                              .add({
//                                                            'name':
//                                                            ListOfPhones[index]
//                                                            ['phonename'],
//                                                            'qtt': _n,
//                                                            'price': _price,
//                                                            'timestamp':
//                                                            DateTime.now(),
//                                                            'currency': currency,
//                                                          });
//                                                          setState(() {
//                                                            getqtt(
//                                                                ListOfPhones[index]
//                                                                ['phonename']);
//                                                          });
//                                                          Navigator.of(context)
//                                                              .pop();
//                                                        }
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    childCount: ListOfPhones.length,
                  ),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    ///no.of items in the horizontal axis
                    crossAxisCount: 2,
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
