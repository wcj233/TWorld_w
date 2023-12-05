//
//  STopOrderDetailView.h
//  PhoneWorld
//
//  Created by 刘岑颖 on 2017/6/6.
//  Copyright © 2017年 xiyoukeji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RechargeListModel.h"

#import "RightsOrderListModel.h"

@interface STopOrderDetailView : UIView

- (instancetype)initWithFrame:(CGRect)frame andLeftTitlesArray:(NSArray *)titlesArray;

@property (nonatomic) NSMutableArray<UILabel *> *labelsArray;

@property (nonatomic) RechargeListModel *rechargeListModel;

@property (nonatomic, strong) RightsOrderListModel *rightsOrderListModel;

@end
