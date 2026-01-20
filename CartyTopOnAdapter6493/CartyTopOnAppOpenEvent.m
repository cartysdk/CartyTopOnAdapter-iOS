
#import "CartyTopOnAppOpenEvent.h"

@implementation CartyTopOnAppOpenEvent

- (void)CTOpenAdDidLoad:(nonnull CTAppOpenAd *)ad
{
    [self trackSplashAdLoaded:ad adExtra:nil];
}

- (void)CTOpenAdLoadFail:(nonnull CTAppOpenAd *)ad withError:(nonnull NSError *)error
{
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
