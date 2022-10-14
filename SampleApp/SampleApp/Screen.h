//
//  Screen.h
//  SampleApp
//
//  Created by lizhifm on 2022/6/5.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

// 传入设备的方向，返回是否为横屏或竖屏
// 判断是否为横屏 也可以通过UIDevice获取设备方向
#define IS_LANDSCAPE (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]))

#define SCREEN_WIDTH (IS_LANDSCAPE ? [[UIScreen mainScreen ] bounds].size.height : [[UIScreen mainScreen ] bounds].size.width)
#define SCREEN_HEIGHT (IS_LANDSCAPE ? [[UIScreen mainScreen ] bounds].size.width : [[UIScreen mainScreen ] bounds].size.height)

#define IS_IPHONE_X_XR_MAX (IS_IPHONE_X || IS_IPHONE_XR || IS_IPHONE_XMAX)

// 判断机型 通过屏幕的尺寸和scale判断屏幕机型
#define IS_IPHONE_X (SCREEN_WIDTH == [Screen sizeFor58Inch].width && SCREEN_HEIGHT == [Screen sizeFor58Inch].height)
#define IS_IPHONE_XR (SCREEN_WIDTH == [Screen sizeFor61Inch].width && SCREEN_HEIGHT == [Screen sizeFor61Inch].height && [UIScreen mainScreen].scale == 2)
#define IS_IPHONE_XMAX (SCREEN_WIDTH == [Screen sizeFor65Inch].width && SCREEN_HEIGHT == [Screen sizeFor65Inch].height && [UIScreen mainScreen].scale == 3)

#define STATUSBARHEIGHT (IS_IPHONE_X_XR_MAX ? 44 : 20)

#define UI(x) UIAdapter(x)
#define UIRect(x,y,width,height) UIRectAdapter(x,y,width,height)

// 写一个内联函数作为一个宏，使所有的尺寸都按比例的扩大和缩小。

static inline NSInteger UIAdapter (float x) {
    // 1 - 分机型 特定的比例
    
    // 2 - 屏幕宽度按比例适配
    CGFloat scale = 414 / SCREEN_WIDTH;
    return (NSInteger)x / scale;
}

static inline CGRect UIRectAdapter(x,y,width,height) {
    return CGRectMake(UIAdapter(x), UIAdapter(y), UIAdapter(width), UIAdapter(height));
}

@interface Screen : NSObject

// xs max
+ (CGSize)sizeFor65Inch;

// xr
+ (CGSize)sizeFor61Inch;

// x
+ (CGSize)sizeFor58Inch;

@end

NS_ASSUME_NONNULL_END
