//
//  Mediator.h
//  SampleApp
//
//  Created by lizhifm on 2022/8/6.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol DetailViewControllerProtocol <NSObject>
- (__kindof UIViewController *)detailViewControllerWithUrl:(NSString *)detailUrl;
@end
// 在自己初始化load方式的时候，把自己类的class的protocol注册到Mediator中。

// 通过mediator的中转获得底层页的Controller
@interface Mediator : NSObject

// Target - Action
+ (__kindof UIViewController *)detailViewControllerWithUrl:(NSString *)detailUrl;

// urlScheme
/*对于Mediator来说是所有的业务逻辑都交由GTDetailViewController，这个需要解耦的类自己来处理，然后注册到Mediator当中。其他的类调用Mediator达到组件化之间的通信*/
typedef void(^MediatorProcessBlock)(NSDictionary * params); // 业务逻辑
+ (void)registerScheme:(NSString *)scheme processBlock:(MediatorProcessBlock)processBlock; // scheme用于标记指向到的Controller
+ (void)openUrl:(NSString *)url params:(NSDictionary *)params; // 调用者调用的方法

// protocol - Class
// protocol和urlScheme类似，需要在初始化的时候，将想要暴露的protocol注册到Mediator当中。
+ (void)registerProtocol:(Protocol *)proto class:(Class)cls;
+ (Class)classForProtocol:protocol;

@end

NS_ASSUME_NONNULL_END
