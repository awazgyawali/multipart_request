import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multipart_request/multipart_request.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String imagePath = "";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              FlatButton(
                child: Text("Pick an image"),
                onPressed: () async {
                  File image =
                      await ImagePicker.pickImage(source: ImageSource.gallery);
                  imagePath = image.path;
                },
              ),
              FlatButton(
                child: Text("Call multipart request"),
                onPressed: () {
                  sendRequest();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void sendRequest() {
    var request = MultipartRequest();

    request.addFile("image", imagePath);

    Response response = request.send();

    response.onError = () {
      print("Error");
    };

    response.onComplete = (response) {
      print(response);
    };

    response.progress.listen((int progress) {
      print("progress from response object " + progress.toString());
    });
  }
}
