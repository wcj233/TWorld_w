//
//  WhitePrepareOpenThreeViewController.m
//  PhoneWorld
//
//  Created by 刘岑颖 on 2017/5/9.
//  Copyright © 2017年 xiyoukeji. All rights reserved.
//

#import "WhitePrepareOpenThreeViewController.h"
#import "WhitePrepareOpenThreeView.h"
#import "OpenWayView.h"
#import "WhitePrepareOpenFourViewController.h"

@interface WhitePrepareOpenThreeViewController ()

@property (nonatomic) WhitePrepareOpenThreeView *threeView;

@property (nonatomic) int cardOpenMode;//可提供的开户信息采集方式

@end

@implementation WhitePrepareOpenThreeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"开户方式选择";
    
    self.threeView = [[WhitePrepareOpenThreeView alloc] init];
    [self.view addSubview:self.threeView];
    [self.threeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0);
    }];
    
    [self requestForInfoWays];
    self.cardOpenMode = 3;
    
    for (int i = 0; i < self.threeView.openArray.count; i ++) {
        OpenWayView *openWayView = self.threeView.openArray[i];
        [openWayView.chooseButton addTarget:self action:@selector(nextAction:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)requestForInfoWays{
    @WeakObj(self);
    [WebUtils requestWithCardModeWithCallBack:^(id obj) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            if ([obj[@"code"] isEqualToString:@"10000"]) {
                @StrongObj(self);
                [[NSUserDefaults standardUserDefaults]setObject:obj[@"data"] forKey:@"kaihuMode"];
                [[NSUserDefaults standardUserDefaults]synchronize];
                NSDictionary *modeDic = [[NSUserDefaults standardUserDefaults]objectForKey:@"kaihuMode"];
                NSNumber *cardOpenMode = modeDic[@"modes"];
                self.cardOpenMode = cardOpenMode.intValue;
                //                weakself.cardOpenMode = [obj[@"data"][@"cardOpenMode"] intValue];
            }
        }
    }];
    
    
//    @WeakObj(self);
//    [WebUtils requestWithChooseScanWithCallBack:^(id obj) {
//        if ([obj isKindOfClass:[NSDictionary class]]) {
//            if ([obj[@"code"] isEqualToString:@"10000"]) {
//                @StrongObj(self);
//                self.cardOpenMode = [obj[@"data"][@"cardOpenMode"] intValue];
//            }else{
//                [self showWarningText:obj[@"mes"]];
//            }
//        }
//    }];
    
}

- (void)nextAction:(UIButton *)button{
    
    switch (self.cardOpenMode) {
        case 3:
        {//都支持
            [self jumpNextWithTag:button.tag];
        }
            break;
        case 2:
        {//识别仪开户
            if (button.tag == 0) {
                [self jumpNextWithTag:button.tag];
            }else{
                [Utils toastview:@"当前不支持扫描开户"];
            }
        }
            break;
        case 1:
        {//扫描开户
            if (button.tag == 0) {
                [Utils toastview:@"当前不支持识别仪开户"];
            }else{
                [self jumpNextWithTag:button.tag];
            }
        }
            break;
        default:
        {
            [Utils toastview:@"正在查询可提供的开户方式"];
        }
            break;
    }
}

- (void)jumpNextWithTag:(NSInteger)tag{
    WhitePrepareOpenFourViewController *vc = [[WhitePrepareOpenFourViewController alloc] init];
    if (tag == 0) {
        //识别仪开户
        vc.openWay = @"识别仪开户";
    }else{
        //扫描开户
        vc.openWay = @"扫描开户";
    }
    vc.numberModel = self.numberModel;
    vc.orderNo = self.orderNo;
    vc.payMethod = self.payMethod;
    vc.detailDictionary = self.detailDictionary;
    vc.packagesDictionary = self.packagesDictionary;
    vc.typeString = self.typeString;
    vc.iccidString = self.iccidString;
    vc.imsiDictionary = self.imsiDictionary;
    vc.promotionDictionary = self.promotionsDictionary;
    
    vc.phoneNumber = self.phoneNumber;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
