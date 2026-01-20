
#import "CartyTopOnNativeObject.h"

@implementation CartyTopOnNativeObject

- (void)registerClickableViews:(NSArray<UIView *> *)clickableViews withContainer:(UIView *)container registerArgument:(nullable ATNativeRegisterArgument *)registerArgument
{
    [self.nativeAd registerContainer:container withClickableViews:clickableViews];
}


@end
