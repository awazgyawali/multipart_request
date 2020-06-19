import Alamofire
import Flutter
import UIKit

public class SwiftMultipartRequestPlugin: NSObject, FlutterPlugin {
    private var channel: FlutterMethodChannel?
    
    init(channel: FlutterMethodChannel) {
        self.channel = channel;
    }

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "multipart_request", binaryMessenger: registrar.messenger())
        let instance = SwiftMultipartRequestPlugin(channel: channel)
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "multipartRequest":
            guard let args = call.arguments else {
                return
            }
            if let myArgs = args as? [String: Any],
                let files = myArgs["files"] as? [[String: String]],
                let url = myArgs["url"] as? String,
                let headers = myArgs["headers"] as? [String: String],
                let fields = myArgs["fields"] as? [String: String] {
                uploadFile(files: files, url: url, headers: headers, fields: fields, result: result)
            }
        default:
            result(nil)
        }
    }

    private func fillFiles(_ multipartFormData: MultipartFormData, files: [[String: String]]) {
        for file in files {
            var fileData: Data?
            do {
                fileData = try Data(contentsOf: URL(fileURLWithPath: file["path"]!), options: Data.ReadingOptions.alwaysMapped)
            } catch _ {
                fileData = nil
                return
            }
            let filePathArray = file["path"]!.split(separator: "/").map(String.init)
            multipartFormData.append(fileData!, withName: file["field"]!, fileName: filePathArray.last!, mimeType: "")
        }
    }

    private func fillFields(_ multipartFormData: MultipartFormData, fields: [String: String]) {
        for (key, value) in fields {
            multipartFormData.append(Data(value.utf8), withName: key)
        }
    }

    fileprivate func onSuccess(_ response: DataResponse<Any>) {
        if let data = response.data {
            let json = String(data: data, encoding: String.Encoding.utf8)
            self.channel?.invokeMethod("success", arguments: json)
        }
    }
    
    private func uploadFile(files: [[String: String]], url: String, headers: [String: String], fields: [String: String], result _: @escaping FlutterResult) {
        Alamofire.upload(multipartFormData: { multipartFormData in
            self.fillFiles(multipartFormData, files: files)
            self.fillFields(multipartFormData, fields: fields)
        }, to: url, headers: headers, encodingCompletion: { encodingResult in
            switch encodingResult {
            case let .failure(error):
                self.channel?.invokeMethod("error", arguments: "")
            case .success(request: let upload, streamingFromDisk: false, streamFileURL: let streamFileURL):
                upload.validate()
                upload.responseJSON { response in
                    self.onSuccess(response)
                }
                upload.uploadProgress(closure: { progress in
                    self.channel?.invokeMethod("progress", arguments: progress.fractionCompleted)
                       })
            case .success(request: let upload, streamingFromDisk: true, streamFileURL: let streamFileURL):
                upload.validate()
                upload.responseJSON { response in
                    self.onSuccess(response)
                }
            }
               })
    }
}
