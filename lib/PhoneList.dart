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
class PhonesList extends StatefulWidget {
  static const String id = 'PhoneList_Screen';
  static String subcat='';
  @override
  _PhonesListState createState() => _PhonesListState();
}

class _PhonesListState extends State<PhonesList> {
  var ListOfPhones = [];
  var ListOfItems=[];
  var ImageLink;
  var upload='Choose the Item Image';
  var nameOfItem='';
  var PriceOfItem='';
  bool _saving = true;
  DateTime now ;

  Future delay() async{
    await new Future.delayed(new Duration(seconds: 5), ()
    {
      setState(() {
        _saving=false;
      });

    });
  }



  Future<String> uploadPicfromCamera() async {

    //Get the file from the image picker and store it
    File image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {

      now=DateTime.now();

    });

    //Create a reference to the location you want to upload to in firebase
    StorageReference reference = _storage.ref().child(now.toString());

    //Upload the file to firebase
    StorageUploadTask uploadTask = reference.putFile(image);

    // Waits till the file is uploaded then stores the download url
    String location = await (await uploadTask.onComplete).ref.getDownloadURL() as String;
    print(location);
    setState(() {
      upload ='Uploaded';
      ImageLink = location;
    });

    //returns the download url
    return location;

  }

  Future<String> uploadPic() async {
    setState(() {
      _saving=true;
    });
    //Get the file from the image picker and store it
    File image = await ImagePicker.pickImage(source: ImageSource.gallery);

    //Create a reference to the location you want to upload to in firebase
    StorageReference reference = _storage.ref().child('images/');

    //Upload the file to firebase
    StorageUploadTask uploadTask = reference.putFile(image);

    // Waits till the file is uploaded then stores the download url
    String location = await (await uploadTask.onComplete).ref.getDownloadURL() as String;
    print(location);
    setState(() {
      ImageLink = location;
      upload ='Uploaded';
      _saving=false;

    });

    //returns the download url
    return location;

  }

  void getPhonesList() async {
    ListOfPhones.clear();
    try {

      final messages = await _firestore.collection('tele').where(
          'subcat', isEqualTo: PhonesList.subcat).where(
          'categories', isEqualTo: 'phones').getDocuments();
      for (var msg in messages.documents) {
        final name = msg['phonename'].toString();
        final price = msg['price'];
        final image = msg['image'].toString();
        setState(() {
          ListOfPhones.add({'phonename': name, 'price': price, 'image': image});
          _saving=false;
        });
        ListOfPhones.sort((a, b) {
          return a['phonename'].toLowerCase().compareTo(b['phonename'].toLowerCase());
        });

      }
    }
    catch(e){
      print(e);
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
    // TODO: implement initState
    super.initState();
    getPhonesList();
    delay();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black12,
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            color: Colors.white,
            child: ModalProgressHUD(
              inAsyncCall: _saving,
              dismissible: true,
              child: CustomScrollView(
                slivers: <Widget>[
                  SliverAppBar(

                    actions: <Widget>[
                      IconButton(icon:Icon(Icons.add,color: Colors.black,),

                          onPressed:(){
                        var nn=1.0;
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(

                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        MaterialButton(

                                          onPressed: (){
                                            setState(() {

                                              uploadPic();
                                            },);
                                          },
                                          child: Text(upload,style: TextStyle(color: Colors.black),),
                                          elevation: 20,
                                          color: Colors.white,
                                        ),

                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 10, right: 10,top: 10),
                                          child: TextField(
                                            keyboardType: TextInputType
                                                .emailAddress,
                                            textAlign: TextAlign.center,
                                            onChanged: (value) {
                                              setState(() {
                                                nameOfItem = value;
                                              });
                                            },
                                            decoration:
                                            KTextFieldImputDecoration
                                                .copyWith(
                                                hintText:
                                                'Enter the Name Of Item'),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 10, right: 10,top: 10),
                                          child: TextField(
                                            keyboardType: TextInputType
                                                .emailAddress,
                                            textAlign: TextAlign.center,
                                            onChanged: (value) {
                                              setState(() {
                                                PriceOfItem =
                                                value;
                                              });
                                            },
                                            decoration:
                                            KTextFieldImputDecoration
                                                .copyWith(
                                                hintText:
                                                'Enter the Price Of Item in \$'),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 10, right: 10,top: 10),
                                          child: TextField(
                                            keyboardType: TextInputType
                                                .emailAddress,
                                            textAlign: TextAlign.center,
                                            onChanged: (value) {
                                              setState(() {
                                                nn =
                                                (double.parse(value));
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
                                            child: Text('Add',style: TextStyle(fontSize: 30,color: Colors.black),),
                                            onPressed: (){
                                          _firestore.collection('tele').add({
                                            'phonename':nameOfItem,
                                            'price': PriceOfItem,
                                            'image': ImageLink,
                                            'INOUT': 'out',
                                            'categories':'phones',
                                            'subcat':PhonesList.subcat,
                                          });
                                          _firestore.collection('transaction').add({
                                            'name': nameOfItem,
                                            'categorie': 'phones',
                                            'inout': 'in',
                                            'qtt': nn,
                                          });
                                          getPhonesList();
                                          Navigator.of(context).pop();
                                        }),



                                      ],
                                    ),
                                  );
                                });


                      })
                    ],
                    title: Card(
                      elevation: 20,
                      color: Colors.white.withOpacity(0.0),
                      child: Text(
                        PhonesList.subcat,
                        style: TextStyle(color: Colors.black,fontSize: 25,fontWeight: FontWeight.bold),
                      ),
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
                          return GestureDetector(
                            onTap: (){
                              var _n = -1.0;
                              var _price = 0.0;
                              var currency = 'L.L';
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      backgroundColor: Colors.white,

                                      content: Card(


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
                                                color: Colors.black,
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
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black),
                                            ),
                                            Expanded(
                                              child: FutureBuilder(
                                                  builder:
                                                      (BuildContext context,
                                                      AsyncSnapshot<double>
                                                      qttnumbr) {
                                                    return Center(
                                                      child: Text(
                                                        'Available : ${qttnumbr.data}',style: TextStyle(color:Colors.black),
                                                      ),
                                                    );
                                                  },
                                                  initialData: 1.0,
                                                  future: getqtt(
                                                      ListOfPhones[index]
                                                      ['phonename'])),
                                            ),
                                            Text('Enter Your Qtt',style: TextStyle(color: Colors.black),),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10, right: 10,top: 2),
                                              child: TextField(
                                                keyboardType: TextInputType
                                                    .emailAddress,
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
                                                  'Enter Your Qtt',),
                                              ),
                                            ),
                                            Text('Enter Your price',style: TextStyle(color: Colors.black),),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10, right: 10,top: 2),
                                              child: TextField(
                                                keyboardType: TextInputType
                                                    .emailAddress,
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
                                              padding: const EdgeInsets.all(8.0),
                                              child: CustomRadioButton(
                                                buttonColor: Colors.white,


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
                                                selectedColor: Colors.black54,


                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 10, bottom: 10),
                                              child: MaterialButton(
                                                child: Text('Sell',style: TextStyle(fontSize: 30,color: Colors.black,fontWeight: FontWeight.bold),),
                                                onPressed: () {
                                                  return showDialog(
                                                    context: context,
                                                    builder:(BuildContext context) {
                                                     return AlertDialog(
                                                        title: Text(
                                                            'Are You Sure to Sell ${ListOfPhones[index]
                                                            ['phonename']}'),
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
                                                            child: Text('yes'),
                                                            onPressed: () {
                                                              _firestore
                                                                  .collection(
                                                                  'transaction')
                                                                  .add({
                                                                'name':
                                                                ListOfPhones[index]['phonename'],
                                                                'qtt': _n,
                                                                'price': _price,
                                                                'timestamp':
                                                                DateTime.now(),
                                                                'currency': currency,
                                                              });
                                                              setState(() {
                                                                getqtt(
                                                                    ListOfPhones[index]['phonename']);
                                                              });
                                                              Navigator.of(
                                                                  context)
                                                                  .pop();
                                                              Navigator.of(
                                                                  context)
                                                                  .pop();
                                                            },
                                                          ),


                                                        ],
                                                      );

                                                    }
                                                  );


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
                                color: Colors.white,
                                child: Column(
                                  children: <Widget>[
                                    Expanded(
                                      child: Container(
                                        child: Padding(
                                          padding: const EdgeInsets.all(2.0),
                                          child: ImageLink(
                                            imageUrl: ListOfPhones[index]['image'],fit: BoxFit.fill,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        ListOfPhones[index]['phonename'],
                                        style: TextStyle(fontSize: 16,color: Colors.black,fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Text(
                                      '${ListOfPhones[index]['price'].toString()} \$',
                                      style:
                                          TextStyle(fontSize: 16, color: Colors.green),
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
                                                      color: Colors.black),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                        initialData: 1.0,
                                        future:
                                            getqtt(ListOfPhones[index]['phonename'])),

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
        ),
      ),
    );
  }
}
