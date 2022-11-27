#import "MultipartRequestNullSafetyPlugin.h"
#if __has_include(<multipart_request_null_safety/multipart_request_null_safety-Swift.h>)
#import <multipart_request_null_safety/multipart_request_null_safety-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "multipart_request_null_safety-Swift.h"
#endif

@implementation MultipartRequestNullSafetyPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftMultipartRequestNullSafetyPlugin registerWithRegistrar:registrar];
}
@end
