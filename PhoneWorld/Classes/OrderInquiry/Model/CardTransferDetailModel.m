//
//  CardTransferDetailModel.m
//  PhoneWorld
//
//  Created by 刘岑颖 on 16/11/3.
//  Copyright © 2016年 xiyoukeji. All rights reserved.
//

#import "CardTransferDetailModel.h"

@implementation CardTransferDetailModel

+ (JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"description":@"model_description"}];
}

@end
