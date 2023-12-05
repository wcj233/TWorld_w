//
//  PreOrderTBCell.h
//  PhoneWorld
//
//
// Created by 黄振元 on 2019/4/23.
// Copyright © 2019 xiyoukeji. All rights reserved.
//
// @class PreOrderTBCell
// @abstract 预订单的TBCell
//

#import <UIKit/UIKit.h>
#import "PreOrderListModel.h"

@interface PreOrderTBCell : UITableViewCell

@property (strong, nonatomic) PreOrderListModel *listModel;

@end
