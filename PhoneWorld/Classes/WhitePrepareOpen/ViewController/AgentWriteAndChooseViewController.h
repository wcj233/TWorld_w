//
//  AgentWriteAndChooseViewController.h
//  PhoneWorld
//
//  Created by 刘岑颖 on 2017/6/2.
//  Copyright © 2017年 xiyoukeji. All rights reserved.
//

#import "BaseViewController.h"
#import "LiangNumberModel.h"

@interface AgentWriteAndChooseViewController : BaseViewController

@property (nonatomic) NSArray *leftTitlesArray;

/*
 话机世界靓号平台
 代理商白卡预开户
 */
@property (nonatomic) NSString *typeString;

//话机世界靓号平台的模型
@property (nonatomic) LiangNumberModel *numberModel;
//代理商白卡预开户数据
@property (nonatomic) NSDictionary *agentNumberModel;

//写卡激活
@property(nonatomic,strong) NSString *phoneNumber;

/// 订单状态是否已锁定
@property (assign, nonatomic) BOOL stateIsLock;

// 如果是直接写卡激活，那么orderNo是支付成功返回的。如果是重写，那么orderNo是从列表或者详情页上带进去的。
@property (nonatomic) NSString *orderNo;

@end
