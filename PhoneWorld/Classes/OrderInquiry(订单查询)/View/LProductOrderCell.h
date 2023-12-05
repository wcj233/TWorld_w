//
//  LProductOrderCell.h
//  PhoneWorld
//
//  Created by 刘岑颖 on 2018/1/17.
//  Copyright © 2018年 xiyoukeji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBookedModel.h"
#import "RightsOrderListModel.h"

@interface LProductOrderCell : UITableViewCell

@property (nonatomic, strong) UILabel *numberLabel;
@property (nonatomic, strong) UILabel *stateLabel;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UILabel *desLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIImageView *rightArrowImageView;

@property (nonatomic, strong) LBookedModel *bookedModel;

@property (nonatomic, strong) RightsOrderListModel *rightsOrderListModel;

@end
