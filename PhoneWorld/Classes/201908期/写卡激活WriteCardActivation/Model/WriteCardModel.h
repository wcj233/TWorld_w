//
//  WriteCardModel.h
//  PhoneWorld
//
//  Created by Allen on 2019/8/26.
//  Copyright © 2019 xiyoukeji. All rights reserved.
//

#import <JSONModel/JSONModel.h>
//写卡激活Model
NS_ASSUME_NONNULL_BEGIN

@interface WriteCardModel : JSONModel

@property(nonatomic,strong)NSString<Optional> *ePreNo;

@property(nonatomic,strong)NSString<Optional> *number;

@property(nonatomic,strong)NSNumber<Optional> *amount;

@property(nonatomic,strong)NSString<Optional> *createdate;

@property(nonatomic,strong)NSString<Optional> *state;

@property(nonatomic,strong)NSString<Optional> *promotionDesc;

@property(nonatomic,strong)NSString<Optional> *memo4;

@end

NS_ASSUME_NONNULL_END
