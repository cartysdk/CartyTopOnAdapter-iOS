
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
        [[CartyADSDK sharedInstance] setGDPRStatus:([ATAPI sharedInstance].dataConsentSet == ATDataConsentSetPersonalized)];
    };
    [[CartyADSDK sharedInstance] setCOPPAStatus:adInitArgument.complyWithCOPPA];
    [[CartyADSDK sharedInstance] setDoNotSell:!adInitArgument.complyWithCCPA];
    [CartyADSDK sharedInstance].mediation = @"TopOn";
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
