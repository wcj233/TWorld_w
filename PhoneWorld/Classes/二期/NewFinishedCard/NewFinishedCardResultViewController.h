//
//  NewFinishedCardResultViewController.h
//  PhoneWorld
//
//  Created by fym on 2018/7/31.
//  Copyright © 2018年 xiyoukeji. All rights reserved.
//

#import "BaseViewController.h"
#import "IMSIModel.h"
#import "PhoneDetailModel.h"

@interface NewFinishedCardResultViewController : BaseViewController

@property(nonatomic, assign) int cardMode;//识别仪 扫描
@property(nonatomic, assign) BOOL isFace;
@property (nonatomic) PhoneDetailModel *detailModel;//成卡开户
@property (nonatomic) BOOL isAuto;//自动获取还是手动获取 成卡开户才需要


@property (nonatomic) NSDictionary *currentPackageDictionary;
@property (nonatomic) NSDictionary *currentPromotionDictionary;
@property (nonatomic) NSDictionary *collectionInfoDictionary;//informationCollectionViewController界面收集的信息字典
@property (nonatomic) NSString *moneyString;


@property (nonatomic) IMSIModel *imsiModel;//白卡开户
@property (nonatomic) NSString *iccidString;//白卡开户读卡得到的iccid
@property (nonatomic) NSArray *infosArray;//白卡开户的到手机号信息

@property (nonatomic) NSDictionary *fourImageDic;//已经上传的四张图片
@property (nonatomic) NSDictionary *videoImageDic;//已经上传的人像

@end
