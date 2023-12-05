//
//  WWhiteCardOrderListCell.h
//  PhoneWorld
//
//  Created by 王陈洁 on 2018/10/18.
//  Copyright © 2018年 xiyoukeji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WhiteCardListModel.h"

@interface WWhiteCardOrderListCell : UITableViewCell

@property(nonatomic, strong) UILabel *numLabel;
@property(nonatomic, strong) UILabel *applyNumLabel;
@property(nonatomic, strong) UILabel *agreeNumLabel;
@property(nonatomic, strong) UILabel *nameLabel;
@property(nonatomic, strong) UILabel *timeLabel;
@property(nonatomic, strong) UILabel *statusLabel;

@property(nonatomic, strong) WhiteCardListModel *model;

@end

