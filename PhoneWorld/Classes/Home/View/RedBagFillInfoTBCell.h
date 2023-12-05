//
//  RedBagFillInfoTBCell.h
//  PhoneWorld
//
//
// Created by 黄振元 on 2019/4/22.
// Copyright © 2019 xiyoukeji. All rights reserved.
//
// @class RedBagFillInfoTBCell
// @abstract 红包抽奖 补登记资料 TBCell
//

#import <UIKit/UIKit.h>
@class RedBagFillInfoModel;

@interface RedBagFillInfoTBCell : UITableViewCell

@property (strong, nonatomic) UILabel *addressLabel;
@property (strong, nonatomic) UITextField *tf;
@property (strong, nonatomic) RedBagFillInfoModel *infoModel;

@property (nonatomic, copy) void(^changeTFTextBlock)(RedBagFillInfoTBCell *cell, NSString *str);

@end
