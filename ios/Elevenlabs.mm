#import "Elevenlabs.h"
#import "Elevenlabs-Swift.h" // Replace with your actual module name

@implementation Elevenlabs

+ (instancetype)sharedInstance {
    static Elevenlabs *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

RCT_EXPORT_MODULE()

- (NSNumber *)multiply:(double)a b:(double)b {
    static SwiftElevenlabs *swiftInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        swiftInstance = [SwiftElevenlabs new];
    });
    return [swiftInstance multiplyWithA:a b:b];
}

- (std::shared_ptr<facebook::react::TurboModule>)getTurboModule:
    (const facebook::react::ObjCTurboModule::InitParams &)params
{
    return std::make_shared<facebook::react::NativeElevenlabsSpecJSI>(params);
}

@end
