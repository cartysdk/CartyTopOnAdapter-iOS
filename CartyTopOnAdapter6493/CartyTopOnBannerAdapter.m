
#import "CartyTopOnBannerAdapter.h"
#import "CartyTopOnBannerEvent.h"
#import "CartyTopOnAdapter.h"
#import <AnyThinkBanner/AnyThinkBanner.h>
#import <CartySDK/CartySDK.h>

@interface CartyTopOnBannerAdapter()

@property (nonatomic,strong)CartyTopOnBannerEvent *bannerEvent;
@property (nonatomic,strong)CTBannerAd *bannerAd;
@end

@implementation CartyTopOnBannerAdapter

+ (void)bidRequestWithPlacementModel:(ATPlacementModel *)placementModel unitGroupModel:(ATUnitGroupModel *)unitGroupModel info:(NSDictionary *)info completion:(void(^)(ATBidInfo *bidInfo, NSError *error))completion
{
    dispatch_async(dispatch_get_main_queue(), ^{
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
        CartyTopOnBannerEvent *cartyTopOnBannerEvent = [[CartyTopOnBannerEvent alloc] initWithInfo:info localInfo:info];
        CTBannerAd *bannerAd = [[CTBannerAd alloc] init];
        bannerAd.placementid = pid;
        bannerAd.delegate = cartyTopOnBannerEvent;
        cartyTopOnBannerEvent.isC2SBiding = YES;
        cartyTopOnBannerEvent.bidCompletion = completion;
        cartyTopOnBannerEvent.bidInfo =  [ATBidInfo bidInfoC2SWithPlacementID:placementModel.placementID unitGroupUnitID:unitGroupModel.unitID adapterClassString:unitGroupModel.adapterClassString price:@"0" currencyType:ATBiddingCurrencyTypeUS expirationInterval:unitGroupModel.bidTokenTime customObject:bannerAd];
        NSString *bannerSize = info[@"bannerSize"];
        if([bannerSize isKindOfClass:[NSString class]])
        {
            if([bannerSize isEqualToString:@"320x50"])
            {
                bannerAd.bannerSize = CTBannerSizeType320x50;
                bannerAd.frame = CGRectMake(0, 0, 320, 50);
            }
            else if([bannerSize isEqualToString:@"320x100"])
            {
                bannerAd.bannerSize = CTBannerSizeType320x100;
                bannerAd.frame = CGRectMake(0, 0, 320, 100);
            }
            else if([bannerSize isEqualToString:@"300x250"])
            {
                bannerAd.bannerSize = CTBannerSizeType300x250;
                bannerAd.frame = CGRectMake(0, 0, 300, 250);
            }
        }
        if([info valueForKey:@"Carty_isMute"])
        {
            bannerAd.isMute = [info[@"Carty_isMute"] boolValue];
        }
        if([info valueForKey:@"Carty_BannerSize"])
        {
            NSString *bannerSize = info[@"Carty_BannerSize"];
            if([bannerSize isKindOfClass:[NSString class]])
            {
                if([bannerSize isEqualToString:@"320x50"])
                {
                    bannerAd.bannerSize = CTBannerSizeType320x50;
                    bannerAd.frame = CGRectMake(0, 0, 320, 50);
                }
                else if([bannerSize isEqualToString:@"320x100"])
                {
                    bannerAd.bannerSize = CTBannerSizeType320x100;
                    bannerAd.frame = CGRectMake(0, 0, 320, 100);
                }
                else if([bannerSize isEqualToString:@"300x250"])
                {
                    bannerAd.bannerSize = CTBannerSizeType300x250;
                    bannerAd.frame = CGRectMake(0, 0, 300, 250);
                }
            }
        }
        [bannerAd loadAd];
        [[CartyTopOnC2SManager sharedInstance] addEvent:cartyTopOnBannerEvent placementid:pid];
    });
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
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *bidId = serverInfo[kATAdapterCustomInfoBuyeruIdKey];
        NSString *pid = serverInfo[@"slot_id"];
        if(bidId && pid)
        {
            ATAdCustomEvent *event = [[CartyTopOnC2SManager sharedInstance] getEvent:pid];
            if([event isKindOfClass:[CartyTopOnBannerEvent class]])
            {
                self.bannerEvent = (CartyTopOnBannerEvent *)event;
                self.bannerEvent.requestCompletionBlock = completion;
                [self.bannerEvent trackBannerAdLoaded:self.bannerEvent.bidInfo.customObject adExtra:nil];
            }
            [[CartyTopOnC2SManager sharedInstance] removeEvent:pid];
            return;
        }
        self.bannerEvent = [[CartyTopOnBannerEvent alloc] initWithInfo:serverInfo localInfo:localInfo];
        self.bannerEvent.requestCompletionBlock = completion;
        if(pid == nil)
        {
            NSError *error = [NSError errorWithDomain:@"CartyTopOnAdapter" code:400 userInfo:@{NSLocalizedDescriptionKey:@"not pid"}];
            [self.bannerEvent trackBannerAdLoadFailed:error];
            return;
        }
        self.bannerAd = [[CTBannerAd alloc] init];
        self.bannerAd.placementid = pid;
        self.bannerAd.delegate = self.bannerEvent;
        NSString *bannerSize = serverInfo[@"bannerSize"];
        if([bannerSize isKindOfClass:[NSString class]])
        {
            if([bannerSize isEqualToString:@"320x50"])
            {
                self.bannerAd.bannerSize = CTBannerSizeType320x50;
                self.bannerAd.frame = CGRectMake(0, 0, 320, 50);
            }
            else if([bannerSize isEqualToString:@"320x100"])
            {
                self.bannerAd.bannerSize = CTBannerSizeType320x100;
                self.bannerAd.frame = CGRectMake(0, 0, 320, 100);
            }
            else if([bannerSize isEqualToString:@"300x250"])
            {
                self.bannerAd.bannerSize = CTBannerSizeType300x250;
                self.bannerAd.frame = CGRectMake(0, 0, 300, 250);
            }
        }
        if([localInfo valueForKey:@"Carty_isMute"])
        {
            self.bannerAd.isMute = [localInfo[@"Carty_isMute"] boolValue];
        }
        if([localInfo valueForKey:@"Carty_BannerSize"])
        {
            NSString *bannerSize = localInfo[@"Carty_BannerSize"];
            if([bannerSize isKindOfClass:[NSString class]])
            {
                if([bannerSize isEqualToString:@"320x50"])
                {
                    self.bannerAd.bannerSize = CTBannerSizeType320x50;
                    self.bannerAd.frame = CGRectMake(0, 0, 320, 50);
                }
                else if([bannerSize isEqualToString:@"320x100"])
                {
                    self.bannerAd.bannerSize = CTBannerSizeType320x100;
                    self.bannerAd.frame = CGRectMake(0, 0, 320, 100);
                }
                else if([bannerSize isEqualToString:@"300x250"])
                {
                    self.bannerAd.bannerSize = CTBannerSizeType300x250;
                    self.bannerAd.frame = CGRectMake(0, 0, 300, 250);
                }
            }
        }
        [self.bannerAd loadAd];
    });
}

+ (BOOL)adReadyWithCustomObject:(id)customObject info:(NSDictionary *)info
{
    return customObject;
}

@end
