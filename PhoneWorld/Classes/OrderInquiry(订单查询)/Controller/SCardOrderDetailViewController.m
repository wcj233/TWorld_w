//
//  SCardOrderDetailViewController.m
//  PhoneWorld
//
//  Created by 刘岑颖 on 2017/6/5.
//  Copyright © 2017年 xiyoukeji. All rights reserved.
//

#import "SCardOrderDetailViewController.h"
#import "SCardOrderDetailView.h"
#import "WriteCardNumberDetails.h"
#import "WhitePrepareOpenThreeViewController.h"
#import "ChooseWayViewController.h"
#import "WriteCardOrderDetailsModel.h"

@interface SCardOrderDetailViewController ()

@property (nonatomic) SCardOrderDetailView *detailView;

@end

@implementation SCardOrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.detailView = [[SCardOrderDetailView alloc] initWithFrame:CGRectZero andCardDetailType:self.type];
    // 判断 写卡订单 是否为 已锁定
    self.detailView.stateIsLock = [@"已锁定" isEqualToString:self.writeCardModel.state];
    
    [self.view addSubview:self.detailView];
    [self.detailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0);
    }];
    
    
    //写卡激活订单
    if (self.type == XieKa && [self.writeCardModel.state isEqualToString:@"待激活"]) {
        UIButton *activationBtn = [[UIButton alloc]init];
        activationBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        activationBtn.backgroundColor = [UIColor colorWithRed:236/255.0 green:108/255.0 blue:0/255.0 alpha:1.0];
        [activationBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        activationBtn.layer.cornerRadius = 4;
        activationBtn.layer.masksToBounds = YES;
        [activationBtn setTitle:@"激活" forState:UIControlStateNormal];
        [activationBtn addTarget:self action:@selector(clickActivationBtn) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:activationBtn];
        [activationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.view);
            make.bottom.mas_equalTo(self.view).mas_equalTo(-90);
            make.size.mas_equalTo(CGSizeMake(170, 40));
        }];
    }
    
    
    [self requestDataAction];
}

// 写卡激活详情页，点击 激活 按钮
- (void)clickActivationBtn{
    ChooseWayViewController *vc = [[ChooseWayViewController alloc]init];
    vc.typeString = @"写卡激活";
    vc.phoneNumber = self.writeCardModel.number;
    [self.navigationController pushViewController:vc animated:YES];
//    //渠道商
//    WhitePrepareOpenThreeViewController *vc = [[WhitePrepareOpenThreeViewController alloc] init];
//    vc.typeString = @"写卡激活";
//    vc.phoneNumber = self.writeCardModel.number;
//    [self.navigationController pushViewController:vc animated:YES];
}

- (void)requestDataAction{
    [self showWaitView];
    switch (self.type) {
        case ChengKa:
        case BaiKa:
        {
            [self getChengkaOrBaikaDetailAction];
        }
            break;
       case GuoHu:
        {
            [self getGuohuDetailAction];
        }
            break;
        case BuKa:
        {
            self.detailView.cardTransferListModel = self.cardTransferListModel;
            [self getBukaDetailAction];
        }
            break;
        case XieKa:{
            [self getWriteCardActivationNumberDetails];
        }
            break;
    }
}

//写卡激活详情页
- (void)getWriteCardActivationNumberDetails{
    
    @WeakObj(self);
    [WebUtils agency_2019preNumberOrderInfoWithParams:@{@"ePreNo":self.writeCardModel.ePreNo} andCallback:^(id obj) {
        @StrongObj(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideWaitView];
        });
        if ([obj isKindOfClass:[NSDictionary class]]) {
            NSString *code = [NSString stringWithFormat:@"%@",obj[@"code"]];
            if ([code isEqualToString:@"10000"]) {
                NSDictionary *dic = obj[@"data"];
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.detailView.writeCardOrderDetailsModel = [[WriteCardOrderDetailsModel alloc] initWithDictionary:dic error:nil];
                });
            }else {
                [self showWarningText:obj[@"mes"]];
            }
        }
    }];
}

- (void)getChengkaOrBaikaDetailAction{
    @WeakObj(self);
    if (self.type == ChengKa) {
        [WebUtils requestOrderDetailWithOrderNo:self.order_id andCallBack:^(id obj) {
            @StrongObj(self);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self hideWaitView];
            });
            if ([obj isKindOfClass:[NSDictionary class]]) {
                NSString *code = [NSString stringWithFormat:@"%@",obj[@"code"]];
                if ([code isEqualToString:@"10000"]) {
                    NSDictionary *dic = obj[@"data"];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.detailView.orderDetailModel = [[OrderDetailModel alloc] initWithDictionary:dic error:nil];
                    });
                }else{
                    [self showWarningText:obj[@"mes"]];
                }
            }
        }];
    }
    else{
        [WebUtils requestEOrderDetailWithOrderNo:self.order_id andCallBack:^(id obj) {
            @StrongObj(self);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self hideWaitView];
            });
            if ([obj isKindOfClass:[NSDictionary class]]) {
                NSString *code = [NSString stringWithFormat:@"%@",obj[@"code"]];
                if ([code isEqualToString:@"10000"]) {
                    NSDictionary *dic = obj[@"data"];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.detailView.orderDetailModel = [[OrderDetailModel alloc] initWithDictionary:dic error:nil];
                    });
                }else{
                    [self showWarningText:obj[@"mes"]];
                }
            }
        }];
    }
}

- (void)getGuohuDetailAction{
    @WeakObj(self);
    [WebUtils requestTransferDetailWithId:self.order_id andCallBack:^(id obj) {
        @StrongObj(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideWaitView];
        });
        if ([obj isKindOfClass:[NSDictionary class]]) {
            NSString *code = [NSString stringWithFormat:@"%@",obj[@"code"]];
            if ([code isEqualToString:@"10000"]) {
                NSDictionary *dic = obj[@"data"];
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.detailView.cardTransferDetailModel = [[CardTransferDetailModel alloc] initWithDictionary:dic error:nil];
                });
            }else{
                [self showWarningText:obj[@"mes"]];
            }
        }
    }];
}

- (void)getBukaDetailAction{
    @WeakObj(self);
    [WebUtils requestCardTransferDetailWithId:self.order_id andCallBack:^(id obj) {
        @StrongObj(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideWaitView];
        });
        if ([obj isKindOfClass:[NSDictionary class]]) {
            NSString *code = [NSString stringWithFormat:@"%@",obj[@"code"]];
            if ([code isEqualToString:@"10000"]) {
                NSDictionary *dic = obj[@"data"];
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.detailView.cardRepairDetailModel = [[CardRepairDetailModel alloc] initWithDictionary:dic error:nil];
                });
            }else{
                [self showWarningText:obj[@"mes"]];
            }
        }
    }];
}

@end
