#import "Elevenlabs.h"
#if __has_include(<Elevenlabs/Elevenlabs-Swift.h>)
#import <Elevenlabs/Elevenlabs-Swift.h>
#else
#import "Elevenlabs-Swift.h"
#endif

@implementation Elevenlabs

+ (ElevenLabsController *)sharedInstance {
  static ElevenLabsController *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[ElevenLabsController alloc] init];
    });
    return sharedInstance;
}

RCT_EXPORT_MODULE()

- (NSNumber *)multiply:(double)a b:(double)b {
    static Elevenlabs *swiftInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        swiftInstance = [Elevenlabs new];
    });
//    return [swiftInstance multiplyWithA:a b:b];
  return @10;
}

- (std::shared_ptr<facebook::react::TurboModule>)getTurboModule:
    (const facebook::react::ObjCTurboModule::InitParams &)params
{
    return std::make_shared<facebook::react::NativeElevenlabsSpecJSI>(params);
}

@end
