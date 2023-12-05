//
//  BondModel.h
//  PhoneWorld
//
//  Created by 刘岑颖 on 2017/12/6.
//  Copyright © 2017年 xiyoukeji. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface BondModel : JSONModel

@property (nonatomic, strong) NSString *orderNo;
@property (nonatomic, strong) NSString *amount;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *model_description;

@end
