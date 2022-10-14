//
//  DeleteCellView.m
//  SampleApp
//
//  Created by lizhifm on 2022/5/24.
//

#import "DeleteCellView.h"

@interface DeleteCellView ()

@property(nonatomic, strong, readwrite) UIView * backgroundView;
@property(nonatomic, strong, readwrite) UIButton * deleteButton;
@property(nonatomic, copy, readwrite) dispatch_block_t deleteBlock; // Block为什么使用copy属性

@end


@implementation DeleteCellView

- (instancetype)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		[self addSubview:({
			_backgroundView = [[UIView alloc] initWithFrame:self.bounds];
			_backgroundView.backgroundColor = [UIColor blackColor];
			_backgroundView.alpha = 0.5;
			[_backgroundView addGestureRecognizer:({
				UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissDeleteView)];
				tapGesture;
			})];
			_backgroundView;
		})];

		[self addSubview:({
			_deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
			[_deleteButton addTarget:self action:@selector(_clickButton) forControlEvents:UIControlEventTouchUpInside];
			_deleteButton.backgroundColor = [UIColor blueColor];
			_deleteButton;
		})];
	}
	return self;
}

// 传入点击X按钮的位置以及点击蓝色大View后需要controller做的操作传入到block当中        // typedef void (^dispatch_block_t)(void);
- (void)showDeleteViewFromPoint:(CGPoint)point clickBlock:(dispatch_block_t)clickBlock {
	// 动画初始位置设置为点击位置
	_deleteButton.frame = CGRectMake(point.x, point.y, 0, 0);
	// 点击X时持有这个block
	// 将自己粘贴到window上
	[[UIApplication sharedApplication].keyWindow addSubview:self];

//    [UIView animateWithDuration:1 animations:^{
//        self.deleteButton.frame = CGRectMake((self.bounds.size.width - 200)/2, (self.bounds.size.height - 200)/2, 200, 200);
//    }];

	[UIView animateWithDuration:1 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
	         self.deleteButton.frame = CGRectMake((self.bounds.size.width - 200)/2, (self.bounds.size.height - 200)/2, 200, 200);
	 } completion:^(BOOL finished) {
	         NSLog(@"");
	 }];
}

- (void)dismissDeleteView {
	[self removeFromSuperview];
}

// 点击按钮时，在click事件中执行block
- (void)_clickButton {
	if (_deleteBlock) {
		_deleteBlock();
	}
	[self removeFromSuperview];
}

@end
