//
//  PreOrderInfoView.h
//  PhoneWorld
//
//
// Created by 黄振元 on 2019/4/23.
// Copyright © 2019 xiyoukeji. All rights reserved.
//
// @class PreOrderInfoView
// @abstract 预订单详情VC下的 订单信息view
//

#import <UIKit/UIKit.h>

typedef void(^DeliveryBlock)();
typedef void(^CancelBlock)();

@interface PreOrderInfoView : UIView

// 发货按钮
@property (strong, nonatomic) UIButton *deliveryBtn;
// 取消按钮
@property (strong, nonatomic) UIButton *cancelBtn;

@property (copy, nonatomic) DeliveryBlock deliveryBlock;

@property (copy, nonatomic) CancelBlock cancelBlock;

- (instancetype)initWithOrderNumber:(NSString *)orderNumber orderTime:(NSString *)orderTime orderType:(NSString *)orderType mobile:(NSString *)mobile checkTime:(NSString *)checkTime orderStatusName:(NSString *)orderStatusName orderStatusCode:(NSString *)orderStatusCode cancelResult:(NSString *)cancelResult;

@end
