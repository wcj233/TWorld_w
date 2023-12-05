//
//  BondView.h
//  PhoneWorld
//
//  Created by 刘岑颖 on 2017/12/6.
//  Copyright © 2017年 xiyoukeji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BondModel.h"

@interface BondView : UIView

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIView *payWay;

@property (nonatomic, strong) UIButton *payButton;

@property (nonatomic, strong) BondModel *model;

@end
