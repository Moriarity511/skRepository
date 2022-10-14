//
//  SceneDelegate.m
//  SampleApp
//
//  Created by lizhifm on 2022/5/21.
//

#import "SceneDelegate.h"
#import "NewsViewController.h"
#import "VideoViewController.h"
#import "RecommendViewController.h"
#import "SplashView.h"
#import "StaticTest.h"
#import <MyFramework/FrameworkTest.h> // 动态库需要使用文件的引入方式

@interface SceneDelegate () <UITabBarControllerDelegate>

@end

@implementation SceneDelegate


- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
    // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
    // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
    // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
    
    // 手动创建window
    UIWindowScene * windowScene = (UIWindowScene*)scene;
    _window = [[UIWindow alloc] initWithFrame:windowScene.coordinateSpace.bounds];
    _window.backgroundColor = [UIColor whiteColor];
    _window.windowScene = windowScene;
    [_window setRootViewController:[[UIViewController alloc] init]];
    [_window makeKeyAndVisible];
    
    UITabBarController *tabbarController = [[UITabBarController alloc] init];
    tabbarController.tabBar.backgroundColor = [UIColor whiteColor];
    
    NewsViewController * newsViewController = [[NewsViewController alloc] init];
    newsViewController.tabBarItem.title = @"新闻";
    newsViewController.tabBarItem.image = [UIImage imageNamed:@"icon.bundle/page@2x.png"];
    newsViewController.tabBarItem.selectedImage = [UIImage imageNamed:@"icon.bundle/page_selected@2x.png"];
    
    VideoViewController *videoController = [[VideoViewController alloc] init];
    RecommendViewController *controller3 = [[RecommendViewController alloc] init];
    
    UIViewController *mineViewController = [[UIViewController alloc] init];
    mineViewController.view.backgroundColor = [UIColor greenColor];
    mineViewController.tabBarItem.title = @"我的";
    mineViewController.tabBarItem.image = [UIImage imageNamed:@"icon.bundle/home@2x.png"];
    
    // 将四个页面的 UIViewController 加入到 UITabBarController 之中
    [tabbarController setViewControllers: @[newsViewController, videoController, controller3, mineViewController]];
    
    // 表明要自定义执行的TabBar方法是在当前类中
    tabbarController.delegate = self;
    
    // navigation的根视图是TabBar，当点击矩形时，view会压入栈中，在tabbar之上，就会显示view  
    UINavigationController * navigationController1 = [[UINavigationController alloc] initWithRootViewController:tabbarController];
    
    
    
//    [tabbarController.view addSubview:({
//        UIView * playView = [[UIView alloc] initWithFrame:CGRectMake(0, 1000, self.window.frame.size.width, 150)];
//        playView.backgroundColor = [UIColor systemGreenColor];
//        playView;
//    })];
    
    
//    self.window.rootViewController = tabbarController;
    self.window.rootViewController = navigationController1;
    
    [self.window makeKeyAndVisible];
    
    [self.window addSubview:({
        SplashView * splashView = [[SplashView alloc] initWithFrame:self.window.bounds];
        splashView;
    })];
    
//    [[UIApplication sharedApplication].keyWindow addSubview:({
//        UIView * playView = [[UIView alloc] initWithFrame:CGRectMake(0, tabbarController.tabBar.frame.origin.y - tabbarController.tabBar.frame.size.height , self.window.frame.size.width, tabbarController.view.frame.size.height)];
//        playView.backgroundColor = [UIColor systemGreenColor];
//        playView;
//    })];
    
    // static
    [[StaticTest alloc] init];
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    NSLog(@"did select");
}

- (void)sceneDidDisconnect:(UIScene *)scene {
    // Called as the scene is being released by the system.
    // This occurs shortly after the scene enters the background, or when its session is discarded.
    // Release any resources associated with this scene that can be re-created the next time the scene connects.
    // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
}


- (void)sceneDidBecomeActive:(UIScene *)scene {
    // Called when the scene has moved from an inactive state to an active state.
    // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
}


- (void)sceneWillResignActive:(UIScene *)scene {
    // Called when the scene will move from an active state to an inactive state.
    // This may occur due to temporary interruptions (ex. an incoming phone call).
}


- (void)sceneWillEnterForeground:(UIScene *)scene {
    // Called as the scene transitions from the background to the foreground.
    // Use this method to undo the changes made on entering the background.
}


- (void)sceneDidEnterBackground:(UIScene *)scene {
    // Called as the scene transitions from the foreground to the background.
    // Use this method to save data, release shared resources, and store enough scene-specific state information
    // to restore the scene back to its current state.
}

// MARK: -

//- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options {
//    NSLog(url);
//    return YES;
//}

- (void)scene:(UIScene *)scene openURLContexts:(NSSet<UIOpenURLContext *> *)URLContexts {
    if (URLContexts.count <= 0) {
        return;
    }
    UIOpenURLContext * openUrlContenxt = [URLContexts anyObject];
    NSURL * url = openUrlContenxt.URL;
    NSLog(@"%@", url);
    // Test://111
}
@end
