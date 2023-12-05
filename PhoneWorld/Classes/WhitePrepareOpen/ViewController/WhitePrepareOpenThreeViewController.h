//
//  WhitePrepareOpenThreeViewController.h
//  PhoneWorld
//
//  Created by 刘岑颖 on 2017/5/9.
//  Copyright © 2017年 xiyoukeji. All rights reserved.
//

#import "BaseViewController.h"
#import "LiangNumberModel.h"

@interface WhitePrepareOpenThreeViewController : BaseViewController

@property (nonatomic) NSString *typeString;

//渠道商话机世界靓号平台的数据
@property (nonatomic) LiangNumberModel *numberModel;
@property (nonatomic) NSDictionary *detailDictionary;//渠道商白卡预开户传过来的数据也存在这里
@property (nonatomic) NSDictionary *imsiDictionary;
@property (nonatomic) NSString *iccidString;

//渠道商话机世界靓号平台的套餐包
@property (nonatomic) NSDictionary *promotionsDictionary;
@property (nonatomic) NSDictionary *packagesDictionary;//活动包

//话机世界靓号平台号码支付方式
@property (nonatomic) int payMethod;

//之前界面需要支付的话，支付成功返回的
@property (nonatomic) NSString *orderNo;

//写卡激活
@property(nonatomic,strong)NSString *phoneNumber;

@end
