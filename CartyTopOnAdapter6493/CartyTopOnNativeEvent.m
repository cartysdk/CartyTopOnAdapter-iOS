
#import "CartyTopOnNativeEvent.h"
#import "CartyTopOnC2SManager.h"

@implementation CartyTopOnNativeEvent

- (void)CTNativeAdDidLoad:(nonnull CTNativeAd *)ad
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
    NSMutableDictionary *asset = [[NSMutableDictionary alloc] init];
    if(ad.isTemplate)
    {
        asset[kATNativeADAssetsIsExpressAdKey] = @(YES);
        asset[kATAdAssetsCustomObjectKey] = ad;
        asset[kATAdAssetsCustomEventKey] = self;
    }
    else
    {
        asset[kATAdAssetsCustomObjectKey] = ad;
        asset[kATNativeADAssetsMainTitleKey] = ad.title;
        asset[kATNativeADAssetsMainTextKey] = ad.desc;
        asset[kATNativeADAssetsCTATextKey] = ad.ctaText;
        asset[kATNativeADAssetsIconURLKey] = ad.iconImageURL;
        asset[kATNativeADAssetsLogoSetKey] = @{@"adChoiceView":ad.adChoiceView};
        asset[kATAdAssetsCustomEventKey] = self;
    }
    [self trackNativeAdLoaded:@[asset]];
}

- (void)CTNativeAdLoadFail:(nonnull CTNativeAd *)ad withError:(nonnull NSError *)error
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
    [self trackNativeAdClick];
}
@end
