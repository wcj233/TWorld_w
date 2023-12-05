//
//  AgentResultViewController.h
//  PhoneWorld
//
//  Created by 刘岑颖 on 2017/5/10.
//  Copyright © 2017年 xiyoukeji. All rights reserved.
//

#import "BaseViewController.h"
#import "AgentNumberModel.h"

@interface AgentResultViewController : BaseViewController

//代理商白卡预开户
@property (nonatomic) NSDictionary *detailDictionary;
@property (nonatomic) NSDictionary *agentNumberModel;

@property (nonatomic) NSDictionary *packageDictionary;
@property (nonatomic) NSDictionary *promotionDictionary;

@end
