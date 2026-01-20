
#import "CartyTopOnInitAdapter.h"
#import <CartySDK/CartySDK.h>

@implementation CartyTopOnInitAdapter

+ (void)setUserID:(NSString *)userID
{
    [CartyADSDK sharedInstance].userid = userID;
}

- (void)initWithInitArgument:(ATAdInitArgument *)adInitArgument
{
    NSString *appid = adInitArgument.serverContentDic[@"appid"];
    if([ATAPI sharedInstance].dataConsentSet != ATDataConsentSetUnknown)
    {
        [[CartyADSDK sharedInstance] setCOPPAStatus:([ATAPI sharedInstance].dataConsentSet == ATDataConsentSetPersonalized)];
    };
    [[CartyADSDK sharedInstance] setCOPPAStatus:[ATAppSettingManager sharedManager].complyWithCOPPA];
    [[CartyADSDK sharedInstance] setDoNotSell:![ATAppSettingManager sharedManager].complyWithCCPA];
    [[CartyADSDK sharedInstance] start:appid completion:^{
        [self notificationNetworkInitSuccess];
    }];
}

#pragma mark - version
- (nullable NSString *)sdkVersion
{
    return [CartyADSDK sdkVersion];
}

- (nullable NSString *)adapterVersion
{
    return @"1.0.0";
}
@end
