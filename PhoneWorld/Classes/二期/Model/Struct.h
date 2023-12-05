//
//  Struct.h
//  PhoneWorld
//
//  Created by fym on 2018/7/20.
//  Copyright © 2018年 xiyoukeji. All rights reserved.
//

#import "Jastor.h"

@interface BillPeriodInfo : Jastor
@property(nonatomic,assign)int year;
@property(nonatomic,assign)int month;
@end

@interface BillItemInfo : Jastor
@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *value;

+ (NSArray *)arrayFromData:(NSArray *)data;
@end

@interface BillInfo : Jastor
@property(nonatomic,copy)NSString *accountName;
@property(nonatomic,copy)NSString *billingCycle;
@property(nonatomic,copy)NSString *costItem;
@property(nonatomic,copy)NSString *accountTel;
@property(nonatomic,copy)NSString *meal;
@property(nonatomic,retain)NSArray<BillItemInfo *> *others;
@property(nonatomic,retain)NSArray<BillItemInfo *> *basic;
@property(nonatomic,copy)NSString *sum;
@end

@interface ChildOrderInfo : Jastor
@property(nonatomic,copy)NSString *orderNo;
@property(nonatomic,copy)NSString *number;
@property(nonatomic,copy)NSString *acceptUser;
@property(nonatomic,copy)NSString *statusName;
@property(nonatomic,copy)NSString *startTime;

+ (NSArray *)arrayFromData:(NSArray *)data;
@end

@interface OrderFilterInfo : Jastor
@property(nonatomic,assign)int status;
@property(nonatomic,copy)NSString *mobile;
@property(nonatomic,copy)NSString *way;
@property(nonatomic,assign)int startTime;
@property(nonatomic,assign)int endTime;
@end

@interface ChildOrderDetail : Jastor
@property(nonatomic,copy)NSString *orderNo;
@property(nonatomic,copy)NSString *orderStatus;
@property(nonatomic,copy)NSString *authenticationType;
@property(nonatomic,copy)NSString *createDate;
@property(nonatomic,copy)NSString *cardType;
@property(nonatomic,copy)NSString *acceptUser;
@property(nonatomic,copy)NSString *acceptChannel;
@property(nonatomic,copy)NSString *number;
@property(nonatomic,copy)NSString *iccid;
@property(nonatomic,copy)NSString *operatorname;
@property(nonatomic,copy)NSString *network;
@property(nonatomic,copy)NSString *province;
@property(nonatomic,copy)NSString *city;
@property(nonatomic,copy)NSString *isLiang;
@property(nonatomic,copy)NSString *promotion;
@property(nonatomic,copy)NSString *packagename;
@property(nonatomic,copy)NSString *startName;
@property(nonatomic,copy)NSString *cancelInfo;
//@property(nonatomic,copy)NSString *acceptUser;
@property(nonatomic,copy)NSString *grade;
@property(nonatomic,copy)NSString *fatherONE;
@property(nonatomic,copy)NSString *fatherTwo;
@end

@interface BrokerageInfo : Jastor
@property(nonatomic,assign)int id;
@property(nonatomic,copy)NSString *openTime;
@property(nonatomic,copy)NSString *tel;
@property(nonatomic,copy)NSString *amount;
@property(nonatomic,copy)NSString *accountPeriod;

+ (NSArray *)arrayFromData:(NSArray *)data;
@end

@interface BrokerageDetail : Jastor
@property(nonatomic,copy)NSString *user;
@property(nonatomic,copy)NSString *openTime;
@property(nonatomic,copy)NSString *tel;
@property(nonatomic,copy)NSString *telStart;
@property(nonatomic,copy)NSString *subject;
@property(nonatomic,copy)NSString *amount;
@property(nonatomic,copy)NSString *year;
@property(nonatomic,copy)NSString *reason;
@property(nonatomic,copy)NSString *accountPeriod;
@property(nonatomic,copy)NSString *acceptanceTime;
@end


