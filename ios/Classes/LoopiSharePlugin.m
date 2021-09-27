#import "LoopiSharePlugin.h"
#if __has_include(<loopi_share/loopi_share-Swift.h>)
#import <loopi_share/loopi_share-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "loopi_share-Swift.h"
#endif

@implementation LoopiSharePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftLoopiSharePlugin registerWithRegistrar:registrar];
}
@end
