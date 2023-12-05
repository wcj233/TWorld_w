//
//  RedBagFillInfoModel.m
//  PhoneWorld
//
//
// Created by 黄振元 on 2019/4/22.
// Copyright © 2019 xiyoukeji. All rights reserved.
//
// @class RedBagFillInfoModel
// @abstract 红包抽奖 补登记资料 页面上的model，只存放数据
//

#import "RedBagFillInfoModel.h"
// controllers

// views

// models

// others

@implementation RedBagFillInfoModel

#pragma mark - Override Methods


#pragma mark - Initial Methods


#pragma mark - Privater Methods


#pragma mark - Target Methods


#pragma mark - Public Methods

//+ (instancetype)modelWithName:(NSString *)name mobile:(NSString *)mobile identifyNumber:(NSString *)identifyNumber email:(NSString *)email provinceCity:(NSString *)provinceCity address:(NSString *)address {
//    RedBagFillInfoModel *model = [[RedBagFillInfoModel alloc] init];
//
//    model.name = name;
//    model.mobile = mobile;
//    model.identifyNumber = identifyNumber;
//    model.email = email;
//    model.provinceCity = provinceCity;
//    model.address = address;
//
//    return model;
//}

+ (instancetype)modelWithTitle:(NSString *)title placeholder:(NSString *)placeholder content:(NSString *)content {
    RedBagFillInfoModel *model = [[RedBagFillInfoModel alloc] init];
    
    model.title = title;
    model.placeholder = placeholder;
    model.content = content;
    
    return model;
}


#pragma mark - Notification Methods


#pragma mark - KVO Methods


#pragma mark - Getter Setter Methods


@end
