
#import "CartyTopOnNativeAdapter.h"
#import "CartyTopOnNativeEvent.h"
#import "CartyTopOnAdapter.h"
#import "CartyTopOnNativeRenderer.h"
#import <AnyThinkNative/AnyThinkNative.h>
#import <CartySDK/CartySDK.h>

@interface CartyTopOnNativeAdapter()

@property (nonatomic,strong)CartyTopOnNativeEvent *nativeEvent;
@property (nonatomic,strong)CTNativeAd *nativeAd;
@end


@implementation CartyTopOnNativeAdapter

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
    CartyTopOnNativeEvent *cartyTopOnNativeEvent = [[CartyTopOnNativeEvent alloc] initWithInfo:info localInfo:info];
    CTNativeAd *nativeAd = [[CTNativeAd alloc] init];
    nativeAd.placementid = pid;
    nativeAd.delegate = cartyTopOnNativeEvent;
    cartyTopOnNativeEvent.isC2SBiding = YES;
    cartyTopOnNativeEvent.bidCompletion = completion;
    cartyTopOnNativeEvent.bidInfo =  [ATBidInfo bidInfoC2SWithPlacementID:placementModel.placementID unitGroupUnitID:unitGroupModel.unitID adapterClassString:unitGroupModel.adapterClassString price:@"0" currencyType:ATBiddingCurrencyTypeUS expirationInterval:unitGroupModel.bidTokenTime customObject:nativeAd];
    if([info valueForKey:@"Carty_isMute"])
    {
        nativeAd.isMute = [info[@"Carty_isMute"] boolValue];
    }
    [nativeAd loadAd];
    [[CartyTopOnC2SManager sharedInstance] addEvent:cartyTopOnNativeEvent placementid:pid];
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
        if([event isKindOfClass:[CartyTopOnNativeEvent class]])
        {
            self.nativeEvent = (CartyTopOnNativeEvent *)event;
            self.nativeEvent.requestCompletionBlock = completion;
            CTNativeAd *nativeAd = self.nativeEvent.bidInfo.customObject;
            NSMutableDictionary *asset = [[NSMutableDictionary alloc] init];
            if(nativeAd.isTemplate)
            {
                asset[kATNativeADAssetsIsExpressAdKey] = @(YES);
                asset[kATAdAssetsCustomObjectKey] = nativeAd;
                asset[kATAdAssetsCustomEventKey] = self.nativeEvent;
            }
            else
            {
                asset[kATAdAssetsCustomObjectKey] = nativeAd;
                asset[kATNativeADAssetsMainTitleKey] = nativeAd.title;
                asset[kATNativeADAssetsMainTextKey] = nativeAd.desc;
                asset[kATNativeADAssetsCTATextKey] = nativeAd.ctaText;
                asset[kATNativeADAssetsIconURLKey] = nativeAd.iconImageURL;
                asset[kATNativeADAssetsLogoSetKey] = @{@"adChoiceView":nativeAd.adChoiceView};
                asset[kATAdAssetsCustomEventKey] = self.nativeEvent;
            }
            [self.nativeEvent trackNativeAdLoaded:@[asset]];
        }
        [[CartyTopOnC2SManager sharedInstance] removeEvent:pid];
        return;
    }
    self.nativeEvent = [[CartyTopOnNativeEvent alloc] initWithInfo:serverInfo localInfo:localInfo];
    self.nativeEvent.requestCompletionBlock = completion;
    if(pid == nil)
    {
        NSError *error = [NSError errorWithDomain:@"CartyTopOnAdapter" code:400 userInfo:@{NSLocalizedDescriptionKey:@"not pid"}];
        [self.nativeEvent trackNativeAdLoadFailed:error];
        return;
    }
    self.nativeAd = [[CTNativeAd alloc] init];
    self.nativeAd.placementid = pid;
    self.nativeAd.delegate = self.nativeEvent;
    if([localInfo valueForKey:@"Carty_isMute"])
    {
        self.nativeAd.isMute = [localInfo[@"Carty_isMute"] boolValue];
    }
    [self.nativeAd loadAd];
}

+ (Class)rendererClass
{
    return [CartyTopOnNativeRenderer class];
}


@end
