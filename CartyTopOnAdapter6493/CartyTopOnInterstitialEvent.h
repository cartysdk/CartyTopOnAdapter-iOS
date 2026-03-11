
#import <Foundation/Foundation.h>
#import <AnyThinkInterstitial/AnyThinkInterstitial.h>
#import <CartySDK/CartySDK.h>

NS_ASSUME_NONNULL_BEGIN

@interface CartyTopOnInterstitialEvent : ATInterstitialCustomEvent<CTInterstitialAdDelegate>

@property (nonatomic, copy)void(^bidCompletion)(ATBidInfo * _Nullable bidInfo, NSError * _Nullable error);
@property (nonatomic,strong)ATBidInfo *bidInfo;
@end

NS_ASSUME_NONNULL_END
