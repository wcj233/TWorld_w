//
//  InformationCollectionViewController.h
//  PhoneWorld
//
//  Created by 刘岑颖 on 16/10/18.
//  Copyright © 2016年 xiyoukeji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhoneDetailModel.h"
#import "LiangNumberModel.h"
#import "IMSIModel.h"

@interface InformationCollectionViewController : UIViewController

@property (nonatomic) BOOL isFinished;//是不是成卡开户
//成卡需要的
@property (nonatomic) PhoneDetailModel *detailModel;//成卡开户

//共有的
@property (nonatomic) NSDictionary *currentPackageDictionary;//套餐
@property (nonatomic) NSDictionary *currentPromotionDictionary;//活动包
@property (nonatomic) NSString *moneyString;//预存金额

//白卡需要的
@property (nonatomic) IMSIModel *imsiModel;//白卡开户
@property (nonatomic) NSString *iccidString;//白卡开户读卡读出来的iccid
@property (nonatomic) NSArray *infosArray;//白卡开户手机号等信息

/// cardOpenModes:扫描/识别仪/全部(1/2/3))
@property (nonatomic) int cardOpenMode;

@property(nonatomic, assign) BOOL isFaceCheck;//是否是人脸识别


//渠道商话机世界靓号平台的数据
@property (nonatomic) LiangNumberModel *numberModel;
@property (nonatomic) NSDictionary *detailDictionary;//渠道商白卡预开户传过来的数据也存在这里
@property (nonatomic) NSDictionary *imsiDictionary;
//话机世界靓号平台号码支付方式
@property (nonatomic) int payMethod;

//之前界面需要支付的话，支付成功返回的
@property (nonatomic) NSString *orderNo;
@property(nonatomic, strong) NSString *typeString;//靓号



@end
