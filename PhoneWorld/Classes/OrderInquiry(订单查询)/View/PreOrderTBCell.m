//
//  PreOrderTBCell.m
//  PhoneWorld
//
//
// Created by 黄振元 on 2019/4/23.
// Copyright © 2019 xiyoukeji. All rights reserved.
//
// @class PreOrderTBCell
// @abstract 预订单的TBCell
//

#import "PreOrderTBCell.h"
// controllers

// views

// models

// others

@interface PreOrderTBCell ()

@property (strong, nonatomic) UILabel *timeLabel;
@property (strong, nonatomic) UILabel *statusLabel;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *mobileLabel;

@end


@implementation PreOrderTBCell

#pragma mark - Override Methods
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self createUI];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

#pragma mark - Initial Methods

- (void)createUI {
    UILabel *timeLabel = [UILabel labelWithTitle:@"" color:kSetColor(@"999999") font:[UIFont systemFontOfSize:14]];
    [self.contentView addSubview:timeLabel];
    self.timeLabel = timeLabel;
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(15);
        make.top.mas_equalTo(9);
    }];
    
    // 状态
    UILabel *statusLabel = [UILabel labelWithTitle:@"" color:kSetColor(@"EC6C00") font:[UIFont systemFontOfSize:14]];
    [self.contentView addSubview:statusLabel];
    self.statusLabel = statusLabel;
    [statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(-15);
        make.centerY.mas_equalTo(timeLabel);
    }];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = kSetColor(@"EEEEEE");
    [self.contentView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(15);
        make.top.mas_equalTo(timeLabel.mas_bottom).offset(8);
        make.trailing.mas_equalTo(self.contentView);
        make.height.mas_equalTo(1);
    }];
    
    UILabel *nameLabel = [UILabel labelWithTitle:@"" color:kSetColor(@"333333") font:[UIFont systemFontOfSize:16]];
    [self.contentView addSubview:nameLabel];
    self.nameLabel = nameLabel;
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(15);
        make.top.mas_equalTo(lineView.mas_bottom).offset(8);
    }];
    
    UILabel *mobileLabel = [UILabel labelWithTitle:@"" color:kSetColor(@"666666") font:[UIFont systemFontOfSize:12]];
    [self.contentView addSubview:mobileLabel];
    self.mobileLabel = mobileLabel;
    [mobileLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(15);
        make.top.mas_equalTo(nameLabel.mas_bottom).offset(4);
    }];
    
    UIImageView *rightIcon = [[UIImageView alloc] init];
    rightIcon.image = kSetImage(@"RightIcon");
    [self.contentView addSubview:rightIcon];
    [rightIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(-15);
        make.top.mas_equalTo(lineView.mas_bottom).offset(20);
        make.size.mas_equalTo(CGSizeMake(8, 13));
    }];
    
    UIView *separatorView = [[UIView alloc] init];
    separatorView.backgroundColor = kSetColor(@"DDDDDD");
    [self.contentView addSubview:separatorView];
    [separatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.contentView);
        make.top.mas_equalTo(mobileLabel.mas_bottom).offset(3);
        make.height.mas_equalTo(1);
        make.bottom.mas_equalTo(self.contentView);
    }];
}


#pragma mark - Privater Methods


#pragma mark - Target Methods


#pragma mark - Public Methods


#pragma mark - Notification Methods


#pragma mark - KVO Methods


#pragma mark - Getter Setter Methods

- (void)setListModel:(PreOrderListModel *)listModel {
    _listModel = listModel;
    
    self.timeLabel.text = listModel.createDate;

//    if ([listModel.orderStatusName isEqualToString:@"待审核"]) {
//        self.statusLabel.textColor = kSetColor(@"EC6C00");
//        self.statusLabel.text = @"待审核";
//    } else if ([listModel.orderStatusName isEqualToString:@"审核通过"]) {
//        self.statusLabel.textColor = kSetColor(@"EC6C00");
//        self.statusLabel.text = @"预审通过";
//    } else if ([listModel.orderStatusName isEqualToString:@"审核不通过"]) {
//        self.statusLabel.textColor = kSetColor(@"FF2626");
//        self.statusLabel.text = @"预审不通过";
//    } else if ([listModel.orderStatusName isEqualToString:@"发货"]) {
//        self.statusLabel.textColor = kSetColor(@"EC6C00");
//        self.statusLabel.text = @"已发货";
//    } else if ([listModel.orderStatusName isEqualToString:@"取消订单"]) {
//        self.statusLabel.textColor = kSetColor(@"EC6C00");
//        self.statusLabel.text = @"已取消";
//    }
    
    self.statusLabel.text = listModel.orderStatusName;
    
    self.nameLabel.text = listModel.customerName;
    self.mobileLabel.text = listModel.number;
}


@end
