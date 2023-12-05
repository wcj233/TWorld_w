//
//  LTopUpVC.m
//  PhoneWorld
//
//  Created by 刘岑颖 on 17/2/27.
//  Copyright © 2017年 xiyoukeji. All rights reserved.
//

#import "LTopUpVC.h"
#import "MainNavigationController.h"
#import "MainTabBarController.h"

@interface LTopUpVC ()

@property (nonatomic) int page;
@property (nonatomic) int linage;

@end

@implementation LTopUpVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.page = 1;
    self.linage = 10;
    
    self.orderModelsArray = [NSMutableArray array];
    
    self.orderView = [[OrderTwoView alloc] init];
    [self.view addSubview:self.orderView];
    [self.orderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0);
    }];
    
    __block __weak LTopUpVC *weakself = self;
    
    self.orderView.orderTwoTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakself requestOrderListWithType:refreshing];
    }];
    
    self.orderView.orderTwoTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakself requestOrderListWithType:loading];
    }];
}

- (void)requestOrderListWithType:(requestType)requestType{
    
    self.orderView.userInteractionEnabled = NO;
    
    __block __weak LTopUpVC *weakself = self;
    
    if (![[AFNetworkReachabilityManager sharedManager] isReachable]) {
        if (requestType == refreshing) {
            [weakself.orderView.orderTwoTableView.mj_header endRefreshing];
        }else{
            [weakself.orderView.orderTwoTableView.mj_footer endRefreshing];
        }
        self.orderView.userInteractionEnabled = YES;
        return;
    }
    
    NSString *requestString = @"没有数据";
    if (requestType == refreshing) {
        self.page = 1;
        self.orderModelsArray = [NSMutableArray array];
    }else{
        self.page ++;
        requestString = @"已经是最后一页";
    }
    
    NSString *phoneNumber = @"无";
    NSString *beginDate = @"无";
    NSString *endDate = @"无";
    if (self.inquiryConditionArray.count > 0) {
        phoneNumber = [NSString stringWithFormat:@"%@",weakself.inquiryConditionArray.lastObject];
        beginDate = [NSString stringWithFormat:@"%@",weakself.inquiryConditionArray.firstObject];
        endDate = [NSString stringWithFormat:@"%@",weakself.inquiryConditionArray[1]];
    }
    NSString *pageStr = [NSString stringWithFormat:@"%d",self.page];
    NSString *linageStr = [NSString stringWithFormat:@"%d",self.linage];
    
    [WebUtils requestRechargeListWithNumber:phoneNumber andRechargeType:@"1" andStartTime:beginDate andEndTime:endDate andPage:pageStr andLinage:linageStr andCallBack:^(id obj) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            
            NSString *code = [NSString stringWithFormat:@"%@",obj[@"code"]];
            if ([code isEqualToString:@"10000"]) {
                
                int count = [NSString stringWithFormat:@"%@",obj[@"data"][@"count"]].intValue;
                if (count == 0) {
                    if (requestType == refreshing) {
                        weakself.orderModelsArray = nil;
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (requestType == loading) {
                            [Utils toastview:requestString];
                        }
                        weakself.orderView.resultNumLB.text = [NSString stringWithFormat:@"共%ld条",weakself.orderModelsArray.count];
                        weakself.orderView.orderListArray = weakself.orderModelsArray;
                        
                        [weakself.orderView.orderTwoTableView reloadData];
                        weakself.orderView.userInteractionEnabled = YES;
                    });
                    
                }else{
                    NSArray *orderArr = obj[@"data"][@"order"];
                    for (NSDictionary *dic in orderArr) {
                        RechargeListModel *rm = [[RechargeListModel alloc] initWithDictionary:dic error:nil];
                        [weakself.orderModelsArray addObject:rm];
                    }
                    weakself.orderView.orderListArray = weakself.orderModelsArray;
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weakself.orderView.orderTwoTableView reloadData];
                        weakself.orderView.resultNumLB.text = [NSString stringWithFormat:@"共%ld条",weakself.orderModelsArray.count];
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
                    [weakself.orderView.orderTwoTableView.mj_header endRefreshing];
                }else{
                    [weakself.orderView.orderTwoTableView.mj_footer endRefreshing];
                }
            });
        }
    }];
}

@end
