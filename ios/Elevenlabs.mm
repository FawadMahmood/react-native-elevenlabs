#import "Elevenlabs.h"
#if __has_include(<Elevenlabs/Elevenlabs-Swift.h>)
#import <Elevenlabs/Elevenlabs-Swift.h>
#else
#import "Elevenlabs-Swift.h"
#endif

@implementation Elevenlabs{
  ElevenLabsController *controller;
}

- (id) init {
  if (self = [super init]) {
    controller = [ElevenLabsController new];
    [controller setEventEmitter:^(NSString* event, NSDictionary *body) {
      // Use if-else or a dictionary lookup, since switch does not work with NSString
      if ([event isEqualToString:ElevenLabsEventEvents.onMessage]) {
        [self emitOnMessage:body];
      } else if ([event isEqualToString:ElevenLabsEventEvents.onConnect]) {
        [self emitOnConnect:body];
      } else if ([event isEqualToString:ElevenLabsEventEvents.onDisconnect]) {
        [self emitOnDisconnect:body];
      } else if ([event isEqualToString:ElevenLabsEventEvents.onError]) {
        [self emitOnError:body];
      } else if ([event isEqualToString:ElevenLabsEventEvents.onStatusChange]) {
        [self emitOnStatusChange:body];
      } else if ([event isEqualToString:ElevenLabsEventEvents.onModeChange]) {
        [self emitOnModeChange:body];
      } else if ([event isEqualToString:ElevenLabsEventEvents.onVolumeUpdate]) {
        [self emitOnVolumeUpdate:body];
      }
    }];
  }
  return self;
}

RCT_EXPORT_MODULE()

- (void)startConversation:(NSString *)agentId
                      dynamicVariables:(NSDictionary *)dynamicVariables {
  @try {
      if (dynamicVariables && [dynamicVariables isKindOfClass:[NSDictionary class]]) {
        [controller startConversation:agentId dynamicVariables:dynamicVariables];
      } else {
        [controller startConversation:agentId dynamicVariables:@{}];
      }
  }
  @catch (NSException *exception) {
      // Optionally emit an error event or handle error here
   [self emitOnError:@{
      @"error": exception.reason ?: @"Unknown error",
      @"info": exception.userInfo ?: @""
    }];
  }
}

- (void)stopConversation {
  [controller stopConversation];
}

- (void)startRecording {
  [controller startRecording];
}

- (void)stopRecording {
  [controller stopRecording];
}

- (void)setEventEmitter:(void (^)(NSString *name, NSDictionary *body))emitter {
  if ([controller respondsToSelector:@selector(setEventEmitter:)]) {
    [controller performSelector:@selector(setEventEmitter:) withObject:emitter];
  }
}

- (std::shared_ptr<facebook::react::TurboModule>)getTurboModule:
    (const facebook::react::ObjCTurboModule::InitParams &)params
{
    return std::make_shared<facebook::react::NativeElevenlabsSpecJSI>(params);
}

@end
