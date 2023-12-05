//
//  LiangRuleModel.m
//  PhoneWorld
//
//  Created by 刘岑颖 on 2017/5/16.
//  Copyright © 2017年 xiyoukeji. All rights reserved.
//

#import "LiangRuleModel.h"

@implementation LiangRuleModel

+ (JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"liangRuleId"}];
}

@end
