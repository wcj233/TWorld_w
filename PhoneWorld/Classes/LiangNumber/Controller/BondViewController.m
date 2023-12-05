//
//  BondViewController.m
//  PhoneWorld
//
//  Created by 刘岑颖 on 2017/12/6.
//  Copyright © 2017年 xiyoukeji. All rights reserved.
//

#import "BondViewController.h"
#import "BondView.h"
#import "BondModel.h"
#import "AppDelegate.h"
#import "LiangListViewController.h"

@interface BondViewController ()

@property (nonatomic, strong) BondView *bondView;
@property (nonatomic, strong) BondModel *model;

@end

@implementation BondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"保证金缴纳";
    
    [self initInterface];
    
    [self initNet];
    
    [self.bondView.payButton addTarget:self action:@selector(payAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)initInterface{
    self.bondView = [[BondView alloc] init];
    [self.view addSubview:self.bondView];
    [self.bondView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0);
    }];
}

- (void)payAction{
    //支付宝支付
    
    [WebUtils topBondOrderWithOrderNumber:self.model.orderNo andAmount:self.model.amount andUsername:self.model.userName andCallBack:^(id obj) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSDictionary *dict = obj;
            NSString *code = [NSString stringWithFormat:@"%@",[dict objectForKey:@"code"]];
            if ([code isEqualToString:@"10000"]) {
                NSString *orderString = [NSString stringWithFormat:@"%@",obj[@"data"][@"request"]];
                
                //NOTE: 调用支付结果开始支付
                [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                    
                    NSLog(@"reslut = %@",resultDic);
                    
                }];
                AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
                [app setAppCallBack:^(BOOL result) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        if (result == YES) {
                            //支付成功
                            [self jumpToLiangListAction];
                        }else{
                            //支付失败
                            [self showWarningText:@"支付失败"];
                        }
                    });
                }];
            }else {
                [self showWarningText:obj[@"mes"]];
            }
        });
    }];
}

- (void)initNet{
    [WebUtils requestBondMoneyWithCallBack:^(id obj) {
        NSDictionary *dict = obj;
        NSString *code = [NSString stringWithFormat:@"%@",[dict objectForKey:@"code"]];
        if ([code isEqualToString:@"10000"]) {
            NSDictionary *dataDic = [dict objectForKey:@"data"];
            self.model = [[BondModel alloc] initWithDictionary:dataDic error:nil];
            self.bondView.model = self.model;
        }else {
            [self showWarningText:obj[@"mes"]];
        }
    }];
}

- (void)jumpToLiangListAction{
    dispatch_async(dispatch_get_main_queue(), ^{
//        LiangListViewController *vc = [[LiangListViewController alloc] init];
//        vc.title = @"话机世界靓号";
//        [self.navigationController pushViewController:vc animated:YES];
        
        [self.navigationController popViewControllerAnimated:YES];
    });
}

@end
