import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';

final _firestore = Firestore.instance;

class EditItems extends StatefulWidget {
  static const String id = 'Edit_Screen';
  @override
  _EditItemsState createState() => _EditItemsState();
}

class _EditItemsState extends State<EditItems> {
  var categorie='phones';

  var ListOfItems = [];






  void getcategories(String cat) async {
    ListOfItems.clear();
    if (cat == 'phones') {
      final Messages = await _firestore
          .collection('tele')
          .where('categories', isEqualTo: cat)
          .getDocuments();
      for (var msg in Messages.documents) {
        final name = msg.data['phonename'].toString();
        final price=msg.data['price'].toString();
        final id=msg.documentID;
        setState(() {
          ListOfItems.add({

            'name':name,
            'price':price,
            'id':id,
          });
        });
        ListOfItems.sort((a, b) {
          return a['name'].toLowerCase().compareTo(b['name'].toLowerCase());
        });
      }
    }
    if (cat == 'accessories') {
      final Messages = await _firestore
          .collection('accessories')
          .where('categories', isEqualTo: cat)
          .getDocuments();
      for (var msg in Messages.documents) {
        final name = msg.data['phonename'].toString();
        final price=msg.data['price'].toString();
        final id=msg.documentID;
        setState(() {
          ListOfItems.add({
            'name':name,
            'price':price,
            'id':id,



          });
        });
        ListOfItems.sort((a, b) {
          return a['name'].toLowerCase().compareTo(b['name'].toLowerCase());
        });
      }
    }
    final Messages = await _firestore
        .collection('phones')
        .where('categories', isEqualTo: cat)
        .getDocuments();
    for (var msg in Messages.documents) {
      final name = msg.data['phonename'].toString();
      final price=msg.data['price'].toString();
      final id=msg.documentID;
      setState(() {
        ListOfItems.add({
          'name':name,
          'price':price,
          'id':id,
        });
      });
      ListOfItems.sort((a, b) {
        return a['name'].toLowerCase().compareTo(b['name'].toLowerCase());
      });
    }
  }


@override
  void initState() {
    // TODO: implement initState
    super.initState();
    getcategories(categorie);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        backgroundColor: Colors.black54,

        actions: <Widget>[

          MaterialButton(
            child: Text('phones',style: TextStyle(color: Colors.yellow,fontSize: 20),),
            onPressed: (){
              setState(() {
                categorie='phones';

                getcategories(categorie);

              });
            },
          ),
          MaterialButton(
            child: Text('accessories',style: TextStyle(color: Colors.yellow,fontSize: 20),),
            onPressed: (){
              setState(() {
                categorie='accessories';

                getcategories(categorie);

              });
            },
          ),

        ],

      ),
      body:Container(
        color: Colors.black54,
        child: ListView.builder(

          itemBuilder: (context,index){
            return ListTile(
              title: Text(ListOfItems[index]['name'],style: TextStyle(color: Colors.yellow,fontSize: 20),),
              onTap:(){
                showDialog(context: context,
                  builder: (BuildContext context){
                  return AlertDialog(
                    content: Column(
                      children: <Widget>[
                        Text('name: ${ListOfItems[index]['name']}') ,
                        Text('price: ${ListOfItems[index]['price']}\$'),
                        MaterialButton(onPressed: (){
                          if(categorie=='phones'){
                            _firestore.collection('tele').document('${ListOfItems[index]['id']}').delete();
                            getcategories('phones');
                            Navigator.of(context).pop();
                          }
                          else{
                            _firestore.collection('accessories').document('${ListOfItems[index]['id']}').delete();
                            getcategories('accessories');
                            Navigator.of(context).pop();
                          }


                        },
                          child: Text('Delete',style: TextStyle(color: Colors.blue),),

                        ),



                      ],
                    ),

                  );
                  }

                );

              },
            );

          },
          itemCount: ListOfItems.length,
        ),
      )

    );
  }
}
