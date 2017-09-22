//
//  AppDelegate+ToolsService.m
//  HoauAiHuaZai
//
//  Created by 岳俊杰 on 2017/9/14.
//  Copyright © 2017年 Jack. All rights reserved.
//

#import "AppDelegate+ToolsService.h"
#import <PgySDK/PgyManager.h>
#import <PgyUpdate/PgyUpdateManager.h>
@implementation AppDelegate (ToolsService)
-(void)PGYAllocInit
{
    //启动基本SDK
    [[PgyManager sharedPgyManager] startManagerWithAppId:@"3eacfb0d2fa37cfa9289c474ff15a222"];
    //启动更新检查SDK
    [[PgyUpdateManager sharedPgyManager] startManagerWithAppId:@"3eacfb0d2fa37cfa9289c474ff15a222"];
    //开启或关闭用户手势反馈功能.
    [[PgyManager sharedPgyManager] setEnableFeedback:NO];
    //检查版本是否有更新
    [[PgyUpdateManager sharedPgyManager] checkUpdate];
}
@end
