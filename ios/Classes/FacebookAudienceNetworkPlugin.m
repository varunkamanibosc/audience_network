#import "FacebookAudienceNetworkPlugin.h"
#import <audience_network/audience_network-Swift.h>
// #import "audience_network-Swift.h"

@implementation FacebookAudienceNetworkPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [FANPlugin registerWithRegistrar:registrar];
}
@end
