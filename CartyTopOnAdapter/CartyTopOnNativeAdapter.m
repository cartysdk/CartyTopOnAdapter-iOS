
#import "CartyTopOnNativeAdapter.h"
#import <AnyThinkSDK/AnyThinkSDK.h>
#import <CartySDK/CartySDK.h>
#import "CartyTopOnNativeObject.h"

@interface CartyTopOnNativeAdapter()<CTNativeAdDelegate>
@property (nonatomic,strong)CTNativeAd *nativeAd;
@end


@implementation CartyTopOnNativeAdapter

- (void)loadADWithArgument:(ATAdMediationArgument *)argument
{
    NSString *pid = argument.serverContentDic[@"slot_id"];
    if(pid == nil)
    {
        NSError *error = [NSError errorWithDomain:@"CartyTopOnAdapter" code:400 userInfo:@{NSLocalizedDescriptionKey:@"not pid"}];
        [self.adStatusBridge atOnAdLoadFailed:error adExtra:nil];
        return;
    }
    self.nativeAd = [[CTNativeAd alloc] init];
    self.nativeAd.placementid = pid;
    self.nativeAd.delegate = self;
    if([argument.localInfoDic valueForKey:@"Carty_isMute"])
    {
        self.nativeAd.isMute = [argument.localInfoDic[@"Carty_isMute"] boolValue];
    }
    [self.nativeAd loadAd];
}


- (void)CTNativeAdDidLoad:(nonnull CTNativeAd *)ad
{
    CartyTopOnNativeObject *nativeObject = [[CartyTopOnNativeObject alloc] init];
    nativeObject.nativeAd = ad;
    nativeObject.nativeAdRenderType = ATNativeAdRenderSelfRender;
    nativeObject.title = ad.title;
    nativeObject.mainText = ad.desc;
    nativeObject.iconUrl = ad.iconImageURL;
    nativeObject.ctaText = ad.ctaText;
    nativeObject.logoView = ad.adChoiceView;
    nativeObject.mediaView = ad.mediaView;
    [self.adStatusBridge atOnNativeAdLoadedArray:@[nativeObject] adExtra:nil];
}

- (void)CTNativeAdLoadFail:(nonnull CTNativeAd *)ad withError:(nonnull NSError *)error
{
    [self.adStatusBridge atOnAdLoadFailed:error adExtra:nil];
}

- (void)CTNativeAdDidShow:(nonnull CTNativeAd *)ad
{
    [self.adStatusBridge atOnAdShow:nil];
}

- (void)CTNativeAdShowFail:(nonnull CTNativeAd *)ad withError:(nonnull NSError *)error
{
    [self.adStatusBridge atOnAdShowFailed:error extra:nil];
}

- (void)CTNativeAdDidClick:(nonnull CTNativeAd *)ad
{
    [self.adStatusBridge atOnAdClick:nil];
}

@end
