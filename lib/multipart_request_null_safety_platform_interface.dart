import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'multipart_request_null_safety_method_channel.dart';

abstract class MultipartRequestPlatform extends PlatformInterface {
  /// Constructs a MultipartRequestPlatform.
  MultipartRequestPlatform() : super(token: _token);

  static final Object _token = Object();

  static MultipartRequestPlatform _instance = MethodChannelMultipartRequest();

  /// The default instance of [MultipartRequestPlatform] to use.
  ///
  /// Defaults to [MethodChannelMultipartRequest].
  static MultipartRequestPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [MultipartRequestPlatform] when
  /// they register themselves.
  static set instance(MultipartRequestPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
