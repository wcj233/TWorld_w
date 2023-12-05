//
//  PreOrderInfoView.m
//  PhoneWorld
//
//
// Created by 黄振元 on 2019/4/23.
// Copyright © 2019 xiyoukeji. All rights reserved.
//
// @class PreOrderInfoView
// @abstract 预订单详情VC下的 订单信息view
//

#import "PreOrderInfoView.h"
// controllers

// views

// models

// others


@interface PreOrderInfoView ()

@property (strong, nonatomic) NSString *orderNumber;
@property (strong, nonatomic) NSString *orderTime;
@property (strong, nonatomic) NSString *orderType;
@property (strong, nonatomic) NSString *mobile;
@property (strong, nonatomic) NSString *checkTime;
/// 订单状态（0 待审核/ 1 审核通过/ 2 审核不同过/ 3 发货/ 4 取消订单）
@property (strong, nonatomic) NSString *orderStatusName;
@property (strong, nonatomic) NSString *cancelResult;
@property (copy, nonatomic) NSString *orderStatusCode;

@end


@implementation PreOrderInfoView

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
    
    UILabel *orderNumberLabel = [self createLabelWithText:self.orderNumber];
    orderNumberLabel.numberOfLines = 0;
    orderNumberLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:orderNumberLabel];
    [orderNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.mas_equalTo(15);
        make.trailing.mas_equalTo(-15);
    }];
    
    UILabel *orderTimeLabel = [self createLabelWithText:self.orderTime];
    orderTimeLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:orderTimeLabel];
    [orderTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(15);
        make.top.mas_equalTo(orderNumberLabel.mas_bottom).offset(8);
        make.trailing.mas_equalTo(-15);
    }];
    
    UILabel *orderTypeLabel = [self createLabelWithText:self.orderType];
    orderTypeLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:orderTypeLabel];
    [orderTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(15);
        make.top.mas_equalTo(orderTimeLabel.mas_bottom).offset(8);
        make.trailing.mas_equalTo(-15);
    }];
    
    UILabel *mobileLabel = [self createLabelWithText:self.mobile];
    mobileLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:mobileLabel];
    [mobileLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(15);
        make.top.mas_equalTo(orderTypeLabel.mas_bottom).offset(8);
        make.trailing.mas_equalTo(-15);
    }];
    
    UILabel *checkTimeLabel = [self createLabelWithText:self.checkTime];
    checkTimeLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:checkTimeLabel];
    [checkTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(15);
        make.top.mas_equalTo(mobileLabel.mas_bottom).offset(8);
        make.trailing.mas_equalTo(-15);
    }];
    
    UILabel *orderStatusLabel = [self createLabelWithText:self.orderStatusName];
    orderStatusLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:orderStatusLabel];
    [orderStatusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(15);
        make.top.mas_equalTo(checkTimeLabel.mas_bottom).offset(8);
        make.trailing.mas_equalTo(-15);
    }];
    
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(orderStatusLabel.mas_bottom).offset(15);
    }];
    
    if (self.cancelResult.length > 0) {
        // 取消view
        
        UIView *cancelBgView = [[UIView alloc] init];
        cancelBgView.backgroundColor = [UIColor whiteColor];
        [self addSubview:cancelBgView];
        [cancelBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.mas_equalTo(self);
            make.top.mas_equalTo(bgView.mas_bottom).offset(20);
        }];
        
        UILabel *cancelTitleLabel = [UILabel labelWithTitle:@"取消原因：" color:kSetColor(@"333333") font:[UIFont systemFontOfSize:16]];
        [cancelBgView addSubview:cancelTitleLabel];
        [cancelTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.top.mas_equalTo(15);
        }];
        
        UILabel *cancelResultLabel = [UILabel labelWithTitle:self.cancelResult color:kSetColor(@"333333") font:[UIFont systemFontOfSize:16]];
        cancelResultLabel.numberOfLines = 0;
        cancelResultLabel.textAlignment = NSTextAlignmentLeft;
        [cancelBgView addSubview:cancelResultLabel];
        [cancelResultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(15);
            make.trailing.mas_equalTo(-15);
            make.top.mas_equalTo(cancelTitleLabel.mas_bottom).offset(10);
            make.bottom.mas_equalTo(cancelBgView).offset(-15);
        }];
    } else if (self.orderStatusCode.integerValue == 1) {
        // 审核通过等状态
        
        UIButton *deliveryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [deliveryBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [deliveryBtn setTitle:@"发货" forState:UIControlStateNormal];
        deliveryBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        deliveryBtn.layer.cornerRadius = 4;
        deliveryBtn.backgroundColor = kSetColor(@"EC6C00");
        [deliveryBtn addTarget:self action:@selector(deliveryBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:deliveryBtn];
        self.deliveryBtn = deliveryBtn;
        [deliveryBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(get6W(47));
            make.top.mas_equalTo(bgView.mas_bottom).offset(get6W(63));
            make.size.mas_equalTo(CGSizeMake(get6W(111), get6W(33)));
        }];
        
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn setTitleColor:kSetColor(@"999999") forState:UIControlStateNormal];
        cancelBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        cancelBtn.layer.cornerRadius = 4;
        cancelBtn.layer.borderWidth = 1;
        cancelBtn.layer.borderColor = kSetColor(@"979797").CGColor;
        cancelBtn.backgroundColor = kSetColor(@"FFFFFF");
        [cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cancelBtn];
        self.cancelBtn = cancelBtn;
        [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.mas_equalTo(get6W(-47));
            make.centerY.mas_equalTo(deliveryBtn);
            make.size.mas_equalTo(deliveryBtn);
        }];
    }
}

- (UILabel *)createLabelWithText:(NSString *)text {
    UILabel *titleLabel = [UILabel labelWithTitle:text color:kSetColor(@"333333") font:[UIFont systemFontOfSize:16]];
    return titleLabel;
}


#pragma mark - Target Methods

- (void)deliveryBtnClick {
    if (self.deliveryBlock) {
        self.deliveryBlock();
    }
}

- (void)cancelBtnClick {
    if (self.cancelBlock) {
        self.cancelBlock();
    }
}


#pragma mark - Public Methods

- (instancetype)initWithOrderNumber:(NSString *)orderNumber orderTime:(NSString *)orderTime orderType:(NSString *)orderType mobile:(NSString *)mobile checkTime:(NSString *)checkTime orderStatusName:(NSString *)orderStatusName orderStatusCode:(NSString *)orderStatusCode cancelResult:(NSString *)cancelResult {
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.orderNumber = orderNumber;
        self.orderTime = orderTime;
        self.orderType = orderType;
        self.mobile = mobile;
        self.checkTime = checkTime;
        self.orderStatusName = orderStatusName;
        self.cancelResult = cancelResult;
        self.orderStatusCode = orderStatusCode;
        
        [self createUI];
    }
    return self;
}


#pragma mark - Notification Methods


#pragma mark - KVO Methods


#pragma mark - Getter Setter Methods


@end
