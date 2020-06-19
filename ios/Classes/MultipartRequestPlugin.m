#import "MultipartRequestPlugin.h"
#if __has_include(<multipart_request/multipart_request-Swift.h>)
#import <multipart_request/multipart_request-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "multipart_request-Swift.h"
#endif


@implementation MultipartRequestPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftMultipartRequestPlugin registerWithRegistrar:registrar];
}
@end
