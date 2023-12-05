//
//  LOpenWhiteCardVC.m
//  PhoneWorld
//
//  Created by 刘岑颖 on 17/2/27.
//  Copyright © 2017年 xiyoukeji. All rights reserved.
//

#import "LOpenWhiteCardVC.h"
#import "NormalOrderDetailViewController.h"
#import "MainNavigationController.h"
#import "MainTabBarController.h"

@interface LOpenWhiteCardVC ()

@property (nonatomic) int page;
@property (nonatomic) int linage;

@end

@implementation LOpenWhiteCardVC

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
    
    __block __weak LOpenWhiteCardVC *weakself = self;
    
    self.orderView.orderTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakself requestOrderListWithType:refreshing];
    }];
    
    self.orderView.orderTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakself requestOrderListWithType:loading];
    }];
    
    [self.orderView setOrderViewCallBack:^(NSInteger section) {
        
        OrderListModel *orderModel = weakself.orderModelsArray[section];
        
        //成卡开户  跳转  订单信息
        NormalOrderDetailViewController *vc = [NormalOrderDetailViewController new];
        vc.hidesBottomBarWhenPushed = YES;
        vc.orderNo = orderModel.orderNo;
        vc.orderModel = orderModel;
    
        
        MainTabBarController *tabVC = (MainTabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
        
        MainNavigationController *naviVC = (MainNavigationController *)tabVC.viewControllers[1];
        
        [naviVC pushViewController:vc animated:YES];
    }];
}

- (void)requestOrderListWithType:(requestType)requestType{
    __block __weak LOpenWhiteCardVC *weakself = self;
    
    self.orderView.userInteractionEnabled = NO;
    
    if (![[AFNetworkReachabilityManager sharedManager] isReachable]) {
        if (requestType == refreshing) {
            [weakself.orderView.orderTableView.mj_header endRefreshing];
        }else{
            [weakself.orderView.orderTableView.mj_footer endRefreshing];
        }
        self.orderView.userInteractionEnabled = YES;
        return;
    }
    
    NSString *requestString = @"没有数据";
    
    if (requestType == refreshing) {
        self.page = 1;
        self.orderModelsArray = [NSMutableArray array];
        
    }else if(requestType == loading){
        self.page ++;
        requestString = @"已经是最后一页";
    }
    
    NSString *phoneNumber = @"无";
    NSString *beginDate = @"无";
    NSString *endDate = @"无";
    NSString *orderState = @"无";
    NSString *orderStatusCode = @"无";
    
    if (self.inquiryConditionArray.count > 0) {
        phoneNumber = [NSString stringWithFormat:@"%@",weakself.inquiryConditionArray.lastObject];
        beginDate = [NSString stringWithFormat:@"%@",weakself.inquiryConditionArray.firstObject];
        endDate = [NSString stringWithFormat:@"%@",weakself.inquiryConditionArray[1]];
        orderState = [NSString stringWithFormat:@"%@",weakself.inquiryConditionArray[2]];
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
    
    [WebUtils requestInquiryOrderListWithPhoneNumber:phoneNumber andType:@"ESIM" andStartTime:beginDate andEndTime:endDate andOrderStatusCode:orderStatusCode andOrderStatusName:orderState andPage:pageStr andLinage:linageStr andCallBack:^(id obj) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            
            NSString *code = [NSString stringWithFormat:@"%@",obj[@"code"]];
            if ([code isEqualToString:@"10000"]) {
                int count = [NSString stringWithFormat:@"%@",obj[@"data"][@"count"]].intValue;
                if (count == 0) {
                    if (requestType == refreshing) {
                        weakself.orderView.orderListArray = nil;
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (requestType == loading) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [Utils toastview:requestString];
                            });
                        }
                        weakself.orderView.resultNumLB.text = [NSString stringWithFormat:@"共%ld条",weakself.orderModelsArray.count];
                        
                        [weakself.orderView.orderTableView reloadData];
                        weakself.orderView.userInteractionEnabled = YES;
                    });
                }else{
                    NSArray *arr = obj[@"data"][@"order"];
                    for (NSDictionary *dic in arr) {
                        OrderListModel *om = [[OrderListModel alloc] initWithDictionary:dic error:nil];
                        [weakself.orderModelsArray addObject:om];
                    }
                    weakself.orderView.orderListArray = weakself.orderModelsArray;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        weakself.orderView.resultNumLB.text = [NSString stringWithFormat:@"共%ld条",weakself.orderModelsArray.count];
                        
                        [weakself.orderView.orderTableView reloadData];
                        weakself.orderView.userInteractionEnabled = YES;
                        
                    });
                }
            }else{
                if (![code isEqualToString:@"39999"]) {
                    NSString *mes = [NSString stringWithFormat:@"%@",obj[@"mes"]];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [Utils toastview:mes];
                        weakself.orderView.userInteractionEnabled = YES;
                        
                    });
                }
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (requestType == refreshing) {
                    [weakself.orderView.orderTableView.mj_header endRefreshing];
                }else{
                    [weakself.orderView.orderTableView.mj_footer endRefreshing];
                }
            });
            
        }
    }];
}


@end
