
#import "CartyTopOnRewardedAdapter.h"
#import <AnyThinkSDK/AnyThinkSDK.h>
#import <CartySDK/CartySDK.h>

@interface CartyTopOnRewardedAdapter()<CTRewardedVideoAdDelegate>
@property (nonatomic,strong)CTRewardedVideoAd *rewardedVideoAd;
@end

@implementation CartyTopOnRewardedAdapter

- (void)loadADWithArgument:(ATAdMediationArgument *)argument
{
    NSString *pid = argument.serverContentDic[@"slot_id"];
    if(pid == nil)
    {
        NSError *error = [NSError errorWithDomain:@"CartyTopOnAdapter" code:400 userInfo:@{NSLocalizedDescriptionKey:@"not pid"}];
        [self.adStatusBridge atOnAdLoadFailed:error adExtra:nil];
        return;
    }
    self.rewardedVideoAd = [[CTRewardedVideoAd alloc] init];
    if([argument.localInfoDic valueForKey:kATAdLoadingExtraUserIDKey])
    {
        [CartyADSDK sharedInstance].userid = argument.localInfoDic[kATAdLoadingExtraUserIDKey];
    }
    if([argument.localInfoDic valueForKey:kATAdLoadingExtraMediaExtraKey])
    {
        self.rewardedVideoAd.customRewardString = argument.localInfoDic[kATAdLoadingExtraMediaExtraKey];
    }
    if([argument.localInfoDic valueForKey:@"Carty_isMute"])
    {
        self.rewardedVideoAd.isMute = [argument.localInfoDic[@"Carty_isMute"] boolValue];
    }
    self.rewardedVideoAd.placementid = pid;
    self.rewardedVideoAd.delegate = self;
    [self.rewardedVideoAd loadAd];
}

- (BOOL)adReadyRewardedWithInfo:(NSDictionary *)info
{
    return self.rewardedVideoAd.isReady;
}

- (void)showRewardedVideoInViewController:(UIViewController *)viewController
{
    [self.rewardedVideoAd showAd:viewController];
}

- (void)CTRewardedVideoAdDidLoad:(nonnull CTRewardedVideoAd *)ad
{
    [self.adStatusBridge atOnRewardedAdLoadedExtra:nil];
}

- (void)CTRewardedVideoAdLoadFail:(nonnull CTRewardedVideoAd *)ad withError:(nonnull NSError *)error
{
    [self.adStatusBridge atOnAdLoadFailed:error adExtra:nil];
}

- (void)CTRewardedVideoAdDidShow:(nonnull CTRewardedVideoAd *)ad
{
    [self.adStatusBridge atOnAdShow:nil];
}

- (void)CTRewardedVideoAdShowFail:(nonnull CTRewardedVideoAd *)ad withError:(nonnull NSError *)error
{
    [self.adStatusBridge atOnAdShowFailed:error extra:nil];
}

- (void)CTRewardedVideoAdDidClick:(nonnull CTRewardedVideoAd *)ad
{
    [self.adStatusBridge atOnAdClick:nil];
}

- (void)CTRewardedVideoAdDidDismiss:(nonnull CTRewardedVideoAd *)ad
{
    [self.adStatusBridge atOnAdClosed:nil];
}

- (void)CTRewardedVideoAdDidEarnReward:(nonnull CTRewardedVideoAd *)ad rewardInfo:(nonnull NSDictionary *)rewardInfo
{
    [self.adStatusBridge atOnRewardedVideoAdRewarded];
}

@end
