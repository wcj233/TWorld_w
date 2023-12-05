//
//  PreOrderTariffView.m
//  PhoneWorld
//
//
// Created by 黄振元 on 2019/4/24.
// Copyright © 2019 xiyoukeji. All rights reserved.
//
// @class PreOrderTariffView
// @abstract 预订单详情VC下的资费信息view
//

#import "PreOrderTariffView.h"
// controllers

// views

// models

// others


@interface PreOrderTariffView ()

@property (strong, nonatomic) NSString *preMoney;
@property (strong, nonatomic) NSString *activyPackage;
@property (strong, nonatomic) NSString *isGoodNumber;

@end


@implementation PreOrderTariffView

#pragma mark - Override Methods
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */


#pragma mark - Initial Methods


#pragma mark - Privater Methods

- (void)createUI {
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.trailing.mas_equalTo(self);
    }];
    
    UILabel *preMoneyLabel = [self createLabelWithText:self.preMoney];
    [bgView addSubview:preMoneyLabel];
    [preMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.mas_equalTo(15);
        make.height.mas_equalTo(22);
    }];
    
    UILabel *activyPackageLabel = [self createLabelWithText:self.activyPackage];
    activyPackageLabel.numberOfLines = 0;
    activyPackageLabel.textAlignment = NSTextAlignmentLeft;
    [bgView addSubview:activyPackageLabel];
    [activyPackageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(15);
        make.top.mas_equalTo(preMoneyLabel.mas_bottom).offset(8);
        make.trailing.mas_equalTo(-15);
    }];
    
    UILabel *goodNumberLabel = [self createLabelWithText:self.isGoodNumber];
    [bgView addSubview:goodNumberLabel];
    [goodNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(15);
        make.top.mas_equalTo(activyPackageLabel.mas_bottom).offset(8);
        make.bottom.mas_equalTo(bgView).offset(-15);
    }];
}

- (UILabel *)createLabelWithText:(NSString *)text {
    UILabel *titleLabel = [UILabel labelWithTitle:text color:kSetColor(@"333333") font:[UIFont systemFontOfSize:16]];
    return titleLabel;
}


#pragma mark - Target Methods


#pragma mark - Public Methods

- (instancetype)initWithPreMoney:(NSString *)preMoney activyPackage:(NSString *)activyPackage isGoodNumber:(NSString *)isGoodNumber {
    if (self = [super init]) {
        self.backgroundColor = kSetColor(@"FBFBFB");
        
        self.preMoney = preMoney;
        self.activyPackage = activyPackage;
        self.isGoodNumber = isGoodNumber;
        
        [self createUI];
    }
    return self;
}


#pragma mark - Notification Methods


#pragma mark - KVO Methods


#pragma mark - Getter Setter Methods


@end
