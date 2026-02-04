
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
