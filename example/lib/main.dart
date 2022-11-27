import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import 'package:multipart_request_null_safety/multipart_request_null_safety.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String imagePath = "";
  var upload_progress;
  final ImagePicker picker = ImagePicker();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Multi Request Plugin example app'),
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if(upload_progress != null)
                Text("${upload_progress}%", style: TextStyle(color: Colors.green, fontSize: 15)),
            MaterialButton(
                onPressed: () async {
                PickedFile? image = await picker.getImage(source: ImageSource.gallery);
                  if(image != null)
                  {
                    imagePath = image.path;
                  }
                },
                child: const Text("Pick an image")
              ),
              MaterialButton(
                child: const Text("Call multipart request"),
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
    var url = "THE URL TO THE SERVER";
    request.setUrl(url);
    request.addFile("photo", imagePath);
    Response response = request.send();

    response.onError = () {
      setState(() {
        upload_progress = "something went wrong while uploading\ncheck your internet connection!";
      });
    };

    response.onComplete = (response) {
      setState(() {
        upload_progress = null;
      });
    };

    response.progress.listen((int progress) {
      setState(() {
        upload_progress = progress;
      });
    });

  }
}
