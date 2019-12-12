import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _firestore = Firestore.instance;

class PhonesScreen extends StatefulWidget {
  static const String id = 'Selling_Screnn';
  @override
  _PhonesScreenState createState() => _PhonesScreenState();
}

class _PhonesScreenState extends State<PhonesScreen> {
  var ListOfPhones = [];
  var PhoneFilter = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: _firestore.collection('phones').snapshots(),
          builder: (context, snapshot) {
            ListOfPhones.clear();
            if (snapshot.hasData) {
              final messages = snapshot.data.documents;
              for (var doc in messages) {
                final phonename = doc['phonename'].toString();
                final price = doc['price'];
                final qtt = doc['qtt'];
                ListOfPhones.add({
                  'phonename': phonename,
                  'price': price,
                  'qtt': qtt,
                });
              }
            }
            return Container(
              color: Colors.white24,
              child: CustomScrollView(
                slivers: <Widget>[
                  SliverAppBar(
                    title: Text('Phones'),
                  ),
                  SliverGrid(
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          PhoneFilter.clear();
                          for (var i = 0; i <= ListOfPhones.length - 1; i++) {
                            PhoneFilter.add(
                                ListOfPhones[i]['phonename'].toString());
                          }
                          var filterlist = Set.of(PhoneFilter).toList();
                          print(filterlist);
                          return Container(
                            color: Colors.blueAccent,
                            child: Column(
                              children: <Widget>[
                                Text(ListOfPhones[index]['phonename']),
                                Text(ListOfPhones[index]['price'].toString()),
                                MaterialButton(
                                  child: Text('Buy'),
                                  onPressed: () {},
                                )
                              ],
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
            );
          }),
    );
  }
}
