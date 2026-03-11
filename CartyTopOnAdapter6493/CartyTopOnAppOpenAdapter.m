
#import "CartyTopOnAppOpenAdapter.h"
#import <AnyThinkSplash/AnyThinkSplash.h>
#import <CartySDK/CartySDK.h>
#import "CartyTopOnAdapter.h"
#import "CartyTopOnAppOpenEvent.h"

@interface CartyTopOnAppOpenAdapter()

@property (nonatomic,strong)CTAppOpenAd *appOpenAd;
@property (nonatomic,strong)CartyTopOnAppOpenEvent *appOpenEvent;
@end

@implementation CartyTopOnAppOpenAdapter

#pragma mark - c2s
+ (void)bidRequestWithPlacementModel:(ATPlacementModel *)placementModel unitGroupModel:(ATUnitGroupModel *)unitGroupModel info:(NSDictionary *)info completion:(void(^)(ATBidInfo *bidInfo, NSError *error))completion
{
    NSString *appid = info[@"appid"];
    [CartyTopOnAdapter startWithAppID:appid];
    NSString *pid = info[@"slot_id"];
    if(pid == nil)
    {
        if(completion)
        {
            NSError *error = [NSError errorWithDomain:@"CartyTopOnAdapter" code:400 userInfo:@{NSLocalizedDescriptionKey:@"not pid"}];
            completion(nil,error);
        }
        return;
    }
    CartyTopOnAppOpenEvent *cartyTopOnAppOpenEvent = [[CartyTopOnAppOpenEvent alloc] initWithInfo:info localInfo:info];
    CTAppOpenAd *appOpenAd = [[CTAppOpenAd alloc] init];
    appOpenAd.placementid = pid;
    appOpenAd.delegate = cartyTopOnAppOpenEvent;
    
    cartyTopOnAppOpenEvent.isC2SBiding = YES;
    cartyTopOnAppOpenEvent.bidCompletion = completion;
    cartyTopOnAppOpenEvent.bidInfo =  [ATBidInfo bidInfoC2SWithPlacementID:placementModel.placementID unitGroupUnitID:unitGroupModel.unitID adapterClassString:unitGroupModel.adapterClassString price:@"0" currencyType:ATBiddingCurrencyTypeUS expirationInterval:unitGroupModel.bidTokenTime customObject:appOpenAd];
    
    if([info valueForKey:@"Carty_isMute"])
    {
        appOpenAd.isMute = [info[@"Carty_isMute"] boolValue];
    }
    [appOpenAd loadAd];
    [[CartyTopOnC2SManager sharedInstance] addEvent:cartyTopOnAppOpenEvent placementid:pid];
}

- (nonnull instancetype)initWithNetworkCustomInfo:(nonnull NSDictionary *)serverInfo localInfo:(nonnull NSDictionary *)localInfo
{
    self = [super init];
    if (self != nil) {
        NSString *appid = serverInfo[@"appid"];
        [CartyTopOnAdapter startWithAppID:appid];
    }
    return self;
}

- (void)loadADWithInfo:(nonnull NSDictionary *)serverInfo localInfo:(nonnull NSDictionary *)localInfo completion:(nonnull void (^)(NSArray<NSDictionary *> * _Nonnull, NSError * _Nonnull))completion
{
    NSString *bidId = serverInfo[kATAdapterCustomInfoBuyeruIdKey];
    NSString *pid = serverInfo[@"slot_id"];
    if(bidId && pid)
    {
        ATAdCustomEvent *event = [[CartyTopOnC2SManager sharedInstance] getEvent:pid];
        if([event isKindOfClass:[CartyTopOnAppOpenEvent class]])
        {
            self.appOpenEvent = (CartyTopOnAppOpenEvent *)event;
            self.appOpenEvent.requestCompletionBlock = completion;
            [self.appOpenEvent trackSplashAdLoaded:self.appOpenEvent.bidInfo.customObject adExtra:nil];
        }
        [[CartyTopOnC2SManager sharedInstance] removeEvent:pid];
        return;
    }
    self.appOpenEvent = [[CartyTopOnAppOpenEvent alloc] initWithInfo:serverInfo localInfo:localInfo];
    self.appOpenEvent.requestCompletionBlock = completion;
    if(pid == nil)
    {
        NSError *error = [NSError errorWithDomain:@"CartyTopOnAdapter" code:400 userInfo:@{NSLocalizedDescriptionKey:@"not pid"}];
        [self.appOpenEvent trackSplashAdLoadFailed:error];
        return;
    }
    self.appOpenAd = [[CTAppOpenAd alloc] init];
    self.appOpenAd.placementid = pid;
    self.appOpenAd.delegate = self.appOpenEvent;
    if([localInfo valueForKey:@"Carty_isMute"])
    {
        self.appOpenAd.isMute = [localInfo[@"Carty_isMute"] boolValue];
    }
    [self.appOpenAd loadAd];
}

+ (BOOL)adReadyWithCustomObject:(nonnull id)customObject info:(nonnull NSDictionary *)info
{
    if([customObject isKindOfClass:[CTAppOpenAd class]])
    {
        CTAppOpenAd *appOpenAd = (CTAppOpenAd *)customObject;
        return appOpenAd.isReady;
    }
    return NO;
}

+ (void)showSplash:(ATSplash *)splash localInfo:(NSDictionary *)localInfo delegate:(id)delegate
{
    UIWindow *window = localInfo[kATSplashExtraWindowKey];
    CTAppOpenAd *appOpenAd = (CTAppOpenAd *)splash.customObject;
    CartyTopOnAppOpenEvent *customEvent = (CartyTopOnAppOpenEvent *)splash.customEvent;
    customEvent.delegate = delegate;
    [appOpenAd showAd:window.rootViewController];
}
@end
