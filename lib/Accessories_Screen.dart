import 'dart:async';
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

class AccessoriesScreen extends StatefulWidget {
  static const String id = 'Accessories_Screen';
  static String accesscat = '';
  @override
  _AccessoriesScreenState createState() => _AccessoriesScreenState();
}

class _AccessoriesScreenState extends State<AccessoriesScreen> {
  var ListOfPhones = [];
  var ListOfItems = [];
  var ImageLink;
  var upload = 'Choose the Item Image';
  var nameOfItem = '';
  var PriceOfItem = '';
  bool _saving = true;
  bool _save = false;
  DateTime now;

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
    setState(() {
      now = DateTime.now();
      _save = true;
    });

    //Create a reference to the location you want to upload to in firebase
    StorageReference reference = _storage.ref().child(now.toString());

    //Upload the file to firebase
    StorageUploadTask uploadTask = reference.putFile(image);

    // Waits till the file is uploaded then stores the download url
    String location =
        await (await uploadTask.onComplete).ref.getDownloadURL() as String;
    print(location);
    setState(() {
      _save = false;
      upload = 'Uploaded';
      ImageLink = location;

      print(_save);
    });

    //returns the download url
    return location;
  }

  void getPhonesList() async {
    ListOfPhones.clear();
    final messages = await _firestore
        .collection('accessories')
        .where('subcat', isEqualTo: AccessoriesScreen.accesscat)
        .where('categories', isEqualTo: 'accessories')
        .getDocuments();
    for (var msg in messages.documents) {
      final name = msg['phonename'].toString();
      final price = msg['price'];
      final image = msg['image'].toString();
      setState(() {
        ListOfPhones.add({'phonename': name, 'price': price, 'image': image});
        _saving = false;
      });
      ListOfPhones.sort((a, b) {
        return a['phonename']
            .toLowerCase()
            .compareTo(b['phonename'].toLowerCase());
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
    }

    var result = qtts.reduce((sum, element) => sum + element);
    return new Future(() => result);
  }

  @override
  void initState() {
    super.initState();
    getPhonesList();
    delay();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ModalProgressHUD(
          inAsyncCall: _saving,
          dismissible: true,
          child: Container(
            color: Colors.white24,
            child: CustomScrollView(
              slivers: <Widget>[
                SliverAppBar(
                  actions: <Widget>[
                    IconButton(
                        icon: Icon(
                          Icons.add,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          var nn = 1.0;
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  content: Form(
                                    child: ModalProgressHUD(
                                      inAsyncCall: _save,
                                      dismissible: true,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          MaterialButton(
                                            onPressed: () {
                                              setState(
                                                () {
                                                  uploadPic();
                                                },
                                              );
                                            },
                                            child: Text(upload),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10, right: 10, top: 10),
                                            child: TextField(
                                              keyboardType:
                                                  TextInputType.emailAddress,
                                              textAlign: TextAlign.center,
                                              onChanged: (value) {
                                                setState(() {
                                                  nameOfItem = value;
                                                });
                                              },
                                              decoration: KTextFieldImputDecoration
                                                  .copyWith(
                                                      hintText:
                                                          'Enter the Name Of Item'),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10, right: 10, top: 10),
                                            child: TextField(
                                              keyboardType:
                                                  TextInputType.emailAddress,
                                              textAlign: TextAlign.center,
                                              onChanged: (value) {
                                                setState(() {
                                                  PriceOfItem = value;
                                                });
                                              },
                                              decoration: KTextFieldImputDecoration
                                                  .copyWith(
                                                      hintText:
                                                          'Enter the Price Of Item in \$'),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10, right: 10, top: 10),
                                            child: TextField(
                                              keyboardType:
                                                  TextInputType.emailAddress,
                                              textAlign: TextAlign.center,
                                              onChanged: (value) {
                                                setState(() {
                                                  nn = (double.parse(value));
                                                });
                                              },
                                              decoration:
                                                  KTextFieldImputDecoration
                                                      .copyWith(
                                                          hintText:
                                                              'Enter the Qtt'),
                                            ),
                                          ),
                                          MaterialButton(
                                              child: Text(
                                                'Add',
                                                style: TextStyle(
                                                    fontSize: 30,
                                                    color: Colors.blueAccent),
                                              ),
                                              onPressed: () {
                                                _firestore
                                                    .collection('accessories')
                                                    .add({
                                                  'phonename': nameOfItem,
                                                  'price': PriceOfItem,
                                                  'image': ImageLink,
                                                  'INOUT': 'out',
                                                  'categories': 'accessories',
                                                  'subcat': AccessoriesScreen
                                                      .accesscat,
                                                });
                                                _firestore
                                                    .collection('transaction')
                                                    .add({
                                                  'name': nameOfItem,
                                                  'categorie': 'accessories',
                                                  'inout': 'in',
                                                  'qtt': nn,
                                                });
                                                getPhonesList();
                                                setState(() {
                                                  upload = 'choose your image';
                                                });

                                                Navigator.of(context).pop();
                                              }),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              });
                        })
                  ],
                  title: Text(
                    AccessoriesScreen.accesscat,
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
                          child: GestureDetector(
                            onTap: () {
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
                                                  imageUrl: ListOfPhones[index]
                                                      ['image'],
                                                ),
                                              ),
                                            ),
                                            Text(
                                              ListOfPhones[index]['phonename'],
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              '${ListOfPhones[index]['price'].toString()} \$',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.green),
                                            ),
                                            FutureBuilder(
                                                builder: (BuildContext context,
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
                                              padding: const EdgeInsets.only(
                                                  left: 40, right: 40, top: 10),
                                              child: TextField(
                                                keyboardType:
                                                    TextInputType.emailAddress,
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
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 40, right: 40, top: 10),
                                              child: TextField(
                                                keyboardType:
                                                    TextInputType.emailAddress,
                                                textAlign: TextAlign.center,
                                                onChanged: (value) {
                                                  setState(() {
                                                    _price =
                                                        (double.parse(value));
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
                                                selectedColor: Theme.of(context)
                                                    .accentColor,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 10, bottom: 10),
                                              child: MaterialButton(
                                                child: Text(
                                                  'Sell',
                                                  style: TextStyle(
                                                      fontSize: 30,
                                                      color: Colors.blueAccent,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                onPressed: () {
                                                  return showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return AlertDialog(
                                                          title: Text(
                                                              'Are You Sure to sell ${ListOfPhones[index]['phonename']}'),
                                                          actions: <Widget>[
                                                            MaterialButton(
                                                              child: Text(
                                                                  'cancel'),
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                            ),
                                                            MaterialButton(
                                                              child:
                                                                  Text('Yes'),
                                                              onPressed: () {
                                                                _firestore
                                                                    .collection(
                                                                        'transaction')
                                                                    .add({
                                                                  'name': ListOfPhones[
                                                                          index]
                                                                      [
                                                                      'phonename'],
                                                                  'qtt': _n,
                                                                  'price':
                                                                      _price,
                                                                  'timestamp':
                                                                      DateTime
                                                                          .now(),
                                                                  'currency':
                                                                      currency,
                                                                });
                                                                setState(() {
                                                                  getqtt(ListOfPhones[
                                                                          index]
                                                                      [
                                                                      'phonename']);
                                                                });
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                            )
                                                          ],
                                                        );
                                                      });
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Card(
                                elevation: 20,
                                child: Container(
                                  child: Column(
                                    children: <Widget>[
                                      Expanded(
                                        child: Container(
                                          child: Padding(
                                            padding: const EdgeInsets.all(3.0),
                                            child: ImageLink(
                                              imageUrl: ListOfPhones[index]
                                                  ['image'],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Text(
                                        ListOfPhones[index]['phonename'],
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        '${ListOfPhones[index]['price'].toString()} \$',
                                        style: TextStyle(
                                            fontSize: 15, color: Colors.green),
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
                                                    '${qttnumbr.data}',
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        color:
                                                            Colors.blueAccent),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                          initialData: 0.0,
                                          future: getqtt(ListOfPhones[index]
                                              ['phonename'])),
                                    ],
                                  ),
                                ),
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
      ),
    );
  }
}
