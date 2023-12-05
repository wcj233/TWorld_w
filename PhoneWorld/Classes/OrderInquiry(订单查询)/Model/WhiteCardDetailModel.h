//
//  WhiteCardDetailModel.h
//  PhoneWorld
//
//  Created by 王陈洁 on 2018/11/7.
//  Copyright © 2018年 xiyoukeji. All rights reserved.
//

#import <JSONModel/JSONModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface WhiteCardDetailModel : JSONModel

@property(nonatomic, strong) NSString<Optional> *deliveryAddress;
@property(nonatomic, strong) NSNumber<Optional> *actualSum;
@property(nonatomic, strong) NSNumber<Optional> *applySum;
@property(nonatomic, strong) NSString<Optional> *orderNumber;
@property(nonatomic, strong) NSString<Optional> *createDate;
@property(nonatomic, strong) NSString<Optional> *auditStatusName;
@property(nonatomic, strong) NSString<Optional> *auditTime;
@property(nonatomic, strong) NSString<Optional> *tel;
@property(nonatomic, strong) NSString<Optional> *name;
@property(nonatomic, strong) NSString<Optional> *notAuditReasons;

@end

NS_ASSUME_NONNULL_END
