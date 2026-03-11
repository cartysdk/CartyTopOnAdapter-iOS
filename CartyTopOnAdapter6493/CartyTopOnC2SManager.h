//
//  CartyTopOnC2SManager.h
//  CartyTopOn
//
//  Created by GZTD-03-01959 on 2026/3/10.
//

#import <Foundation/Foundation.h>
#import <AnyThinkSDK/AnyThinkSDK.h>

NS_ASSUME_NONNULL_BEGIN

@interface CartyTopOnC2SManager : NSObject

+ (CartyTopOnC2SManager *)sharedInstance;
- (void)addEvent:(id)event placementid:(NSString *)placementid;
- (void)removeEvent:(NSString *)placementid;
- (ATAdCustomEvent *)getEvent:(NSString *)placementid;

@end

NS_ASSUME_NONNULL_END
