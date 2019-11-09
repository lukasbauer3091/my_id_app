import 'package:flutter/material.dart';
import 'camera.dart';
class FirstPage extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('First Page'),
      ),
      body: Center(child: RaisedButton(child: Text('go to second page'),onPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => TakePictureScreen()));
      }),),
    );
  }
}