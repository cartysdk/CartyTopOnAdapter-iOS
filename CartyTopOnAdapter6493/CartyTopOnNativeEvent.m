
#import "CartyTopOnNativeEvent.h"

@implementation CartyTopOnNativeEvent

- (void)CTNativeAdDidLoad:(nonnull CTNativeAd *)ad
{
    NSMutableDictionary *asset = [[NSMutableDictionary alloc] init];
    asset[kATAdAssetsCustomObjectKey] = ad;
    asset[kATNativeADAssetsMainTitleKey] = ad.title;
    asset[kATNativeADAssetsMainTextKey] = ad.desc;
    asset[kATNativeADAssetsCTATextKey] = ad.ctaText;
    asset[kATNativeADAssetsIconURLKey] = ad.iconImageURL;
    asset[kATNativeADAssetsLogoSetKey] = @{@"adChoiceView":ad.adChoiceView};
    asset[kATAdAssetsCustomEventKey] = self;
    [self trackNativeAdLoaded:@[asset]];
}

- (void)CTNativeAdLoadFail:(nonnull CTNativeAd *)ad withError:(nonnull NSError *)error
{
    [self trackNativeAdLoadFailed:error];
}

- (void)CTNativeAdDidShow:(nonnull CTNativeAd *)ad
{
    [self trackNativeAdImpression];
}

- (void)CTNativeAdShowFail:(nonnull CTNativeAd *)ad withError:(nonnull NSError *)error
{
    
}

- (void)CTNativeAdDidClick:(nonnull CTNativeAd *)ad
{
    [self trackClick];
}
@end
