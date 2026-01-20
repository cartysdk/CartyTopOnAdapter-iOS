
#import "CartyTopOnBannerEvent.h"

@implementation CartyTopOnBannerEvent

- (void)CTBannerAdDidLoad:(nonnull CTBannerAd *)ad
{ 
    [self trackBannerAdLoaded:ad adExtra:nil];
}

- (void)CTBannerAdLoadFail:(nonnull CTBannerAd *)ad withError:(nonnull NSError *)error
{
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
