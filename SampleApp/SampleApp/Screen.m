//
//  Screen.m
//  SampleApp
//
//  Created by lizhifm on 2022/6/5.
//

#import "Screen.h"

@implementation Screen

// 作为工具类，需要提供类方法 // 类方法会方便书写宏和适配？
// xs max
+ (CGSize)sizeFor65Inch {
    return CGSizeMake(414, 896);
}

// xr
+ (CGSize)sizeFor61Inch {
    return CGSizeMake(414, 896);
}

// x
+ (CGSize)sizeFor58Inch {
    return CGSizeMake(375, 812);
}

@end
