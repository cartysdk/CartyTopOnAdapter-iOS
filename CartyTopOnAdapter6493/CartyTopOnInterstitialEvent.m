
#import "CartyTopOnInterstitialEvent.h"

@implementation CartyTopOnInterstitialEvent

- (void)CTInterstitialAdDidLoad:(nonnull CTInterstitialAd *)ad
{
    [self trackInterstitialAdLoaded:ad adExtra:nil];
}

- (void)CTInterstitialAdLoadFail:(nonnull CTInterstitialAd *)ad withError:(nonnull NSError *)error
{
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
