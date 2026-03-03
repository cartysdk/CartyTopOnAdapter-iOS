
#import "CartyTopOnNativeObject.h"

@implementation CartyTopOnNativeObject

- (void)registerClickableViews:(NSArray<UIView *> *)clickableViews withContainer:(UIView *)container registerArgument:(nullable ATNativeRegisterArgument *)registerArgument
{
    if(self.nativeAdRenderType == ATNativeAdRenderExpress)
    {
        self.templateView.frame = container.bounds;
    }
    [self.nativeAd registerContainer:container withClickableViews:clickableViews];
}


@end
