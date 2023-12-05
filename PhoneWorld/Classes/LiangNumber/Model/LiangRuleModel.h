//
//  LiangRuleModel.h
//  PhoneWorld
//
//  Created by 刘岑颖 on 2017/5/16.
//  Copyright © 2017年 xiyoukeji. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface LiangRuleModel : JSONModel

@property (nonatomic) NSString<Optional> *createby;
@property (nonatomic) NSString<Optional> *createdate;
@property (nonatomic) NSString<Optional> *liangRuleId;
@property (nonatomic) NSString<Optional> *pageSize;
@property (nonatomic) NSString<Optional> *recordStatus;
@property (nonatomic) NSString<Optional> *ruleName;
@property (nonatomic) NSString<Optional> *ruleStatus;
@property (nonatomic) NSString<Optional> *startRow;
@property (nonatomic) NSString<Optional> *tips;
@property (nonatomic) NSString<Optional> *updateby;
@property (nonatomic) NSString<Optional> *updatedate;

@end
