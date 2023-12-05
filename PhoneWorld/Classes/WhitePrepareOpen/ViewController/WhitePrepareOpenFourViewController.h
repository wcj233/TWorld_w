//
//  WhitePrepareOpenFourViewController.h
//  PhoneWorld
//
//  Created by 刘岑颖 on 2017/5/9.
//  Copyright © 2017年 xiyoukeji. All rights reserved.
//

#import "BaseViewController.h"
#import "LiangNumberModel.h"

@interface WhitePrepareOpenFourViewController : BaseViewController

@property (nonatomic) NSString *typeString;

@property (nonatomic) NSString *openWay;//识别仪开户／扫描开户 //人脸识别

//渠道商话机世界靓号平台的数据
@property (nonatomic) LiangNumberModel *numberModel;
@property (nonatomic) NSDictionary *detailDictionary;
@property (nonatomic) NSDictionary *imsiDictionary;
@property (nonatomic) NSString *iccidString;
@property (nonatomic) NSDictionary *promotionDictionary;
@property (nonatomic) NSDictionary *packagesDictionary;
@property (nonatomic) int payMethod;

@property (nonatomic) NSString *orderNo;

/// cardOpenModes:扫描/识别仪/全部(1/2/3))
@property (nonatomic) int cardOpenMode;

//手机号
@property(nonatomic,strong)NSString *phoneNumber;

@property (nonatomic, assign) BOOL isFaceVerify;

@end
