//
//  BaiduMapTool.h
//  PhoneWorld
//
//  Created by 黄振元 on 2020/9/14.
//  Copyright © 2020 xiyoukeji. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BMKLocationKit/BMKLocationComponent.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^LocationSuccessBlock)(NSString *provinceCode, NSString *cityCode);
typedef void(^LocationErrorBlock)(NSError *error);
typedef void(^CheckLocationPermissionBlock)(BOOL isOpen);
typedef void(^UploadLocationInfoSuccessBlock)(void);
typedef void(^UploadLocationInfoFailBlock)(void);
typedef void(^WCJLocationSuccessBlock)(CLPlacemark *placemark);


/// 百度定位SDK工具类
@interface BaiduMapTool : NSObject

//@property (strong, nonatomic) BMKLocationManager *locationManager;

+ (instancetype)sharedInstance;

/// 判断定位选前
- (void)checkLocationPermissionWithResultBlock:(CheckLocationPermissionBlock)checkBlock;
/// 请求一次定位
- (void)requestOnceLocationWithSuccessBlock:(LocationSuccessBlock)successBlock withErrorBlock:(LocationErrorBlock)errorBlock;
/// 退出登录
- (void)logoutAction;
/// 上传定位信息
- (void)uploadLocationInfoWithSuccessBlock:(UploadLocationInfoSuccessBlock)successBlock failBlock:(UploadLocationInfoFailBlock)failBlock;
+ (UIViewController *)getCurrentVC;

//返回当前定位详细信息
- (void)workSignRequestOnceLocationWithSuccessBlock:(WCJLocationSuccessBlock)successBlock withErrorBlock:(LocationErrorBlock)errorBlock;

@end

NS_ASSUME_NONNULL_END
