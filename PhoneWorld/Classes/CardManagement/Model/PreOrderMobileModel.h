//
//  PreOrderMobileModel.h
//  PhoneWorld
//
// Created by 黄振元 on 2019/4/24.
// Copyright © 2019 xiyoukeji. All rights reserved.
//
// @class PreOrderMobileModel
// @abstract 预订单的套餐详情Model
//

#import <JSONModel/JSONModel.h>
@class PreOrderMobilePackageModel;

@protocol PreOrderMobilePackageModel
@end


@interface PreOrderMobileModel : JSONModel

@property (copy, nonatomic) NSString *cityName;
@property (copy, nonatomic) NSString<Optional> *number;
// 网络制式名称
@property (copy, nonatomic) NSString *operatorName;
@property (copy, nonatomic) NSString *numberStatus;
// 预存金额
@property (copy, nonatomic) NSString *prestore;
// 套餐
@property (strong, nonatomic) NSArray <PreOrderMobilePackageModel *> *packages;

@end


@interface PreOrderMobilePackageModel : JSONModel

@property (copy, nonatomic) NSString *packageId;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *productDetails;

@end
