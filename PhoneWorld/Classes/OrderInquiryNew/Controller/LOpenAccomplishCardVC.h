//
//  LOpenAccomplishCardVC.h
//  PhoneWorld
//
//  Created by 刘岑颖 on 17/2/27.
//  Copyright © 2017年 xiyoukeji. All rights reserved.
//

#import "BaseViewController.h"
#import "OrderView.h"
#import "OrderListModel.h"

@interface LOpenAccomplishCardVC : BaseViewController

//界面
@property (nonatomic) OrderView *orderView;

//查询结果
@property (nonatomic) NSMutableArray *orderModelsArray;

//查询条件
@property (nonatomic) NSArray *inquiryConditionArray;

@end
