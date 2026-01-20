
#import "CartyTopOnRewardedAdapter.h"
#import "CartyTopOnRewardedEvent.h"
#import "CartyTopOnAdapter.h"
#import <AnyThinkRewardedVideo/AnyThinkRewardedVideo.h>
#import <CartySDK/CartySDK.h>

@interface CartyTopOnRewardedAdapter()

@property (nonatomic,strong)CartyTopOnRewardedEvent *rewardedEvent;
@property (nonatomic,strong)CTRewardedVideoAd *rewardedVideoAd;
@end

@implementation CartyTopOnRewardedAdapter

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
    self.rewardedEvent = [[CartyTopOnRewardedEvent alloc] initWithInfo:serverInfo localInfo:localInfo];
    self.rewardedEvent.requestCompletionBlock = completion;
    NSString *pid = serverInfo[@"slot_id"];
    if(pid == nil)
    {
        NSError *error = [NSError errorWithDomain:@"CartyTopOnAdapter" code:400 userInfo:@{NSLocalizedDescriptionKey:@"not pid"}];
        [self.rewardedEvent trackRewardedVideoAdLoadFailed:error];
        return;
    }
    self.rewardedVideoAd = [[CTRewardedVideoAd alloc] init];
    self.rewardedVideoAd.placementid = pid;
    self.rewardedVideoAd.delegate = self.rewardedEvent;
    if([localInfo valueForKey:kATAdLoadingExtraUserIDKey])
    {
        [CartyADSDK sharedInstance].userid = localInfo[kATAdLoadingExtraUserIDKey];
    }
    if([localInfo valueForKey:kATAdLoadingExtraMediaExtraKey])
    {
        self.rewardedVideoAd.customRewardString = localInfo[kATAdLoadingExtraMediaExtraKey];
    }
    if([localInfo valueForKey:@"Carty_isMute"])
    {
        self.rewardedVideoAd.isMute = [localInfo[@"Carty_isMute"] boolValue];
    }
    [self.rewardedVideoAd loadAd];
}

+ (BOOL)adReadyWithCustomObject:(id)customObject info:(NSDictionary *)info
{
    if([customObject isKindOfClass:[CTRewardedVideoAd class]])
    {
        CTRewardedVideoAd *rewardedVideoAd = (CTRewardedVideoAd *)customObject;
        return rewardedVideoAd.isReady;
    }
    return NO;
}

+ (void)showRewardedVideo:(ATRewardedVideo *)rewardedVideo inViewController:(UIViewController *)viewController delegate:(id)delegate
{
    rewardedVideo.customEvent.delegate = delegate;
    CTRewardedVideoAd *rewardAd = rewardedVideo.customObject;
    [rewardAd showAd:viewController];
}
@end
