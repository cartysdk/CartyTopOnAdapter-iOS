
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
        self.bannerEvent = [[CartyTopOnBannerEvent alloc] initWithInfo:serverInfo localInfo:localInfo];
        self.bannerEvent.requestCompletionBlock = completion;
        NSString *pid = serverInfo[@"slot_id"];
        if(pid == nil)
        {
            NSError *error = [NSError errorWithDomain:@"CartyTopOnAdapter" code:400 userInfo:@{NSLocalizedDescriptionKey:@"not pid"}];
            [self.bannerEvent trackBannerAdLoadFailed:error];
            return;
        }
        self.bannerAd = [[CTBannerAd alloc] init];
        self.bannerAd.placementid = pid;
        self.bannerAd.delegate = self.bannerEvent;
        ATUnitGroupModel *unitGroupModel = serverInfo[kATAdapterCustomInfoUnitGroupModelKey];
        CGRect rect = CGRectZero;
        rect.size = unitGroupModel.adSize;
        self.bannerAd.frame = rect;
        if([localInfo valueForKey:@"Carty_isMute"])
        {
            self.bannerAd.isMute = [localInfo[@"Carty_isMute"] boolValue];
        }
        if([localInfo valueForKey:@"Carty_BannerSize"])
        {
            self.bannerAd.bannerSize = [localInfo[@"Carty_BannerSize"] integerValue];
        }
        [self.bannerAd loadAd];
    });
}

+ (BOOL)adReadyWithCustomObject:(id)customObject info:(NSDictionary *)info
{
    return customObject;
}

@end
