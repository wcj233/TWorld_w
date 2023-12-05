//
//  AgentWriteAndChooseView.h
//  PhoneWorld
//
//  Created by 刘岑颖 on 2017/6/2.
//  Copyright © 2017年 xiyoukeji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PayWayView.h"

@interface AgentWriteAndChooseView : UIView<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) void(^AgentWriteAndChooseCallBack) (NSString *titleString, NSInteger row);

- (instancetype)initWithFrame:(CGRect)frame andLeftTitlesArray:(NSArray *)array andType:(NSString *)typeString;

@property (nonatomic) NSArray *leftTitlesArray;

@property (nonatomic) UITableView *contentTableView;

@property (nonatomic) UIButton *nextButton;

@property (nonatomic) UIButton *writeButton;

@property (nonatomic) NSMutableArray *dataArray;

@property (nonatomic) UIView *tableFooterView;
@property (nonatomic) PayWayView *alipayView;
@property (nonatomic) PayWayView *cashView;
@property (nonatomic) int payWay;//支付方式 0账户支付  1支付宝支付

@end
