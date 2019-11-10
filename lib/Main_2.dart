import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'package:camera/camera.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import 'camera.dart';
import 'package:image_picker/image_picker.dart';


void main(){
  runApp(new MaterialApp(
    title: "camera app", home: LandingScreen()));
}

class LandingScreen extends StatefulWidget {
  @override
  _LandingScreenState createState() => _LandingScreenState();
}


class _LandingScreenState extends State<LandingScreen> {

  File imageFile;
  File imageFile2;
  bool swap = true;
  bool afterFill = false;

  _openGallery(BuildContext context) async {
    var picture = await ImagePicker.pickImage(source: ImageSource.gallery);
    this.setState(() {
      if (imageFile == null) {
        print("saving to PIC1");
        imageFile = picture;
      }else {
        imageFile2 = picture;
        print("saving to PIC2");
        afterFill = true;

      }
    });
    Navigator.of(context).pop();
  }

  _openCamera(BuildContext context) async {
    var picture = await ImagePicker.pickImage(source: ImageSource.camera);
    this.setState(() {
      imageFile = picture;
    });
    Navigator.of(context).pop();
  }


  Future<void> _showChoiceDialog(BuildContext context) {
      return showDialog(context: context, builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Upload"),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                GestureDetector(
                  child: Text("Gallery"),
                  onTap: () {
                    _openGallery(context);
                  },
                ),
                Padding(padding: EdgeInsets.all(8.0)),
                GestureDetector(
                  child: Text("Camera"),
                  onTap: () {
                    _openCamera(context);
                  },
                )
              ],
            ),
          ),
        );
      });
    }

  Widget _decideImageView() {
   // print("//////////");
    //print(d);print(imageFile == null);print(imageFile2 == null);
    if (imageFile == null) { // fiz this logic right now after dinner.
      // need to check both files and have ekse if arrays
      print("no image");
      return Text("No Image Selected");
    } else{
      return Image.file(imageFile,width: 400, height: 400);
      }
    }
    _keepImage(){
    setState(() {
      File dummy = imageFile;
      imageFile = imageFile2;
      imageFile2 = dummy;
    });
  }
  @override
  Widget build(BuildContext context) {
    if (!afterFill){
    return Scaffold(
      appBar: AppBar(
        title: Text("Main Screen"),
      ),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              _decideImageView(), RaisedButton(onPressed: () {
                _showChoiceDialog(context);
              }, child: Text("Select Imgae"))
            ],
          ),
        ),
      ),
    );
  }
  else{
      return Scaffold(
        appBar: AppBar(
          title: Text("Main Screen"),
        ),
        body: Container(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
               _decideImageView(), RaisedButton(onPressed: () {
                  _keepImage();
                }, child: Text("Flip Image"))
              ],
            ),
          ),
        ),
      );
    }

    }
}

