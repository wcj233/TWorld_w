//
//  AgentWriteViewController.h
//  PhoneWorld
//
//  Created by 刘岑颖 on 2017/5/10.
//  Copyright © 2017年 xiyoukeji. All rights reserved.
//

#import "BaseViewController.h"
#import "LiangNumberModel.h"
#import "AgentNumberModel.h"

@interface AgentWriteViewController : BaseViewController

@property (nonatomic) NSString *typeString;

//话机世界靓号平台下的
@property (nonatomic) LiangNumberModel *numberModel;
//代理商白卡预开户下的
@property (nonatomic) NSDictionary *agentNumberModel;

//号码详情都是存在这里
@property (nonatomic) NSDictionary *detailDictionary;

//套餐包
@property (nonatomic) NSDictionary *promotionsDictionary;
//活动包
@property (nonatomic) NSDictionary *packagesDictionary;

@end
