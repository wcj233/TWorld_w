//
//  AgentNumberModel.m
//  PhoneWorld
//
//  Created by 刘岑颖 on 2017/5/19.
//  Copyright © 2017年 xiyoukeji. All rights reserved.
//

#import "AgentNumberModel.h"

@implementation AgentNumberModel

+ (JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"operator":@"agentOperator"}];
}

@end
