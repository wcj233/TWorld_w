//
//  PreOrderListModel.h
//  PhoneWorld
//
// Created by 黄振元 on 2019/4/25.
// Copyright © 2019 xiyoukeji. All rights reserved.
//
// @class PreOrderListModel
// @abstract 预订单列表VC的model
//

#import <JSONModel/JSONModel.h>


@interface PreOrderListModel : JSONModel

// 订单id
@property (copy, nonatomic) NSString *numberId;
// 姓名
@property (copy, nonatomic) NSString *customerName;
// 号码
@property (copy, nonatomic) NSString *number;
@property (copy, nonatomic) NSString *certificatesNo;
@property (copy, nonatomic) NSString *createDate;
@property (copy, nonatomic) NSString *orderStatusName;
@property (copy, nonatomic) NSString<Optional> *orderStatus;

@end
