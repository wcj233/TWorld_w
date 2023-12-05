//
//  SCardOrderViewController.h
//  PhoneWorld
//
//  Created by 刘岑颖 on 2017/6/5.
//  Copyright © 2017年 xiyoukeji. All rights reserved.
//

#import "BaseViewController.h"

@interface SCardOrderViewController : BaseViewController

/*
 成卡开户订单
 白卡开户订单
 过户订单
 补卡订单
 */
@property (nonatomic) CardDetailType type;

@end
