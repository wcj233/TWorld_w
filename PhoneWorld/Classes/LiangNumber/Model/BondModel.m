//
//  BondModel.m
//  PhoneWorld
//
//  Created by 刘岑颖 on 2017/12/6.
//  Copyright © 2017年 xiyoukeji. All rights reserved.
//

#import "BondModel.h"

@implementation BondModel

+ (JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"description":@"model_description"}];
}

@end
