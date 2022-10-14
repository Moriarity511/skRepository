//
//  DetailViewController.h
//  SampleApp
//
//  Created by lizhifm on 2022/5/23.
//

#import <UIKit/UIKit.h>
#import "Mediator.h"

NS_ASSUME_NONNULL_BEGIN

/// 文章底层页
@interface DetailViewController : UIViewController<DetailViewControllerProtocol>

- (instancetype)initWithUrlString:(NSString *)urlString;

@end

NS_ASSUME_NONNULL_END
