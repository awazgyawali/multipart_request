# multipart_request

A flutter plugin to send a multipart request and gt progress event.
Only runs on android and uses OkHttp.

## Example
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
