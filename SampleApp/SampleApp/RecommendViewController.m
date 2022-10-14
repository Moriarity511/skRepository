//
//  RecommendViewController.m
//  SampleApp
//
//  Created by lizhifm on 2022/5/22.
//

#import "RecommendViewController.h"

@interface RecommendViewController () <UIScrollViewDelegate, UIGestureRecognizerDelegate>

@end

@implementation RecommendViewController

- (instancetype) init {
	if (self = [super init]) {
		self.tabBarItem.title = @"推荐";
		self.tabBarItem.image = [UIImage imageNamed:@"icon.bundle/like@2x.png"];
		self.tabBarItem.selectedImage = [UIImage imageNamed:@"icon.bundle/like_selected@2x.png"];
	}
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view.
	self.view.backgroundColor = [UIColor whiteColor];

	UIScrollView * scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
	scrollView.backgroundColor = [UIColor lightGrayColor];
	scrollView.contentSize = CGSizeMake(self.view.bounds.size.width * 5, self.view.bounds.size.height);
	scrollView.showsHorizontalScrollIndicator = NO;

	scrollView.delegate = self;

	NSArray * colorArray = @[[UIColor systemRedColor], [UIColor systemGreenColor], [UIColor systemYellowColor], [UIColor systemBlueColor], [UIColor systemPinkColor]];
	// 在scrollView上增加5个不同颜色的view
	for (int i=0; i<5; i++) {
		[scrollView addSubview:({
			UIView * view = [[UIView alloc] initWithFrame:CGRectMake(scrollView.bounds.size.width * i,
			                                                         0, scrollView.bounds.size.width, scrollView.bounds.size.height)];

            UIImage * image2x = [UIImage imageNamed:@"testScale"];
//            UIImage * image3x = [UIImage imageNamed:@"testScale"];

            [view addSubview:({
				UIView * view = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
				view.backgroundColor = [UIColor systemGreenColor];
				// 注册一个手势 并添加到view中
				UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewClick)];
				tapGesture.delegate = self;
				[view addGestureRecognizer:tapGesture];
				view;
			})];

			view.backgroundColor = [colorArray objectAtIndex:i];
			view;
		})];
	}
	// 设置YES之后，系统会自动处理offset  初始化的时候，页面会下移
	scrollView.pagingEnabled = YES; // 翻页效果
	// 不调整Inset 页面就不会在点击时上移
	scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;

	[self.view addSubview:scrollView];
}

// 通过Delegate重新设置是否执行当前的手势 方便用于更加复杂的业务场景
// 在view的某一区域相响应，某一区域不响应， 或者响应不同的T-A
// 将gesture添加到整个view 通过实现不同的协议，通过判断GestureRecgnizer中的属性，如点击的位置等，在一个完整的view上实现不同的响应
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
//    return NO;
	return YES;
}

- (void)viewClick {
	NSLog(@"viewClick");
    NSURL * url = [NSURL URLWithString:@"schemeApp://"];
    
    BOOL canOpenUrl = [[UIApplication sharedApplication] canOpenURL:url];
    
    [[UIApplication sharedApplication] openURL:url options:nil completionHandler:^(BOOL success) {
            NSLog(@"");
    }];
}

// 当scrollView进行任何滚动的时候，都会回调到Deledate当中
// 监听页面的滚动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    NSLog(@"scrollViewDidScroll - %f", scrollView.contentOffset.x);
}

// 开始拖拽
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
	NSLog(@"BeginDragging");
}

// 结束拖拽
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
	NSLog(@"EndDragging");
}

// 开始减速
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {

}
// 减速结束
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {

}



/*
 #pragma mark - Navigation

   // In a storyboard-based application, you will often want to do a little preparation before navigation
   - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
   }
 */

@end
