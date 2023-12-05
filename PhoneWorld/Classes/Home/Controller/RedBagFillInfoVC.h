//
//  RedBagFillInfoVC.h
//  PhoneWorld
//
//
// Created by 黄振元 on 2019/4/22.
// Copyright © 2019 xiyoukeji. All rights reserved.
//
// @class RedBagFillInfoVC
// @abstract 红包抽奖 补登记资料 VC
//

typedef NS_ENUM(NSInteger, RedBagFillInfoVCType) {
    RedBagFillInfoVCTypeRegistration = 0,
    RedBagFillInfoVCTypeRealName
};

#import "BaseViewController.h"

@interface RedBagFillInfoVC : BaseViewController

- (instancetype )initWithForType:(RedBagFillInfoVCType)type isCompare:(BOOL)isCompare;

@end
