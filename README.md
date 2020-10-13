# multipart_request

A flutter plugin to send a multipart request with get progress event.
Works on both Android and iOS

## Example

    var request = MultipartRequest();

    request.setMethodPut() //default method is POST

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
