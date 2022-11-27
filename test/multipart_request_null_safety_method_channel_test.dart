import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:multipart_request_null_safety/multipart_request_null_safety_method_channel.dart';

void main() {
  MethodChannelMultipartRequestNullSafety platform = MethodChannelMultipartRequestNullSafety();
  const MethodChannel channel = MethodChannel('multipart_request_null_safety');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
