import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'multipart_request_null_safety_platform_interface.dart';

/// An implementation of [MultipartRequestPlatform] that uses method channels.
class MethodChannelMultipartRequest extends MultipartRequestPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('multipart_request');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
