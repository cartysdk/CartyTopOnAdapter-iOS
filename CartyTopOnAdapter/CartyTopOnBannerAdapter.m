
#import "CartyTopOnBannerAdapter.h"
#import <AnyThinkSDK/AnyThinkSDK.h>
#import <CartySDK/CartySDK.h>

@interface CartyTopOnBannerAdapter()<CTBannerAdDelegate>

@property (nonatomic,strong)CTBannerAd *bannerAd;
@end

@implementation CartyTopOnBannerAdapter

- (void)loadADWithArgument:(ATAdMediationArgument *)argument
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *pid = argument.serverContentDic[@"slot_id"];
        if(pid == nil)
        {
            NSError *error = [NSError errorWithDomain:@"CartyTopOnAdapter" code:400 userInfo:@{NSLocalizedDescriptionKey:@"not pid"}];
            [self.adStatusBridge atOnAdLoadFailed:error adExtra:nil];
            return;
        }
        self.bannerAd = [[CTBannerAd alloc] init];
        self.bannerAd.placementid = pid;
        self.bannerAd.delegate = self;
        CGSize bannerSize = CGSizeMake(320, 50);
        if (!CGSizeEqualToSize(argument.bannerSize, CGSizeZero)) {
            bannerSize = argument.bannerSize;
        }
        CGRect rect = CGRectZero;
        rect.size = bannerSize;
        self.bannerAd.frame = rect;
        if([argument.localInfoDic valueForKey:@"Carty_isMute"])
        {
            self.bannerAd.isMute = [argument.localInfoDic[@"Carty_isMute"] boolValue];
        }
        if([argument.localInfoDic valueForKey:@"Carty_BannerSize"])
        {
            self.bannerAd.bannerSize = [argument.localInfoDic[@"Carty_BannerSize"] integerValue];
        }
        [self.bannerAd loadAd];
    });
}

- (void)CTBannerAdDidLoad:(nonnull CTBannerAd *)ad
{
    [self.adStatusBridge atOnBannerAdLoadedWithView:ad adExtra:nil];
}

- (void)CTBannerAdLoadFail:(nonnull CTBannerAd *)ad withError:(nonnull NSError *)error
{
    [self.adStatusBridge atOnAdLoadFailed:error adExtra:nil];
}

- (void)CTBannerAdDidShow:(nonnull CTBannerAd *)ad
{
    [self.adStatusBridge atOnAdShow:nil];
}

- (void)CTBannerAdShowFail:(nonnull CTBannerAd *)ad withError:(nonnull NSError *)error
{
    [self.adStatusBridge atOnAdShowFailed:error extra:nil];
}

- (void)CTBannerAdDidClick:(nonnull CTBannerAd *)ad
{
    [self.adStatusBridge atOnAdClick:nil];
}

- (void)CTBannerAdDidClose:(nonnull CTBannerAd *)ad
{
    [self.adStatusBridge atOnAdClosed:nil];
}

@end
