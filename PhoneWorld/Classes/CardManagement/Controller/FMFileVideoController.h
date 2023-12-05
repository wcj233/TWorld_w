//
//  FMFileVideoController.h
//  FMRecordVideo
//
//  Created by qianjn on 2017/3/12.
//  Copyright © 2017年 SF. All rights reserved.
//
//  Github:https://github.com/suifengqjn
//  blog:http://gcblog.github.io/
//  简书:http://www.jianshu.com/u/527ecf8c8753
#import <UIKit/UIKit.h>
#import "PhoneDetailModel.h"
#import "IMSIModel.h"
#import "BaseViewController.h"
#import "LiangNumberModel.h"

@interface FMFileVideoController : BaseViewController

@property (nonatomic) PhoneDetailModel *detailModel;//成卡开户
@property (nonatomic) BOOL isAuto;//自动获取还是手动获取 成卡开户才需要


@property (nonatomic) NSDictionary *currentPackageDictionary;
@property (nonatomic) NSDictionary *currentPromotionDictionary;
@property (nonatomic) NSDictionary *collectionInfoDictionary;//informationCollectionViewController界面收集的信息字典
@property (nonatomic) NSDictionary *fourImageDic;//已经上传了的四张图片

@property (nonatomic) NSString *moneyString;


@property (nonatomic) IMSIModel *imsiModel;//白卡开户
@property (nonatomic) NSString *iccidString;//白卡开户读卡得到的iccid
@property (nonatomic) NSArray *infosArray;//白卡开户的到手机号信息


//渠道商话机世界靓号平台的数据
@property (nonatomic) LiangNumberModel *numberModel;
@property (nonatomic) NSDictionary *detailDictionary;//渠道商白卡预开户传过来的数据也存在这里
@property (nonatomic) NSDictionary *imsiDictionary;
//话机世界靓号平台号码支付方式
@property (nonatomic) int payMethod;

//之前界面需要支付的话，支付成功返回的
@property (nonatomic) NSString *orderNo;
@property(nonatomic, strong) NSString *typeString;//靓号


//写卡激活
@property (nonatomic, copy) void(^callBackImageURLs)(NSDictionary *imageURLs);

@end
