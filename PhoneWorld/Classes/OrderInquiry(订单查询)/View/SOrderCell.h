//
//  SOrderCell.h
//  PhoneWorld
//
//  Created by 刘岑颖 on 2017/6/5.
//  Copyright © 2017年 xiyoukeji. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SOrderCell : UITableViewCell

@property (nonatomic) UILabel *timeLabel;
@property (nonatomic) UILabel *stateLabel;
//@property (nonatomic) UIView *lineView;
@property (nonatomic) UILabel *nameLabel;
@property (nonatomic) UILabel *phoneLabel;
@property (nonatomic) UIImageView *rightImageView;

@property (nonatomic) UILabel *resubmitLab;
@property (nonatomic) UIButton *resubmitbtn;

/// 已锁定状态下的重写按钮
@property (strong, nonatomic) UIButton *reWriteBtn;

@end
