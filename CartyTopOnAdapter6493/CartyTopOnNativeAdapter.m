
#import "CartyTopOnNativeAdapter.h"
#import "CartyTopOnNativeEvent.h"
#import "CartyTopOnAdapter.h"
#import "CartyTopOnNativeRenderer.h"
#import <AnyThinkNative/AnyThinkNative.h>
#import <CartySDK/CartySDK.h>

@interface CartyTopOnNativeAdapter()

@property (nonatomic,strong)CartyTopOnNativeEvent *nativeEvent;
@property (nonatomic,strong)CTNativeAd *nativeAd;
@end


@implementation CartyTopOnNativeAdapter


- (nonnull instancetype)initWithNetworkCustomInfo:(nonnull NSDictionary *)serverInfo localInfo:(nonnull NSDictionary *)localInfo
{
    self = [super init];
    if (self != nil) {
        NSString *appid = serverInfo[@"appid"];
        [CartyTopOnAdapter startWithAppID:appid];
    }
    return self;
}

- (void)loadADWithInfo:(NSDictionary *)serverInfo localInfo:(NSDictionary *)localInfo completion:(void (^)(NSArray *, NSError *))completion
{
    self.nativeEvent = [[CartyTopOnNativeEvent alloc] initWithInfo:serverInfo localInfo:localInfo];
    self.nativeEvent.requestCompletionBlock = completion;
    NSString *pid = serverInfo[@"slot_id"];
    if(pid == nil)
    {
        NSError *error = [NSError errorWithDomain:@"CartyTopOnAdapter" code:400 userInfo:@{NSLocalizedDescriptionKey:@"not pid"}];
        [self.nativeEvent trackNativeAdLoadFailed:error];
        return;
    }
    self.nativeAd = [[CTNativeAd alloc] init];
    self.nativeAd.placementid = pid;
    self.nativeAd.delegate = self.nativeEvent;
    if([localInfo valueForKey:@"Carty_isMute"])
    {
        self.nativeAd.isMute = [localInfo[@"Carty_isMute"] boolValue];
    }
    [self.nativeAd loadAd];
}

+ (Class)rendererClass
{
    return [CartyTopOnNativeRenderer class];
}


@end
