//
//  DetailViewController.m
//  SampleApp
//
//  Created by lizhifm on 2022/5/23.
//

#import "DetailViewController.h"
#import <WebKit/WebKit.h>
#import "Screen.h"
#import "Mediator.h"


@interface DetailViewController ()<WKNavigationDelegate>
@property(nonatomic, strong, readwrite) WKWebView * webView;
@property(nonatomic, strong, readwrite) UIProgressView * progressView;
@property(nonatomic, copy, readwrite) NSString * articleUrl;
@end

@implementation DetailViewController

// 注册底层页push逻辑到Mediator当中
+ (void)load {
//    [Mediator registerScheme:@"detail://" processBlock:^(NSDictionary * _Nonnull params) {
//        NSString * url = (NSString *)[params objectForKey:@"url"];
//        UINavigationController * navigationController = (UINavigationController *)[params objectForKey:@"controller"];
//        DetailViewController * controller = [[DetailViewController alloc] initWithUrlString:url];
//        [navigationController pushViewController:controller animated:YES];
//    }];
    
    // 注册自己的类，和暴露给外部的protocol
    [Mediator registerProtocol:@protocol(DetailViewControllerProtocol) class:[self class]];
}

// 使用网页的url生成
- (__kindof UIViewController *)detailViewControllerWithUrl:(NSString *)detailUrl {
    return [[[self class] alloc] initWithUrlString:detailUrl];
}

- (void)dealloc {
    // 移除监听
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
}

// 生成时传入展示的url
- (instancetype)initWithUrlString:(NSString *)urlString {
    if (self = [super init]) {
        self.articleUrl = urlString;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:({
        // STATUSBARHEIGHT + 44， 44为navigationBar的高度
        self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, (STATUSBARHEIGHT + 44), self.view.frame.size.width, self.view.frame.size.height - (STATUSBARHEIGHT + 44))];
        self.webView.navigationDelegate = self;
        self.webView;
    })];
    
    
    [self.view addSubview:({
        self.progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 88, self.view.frame.size.width, 20)];
        self.progressView;
    })];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.articleUrl]]];
    // 通过监听属性来看WebView的加载进度 // options 属性变化通知条件 // 注册监听
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
}

// loadResquest之后，是否加载URL ，可以从navigation中取到加载的url
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    decisionHandler(WKNavigationActionPolicyAllow);
}

// 页面加载完成之后
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    NSLog(@"");
}

// 监听者接受函数
- (void)observeValueForKeyPath:(nullable NSString *)keyPath ofObject:(nullable id)object change:(nullable NSDictionary<NSKeyValueChangeKey, id> *)change context:(nullable void *)context{
    NSLog(@"");
    // 在断点中打印change可以查看进度变化（new的值）
    self.progressView.progress = self.webView.estimatedProgress;
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
