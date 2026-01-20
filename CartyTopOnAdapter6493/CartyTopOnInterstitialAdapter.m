
#import "CartyTopOnInterstitialAdapter.h"
#import "CartyTopOnInterstitialEvent.h"
#import "CartyTopOnAdapter.h"
#import <AnyThinkInterstitial/AnyThinkInterstitial.h>
#import <CartySDK/CartySDK.h>


@interface CartyTopOnInterstitialAdapter()

@property (nonatomic,strong)CartyTopOnInterstitialEvent *interstitialEvent;
@property (nonatomic,strong)CTInterstitialAd *interstitialAd;
@end

@implementation CartyTopOnInterstitialAdapter

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
    self.interstitialEvent = [[CartyTopOnInterstitialEvent alloc] initWithInfo:serverInfo localInfo:localInfo];
    self.interstitialEvent.requestCompletionBlock = completion;
    NSString *pid = serverInfo[@"slot_id"];
    if(pid == nil)
    {
        NSError *error = [NSError errorWithDomain:@"CartyTopOnAdapter" code:400 userInfo:@{NSLocalizedDescriptionKey:@"not pid"}];
        [self.interstitialEvent trackInterstitialAdLoadFailed:error];
        return;
    }
    self.interstitialAd = [[CTInterstitialAd alloc] init];
    self.interstitialAd.placementid = pid;
    self.interstitialAd.delegate = self.interstitialEvent;
    if([localInfo valueForKey:@"Carty_isMute"])
    {
        self.interstitialAd.isMute = [localInfo[@"Carty_isMute"] boolValue];
    }
    [self.interstitialAd loadAd];
}

+ (BOOL)adReadyWithCustomObject:(id)customObject info:(NSDictionary *)info
{
    if([customObject isKindOfClass:[CTInterstitialAd class]])
    {
        CTInterstitialAd *interstitialAd = (CTInterstitialAd *)customObject;
        return interstitialAd.isReady;
    }
    return NO;
}

+ (void)showInterstitial:(ATInterstitial *)interstitial inViewController:(UIViewController *)viewController delegate:(id)delegate
{
    interstitial.customEvent.delegate = delegate;
    CTInterstitialAd *interstitialAd = interstitial.customObject;
    [interstitialAd showAd:viewController];
}

@end
