
#import "CartyTopOnNativeRenderer.h"
#import "CartyTopOnNativeEvent.h"
#import <CartySDK/CartySDK.h>

@interface CartyTopOnNativeRenderer()

@property (nonatomic,strong)ATNativeADCache *offer;
@end

@implementation CartyTopOnNativeRenderer

- (void)renderOffer:(ATNativeADCache *)offer
{
    self.offer = offer;
    CartyTopOnNativeEvent *customEvent = self.offer.assets[kATAdAssetsCustomEventKey];
    customEvent.adView = self.ADView;
    self.ADView.customEvent = customEvent;
    CTNativeAd *nativeAd = offer.assets[kATAdAssetsCustomObjectKey];
    if(nativeAd.isTemplate)
    {
        nativeAd.templateView.frame = self.ADView.bounds;
        [self.ADView addSubview:nativeAd.templateView];
        [nativeAd registerContainer:nativeAd.templateView withClickableViews:nil];
    }
    else
    {
        [nativeAd registerContainer:self.ADView withClickableViews:[self.ADView clickableViews]];
    }
}

- (UIView *)getNetWorkMediaView
{
    ATNativeADCache *offer = (ATNativeADCache *)self.ADView.nativeAd;
    CTNativeAd *nativeAd = offer.assets[kATAdAssetsCustomObjectKey];
    UIView *videoAdView = nativeAd.mediaView;
    videoAdView.frame = CGRectMake(0, 0, self.configuration.mediaViewFrame.size.width, self.configuration.mediaViewFrame.size.height);
    return videoAdView;
}

@end
