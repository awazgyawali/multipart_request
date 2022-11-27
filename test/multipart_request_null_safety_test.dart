import 'package:flutter_test/flutter_test.dart';
import 'package:multipart_request_null_safety/multipart_request_null_safety.dart';
import 'package:multipart_request_null_safety/multipart_request_null_safety_platform_interface.dart';
import 'package:multipart_request_null_safety/multipart_request_null_safety_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockMultipartRequestNullSafetyPlatform
    with MockPlatformInterfaceMixin
    implements MultipartRequestNullSafetyPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final MultipartRequestNullSafetyPlatform initialPlatform = MultipartRequestNullSafetyPlatform.instance;

  test('$MethodChannelMultipartRequestNullSafety is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelMultipartRequestNullSafety>());
  });

  test('getPlatformVersion', () async {
    MultipartRequestNullSafety multipartRequestNullSafetyPlugin = MultipartRequestNullSafety();
    MockMultipartRequestNullSafetyPlatform fakePlatform = MockMultipartRequestNullSafetyPlatform();
    MultipartRequestNullSafetyPlatform.instance = fakePlatform;

    expect(await multipartRequestNullSafetyPlugin.getPlatformVersion(), '42');
  });
}
