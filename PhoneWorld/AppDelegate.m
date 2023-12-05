//
//  AppDelegate.m
//  PhoneWorld
//
//  Created by 刘岑颖 on 16/10/11.
//  Copyright © 2016年 xiyoukeji. All rights reserved.
//

#import "AppDelegate.h"
#import "MainTabBarController.h"
#import "LoginNewViewController.h"
#import "LoginNaviViewController.h"

#import "MainNavigationController.h"
#import <BMKLocationkit/BMKLocationComponent.h>
#import "BaiduMapTool.h"
#import "SearchLocationViewController.h"
#import <BaiduMapAPI_Map/BMKMapView.h>
#import "WhitePrepareOpenFourViewController.h"
#import <AipOcrSdk/AipOcrSdk.h>

@interface AppDelegate () <BMKLocationAuthDelegate,BMKGeneralDelegate>

@property (nonatomic) BMKMapManager *mapManager;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSNumber *signNum = [ud objectForKey:@"工号登记"];
    if (signNum==nil||signNum.intValue==0) {//没有工号登记
        [ud removeObjectForKey:@"session_token"];
        [ud removeObjectForKey:@"grade"];
        [ud removeObjectForKey:@"hasPayPassword"];
        if (signNum==nil) {
            [ud setObject:@(0) forKey:@"工号登记"];
        }
        [ud synchronize];
    }
    
    [self configBaiduMap];
    
    // 强制左右颠倒页面
//    [UIView appearance].semanticContentAttribute = UISemanticContentAttributeForceRightToLeft;
    
    
    /*--判断版本号--*/
    
    //初始化网络判断
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    //微信
    [WXApi registerApp:@"wxf52ad75c5c060b9e" withDescription:@"demo 2.0"];
    
    //键盘控件
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;//控制整个功能是否启用
    manager.enableAutoToolbar = NO;//控制是否显示键盘上的工具条
    manager.shouldResignOnTouchOutside = YES;//点击背景收回键盘
    
    if ([ud objectForKey:@"username"] && [ud objectForKey:@"session_token"]) {
        [self gotoHomeVC];
    } else {
        LoginNewViewController *newVC = [[LoginNewViewController alloc] init];
        self.window.rootViewController = [[LoginNaviViewController alloc] initWithRootViewController:newVC];
    }
    
    [self.window makeKeyAndVisible];
    
    [[AipOcrService shardService] authWithAK:@"Z54xkXZA2uQpCdGms2u5r8rS" andSK:@"u46hHzz0wqgIcPbFIGHxwmzWbUMWVQAi"];
    
    return YES;
}

- (void)configBaiduMap {
//    [[BMKLocationAuth sharedInstance] checkPermisionWithKey:@"zi9X5cGn6QgknOPzBoOKfVEjYzKuXtrg" authDelegate:self];
    [[BMKLocationAuth sharedInstance] checkPermisionWithKey:@"50TLiCeb2lUFaanLHcclu7X1svqzTxM3" authDelegate:self];
    //要使用百度地图，请先启动BMKMapManager
    _mapManager = [[BMKMapManager alloc] init];
    
    /**
     百度地图SDK所有API均支持百度坐标（BD09）和国测局坐标（GCJ02），用此方法设置您使用的坐标类型.
     默认是BD09（BMK_COORDTYPE_BD09LL）坐标.
     如果需要使用GCJ02坐标，需要设置CoordinateType为：BMK_COORDTYPE_COMMON.
     */
    if ([BMKMapManager setCoordinateTypeUsedInBaiduMapSDK:BMK_COORDTYPE_BD09LL]) {
        NSLog(@"经纬度类型设置成功");
    } else {
        NSLog(@"经纬度类型设置失败");
    }
    
    //启动引擎并设置AK并设置delegate
    BOOL result = [_mapManager start:@"50TLiCeb2lUFaanLHcclu7X1svqzTxM3" generalDelegate:self];
    if (!result) {
        NSLog(@"启动引擎失败");
    }
}

#pragma mark onGetPermissionState
-(void)onGetPermissionState:(int)iError{
    
}
-(void)onGetNetworkState:(int)iError{
    
}

- (void)gotoHomeVC{
    MainTabBarController *vc = [[MainTabBarController alloc] init];
    self.window.rootViewController = vc;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    return [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    return [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options{
    
    if ([url.host isEqualToString:@"safepay"]) {
        // 支付跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            self.payResult = NO;
            if ([resultDic[@"resultStatus"] isEqualToString:@"9000"]) {
                self.payResult = YES;
            }
            self.AppCallBack(self.payResult);
        }];
    }
    return YES;
}

#pragma mark - 百度定位SDK鉴权

/**
 *@brief 返回授权验证错误
 *@param iError 错误号 : 为0时验证通过，具体参加BMKLocationAuthErrorCode
 */
- (void)onCheckPermissionState:(BMKLocationAuthErrorCode)iError {
//    BMKLocationAuthErrorUnknown = -1,                    ///< 未知错误
//    BMKLocationAuthErrorSuccess = 0,           ///< 鉴权成功
//    BMKLocationAuthErrorNetworkFailed = 1,          ///< 因网络鉴权失败
//    BMKLocationAuthErrorFailed  = 2,               ///< KEY非法鉴权失败
    switch (iError) {
        case BMKLocationAuthErrorUnknown:
            NSLog(@"未知错误");
            break;
        case BMKLocationAuthErrorSuccess:
            NSLog(@"鉴权通过");
            break;
        case BMKLocationAuthErrorNetworkFailed:
            NSLog(@"因网络鉴权失败");
            break;
        case BMKLocationAuthErrorFailed:
            NSLog(@"KEY非法鉴权失败");
            break;
        default:
            break;
    }
}


#pragma mark - App生命周期

- (void)applicationWillResignActive:(UIApplication *)application {
    //点击home退出界面时（程序进入后台）进入
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    [WebUtils requestWithTouchTimes];//上传点击次数
    
    [ud removeObjectForKey:@"phoneRecharge"];
    [ud removeObjectForKey:@"accountRecharge"];
    [ud removeObjectForKey:@"transform"];
    [ud removeObjectForKey:@"renewOpen"];
    [ud removeObjectForKey:@"newOpen"];
    [ud removeObjectForKey:@"replace"];
    [ud removeObjectForKey:@"phoneBanlance"];
    [ud removeObjectForKey:@"accountRecord"];
    [ud removeObjectForKey:@"cardQuery"];
    [ud removeObjectForKey:@"orderQueryRenew"];
    [ud removeObjectForKey:@"orderQueryNew"];
    [ud removeObjectForKey:@"orderQueryTransform"];
    [ud removeObjectForKey:@"orderQueryReplace"];
    [ud removeObjectForKey:@"orderQueryRecharge"];
    [ud removeObjectForKey:@"qdsList"];
    [ud removeObjectForKey:@"qdsOrderList"];
    
    [ud synchronize];
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    //重新进入刷新
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setInteger:0 forKey:@"phoneRecharge"];
    [ud setInteger:0 forKey:@"accountRecharge"];
    [ud setInteger:0 forKey:@"transform"];
    [ud setInteger:0 forKey:@"renewOpen"];
    [ud setInteger:0 forKey:@"newOpen"];
    [ud setInteger:0 forKey:@"replace"];
    [ud setInteger:0 forKey:@"phoneBanlance"];
    [ud setInteger:0 forKey:@"accountRecord"];
    [ud setInteger:0 forKey:@"cardQuery"];
    [ud setInteger:0 forKey:@"orderQueryRenew"];
    [ud setInteger:0 forKey:@"orderQueryNew"];
    [ud setInteger:0 forKey:@"orderQueryTransform"];
    [ud setInteger:0 forKey:@"orderQueryReplace"];
    [ud setInteger:0 forKey:@"orderQueryRecharge"];
    [ud setInteger:0 forKey:@"qdsList"];
    [ud setInteger:0 forKey:@"qdsOrderList"];
    [ud synchronize];
    
    if ([ud objectForKey:@"username"] && [ud objectForKey:@"session_token"]) {
        // 保持着登录的，判断定位权限
        [[BaiduMapTool sharedInstance] checkLocationPermissionWithResultBlock:^(BOOL isOpen) {
            if (isOpen) {
                // 定位权限通过，则上传定位信息
                [[BaiduMapTool sharedInstance] uploadLocationInfoWithSuccessBlock:^{
                    
                } failBlock:^{
                    
                }];
            } else {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"StopCheckLocationNotificationName" object:nil];
            }
        }];
    }
}


- (void)applicationWillTerminate:(UIApplication *)application {
    
}


@end
