//
//  WCJWorkSignViewController.h
//  PhoneWorld
//
//  Created by sheshe on 2021/1/11.
//  Copyright © 2021 xiyoukeji. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface WCJWorkSignViewController : BaseViewController

@property (nonatomic, assign) BOOL isCompare;
@property (nonatomic, strong) NSDictionary *loginInfoDic;//登录以后的用户信息

@end

NS_ASSUME_NONNULL_END
