
#import "CartyTopOnBannerEvent.h"
#import "CartyTopOnC2SManager.h"

@implementation CartyTopOnBannerEvent

- (void)CTBannerAdDidLoad:(nonnull CTBannerAd *)ad
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
    [self trackBannerAdLoaded:ad adExtra:nil];
}

- (void)CTBannerAdLoadFail:(nonnull CTBannerAd *)ad withError:(nonnull NSError *)error
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
    [self trackBannerAdLoadFailed:error];
}

- (void)CTBannerAdDidShow:(nonnull CTBannerAd *)ad
{
    [self trackBannerAdImpression];
}

- (void)CTBannerAdShowFail:(nonnull CTBannerAd *)ad withError:(nonnull NSError *)error
{
    
}

- (void)CTBannerAdDidClick:(nonnull CTBannerAd *)ad
{
    [self trackBannerAdClick];
}

- (void)CTBannerAdDidClose:(nonnull CTBannerAd *)ad
{
    [self trackBannerAdClosed];
}

@end
