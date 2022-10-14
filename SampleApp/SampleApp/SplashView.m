//
//  SplashView.m
//  SampleApp
//
//  Created by lizhifm on 2022/7/30.
//

#import "SplashView.h"
#import "Screen.h"

@interface SplashView()

@property(nonatomic, strong, readwrite) UIButton * button;

@end

@implementation SplashView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.image = [UIImage imageNamed:@"icon.bundle/splash.png"];
        [self addSubview:({
            _button = [[UIButton alloc] initWithFrame:UIRect(330, 100, 60, 40)];
            _button.backgroundColor = [UIColor lightGrayColor];
            [_button setTitle:@"跳过" forState:UIControlStateNormal];
            [_button addTarget:self action:@selector(_removeSplashView) forControlEvents:UIControlEventTouchUpInside];
            _button;
        })];
    }
    self.userInteractionEnabled = YES;
    return self;
}

// MARK: -

- (void)_removeSplashView{
    [self removeFromSuperview];
}

@end
