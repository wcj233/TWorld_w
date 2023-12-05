//
//  PreOrderDetailModel.h
//  PhoneWorld
//
// Created by 黄振元 on 2019/4/25.
// Copyright © 2019 xiyoukeji. All rights reserved.
//
// @class PreOrderDetailModel
// @abstract 预订单详情信息的model
//

#import <JSONModel/JSONModel.h>


@interface PreOrderDetailModel : JSONModel

@property (copy, nonatomic) NSString *orderNo;
@property (copy, nonatomic) NSString *number;
@property (copy, nonatomic) NSString *customersName;
@property (copy, nonatomic) NSString *orderStatusName;
@property (copy, nonatomic) NSString *startTime;
@property (copy, nonatomic) NSString *packageName;
@property (copy, nonatomic) NSString *promotionName;
@property (copy, nonatomic) NSString *ICCID;
@property (copy, nonatomic) NSString *cardType;
@property (copy, nonatomic) NSString *authenticationType;
@property (copy, nonatomic) NSString *acceptUser;
@property (copy, nonatomic) NSString<Optional> *operatorName;
@property (copy, nonatomic) NSString *provinceName;
@property (copy, nonatomic) NSString *cityName;
@property (copy, nonatomic) NSString<Optional> *certificatesType;
@property (copy, nonatomic) NSString<Optional> *certificatesNo;
@property (copy, nonatomic) NSString<Optional> *customerName;
@property (copy, nonatomic) NSString<Optional> *address;
@property (copy, nonatomic) NSString<Optional> *cancelInfo;
@property (copy, nonatomic) NSString *prestore;
@property (copy, nonatomic) NSString *isLiang;
@property (copy, nonatomic) NSString *orderStatus;

@end
