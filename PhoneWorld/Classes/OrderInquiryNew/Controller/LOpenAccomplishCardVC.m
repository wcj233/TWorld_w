//
//  LOpenAccomplishCardVC.m
//  PhoneWorld
//
//  Created by 刘岑颖 on 17/2/27.
//  Copyright © 2017年 xiyoukeji. All rights reserved.
//

#import "LOpenAccomplishCardVC.h"
#import "MainTabBarController.h"
#import "NormalOrderDetailViewController.h"
#import "MainNavigationController.h"

@interface LOpenAccomplishCardVC ()

@property (nonatomic) int page;
@property (nonatomic) int linage;

@end

@implementation LOpenAccomplishCardVC

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.orderModelsArray = [NSMutableArray array];
    self.page = 1;
    self.linage = 10;
    
    self.orderView = [[OrderView alloc] init];
    [self.view addSubview:self.orderView];
    [self.orderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0);
    }];
    
    @WeakObj(self);
    
    self.orderView.orderTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self requestOrderListWithType:refreshing];
    }];
    
    self.orderView.orderTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        @StrongObj(self);
        [self requestOrderListWithType:loading];
    }];
    
    [self.orderView setOrderViewCallBack:^(NSInteger section) {
        @StrongObj(self);
        OrderListModel *orderModel = self.orderModelsArray[section];
        
        //成卡开户  跳转  订单信息
        NormalOrderDetailViewController *vc = [NormalOrderDetailViewController new];
        vc.hidesBottomBarWhenPushed = YES;
        vc.orderNo = orderModel.orderNo;

        vc.orderModel = orderModel;
        
        MainTabBarController *tabVC = (MainTabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
        
        MainNavigationController *naviVC = (MainNavigationController *)tabVC.viewControllers[1];
        
        [naviVC pushViewController:vc animated:YES];
    }];
    
    [self.orderView.orderTableView.mj_header beginRefreshing];
    
}

- (void)requestOrderListWithType:(requestType)requestType{
    @WeakObj(self);
    self.orderView.userInteractionEnabled = NO;
    
    if (![[AFNetworkReachabilityManager sharedManager] isReachable]) {
        if (requestType == refreshing) {
            [self.orderView.orderTableView.mj_header endRefreshing];
        }else{
            [self.orderView.orderTableView.mj_footer endRefreshing];
        }
        self.orderView.userInteractionEnabled = YES;
        return;
    }
    
    if (requestType == refreshing) {
        self.page = 1;
        self.orderModelsArray = [NSMutableArray array];
        
    }else if(requestType == loading){
        self.page ++;
    }
    
    NSString *phoneNumber = @"无";
    NSString *beginDate = @"无";
    NSString *endDate = @"无";
    NSString *orderState = @"无";
    NSString *orderStatusCode = @"无";
    if (self.inquiryConditionArray.count > 0) {
        phoneNumber = [NSString stringWithFormat:@"%@",self.inquiryConditionArray.lastObject];
        beginDate = [NSString stringWithFormat:@"%@",self.inquiryConditionArray.firstObject];
        endDate = [NSString stringWithFormat:@"%@",self.inquiryConditionArray[1]];
        orderState = [NSString stringWithFormat:@"%@",self.inquiryConditionArray[2]];
    }
    NSString *pageStr = [NSString stringWithFormat:@"%d",self.page];
    NSString *linageStr = [NSString stringWithFormat:@"%d",self.linage];
    
    if ([orderState isEqualToString:@"已提交"]) {
        orderStatusCode = @"PENDING";
    }
    if ([orderState isEqualToString:@"等待中"]) {
        orderStatusCode = @"WAITING";
    }
    if ([orderState isEqualToString:@"成功"]) {
        orderStatusCode = @"SUCCESS";
    }
    if ([orderState isEqualToString:@"失败"]) {
        orderStatusCode = @"FAIL";
    }
    if ([orderState isEqualToString:@"已取消"]) {
        orderStatusCode = @"CANCLE";
    }
    if ([orderState isEqualToString:@"已关闭"]) {
        orderStatusCode = @"CLOSED";
    }
    
    [WebUtils requestInquiryOrderListWithPhoneNumber:phoneNumber andType:@"SIM" andStartTime:beginDate andEndTime:endDate andOrderStatusCode:orderStatusCode andOrderStatusName:orderState andPage:pageStr andLinage:linageStr andCallBack:^(id obj) {
        @StrongObj(self);
        if ([obj isKindOfClass:[NSDictionary class]]) {
            
            NSString *code = [NSString stringWithFormat:@"%@",obj[@"code"]];
            if ([code isEqualToString:@"10000"]) {
                
                NSArray *arr = obj[@"data"][@"order"];
                for (NSDictionary *dic in arr) {
                    OrderListModel *om = [[OrderListModel alloc] initWithDictionary:dic error:nil];
                    [self.orderModelsArray addObject:om];
                }
                
                self.orderView.orderListArray = self.orderModelsArray;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.orderView.resultNumLB.text = [NSString stringWithFormat:@"共%ld条",self.orderModelsArray.count];
                    [self.orderView.orderTableView reloadData];
                });
            }else{
                [self showWarningText:obj[@"mes"]];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.orderView.userInteractionEnabled = YES;
                if (requestType == refreshing) {
                    [self.orderView.orderTableView.mj_header endRefreshing];
                }else{
                    [self.orderView.orderTableView.mj_footer endRefreshing];
                }
            });
        }
    }];
}


@end
