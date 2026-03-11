
#import "CartyTopOnAppOpenEvent.h"
#import "CartyTopOnC2SManager.h"

@implementation CartyTopOnAppOpenEvent

- (void)CTOpenAdDidLoad:(nonnull CTAppOpenAd *)ad
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
    [self trackSplashAdLoaded:ad adExtra:nil];
}

- (void)CTOpenAdLoadFail:(nonnull CTAppOpenAd *)ad withError:(nonnull NSError *)error
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
    [self trackSplashAdLoadFailed:error];
}

- (void)CTOpenAdDidShow:(nonnull CTAppOpenAd *)ad
{
    [self trackSplashAdShow];
}

- (void)CTOpenAdShowFail:(nonnull CTAppOpenAd *)ad withError:(nonnull NSError *)error
{
    [self trackSplashAdShowFailed:error];
}

- (void)CTOpenAdDidClick:(nonnull CTAppOpenAd *)ad
{
    [self trackSplashAdClick];
}

- (void)CTOpenAdDidDismiss:(nonnull CTAppOpenAd *)ad
{
    [self trackSplashAdClosed:nil];
}

@end
