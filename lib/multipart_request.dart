import 'dart:async';

import 'package:flutter/services.dart';

class MultipartRequest {
  static const MethodChannel _channel =
      const MethodChannel('multipart_request');

  String _url;
  var _headers = {}, _fields = {};
  var _files = [];

  setUrl(String url) {
    this._url = url;
  }

  addHeader(key, value) {
    _headers[key] = value;
  }

  addHeaders(Map<String, String> headers) {
    this._headers.addAll(headers);
  }

  addField(key, value) {
    _fields[key] = value;
  }

  addFields(Map<String, String> fields) {
    this._fields.addAll(fields);
  }

  addFile(key, path) {
    _files.add({"field": key, "path": path});
  }

  Response send() {
    var finalBlock = {
      "url": _url,
      "headers": _headers,
      "fields": _fields,
      "files": _files,
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
