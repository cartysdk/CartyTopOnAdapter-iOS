
#import "CartyTopOnAppOpenAdapter.h"
#import <AnyThinkSplash/AnyThinkSplash.h>
#import <CartySDK/CartySDK.h>
#import "CartyTopOnAdapter.h"
#import "CartyTopOnAppOpenEvent.h"

@interface CartyTopOnAppOpenAdapter()

@property (nonatomic,strong)CTAppOpenAd *appOpenAd;
@property (nonatomic,strong)CartyTopOnAppOpenEvent *appOpenEvent;
@end

@implementation CartyTopOnAppOpenAdapter

- (nonnull instancetype)initWithNetworkCustomInfo:(nonnull NSDictionary *)serverInfo localInfo:(nonnull NSDictionary *)localInfo
{
    self = [super init];
    if (self != nil) {
        NSString *appid = serverInfo[@"appid"];
        [CartyTopOnAdapter startWithAppID:appid];
    }
    return self;
}

- (void)loadADWithInfo:(nonnull NSDictionary *)serverInfo localInfo:(nonnull NSDictionary *)localInfo completion:(nonnull void (^)(NSArray<NSDictionary *> * _Nonnull, NSError * _Nonnull))completion
{
    self.appOpenEvent = [[CartyTopOnAppOpenEvent alloc] initWithInfo:serverInfo localInfo:localInfo];
    self.appOpenEvent.requestCompletionBlock = completion;
    NSString *pid = serverInfo[@"slot_id"];
    if(pid == nil)
    {
        NSError *error = [NSError errorWithDomain:@"CartyTopOnAdapter" code:400 userInfo:@{NSLocalizedDescriptionKey:@"not pid"}];
        [self.appOpenEvent trackSplashAdLoadFailed:error];
        return;
    }
    self.appOpenAd = [[CTAppOpenAd alloc] init];
    self.appOpenAd.placementid = pid;
    self.appOpenAd.delegate = self.appOpenEvent;
    if([localInfo valueForKey:@"Carty_isMute"])
    {
        self.appOpenAd.isMute = [localInfo[@"Carty_isMute"] boolValue];
    }
    [self.appOpenAd loadAd];
}

+ (BOOL)adReadyWithCustomObject:(nonnull id)customObject info:(nonnull NSDictionary *)info
{
    if([customObject isKindOfClass:[CTAppOpenAd class]])
    {
        CTAppOpenAd *appOpenAd = (CTAppOpenAd *)customObject;
        return appOpenAd.isReady;
    }
    return NO;
}

+ (void)showSplash:(ATSplash *)splash localInfo:(NSDictionary *)localInfo delegate:(id)delegate
{
    UIWindow *window = localInfo[kATSplashExtraWindowKey];
    CTAppOpenAd *appOpenAd = (CTAppOpenAd *)splash.customObject;
    CartyTopOnAppOpenEvent *customEvent = (CartyTopOnAppOpenEvent *)splash.customEvent;
    customEvent.delegate = delegate;
    [appOpenAd showAd:window.rootViewController];
}
@end
