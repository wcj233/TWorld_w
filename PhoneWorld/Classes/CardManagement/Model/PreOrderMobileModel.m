//
//  PreOrderMobileModel.m
//  PhoneWorld
//
//
// Created by 黄振元 on 2019/4/24.
// Copyright © 2019 xiyoukeji. All rights reserved.
//
// @class PreOrderMobileModel
// @abstract 预订单的套餐详情Model
//

#import "PreOrderMobileModel.h"
// controllers

// views

// models

// others

@implementation PreOrderMobileModel

#pragma mark - Override Methods


#pragma mark - Initial Methods


#pragma mark - Privater Methods


#pragma mark - Target Methods


#pragma mark - Public Methods


#pragma mark - Notification Methods


#pragma mark - KVO Methods


#pragma mark - Getter Setter Methods


@end





@implementation PreOrderMobilePackageModel

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{
                                                                  @"packageId" : @"id"
                                                                  }];
}

@end
