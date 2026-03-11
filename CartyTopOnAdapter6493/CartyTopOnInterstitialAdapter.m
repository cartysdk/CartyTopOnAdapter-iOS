
#import "CartyTopOnInterstitialAdapter.h"
#import "CartyTopOnInterstitialEvent.h"
#import "CartyTopOnAdapter.h"
#import <AnyThinkInterstitial/AnyThinkInterstitial.h>
#import <CartySDK/CartySDK.h>


@interface CartyTopOnInterstitialAdapter()

@property (nonatomic,strong)CartyTopOnInterstitialEvent *interstitialEvent;
@property (nonatomic,strong)CTInterstitialAd *interstitialAd;
@end

@implementation CartyTopOnInterstitialAdapter

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
    CartyTopOnInterstitialEvent *cartyTopOnInterstitialEvent = [[CartyTopOnInterstitialEvent alloc] initWithInfo:info localInfo:info];
    CTInterstitialAd *interstitialAd = [[CTInterstitialAd alloc] init];
    interstitialAd.placementid = pid;
    interstitialAd.delegate = cartyTopOnInterstitialEvent;
    cartyTopOnInterstitialEvent.isC2SBiding = YES;
    cartyTopOnInterstitialEvent.bidCompletion = completion;
    cartyTopOnInterstitialEvent.bidInfo =  [ATBidInfo bidInfoC2SWithPlacementID:placementModel.placementID unitGroupUnitID:unitGroupModel.unitID adapterClassString:unitGroupModel.adapterClassString price:@"0" currencyType:ATBiddingCurrencyTypeUS expirationInterval:unitGroupModel.bidTokenTime customObject:interstitialAd];
    if([info valueForKey:@"Carty_isMute"])
    {
        interstitialAd.isMute = [info[@"Carty_isMute"] boolValue];
    }
    [interstitialAd loadAd];
    [[CartyTopOnC2SManager sharedInstance] addEvent:cartyTopOnInterstitialEvent placementid:pid];
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

- (void)loadADWithInfo:(NSDictionary *)serverInfo localInfo:(NSDictionary *)localInfo completion:(void (^)(NSArray *, NSError *))completion
{
    NSString *bidId = serverInfo[kATAdapterCustomInfoBuyeruIdKey];
    NSString *pid = serverInfo[@"slot_id"];
    if(bidId && pid)
    {
        ATAdCustomEvent *event = [[CartyTopOnC2SManager sharedInstance] getEvent:pid];
        if([event isKindOfClass:[CartyTopOnInterstitialEvent class]])
        {
            self.interstitialEvent = (CartyTopOnInterstitialEvent *)event;
            self.interstitialEvent.requestCompletionBlock = completion;
            [self.interstitialEvent trackInterstitialAdLoaded:self.interstitialEvent.bidInfo.customObject adExtra:nil];
        }
        [[CartyTopOnC2SManager sharedInstance] removeEvent:pid];
        return;
    }
    self.interstitialEvent = [[CartyTopOnInterstitialEvent alloc] initWithInfo:serverInfo localInfo:localInfo];
    self.interstitialEvent.requestCompletionBlock = completion;
    if(pid == nil)
    {
        NSError *error = [NSError errorWithDomain:@"CartyTopOnAdapter" code:400 userInfo:@{NSLocalizedDescriptionKey:@"not pid"}];
        [self.interstitialEvent trackInterstitialAdLoadFailed:error];
        return;
    }
    self.interstitialAd = [[CTInterstitialAd alloc] init];
    self.interstitialAd.placementid = pid;
    self.interstitialAd.delegate = self.interstitialEvent;
    if([localInfo valueForKey:@"Carty_isMute"])
    {
        self.interstitialAd.isMute = [localInfo[@"Carty_isMute"] boolValue];
    }
    [self.interstitialAd loadAd];
}

+ (BOOL)adReadyWithCustomObject:(id)customObject info:(NSDictionary *)info
{
    if([customObject isKindOfClass:[CTInterstitialAd class]])
    {
        CTInterstitialAd *interstitialAd = (CTInterstitialAd *)customObject;
        return interstitialAd.isReady;
    }
    return NO;
}

+ (void)showInterstitial:(ATInterstitial *)interstitial inViewController:(UIViewController *)viewController delegate:(id)delegate
{
    interstitial.customEvent.delegate = delegate;
    CTInterstitialAd *interstitialAd = interstitial.customObject;
    [interstitialAd showAd:viewController];
}

@end
