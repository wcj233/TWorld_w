//
//  WhiteCardListModel.m
//  PhoneWorld
//
//  Created by 王陈洁 on 2018/11/6.
//  Copyright © 2018年 xiyoukeji. All rights reserved.
//

#import "WhiteCardListModel.h"

@implementation WhiteCardListModel

+(JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"orderId":@"id"}];
}

@end
