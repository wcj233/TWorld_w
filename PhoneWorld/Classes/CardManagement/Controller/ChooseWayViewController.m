//
//  ChooseWayViewController.m
//  PhoneWorld
//
//  Created by 刘岑颖 on 17/2/10.
//  Copyright © 2017年 xiyoukeji. All rights reserved.
//

#import "ChooseWayViewController.h"
#import "ChooseWayView.h"
#import "FinishCardViewController.h"
#import "InformationCollectionViewController.h"
#import "WhitePrepareOpenFourViewController.h"

@interface ChooseWayViewController ()

@property (nonatomic) ChooseWayView *chooseView;
/// 可提供的开户信息采集方式  3表示正在查询中  pattern == 3 普通开户+人脸开户    pattern == 2 仅人脸开户
@property (nonatomic) int cardOpenMode;

@end

@implementation ChooseWayViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self requestForInfoWays];
//    NSDictionary *modeDic = [[NSUserDefaults standardUserDefaults]objectForKey:@"kaihuMode"];
//    NSNumber *modeNum = modeDic[@"pattern"];
//    self.cardOpenMode = modeNum.intValue;
    [self requestData];
    self.title = @"开户方式";
    self.view.backgroundColor = [UIColor whiteColor];
}

-(void)requestData{
    [WebUtils requestWithCardModeWithCallBack:^(id obj) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            if ([obj[@"code"] isEqualToString:@"10000"]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[NSUserDefaults standardUserDefaults]setObject:obj[@"data"] forKey:@"kaihuMode"];
                    [[NSUserDefaults standardUserDefaults]synchronize];
                    
                    NSDictionary *modeDic = [[NSUserDefaults standardUserDefaults]objectForKey:@"kaihuMode"];
                    NSNumber *modeNum = modeDic[@"pattern"];
                    self.cardOpenMode = modeNum.intValue;
                    
                    self.chooseView = [[ChooseWayView alloc] initWithMode:self.cardOpenMode];
                    [self.view addSubview:self.chooseView];
                    [self.chooseView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.right.top.bottom.mas_equalTo(0);
                    }];
                    
                    for (int i = 0; i < self.chooseView.openArray.count; i ++) {
                        OpenWayView *openWayView = self.chooseView.openArray[i];
                        [openWayView.chooseButton addTarget:self action:@selector(nextAction:) forControlEvents:UIControlEventTouchUpInside];
                    }
                });
            }
        }
    }];
}

- (void)requestForInfoWays{
//    __block __weak ChooseWayViewController *weakself = self;
    [WebUtils requestWithCardModeWithCallBack:^(id obj) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            if ([obj[@"code"] isEqualToString:@"10000"]) {
                [[NSUserDefaults standardUserDefaults]setObject:obj[@"data"] forKey:@"kaihuMode"];
                [[NSUserDefaults standardUserDefaults]synchronize];
                //                weakself.cardOpenMode = [obj[@"data"][@"cardOpenMode"] intValue];
            }
        }
    }];
}

- (void)nextAction:(UIButton *)button{
    NSDictionary *modeDic = [[NSUserDefaults standardUserDefaults]objectForKey:@"kaihuMode"];
    NSNumber *cardMode = modeDic[@"modes"];
#pragma mark - 2019
//    if ([self.typeString isEqualToString:@"写卡激活"]) {
        [self jumpWhitePrepareOpenFourTag:button.tag andCardMode:cardMode.intValue];
        return;
//    }
    
    if ([self.typeString isEqualToString:@"靓号"]) {
        if (self.cardOpenMode==2) {
            //成卡
            InformationCollectionViewController *vc = [InformationCollectionViewController new];
            vc.typeString = self.typeString;
            vc.isFinished = self.isFinished;
            vc.detailModel = self.detailModel;
            vc.currentPackageDictionary = self.currentPackageDictionary;
            vc.currentPromotionDictionary = self.currentPromotionDictionary;
            vc.moneyString = self.moneyString;
            vc.isFaceCheck = YES;
            vc.cardOpenMode = cardMode.intValue;
            
            //靓号相关
            vc.isFinished = NO;
            vc.payMethod = self.payMethod;
            vc.orderNo = self.orderNo;
            vc.numberModel = self.numberModel;
            vc.imsiDictionary = self.imsiDictionary;
            vc.iccidString = self.iccidString;
            vc.detailDictionary = self.detailDictionary;
            
            
            [self.navigationController pushViewController:vc animated:YES];
            return;
        }
        if (button.tag==0) {//普通开户
            switch (cardMode.intValue) {
                case 3:
                {//都支持
                    [self jumpByLiangHaoNextWithTag:cardMode.intValue andIsFace:NO];
                }
                    break;
                case 2:
                {//识别仪开户
                    [self jumpByLiangHaoNextWithTag:cardMode.intValue andIsFace:NO];
                }
                    break;
                case 1:
                {//扫描开户
                    [self jumpByLiangHaoNextWithTag:cardMode.intValue andIsFace:NO];
                }
                    break;
                default:
                {
                    [Utils toastview:@"正在查询可提供的开户方式"];
                }
                    break;
            }
        }else{
            [self jumpByLiangHaoNextWithTag:cardMode.intValue andIsFace:YES];
        }
        
        return;
    }
    

    if (self.cardOpenMode==2) {
        //成卡
        FinishCardViewController *vc = [FinishCardViewController new];
        vc.isFaceCheck = YES;
        vc.cardOpenMode = cardMode.intValue;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    if (button.tag==0) {//普通开户
        switch (cardMode.intValue) {
            case 3:
            {//都支持
                [self jumpNextWithTag:cardMode.intValue andIsFace:NO];
            }
                break;
            case 2:
            {//识别仪开户
                [self jumpNextWithTag:cardMode.intValue andIsFace:NO];
            }
                break;
            case 1:
            {//扫描开户
                [self jumpNextWithTag:cardMode.intValue andIsFace:NO];
            }
                break;
            default:
            {
                [Utils toastview:@"正在查询可提供的开户方式"];
            }
                break;
        }
    }else{
        [self jumpNextWithTag:cardMode.intValue andIsFace:YES];
    }
    
}

- (void)jumpByLiangHaoNextWithTag:(int)tag andIsFace:(BOOL)isFace{
    //扫描
    InformationCollectionViewController *vc = [InformationCollectionViewController new];
    vc.typeString = self.typeString;
    vc.isFinished = self.isFinished;
    vc.detailModel = self.detailModel;
    vc.currentPackageDictionary = self.currentPackageDictionary;
    vc.currentPromotionDictionary = self.currentPromotionDictionary;
    vc.moneyString = self.moneyString;
    vc.isFaceCheck = isFace;
    vc.cardOpenMode = tag;
    vc.isFinished = NO;
    vc.payMethod = self.payMethod;
    vc.orderNo = self.orderNo;
    vc.numberModel = self.numberModel;
    vc.imsiDictionary = self.imsiDictionary;
    vc.iccidString = self.iccidString;
    vc.detailDictionary = self.detailDictionary;
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)jumpNextWithTag:(int)tag andIsFace:(BOOL)isFace{
    //扫描
    FinishCardViewController *vc = [FinishCardViewController new];
    vc.isFaceCheck = isFace;
    vc.cardOpenMode = tag;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)jumpWhitePrepareOpenFourTag:(int)tag andCardMode:(int)cardMode{
    WhitePrepareOpenFourViewController *vc = [[WhitePrepareOpenFourViewController alloc] init];
//    if (tag == 0) {
//        //识别仪开户
//        vc.openWay = @"识别仪开户";
//    }else{
//        //扫描开户
//        vc.openWay = @"扫描开户";
//    }

//    vc.isFaceVerify = tag == 1?YES:NO;
    
    OpenWayView *tmpView = self.chooseView.openArray[tag];
    if ([tmpView.titleLabel.text isEqualToString:@"人脸开户"]) {
        vc.isFaceVerify = true;
    } else if ([tmpView.titleLabel.text isEqualToString:@"普通开户"]) {
        vc.isFaceVerify = false;
    }
    
    vc.numberModel      =       self.numberModel;
    vc.orderNo          =       self.orderNo;
    vc.payMethod        =       self.payMethod;
    vc.detailDictionary =       self.detailDictionary;
    vc.typeString       =       self.typeString;
    vc.cardOpenMode = cardMode;
    vc.iccidString      =       self.iccidString;
    vc.imsiDictionary   =       self.imsiDictionary;
    
    vc.phoneNumber      =       self.phoneNumber;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
