
#import <Foundation/Foundation.h>
#import <CartySDK/CartySDK.h>

NS_ASSUME_NONNULL_BEGIN

@interface CartyTopOnAdapter : NSObject

+ (void)setUserID:(NSString *)userID;
+ (void)startWithAppID:(NSString *)appid;
@end

NS_ASSUME_NONNULL_END
