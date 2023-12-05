//
//  AgentNumberDetailViewController.h
//  PhoneWorld
//
//  Created by 刘岑颖 on 2017/5/10.
//  Copyright © 2017年 xiyoukeji. All rights reserved.
//

#import "BaseViewController.h"
#import "LiangNumberModel.h"

@interface AgentNumberDetailViewController : BaseViewController

@property (nonatomic) NSArray *leftTitlesArray;

@property (nonatomic) NSString *buttonTitleString;

/*
 代理商白卡预开户（改）
 渠道商白卡预开户
 话机世界靓号平台（改）
 */
@property (nonatomic) NSString *typeString;

//话机世界靓号平台的模型
@property (nonatomic) LiangNumberModel *numberModel;

//代理商白卡预开户数据
@property (nonatomic) NSDictionary *agentNumberModel;

@end
