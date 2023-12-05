//
//  Struct.m
//  PhoneWorld
//
//  Created by fym on 2018/7/20.
//  Copyright © 2018年 xiyoukeji. All rights reserved.
//

#import "Struct.h"

@implementation BillPeriodInfo
@end

@implementation BillItemInfo
+ (NSArray *)arrayFromData:(NSArray *)data {
    if ([data isKindOfClass:[NSArray class]]) {
        NSMutableArray* array = [NSMutableArray array];
        for (NSDictionary* dict in data) {
            [array addObject:[[self alloc] initWithDictionary:dict]];
        }
        return array;
    }
    return [NSArray array];
}
@end

@implementation BillInfo
-(id)initWithDictionary:(NSDictionary *)dictionary{
    self=[super initWithDictionary:dictionary];
    self.others=[BillItemInfo arrayFromData:[dictionary objectForKey:@"others"]];
    self.basic=[BillItemInfo arrayFromData:[dictionary objectForKey:@"basic"]];
    return self;
}
@end

@implementation ChildOrderInfo
+ (NSArray *)arrayFromData:(NSArray *)data {
    if ([data isKindOfClass:[NSArray class]]) {
        NSMutableArray* array = [NSMutableArray array];
        for (NSDictionary* dict in data) {
            [array addObject:[[self alloc] initWithDictionary:dict]];
        }
        return array;
    }
    return [NSArray array];
}
@end

@implementation OrderFilterInfo
@end

@implementation ChildOrderDetail
@end

@implementation BrokerageInfo
+ (NSArray *)arrayFromData:(NSArray *)data {
    if ([data isKindOfClass:[NSArray class]]) {
        NSMutableArray* array = [NSMutableArray array];
        for (NSDictionary* dict in data) {
            [array addObject:[[self alloc] initWithDictionary:dict]];
        }
        return array;
    }
    return [NSArray array];
}
@end

@implementation BrokerageDetail
@end
