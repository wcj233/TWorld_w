//
//  PreOrderListModel.m
//  PhoneWorld
//
//
// Created by 黄振元 on 2019/4/25.
// Copyright © 2019 xiyoukeji. All rights reserved.
//
// @class PreOrderListModel
// @abstract 预订单列表VC的model
//

#import "PreOrderListModel.h"
// controllers

// views

// models

// others

@implementation PreOrderListModel

#pragma mark - Override Methods

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{
                                                                  @"numberId" : @"id"
                                                                  }];
}


#pragma mark - Initial Methods


#pragma mark - Privater Methods


#pragma mark - Target Methods


#pragma mark - Public Methods


#pragma mark - Notification Methods


#pragma mark - KVO Methods


#pragma mark - Getter Setter Methods


@end
