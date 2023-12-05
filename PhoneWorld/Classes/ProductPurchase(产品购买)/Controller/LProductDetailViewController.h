//
//  LProductDetailViewController.h
//  PhoneWorld
//
//  Created by 刘岑颖 on 2018/1/15.
//  Copyright © 2018年 xiyoukeji. All rights reserved.
//

#import "BaseViewController.h"
#import "LBookedModel.h"
#import "RightsOrderListModel.h"

@interface LProductDetailViewController : BaseViewController

@property (nonatomic, strong) LBookedModel *bookedModel;

@property (nonatomic, strong) RightsOrderListModel *rightsOrderListModel;

@end
