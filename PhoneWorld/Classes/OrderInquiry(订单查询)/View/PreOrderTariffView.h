//
//  PreOrderTariffView.h
//  PhoneWorld
//
//
// Created by 黄振元 on 2019/4/24.
// Copyright © 2019 xiyoukeji. All rights reserved.
//
// @class PreOrderTariffView
// @abstract 预订单详情VC下的资费信息view
//

#import <UIKit/UIKit.h>

@interface PreOrderTariffView : UIView

- (instancetype)initWithPreMoney:(NSString *)preMoney activyPackage:(NSString *)activyPackage isGoodNumber:(NSString *)isGoodNumber;

@end
