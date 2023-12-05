//
//  STopOrderDetailViewController.h
//  PhoneWorld
//
//  Created by 刘岑颖 on 2017/6/6.
//  Copyright © 2017年 xiyoukeji. All rights reserved.
//

#import "BaseViewController.h"
#import "RechargeListModel.h"
#import "RightsOrderListModel.h"

@interface STopOrderDetailViewController : BaseViewController

@property (nonatomic) RechargeListModel *rechargeListModel;
@property (nonatomic, strong) RightsOrderListModel *rightsOrderListModel;

@end
