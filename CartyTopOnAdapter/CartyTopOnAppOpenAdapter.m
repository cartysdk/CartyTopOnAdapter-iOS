
#import "CartyTopOnAppOpenAdapter.h"
#import <CartySDK/CartySDK.h>

@interface CartyTopOnAppOpenAdapter()<CTAppOpenAdDelegate>

@property (nonatomic,strong)CTAppOpenAd *appOpenAd;
@end

@implementation CartyTopOnAppOpenAdapter

- (void)loadADWithArgument:(ATAdMediationArgument *)argument
{
    NSString *pid = argument.serverContentDic[@"slot_id"];
    if(pid == nil)
    {
        NSError *error = [NSError errorWithDomain:@"CartyTopOnAdapter" code:400 userInfo:@{NSLocalizedDescriptionKey:@"not pid"}];
        [self.adStatusBridge atOnAdLoadFailed:error adExtra:nil];
        return;
    }
    self.appOpenAd = [[CTAppOpenAd alloc] init];
    self.appOpenAd.placementid = pid;
    self.appOpenAd.delegate = self;
    if([argument.localInfoDic valueForKey:@"Carty_isMute"])
    {
        self.appOpenAd.isMute = [argument.localInfoDic[@"Carty_isMute"] boolValue];
    }
    [self.appOpenAd loadAd];
}

- (BOOL)adReadySplashWithInfo:(NSDictionary *)info
{
    return self.appOpenAd.isReady;
}

- (void)showSplashAdInWindow:(nonnull UIWindow *)window inViewController:(nonnull UIViewController *)inViewController parameter:(nonnull NSDictionary *)parameter
{
    [self.appOpenAd showAd:window.rootViewController];
}


- (void)CTOpenAdDidLoad:(nonnull CTAppOpenAd *)ad
{
    [self.adStatusBridge atOnSplashAdLoadedExtra:nil];
}

- (void)CTOpenAdLoadFail:(nonnull CTAppOpenAd *)ad withError:(nonnull NSError *)error
{
    [self.adStatusBridge atOnAdLoadFailed:error adExtra:nil];
}

- (void)CTOpenAdDidShow:(nonnull CTAppOpenAd *)ad
{
    [self.adStatusBridge atOnAdShow:nil];
}

- (void)CTOpenAdShowFail:(nonnull CTAppOpenAd *)ad withError:(nonnull NSError *)error
{
    [self.adStatusBridge atOnAdShowFailed:error extra:nil];
}

- (void)CTOpenAdDidClick:(nonnull CTAppOpenAd *)ad
{
    [self.adStatusBridge atOnAdClick:nil];
}

- (void)CTOpenAdDidDismiss:(nonnull CTAppOpenAd *)ad
{
    [self.adStatusBridge atOnAdClosed:nil];
}

@end
