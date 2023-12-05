//
//  AgentNumberModel.h
//  PhoneWorld
//
//  Created by 刘岑颖 on 2017/5/19.
//  Copyright © 2017年 xiyoukeji. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface AgentNumberModel : JSONModel

@property (nonatomic) NSString<Optional> *ePreNo;//预开户单号
@property (nonatomic) NSString<Optional> *number;//手机号
@property (nonatomic) NSString<Optional> *amount;//金额
@property (nonatomic) NSString<Optional> *createdate;//预开户时间
@property (nonatomic) NSString<Optional> *agentOperator;//运营商
@property (nonatomic) NSString<Optional> *packageName;//套餐包
@property (nonatomic) NSString<Optional> *promotionName;//活动包

@end
