
#import "CartyTopOnAdapter.h"
#import <AnyThinkSDK/AnyThinkSDK.h>

@implementation CartyTopOnAdapter

+ (void)setUserID:(NSString *)userID
{
    [CartyADSDK sharedInstance].userid = userID;
}

+ (void)startWithAppID:(NSString *)appid
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if([ATAPI sharedInstance].dataConsentSet != ATDataConsentSetUnknown)
        {
            [[CartyADSDK sharedInstance] setCOPPAStatus:([ATAPI sharedInstance].dataConsentSet == ATDataConsentSetPersonalized)];
        };
        [[CartyADSDK sharedInstance] setCOPPAStatus:[ATAppSettingManager sharedManager].complyWithCOPPA];
        [[CartyADSDK sharedInstance] setDoNotSell:![ATAppSettingManager sharedManager].complyWithCCPA];
        [[CartyADSDK sharedInstance] start:appid completion:^{
            
        }];
    });
}

@end
