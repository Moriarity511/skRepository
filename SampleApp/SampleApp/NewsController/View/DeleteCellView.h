//
//  DeleteCellView.h
//  SampleApp
//
//  Created by lizhifm on 2022/5/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 删除Cell确认浮层
@interface DeleteCellView : UIView


/// 点击删除Cell确认浮层
/// @param point 点击的位置
/// @param clickBlock 点击后的操作
- (void)showDeleteViewFromPoint:(CGPoint)point clickBlock:(dispatch_block_t)clickBlock;

@end

NS_ASSUME_NONNULL_END
