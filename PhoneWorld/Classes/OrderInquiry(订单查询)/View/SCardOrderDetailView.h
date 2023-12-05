//
//  SCardOrderDetailView.h
//  PhoneWorld
//
//  Created by 刘岑颖 on 2017/6/5.
//  Copyright © 2017年 xiyoukeji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SShowImageView.h"
#import "InputView.h"
#import "SHeadTitleView.h"
#import "OrderDetailModel.h"
#import "CardTransferDetailModel.h"
#import "CardRepairDetailModel.h"
#import "SRepairCardShowImageView.h"
#import "CardTransferListModel.h"
#import "WriteCardNumberDetails.h"
#import "WriteCardOrderDetailsModel.h"

@interface SCardOrderDetailView : UIView <UIScrollViewDelegate>

- (instancetype)initWithFrame:(CGRect)frame andCardDetailType:(CardDetailType)type;

@property (nonatomic) UIView *headView;
@property (nonatomic) NSMutableArray<UIButton *> *titleButtons;//订单详情+资费信息+客户信息
@property (nonatomic) UIView *moveView;//黄色下标

@property (nonatomic) UIScrollView *contentView;

@property (nonatomic) UIScrollView *firstView;
@property (nonatomic) UIView *firstContentView;

@property (nonatomic) UIScrollView *secondView;
@property (nonatomic) UIView *secondContentView;

@property (nonatomic) UIScrollView *thirdView;
@property (nonatomic) UIView *thirdContentView;

@property (nonatomic) SShowImageView *recentCustomerView;//新用户
@property (nonatomic) SShowImageView *oldCustomerView;//老用户

//过户/补卡手机号列表
@property (nonatomic) SHeadTitleView *phoneHeadTitleView;
@property (nonatomic) NSMutableArray<InputView *> *phoneInputViewsArray;

//补卡证件信息
@property (nonatomic) SHeadTitleView *bukaHeadTitleView;
@property (nonatomic) SRepairCardShowImageView *repairShowView;

/*-------------数据------------------------*/

@property (nonatomic) OrderDetailModel *orderDetailModel;
@property (nonatomic) CardTransferDetailModel *cardTransferDetailModel;
@property (nonatomic) CardRepairDetailModel *cardRepairDetailModel;

@property(nonatomic,strong)WriteCardNumberDetails *writeCardDetailsModel;
//2019
@property (nonatomic, strong) WriteCardOrderDetailsModel *writeCardOrderDetailsModel;

@property (nonatomic) CardTransferListModel *cardTransferListModel;//上级页面传过来的列表数据（过户／补卡）

/// 写卡订单，是否为 被锁定 状态
@property (assign, nonatomic) BOOL stateIsLock;

@end
