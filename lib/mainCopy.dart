import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert' as convert;
import 'package:camera/camera.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:http/http.dart' as http;


void main() {
  // debugPaintSizeEnabled = true;
  runApp(MyApp());
}

final HttpsCallable callable = CloudFunctions.instance.getHttpsCallable(
  functionName: 'addUser',
);

class FavoriteWidget extends StatefulWidget {
  @override
  _FavoriteWidgetState createState() => _FavoriteWidgetState();
}


class _FavoriteWidgetState extends State<FavoriteWidget> {
  bool _isFavorited = true;
  int _favoriteCount = 41;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.all(0),
          child: IconButton(
            icon: (_isFavorited ? Icon(Icons.star) : Icon(Icons.star_border)),
            color: Colors.red[500],
            onPressed: () => _showAddUserDialogBox(context), //--------- new
          ),
        ),
        SizedBox(
          width: 18,
          child: Container(
            child: Text('$_favoriteCount'),
          ),
        ),
      ],
    );
  }
// ···
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    Widget titleSection = Container(
      padding: const EdgeInsets.all(32),
      child: Row(
        children: [
          Expanded(
            /*1*/
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /*2*/
                Container(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    'Oeschinen Lake Campground',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  'Kandersteg, Switzerland',
                  style: TextStyle(
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
          /*3*/
            FavoriteWidget()
        ],
      ),
    );

    Color color = Theme.of(context).primaryColor;

    Widget buttonSection = Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildButtonColumn(color, Icons.call, 'CALL'),
          _buildButtonColumn(color, Icons.near_me, 'ROUTE'),
          _buildButtonColumn(color, Icons.share, 'SHARE'),
        ],
      ),
    );

    Widget textSection = Container(
      padding: const EdgeInsets.all(32),
      child: Text(
        'Lake Oeschinen lies at the foot of the Blüemlisalp in the Bernese '
            'Alps. Situated 1,578 meters above sea level, it is one of the '
            'larger Alpine Lakes. A gondola ride from Kandersteg, followed by a '
            'half-hour walk through pastures and pine forest, leads you to the '
            'lake, which warms to 20 degrees Celsius in the summer. Activities '
            'enjoyed here include rowing, and riding the summer toboggan run.',
        softWrap: true,
      ),
    );

    return MaterialApp(
      title: 'Flutter layout demo',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Flutter layout demo'),
        ),
        body: ListView(
          children: [
            Image.asset(
              'images/lake.jpg',
              width: 600,
              height: 240,
              fit: BoxFit.cover,
            ),
            titleSection,
            buttonSection,
            textSection,
          ],
        ),
      ),
    );
  }

  Column _buildButtonColumn(Color color, IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: color),
        Container(
          margin: const EdgeInsets.only(top: 8),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: color,
            ),
          ),
        ),
      ],
    );
  }
}


Future<Null> _showAddUserDialogBox(BuildContext context) {
  TextEditingController _nameTextController = new TextEditingController();
  TextEditingController _emailTextController = new TextEditingController();

  return showDialog<Null>(
      context: context,
      builder: (BuildContext context) {
        return new AlertDialog(
          title: const Text("Add a contact"),
          content: Container(
            height: 120.0,
            width: 100.0,
            child: ListView(
              children: <Widget>[
                new TextField(
                  controller: _nameTextController,
                  decoration: const InputDecoration(labelText: "Name: "),
                ),
                new TextField(
                  controller: _emailTextController,
                  decoration: const InputDecoration(labelText: "License #: "),
                ),

              ],
            ),
          ),
          actions: <Widget>[

            new FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("Cancel")
            ),
            // This button results in adding the contact to the database
            new FlatButton(
                onPressed: () async {
                  String theName = _nameTextController.text;
                  //int counterpls = 0;
                  //if (Firestore.instance.collection('users').where('name', isEqualTo: theName).snapshots().listen((data) => data.documents.forEach((doc) => print(doc["name"]))) != null){
                  //  print("ASASDAS");
                  //}

                 // Firestore.instance.document('users/name').get().then((theName) {
                 //   theName.exists ? print("its there fam") : print(
                 //       "NEW"); //exists : //not exist ;
                 // });

                  var value = await aName(theName);

                  if (value == true){
                    print("The entry already exists. Skipping and not adding.");
                  }
                  else{
                      callable.call(<String, dynamic>{
                      "name": theName,
                      "email": _emailTextController.text
                    }
                    );
                  }






                  Navigator.of(context).pop();
                },
                child: const Text("Confirm")
            )

          ],

        );
      }

  );
}

Future<bool> doesNameAlreadyExist(String name) async {
  final QuerySnapshot result = await Firestore.instance
      .collection('users')
      .where('name', isEqualTo: name)
      .limit(1)
      .getDocuments();
  final List<DocumentSnapshot> documents = result.documents;
  return documents.length == 1;
}

Future<bool> aName(String name) async {
  QuerySnapshot querySnapshot = await Firestore.instance.collection('users')
      .where('name', isEqualTo: name)
      .getDocuments();
  var list = querySnapshot.documents;
  if(list.length == 0){
    return false;
  }
  else{
    return true;
  }
}


