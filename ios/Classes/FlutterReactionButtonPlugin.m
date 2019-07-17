#import "FlutterReactionButtonPlugin.h"
#import <flutter_reaction_button/flutter_reaction_button-Swift.h>

@implementation FlutterReactionButtonPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterReactionButtonPlugin registerWithRegistrar:registrar];
}
@end
