
#import "CartyTopOnRewardedAdapter.h"
#import "CartyTopOnRewardedEvent.h"
#import "CartyTopOnAdapter.h"
#import <AnyThinkRewardedVideo/AnyThinkRewardedVideo.h>
#import <CartySDK/CartySDK.h>

@interface CartyTopOnRewardedAdapter()

@property (nonatomic,strong)CartyTopOnRewardedEvent *rewardedEvent;
@property (nonatomic,strong)CTRewardedVideoAd *rewardedVideoAd;
@end

@implementation CartyTopOnRewardedAdapter

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
    CartyTopOnRewardedEvent *cartyTopOnRewardedEvent = [[CartyTopOnRewardedEvent alloc] initWithInfo:info localInfo:info];
    CTRewardedVideoAd *rewardedVideoAd = [[CTRewardedVideoAd alloc] init];
    rewardedVideoAd.placementid = pid;
    rewardedVideoAd.delegate = cartyTopOnRewardedEvent;
    
    cartyTopOnRewardedEvent.isC2SBiding = YES;
    cartyTopOnRewardedEvent.bidCompletion = completion;
    cartyTopOnRewardedEvent.bidInfo =  [ATBidInfo bidInfoC2SWithPlacementID:placementModel.placementID unitGroupUnitID:unitGroupModel.unitID adapterClassString:unitGroupModel.adapterClassString price:@"0" currencyType:ATBiddingCurrencyTypeUS expirationInterval:unitGroupModel.bidTokenTime customObject:rewardedVideoAd];
    
    if([info valueForKey:kATAdLoadingExtraUserIDKey])
    {
        [CartyADSDK sharedInstance].userid = info[kATAdLoadingExtraUserIDKey];
    }
    if([info valueForKey:kATAdLoadingExtraMediaExtraKey])
    {
        rewardedVideoAd.customRewardString = info[kATAdLoadingExtraMediaExtraKey];
    }
    if([info valueForKey:@"Carty_isMute"])
    {
        rewardedVideoAd.isMute = [info[@"Carty_isMute"] boolValue];
    }
    [rewardedVideoAd loadAd];
    [[CartyTopOnC2SManager sharedInstance] addEvent:cartyTopOnRewardedEvent placementid:pid];
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
        if([event isKindOfClass:[CartyTopOnRewardedEvent class]])
        {
            self.rewardedEvent = (CartyTopOnRewardedEvent *)event;
            self.rewardedEvent.requestCompletionBlock = completion;
            [self.rewardedEvent trackRewardedVideoAdLoaded:self.rewardedEvent.bidInfo.customObject adExtra:nil];
        }
        [[CartyTopOnC2SManager sharedInstance] removeEvent:pid];
        return;
    }
    self.rewardedEvent = [[CartyTopOnRewardedEvent alloc] initWithInfo:serverInfo localInfo:localInfo];
    self.rewardedEvent.requestCompletionBlock = completion;
    if(pid == nil)
    {
        NSError *error = [NSError errorWithDomain:@"CartyTopOnAdapter" code:400 userInfo:@{NSLocalizedDescriptionKey:@"not pid"}];
        [self.rewardedEvent trackRewardedVideoAdLoadFailed:error];
        return;
    }
    self.rewardedVideoAd = [[CTRewardedVideoAd alloc] init];
    self.rewardedVideoAd.placementid = pid;
    self.rewardedVideoAd.delegate = self.rewardedEvent;
    if([localInfo valueForKey:kATAdLoadingExtraUserIDKey])
    {
        [CartyADSDK sharedInstance].userid = localInfo[kATAdLoadingExtraUserIDKey];
    }
    if([localInfo valueForKey:kATAdLoadingExtraMediaExtraKey])
    {
        self.rewardedVideoAd.customRewardString = localInfo[kATAdLoadingExtraMediaExtraKey];
    }
    if([localInfo valueForKey:@"Carty_isMute"])
    {
        self.rewardedVideoAd.isMute = [localInfo[@"Carty_isMute"] boolValue];
    }
    [self.rewardedVideoAd loadAd];
}

+ (BOOL)adReadyWithCustomObject:(id)customObject info:(NSDictionary *)info
{
    if([customObject isKindOfClass:[CTRewardedVideoAd class]])
    {
        CTRewardedVideoAd *rewardedVideoAd = (CTRewardedVideoAd *)customObject;
        return rewardedVideoAd.isReady;
    }
    return NO;
}

+ (void)showRewardedVideo:(ATRewardedVideo *)rewardedVideo inViewController:(UIViewController *)viewController delegate:(id)delegate
{
    rewardedVideo.customEvent.delegate = delegate;
    CTRewardedVideoAd *rewardAd = rewardedVideo.customObject;
    [rewardAd showAd:viewController];
}
@end
