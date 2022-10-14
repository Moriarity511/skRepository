//
//  VideoPlayer.h
//  SampleApp
//
//  Created by lizhifm on 2022/6/3.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VideoPlayer : UIView

+ (VideoPlayer *)Player;

- (void)playVideoWithUrl:(NSString *)videoUrl attachView:(UIView *)attachView;

@end

NS_ASSUME_NONNULL_END
