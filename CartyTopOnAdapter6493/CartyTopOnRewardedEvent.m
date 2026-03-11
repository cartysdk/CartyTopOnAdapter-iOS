
#import "CartyTopOnRewardedEvent.h"
#import "CartyTopOnC2SManager.h"

@interface CartyTopOnRewardedEvent()

@property (nonatomic, assign) BOOL isRewarded;
@end

@implementation CartyTopOnRewardedEvent

- (void)CTRewardedVideoAdDidLoad:(nonnull CTRewardedVideoAd *)ad
{
    if(self.isC2SBiding)
    {
        self.bidInfo.price = [NSString stringWithFormat:@"%lf",ad.ecpm];
        if(self.bidCompletion)
        {
            self.bidCompletion(self.bidInfo,nil);
        }
        return;
    }
    [self trackRewardedVideoAdLoaded:ad adExtra:nil];;
}

- (void)CTRewardedVideoAdLoadFail:(nonnull CTRewardedVideoAd *)ad withError:(nonnull NSError *)error
{
    if(self.isC2SBiding)
    {
        if(self.bidCompletion)
        {
            self.bidCompletion(nil,error);
        }
        [[CartyTopOnC2SManager sharedInstance] removeEvent:ad.placementid];
        return;
    }
    [self trackRewardedVideoAdLoadFailed:error];
}

- (void)CTRewardedVideoAdDidShow:(nonnull CTRewardedVideoAd *)ad
{
    [self trackRewardedVideoAdShow];
    [self trackRewardedVideoAdVideoStart];
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
