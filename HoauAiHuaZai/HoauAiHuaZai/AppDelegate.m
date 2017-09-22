//
//  AppDelegate.m
//  HoauAiHuaZai
//
//  Created by 岳俊杰 on 2017/9/7.
//  Copyright © 2017年 Jack. All rights reserved.
//

#import "AppDelegate.h"
#import "DWLaunchScreen.h"
#import "ViewController.h"
#import "OrderViewController.h"
#import "AppDelegate+ToolsService.h"
@interface AppDelegate ()<DWLaunchScreenDelegate>
@property(nonatomic,strong) BMKMapManager* mapManager;
@end

@implementation AppDelegate




//导航设置
- (void)navStateType {
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName]];
    [[UINavigationBar appearance] setBackIndicatorImage:[UIImage imageNamed:@"back_arrowNew"]];
    [[UINavigationBar appearance] setBackIndicatorTransitionMaskImage:[UIImage imageNamed:@"back_arrowNew"]];
    [UINavigationBar appearance].barTintColor = [UIColor colorWithRed:98/255.0 green:175/255.0 blue:162/255.0 alpha:1];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[OrderViewController alloc]init]];
    
    self.window.backgroundColor = [UIColor whiteColor];
    
    [self.window makeKeyAndVisible];
    [self navStateType];
    //设置sdk的log等级，log保存在下面设置的工作路径中
    [IFlySetting setLogFile:LVL_ALL];
    
    //打开输出在console的log开关
    [IFlySetting showLogcat:YES];
    
    //设置sdk的工作路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [paths objectAtIndex:0];
    [IFlySetting setLogFilePath:cachePath];
    
    //创建语音配置,appid必须要传入，仅执行一次则可
    NSString *initString = [[NSString alloc] initWithFormat:@"appid=%@",APPID_VALUE];
    
    //所有服务启动前，需要确保执行createUtility
    [IFlySpeechUtility createUtility:initString];
    
    
    DWLaunchScreen *launch = [[DWLaunchScreen alloc] init];
    //设置消失耗时
    launch.deleteLength = 3.0f;
    launch.skipTimerHide = NO;
    //消失方式
    launch.disappearType = DWCrosscutting;
    //字体颜色
    launch.skipTitleColor = [UIColor whiteColor];
    //字体大小
    launch.skipFont = 12;
    //按钮背景颜色
    launch.skipBgColor = [UIColor grayColor];
    
    [launch dw_LaunchScreenContent:@"001.gif" window:self.window withError:^(NSError *error) {
        NSLog(@"%@", error);
    }];
#pragma mark+++百度地图
    [self loadBaiDuMap];
#pragma mark+++蒲公英SDK
    [self PGYAllocInit];
    return YES;
}
-(void)loadBaiDuMap
{
    // 要使用百度地图，请先启动BaiduMapManager
    if (!_mapManager) {
        _mapManager = [[BMKMapManager alloc]init];
    }
    // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
    BOOL ret = [_mapManager start:@"8n2QwQXfz2qiz1fAyFB62LO0hXXKDivi"  generalDelegate:nil];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}
- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
