//
//  NormalTableViewCell.h
//  SampleApp
//
//  Created by lizhifm on 2022/5/22.
//

#import <UIKit/UIKit.h>

@class ListItem;
NS_ASSUME_NONNULL_BEGIN


// 自定义Delegate， 点击按钮时触发这个Delegate
/// 点击删除按钮
@protocol NormalTableViewCellDelegate <NSObject>

// 告诉Delegate点击的是哪个Cell，以及哪个Button
@optional - (void)tableViewCell:(UITableViewCell *)tableViewCell clickDelegateButton:(UIButton *)deleteButton;

@end


/// 新闻列表Cell
@interface NormalTableViewCell : UITableViewCell

// 指针delegate必须指向遵守了该协议的对象 否则报错
@property(nonatomic, weak, readwrite) id<NormalTableViewCellDelegate> delegate;

- (void)layoutTableViewCellWithItem:(ListItem *)item; //暴露该方法

@end

NS_ASSUME_NONNULL_END
