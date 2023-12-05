//
//  LBookedModel.h
//  PhoneWorld
//
//  Created by 刘岑颖 on 2018/1/17.
//  Copyright © 2018年 xiyoukeji. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface LBookedModel : JSONModel

@property (nonatomic, strong) NSString *number;
@property (nonatomic, strong) NSString *prodOfferName;
@property (nonatomic, strong) NSString *prodOfferDesc;
@property (nonatomic, strong) NSString *orderStatusName;
@property (nonatomic, strong) NSString *createDate;

@end
