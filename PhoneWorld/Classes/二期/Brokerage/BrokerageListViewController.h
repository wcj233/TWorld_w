//
//  BrokerageListViewController.h
//  PhoneWorld
//
//  Created by fym on 2018/7/21.
//  Copyright © 2018年 xiyoukeji. All rights reserved.
//

#import "BaseViewController.h"
#import "BrokerageViewController.h"

@interface BrokerageListViewController : BaseViewController

@property(nonatomic,copy)NSString *total;

@property(nonatomic,weak)BrokerageViewController *parentVC;

@property(nonatomic,copy)NSString *periodString;

-(void)setType:(int)type;

-(void)refresh;

@end
