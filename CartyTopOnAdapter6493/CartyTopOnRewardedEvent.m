
#import "CartyTopOnRewardedEvent.h"

@interface CartyTopOnRewardedEvent()

@property (nonatomic, assign) BOOL isRewarded;
@end

@implementation CartyTopOnRewardedEvent

- (void)CTRewardedVideoAdDidLoad:(nonnull CTRewardedVideoAd *)ad
{
    [self trackRewardedVideoAdLoaded:ad adExtra:nil];;
}

- (void)CTRewardedVideoAdDidShow:(nonnull CTRewardedVideoAd *)ad
{
    [self trackRewardedVideoAdShow];
    [self trackRewardedVideoAdVideoStart];
}

- (void)CTRewardedVideoAdLoadFail:(nonnull CTRewardedVideoAd *)ad withError:(nonnull NSError *)error
{
    [self trackRewardedVideoAdLoadFailed:error];
}

- (void)CTRewardedVideoAdShowFail:(nonnull CTRewardedVideoAd *)ad withError:(nonnull NSError *)error
{
    [self trackRewardedVideoAdPlayEventWithError:error];
}

- (void)CTRewardedVideoAdDidClick:(nonnull CTRewardedVideoAd *)ad
{
    [self trackRewardedVideoAdClick];
}

- (void)CTRewardedVideoAdDidDismiss:(nonnull CTRewardedVideoAd *)ad
{
    [self trackRewardedVideoAdVideoEnd];
    [self trackRewardedVideoAdCloseRewarded:self.isRewarded extra:@{}];
}

- (void)CTRewardedVideoAdDidEarnReward:(nonnull CTRewardedVideoAd *)ad rewardInfo:(nonnull NSDictionary *)rewardInfo {
    self.isRewarded = YES;
    [self trackRewardedVideoAdRewarded];
}

@end
