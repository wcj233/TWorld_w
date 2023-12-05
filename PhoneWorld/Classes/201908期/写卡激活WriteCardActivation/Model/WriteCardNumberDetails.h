//
//  WriteCardNumberDetails.h
//  PhoneWorld
//
//  Created by Allen on 2019/8/28.
//  Copyright © 2019 xiyoukeji. All rights reserved.
//

#import <JSONModel/JSONModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface WriteCardNumberDetails : JSONModel

@property(nonatomic,strong)NSString<Optional> *number;
@property(nonatomic,strong)NSString<Optional> *numberStatus;
@property(nonatomic,strong)NSString<Optional> *numberStatusName;
@property(nonatomic,strong)NSString<Optional> *poolname;
@property(nonatomic,strong)NSString<Optional> *crmCode;
@property(nonatomic,strong)NSString<Optional> *crmUserName;
@property(nonatomic,strong)NSString<Optional> *liangType;
@property(nonatomic,strong)NSString<Optional> *isLiang;
@property(nonatomic,strong)NSString<Optional> *orderPrice;
@property(nonatomic,strong)NSString<Optional> *prestore;
@property(nonatomic,strong)NSString<Optional> *regFee;
@property(nonatomic,strong)NSString<Optional> *cycle;
@property(nonatomic,strong)NSString<Optional> *cityName;
@property(nonatomic,strong)NSString<Optional> *province;
@property(nonatomic,strong)NSString<Optional> *operatorname;
@property(nonatomic,strong)NSArray<Optional> *packages;

@end

NS_ASSUME_NONNULL_END
