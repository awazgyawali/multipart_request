# multipart_request

A flutter plugin to send a multipart request with get progress event.
Works on both Android and iOS

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

## Support
<script data-name="BMC-Widget" src="https://cdnjs.buymeacoffee.com/1.0.0/widget.prod.min.js" data-id="aawazgyawali" data-description="Support me on Buy me a coffee!" data-message="Thank you for visiting. You can now buy me a coffee!" data-color="#FFDD00" data-position="Right" data-x_margin="18" data-y_margin="18"></script>
