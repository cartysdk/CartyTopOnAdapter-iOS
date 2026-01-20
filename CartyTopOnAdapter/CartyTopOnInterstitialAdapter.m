
#import "CartyTopOnInterstitialAdapter.h"
#import <AnyThinkSDK/AnyThinkSDK.h>
#import <CartySDK/CartySDK.h>


@interface CartyTopOnInterstitialAdapter()<CTInterstitialAdDelegate>

@property (nonatomic,strong)CTInterstitialAd *interstitialAd;
@end

@implementation CartyTopOnInterstitialAdapter

- (void)loadADWithArgument:(ATAdMediationArgument *)argument
{
    NSString *pid = argument.serverContentDic[@"slot_id"];
    if(pid == nil)
    {
        NSError *error = [NSError errorWithDomain:@"CartyTopOnAdapter" code:400 userInfo:@{NSLocalizedDescriptionKey:@"not pid"}];
        [self.adStatusBridge atOnAdLoadFailed:error adExtra:nil];
        return;
    }
    self.interstitialAd = [[CTInterstitialAd alloc] init];
    self.interstitialAd.placementid = pid;
    self.interstitialAd.delegate = self;
    if([argument.localInfoDic valueForKey:@"Carty_isMute"])
    {
        self.interstitialAd.isMute = [argument.localInfoDic[@"Carty_isMute"] boolValue];
    }
    [self.interstitialAd loadAd];
}

- (BOOL)adReadyInterstitialWithInfo:(NSDictionary *)info
{
    return self.interstitialAd.isReady;
}

- (void)showInterstitialInViewController:(UIViewController *)viewController
{
    [self.interstitialAd showAd:viewController];
}

- (void)CTInterstitialAdDidLoad:(nonnull CTInterstitialAd *)ad
{
    [self.adStatusBridge atOnInterstitialAdLoadedExtra:nil];
}


- (void)CTInterstitialAdLoadFail:(nonnull CTInterstitialAd *)ad withError:(nonnull NSError *)error
{
    [self.adStatusBridge atOnAdLoadFailed:error adExtra:nil];
}

- (void)CTInterstitialAdDidShow:(nonnull CTInterstitialAd *)ad
{
    [self.adStatusBridge atOnAdShow:nil];
}

- (void)CTInterstitialAdShowFail:(nonnull CTInterstitialAd *)ad withError:(nonnull NSError *)error
{
    [self.adStatusBridge atOnAdShowFailed:error extra:nil];
}

- (void)CTInterstitialAdDidClick:(nonnull CTInterstitialAd *)ad
{
    [self.adStatusBridge atOnAdClick:nil];
}

- (void)CTInterstitialAdDidDismiss:(nonnull CTInterstitialAd *)ad
{
    [self.adStatusBridge atOnAdClosed:nil];
}

@end
