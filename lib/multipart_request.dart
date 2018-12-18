import 'dart:async';

import 'package:flutter/services.dart';

class MultipartRequest {
  static const MethodChannel _channel =
      const MethodChannel('multipart_progress');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  String url;
  var headers = {}, fields = {};
  var files = [];

  setUrl(String url) {
    this.url = url;
  }

  addHeader(key, value) {
    headers[key] = value;
  }

  addHeaders(Map<String, String> headers) {
    this.headers.addAll(headers);
  }

  addField(key, value) {
    fields[key] = value;
  }

  addFields(Map<String, String> fields) {
    this.fields.addAll(fields);
  }

  addFile(key, path) {
    files.add({"field": key, "path": path});
  }

  Response send() {
    var finalBlock = {
      "url": url,
      "headers": headers,
      "fields": fields,
      "files": files,
    };

    _channel.invokeMethod('multipartRequest', finalBlock);
    var controller = StreamController<int>();

    Response response = Response();
    response.progress = controller.stream;

    _channel.setMethodCallHandler((handler) {
      switch (handler.method) {
        case "progress":
          int progress = int.parse(handler.arguments);
          controller.add(progress);
          if (progress == 100) controller.close();
          break;
        case "complete":
          response.onComplete(handler.arguments);
          controller.close();
          break;
        case "error":
          response.onError();
          controller.close();

          break;
        default:
      }
    });

    return response;
  }
}

class Response {
  Stream<int> progress;
  Function onComplete, onError;
}
