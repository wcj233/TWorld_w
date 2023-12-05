//
//  LTopUpVC.h
//  PhoneWorld
//
//  Created by 刘岑颖 on 17/2/27.
//  Copyright © 2017年 xiyoukeji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderTwoView.h"
#import "LOpenAccomplishCardVC.h"

@interface LTopUpVC : UIViewController

//界面
@property (nonatomic) OrderTwoView *orderView;

//查询结果
@property (nonatomic) NSMutableArray *orderModelsArray;

//查询条件
@property (nonatomic) NSArray *inquiryConditionArray;

@end
