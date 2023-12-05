//
//  RedBagFillInfoModel.h
//  PhoneWorld
//
// Created by 黄振元 on 2019/4/22.
// Copyright © 2019 xiyoukeji. All rights reserved.
//
// @class RedBagFillInfoModel
// @abstract 红包抽奖 补登记资料 页面上的model，只存放数据
//

#import <Foundation/Foundation.h>


@interface RedBagFillInfoModel : NSObject

//@property (copy, nonatomic) NSString *name;
//@property (copy, nonatomic) NSString *mobile;
//@property (copy, nonatomic) NSString *identifyNumber;
//@property (copy, nonatomic) NSString *email;
//// 省市，直接拼接好
//@property (copy, nonatomic) NSString *provinceCity;
//@property (copy, nonatomic) NSString *address;
//
//+ (instancetype)modelWithName:(NSString *)name mobile:(NSString *)mobile identifyNumber:(NSString *)identifyNumber email:(NSString *)email provinceCity:(NSString *)provinceCity address:(NSString *)address;

@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *placeholder;
@property (copy, nonatomic) NSString *content;

+ (instancetype)modelWithTitle:(NSString *)title placeholder:(NSString *)placeholder content:(NSString *)content;

@end
