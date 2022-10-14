//
//  Mediator.m
//  SampleApp
//
//  Created by lizhifm on 2022/8/6.
//

#import "Mediator.h"
#import "DetailViewController.h"

/**
 会导致Mediator依赖所有的类，并没有达到完全的解耦
 如何实现完全解耦？
 方式一：Target - Action
    Target - Action的精髓，采用OC中runtime和反射机制来实现了Target（UIViewController * controller）- Action的机制（performSelector:NSSelectorFromString(@"DetailViewController")）
 
    该模式的问题:
    1 采用字符串这种硬编码的模式，
    2 - (id)performSelector:(SEL)aSelector withObject:(id)object1 withObject:(id)object2; 传递的参数是有限制的,最多两个
    
    内部的优化方式：
    代码层面的优化：将每个相应的TargetA - Action这种形式相应的函数，变成detailViewController的一个扩展
    参数传递可以采用更复杂的方式，比如传入一个字典的方式
 
 
    当前模式的问题->业务逻辑还是写在Mediator当中的
    解决问题的方式：
        1、将业务逻辑分散到Mdeiator的扩展当中。比如底层页是一个组件，可以写一个Mediator的扩展，然后将和自己相关（组件）的业务逻辑都写到相关的扩展当中
        2、不使用Target - Action的方式，采用注册的方式，实现一些业务上的需求。就是URLScheme。
 
方式二：URL Scheme
    该种方法的问题：
    1、参数传递统一通过Dictionary，具体传递什么参数，调用方式完全不知道的，需要查询需要查阅注册的解析逻辑中哪些参数，才能作为一个合理的传值。
    2、通过openUrl的方式，是变相使用了App之间参数传递的UrlScheme的方式，对于内部的传递来说是没有必要的。
 
方式三：Protocol - Class
    增加了一个Protocol-Wrapper层。通过中间的中心化的Mediator生成对应的Class，根据Class对应的Protocol去生成对应的想要的类以及类的相关方法。
    这种方式相对来说解决一些硬编码的问题，但是这种方法只是增加了Protocol - Wrapper，然后增加了一部分的业务逻辑，其实还不如以上的两种方式简单方便。
 */

@implementation Mediator

// 通过mediator的中转获得底层页的Controller
+ (__kindof UIViewController*)detailViewControllerWithUrl:(NSString *)detailUrl {
//    DetailViewController * controller = [[DetailViewController alloc] initWithUrlString:detaukUrl];
    Class detailCls = NSClassFromString(@"DetailViewController"); // 通过字符串反射到Class
    UIViewController * controller = [[detailCls alloc] performSelector:NSSelectorFromString(@"DetailViewController") withObject:detailUrl];
    return controller;
}

#pragma mark -
+ (NSMutableDictionary *)mediatorCache {
    static NSMutableDictionary *cache;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cache = @{}.mutableCopy;
    });
    return cache;
}

+ (void)registerScheme:(NSString *)scheme processBlock:(MediatorProcessBlock)processBlock {
    if (scheme && processBlock) {
        [[[self class] mediatorCache] setObject:processBlock forKey:scheme];
    }
}

/*
 url可能带一些参数，需要特殊处理，这里简单的用url作k
 正常希望scheme作为k，存储block，并且解析url当中除了scheme以外的参数
 */
+ (void)openUrl:(NSString *)url params:(NSDictionary *)params {
    MediatorProcessBlock block = [[[self class] mediatorCache] objectForKey:url];
    if (block) {
        block(params);
    }
}

//不管是protocol-class还是url，都需要在Mediator中维护一个动态的对应关系表，这个表是可以动态下发的，以及做一些更加延伸的业务逻辑。
//整体上是注册protocol-class的对应关系，然后在第三方要使用的时候，通过暴露的protocol取到对应的class，然后让这个类执行protocol达到业务逻辑。
//对于底层页跳转来说，detailViewController相当于要隐藏的组件

+ (void)registerProtocol:(Protocol *)proto class:(Class)cls {
    if (proto && cls) {
        [[[self class] mediatorCache] setObject:cls forKey:NSStringFromProtocol(proto)];
    }
}

+ (Class)classForProtocol:proto {
    return [[[self class] mediatorCache] objectForKey:NSStringFromProtocol(proto)];
}

@end 
