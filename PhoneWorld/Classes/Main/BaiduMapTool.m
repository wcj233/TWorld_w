//
//  BaiduMapTool.m
//  PhoneWorld
//
//  Created by 黄振元 on 2020/9/14.
//  Copyright © 2020 xiyoukeji. All rights reserved.
//

#import "BaiduMapTool.h"
#import "LoginNaviViewController.h"
#import "LoginNewViewController.h"

static BaiduMapTool *_instance = nil;


@interface BaiduMapTool () <BMKLocationManagerDelegate>

@property (strong, nonatomic) BMKLocationManager *locationManager;

@end


@implementation BaiduMapTool

+ (instancetype)sharedInstance {
    //    // 注意：这里建议使用self,而不是直接使用类名Tools（考虑继承）
    //    return [[self alloc] init];
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
        [_instance configData];
    });
    return _instance;
}

// 重写以下方法，是为了让单例创建只能通过 sharedInstance 来创建。
+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

// 重写以下方法，是为了让单例创建只能通过 sharedInstance 来创建。
- (id)copy {
    return _instance;
}

// 重写以下方法，是为了让单例创建只能通过 sharedInstance 来创建。
- (id)mutableCopy {
    return _instance;
}

- (void)configData {
    self.locationManager = [[BMKLocationManager alloc] init];
    //设置delegate
    self.locationManager.delegate = self;
    //设置返回位置的坐标系类型
    self.locationManager.coordinateType = BMKLocationCoordinateTypeBMK09LL;
    //设置距离过滤参数
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    //设置预期精度参数
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    //设置应用位置类型
    self.locationManager.activityType = CLActivityTypeAutomotiveNavigation;
    //设置是否自动停止位置更新
    self.locationManager.pausesLocationUpdatesAutomatically = YES;
    //设置是否允许后台定位
    //_locationManager.allowsBackgroundLocationUpdates = YES;
    //设置位置获取超时时间
    self.locationManager.locationTimeout = 10;
    //设置获取地址信息超时时间
    self.locationManager.reGeocodeTimeout = 10;
}

-(void)checkLocationPermissionWithResultBlock:(CheckLocationPermissionBlock)checkBlock {
    //定位服务是否可用
    BOOL enable = [CLLocationManager locationServicesEnabled];
    //是否具有定位权限
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    
    if (status == kCLAuthorizationStatusNotDetermined || status == kCLAuthorizationStatusDenied) {
        // 在这里做提示 去开启的操作
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"开户工号需在工号注册地使用，请先开启定位权限" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *goAction = [UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if ([[UIApplication sharedApplication]canOpenURL:url]) {
                [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
            }
        }];
        UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            if ([[BaiduMapTool getCurrentVC] isKindOfClass:[LoginNewViewController class]]) {
                return;
            } else {
                [self logoutAction];
            }
        }];
        [alertVC addAction:cancelAction];
        [alertVC addAction:goAction];
        [[BaiduMapTool getCurrentVC] presentViewController:alertVC animated:true completion:nil];
        checkBlock(NO);
    } else if (enable && (status == kCLAuthorizationStatusAuthorizedAlways || status == kCLAuthorizationStatusAuthorizedWhenInUse)) {
        checkBlock(YES);
    } else {
        checkBlock(NO);
    }
}

-(void)workSignRequestOnceLocationWithSuccessBlock:(WCJLocationSuccessBlock)successBlock withErrorBlock:(LocationErrorBlock)errorBlock{
    // 一次定位
    [self.locationManager requestLocationWithReGeocode:true withNetworkState:true completionBlock:^(BMKLocation * _Nullable location, BMKLocationNetworkState state, NSError * _Nullable error) {
        if (error) {
            NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
            if (errorBlock != nil) {
                errorBlock(error);
            }
            return;
        }
        if (location) {
            //得到定位信息，添加annotation
            
            
            CLGeocoder *geocoder = [[CLGeocoder alloc] init];
                [geocoder reverseGeocodeLocation: location.location completionHandler:^(NSArray *array, NSError *error) {

                    if (array.count > 0) {
                        CLPlacemark *placemark = [array objectAtIndex:0];

                        if (placemark != nil) {

                            successBlock(placemark);

                        }

                    }

                }];
        }
            
            
//            if (location.location) {
//                NSLog(@"LOC = %@",location.location);
//            }
//            if (location.rgcData) {
//                NSLog(@"rgc = %@",[location.rgcData description]);
//                NSString *provinceName = location.rgcData.province;
//                NSString *cityName = location.rgcData.city;
                
//                if ([provinceName hasSuffix:@"省"]) {
//                    provinceName = [provinceName substringToIndex:provinceName.length - 1];
//                }
//                if ([cityName hasSuffix:@"市"]) {
//                    cityName = [cityName substringToIndex:cityName.length - 1];
//                }
                
//                __block NSString *resultProvinceCode = @"";
//                __block NSString *resultCityCode = @"";
//                NSDictionary *areaDic = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"address_20200915" ofType:@"plist"]];
//                NSArray *provinceArray = [NSArray arrayWithArray:areaDic[@"area"][@"province"]];
//                [provinceArray enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull provinceDic, NSUInteger idx, BOOL * _Nonnull stop) {
//                    if ([provinceDic[@"p_name"] isEqualToString:provinceName]) {
//                        [provinceDic[@"p_city"] enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull cityDic, NSUInteger idy, BOOL * _Nonnull subStop) {
//                            if ([cityDic[@"c_name"] isEqualToString:cityName]) {
//                                resultProvinceCode = provinceDic[@"p_id"];
//                                resultCityCode = cityDic[@"c_id"];
//                                *stop = true;
//                                *subStop = true;
//                                return;
//                            }
//                        }];
//                    }
//                }];
                
//                if (successBlock != nil) {
////                    successBlock(resultProvinceCode, resultCityCode);
//                    successBlock(provinceName, cityName);
//                }
    }];
}

- (void)requestOnceLocationWithSuccessBlock:(LocationSuccessBlock)successBlock withErrorBlock:(LocationErrorBlock)errorBlock {
    // 一次定位
    [self.locationManager requestLocationWithReGeocode:true withNetworkState:true completionBlock:^(BMKLocation * _Nullable location, BMKLocationNetworkState state, NSError * _Nullable error) {
        if (error) {
            NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
            if (errorBlock != nil) {
                errorBlock(error);
            }
            return;
        }
        if (location) {
            //得到定位信息，添加annotation
            if (location.location) {
                NSLog(@"LOC = %@",location.location);
            }
            if (location.rgcData) {
                NSLog(@"rgc = %@",[location.rgcData description]);
                NSString *provinceName = location.rgcData.province;
                NSString *cityName = location.rgcData.city;
                
//                if ([provinceName hasSuffix:@"省"]) {
//                    provinceName = [provinceName substringToIndex:provinceName.length - 1];
//                }
//                if ([cityName hasSuffix:@"市"]) {
//                    cityName = [cityName substringToIndex:cityName.length - 1];
//                }
                
//                __block NSString *resultProvinceCode = @"";
//                __block NSString *resultCityCode = @"";
//                NSDictionary *areaDic = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"address_20200915" ofType:@"plist"]];
//                NSArray *provinceArray = [NSArray arrayWithArray:areaDic[@"area"][@"province"]];
//                [provinceArray enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull provinceDic, NSUInteger idx, BOOL * _Nonnull stop) {
//                    if ([provinceDic[@"p_name"] isEqualToString:provinceName]) {
//                        [provinceDic[@"p_city"] enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull cityDic, NSUInteger idy, BOOL * _Nonnull subStop) {
//                            if ([cityDic[@"c_name"] isEqualToString:cityName]) {
//                                resultProvinceCode = provinceDic[@"p_id"];
//                                resultCityCode = cityDic[@"c_id"];
//                                *stop = true;
//                                *subStop = true;
//                                return;
//                            }
//                        }];
//                    }
//                }];
                
                if (successBlock != nil) {
//                    successBlock(resultProvinceCode, resultCityCode);
                    successBlock(provinceName, cityName);
                }
            }
        }
    }];
}

// 上传定位信息
- (void)uploadLocationInfoWithSuccessBlock:(UploadLocationInfoSuccessBlock)successBlock failBlock:(UploadLocationInfoFailBlock)failBlock {
    NSLog(@"请求一次定位信息");
    @WeakObj(self)
    [self requestOnceLocationWithSuccessBlock:^(NSString * _Nonnull provinceCode, NSString * _Nonnull cityCode) {
        @StrongObj(self)
#if DEBUG
//        provinceCode = @"88";
//        cityCode = @"19";
#endif
        @WeakObj(self)
        NSString *province = provinceCode;
        NSString *city = cityCode;
        if ([provinceCode isEqualToString:city]) {//直辖市
            province = [city componentsSeparatedByString:@"市"].firstObject;
            city = province;
        }else{//不是直辖市--要去掉省--除了自治区
            if ([provinceCode containsString:@"省"]) {
                province = [provinceCode componentsSeparatedByString:@"省"].firstObject;
            }else{
                
            }
            city = [cityCode componentsSeparatedByString:@"市"].firstObject;
        }
        [WebUtils agency_judgeLocation:@{@"provinceCode": province, @"cityCode": city} andCallback:^(id obj) {
            @StrongObj(self)
            NSLog(@"上传定位信息");
            if ([obj[@"code"] isEqualToString:@"10000"]) {
                if ([obj[@"data"][@"judgeLocation"] boolValue] == true) {
                    if (successBlock != nil) {
                        successBlock();
                    }
                } else {
                    if (failBlock != nil) {
                        failBlock();
                    }
                    
                    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"用户未在常用地使用" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *goAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        // 退出登录
                        [self logoutAction];
                    }];
                    [alertVC addAction:goAction];
                    [[BaiduMapTool getCurrentVC] presentViewController:alertVC animated:true completion:nil];
                }
            }
        }];
    } withErrorBlock:^(NSError * _Nonnull error) {
        
    }];
}

- (void)logoutAction {
    // 执行退出登录
    [WebUtils requestLogoutResultWithCallBack:^(id obj) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            if ([obj[@"code"] isEqualToString:@"10000"]) {
                NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
                [ud removeObjectForKey:@"session_token"];
                [ud removeObjectForKey:@"grade"];
                [ud removeObjectForKey:@"hasPayPassword"];
                [ud synchronize];
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
                    keyWindow.rootViewController = [[LoginNaviViewController alloc] initWithRootViewController:[LoginNewViewController new]];
                });
            }
        }
    }];
}

+ (UIViewController *)getCurrentVC {
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal){
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows){
            if (tmpWin.windowLevel == UIWindowLevelNormal){
                window = tmpWin;
                break;
            }
        }
    }
    
    UIViewController *result = window.rootViewController;
    while (result.presentedViewController) {
        result = result.presentedViewController;
    }
    
    if ([result isKindOfClass:[UITabBarController class]]) {
        result = [(UITabBarController *)result selectedViewController];
    }
    
    if ([result isKindOfClass:[UINavigationController class]]) {
        result = [(UINavigationController *)result topViewController];
    }
    return result;
}

@end
