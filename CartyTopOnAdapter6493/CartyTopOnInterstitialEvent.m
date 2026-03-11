
#import "CartyTopOnInterstitialEvent.h"
#import "CartyTopOnC2SManager.h"

@implementation CartyTopOnInterstitialEvent

- (void)CTInterstitialAdDidLoad:(nonnull CTInterstitialAd *)ad
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
    [self trackInterstitialAdLoaded:ad adExtra:nil];
}

- (void)CTInterstitialAdLoadFail:(nonnull CTInterstitialAd *)ad withError:(nonnull NSError *)error
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
    [self trackInterstitialAdLoadFailed:error];
}

- (void)CTInterstitialAdDidShow:(nonnull CTInterstitialAd *)ad
{
    [self trackInterstitialAdShow];
}

- (void)CTInterstitialAdShowFail:(nonnull CTInterstitialAd *)ad withError:(nonnull NSError *)error
{
    [self trackInterstitialAdShowFailed:error];
}

- (void)CTInterstitialAdDidClick:(nonnull CTInterstitialAd *)ad
{
    [self trackInterstitialAdClick];
}

- (void)CTInterstitialAdDidDismiss:(nonnull CTInterstitialAd *)ad
{
    [self trackInterstitialAdClose:nil];
}

@end
