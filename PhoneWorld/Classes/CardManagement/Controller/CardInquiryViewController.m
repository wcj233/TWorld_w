//
//  CardInquiryViewController.m
//  PhoneWorld
//
//  Created by 刘岑颖 on 16/10/20.
//  Copyright © 2016年 xiyoukeji. All rights reserved.
//

#import "CardInquiryViewController.h"
#import "CardTransferListModel.h"
#import "TransferDetailViewController.h"
#import "RepairCardDetailViewController.h"

static CardInquiryViewController *_cardInquiryViewController;

@interface CardInquiryViewController ()

@property (nonatomic) int page;
@property (nonatomic) int linage;
@property (nonatomic) NSMutableArray *listArray;

@end

@implementation CardInquiryViewController

+ (CardInquiryViewController *)sharedCardInquiryViewController{
    if (_cardInquiryViewController == nil) {
        _cardInquiryViewController = [[CardInquiryViewController alloc] init];
    }
    return _cardInquiryViewController;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if([[AFNetworkReachabilityManager sharedManager] isReachable]){
        [self.inquiryView.contentView.orderTableView.mj_header beginRefreshing];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"过户、补卡状态查询";
    self.navigationItem.backBarButtonItem = [Utils returnBackButton];
    
    //初始化数据
    self.page = 1;
    self.linage = 10;
    self.listArray = [NSMutableArray array];
    self.stateCode = @"无";//审核
    
    //界面
    self.inquiryView = [[CardInquiryView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight - 64)];
    [self.view addSubview:self.inquiryView];
    
    @WeakObj(self);
    [self.inquiryView.contentView setOrderViewCallBack:^(NSInteger section) {
        @StrongObj(self);
        //过户和补卡返回的list字段一致
        CardTransferListModel *listModel = self.listArray[section];
        if ([listModel.state isEqualToString:@"过户"]) {
            TransferDetailViewController *vc = [TransferDetailViewController new];
            vc.hidesBottomBarWhenPushed = YES;
            vc.listModel = listModel;
            vc.modelId = listModel.order_id;
            [self.navigationController pushViewController:vc animated:YES];
        }else{//补卡
            RepairCardDetailViewController *vc = [RepairCardDetailViewController new];
            vc.cardModel = listModel;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    }];
    
    self.inquiryView.contentView.orderTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @StrongObj(self);
        [self requestAllInfosWithType:refreshing];
    }];
    
    self.inquiryView.contentView.orderTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        @StrongObj(self);
        [self requestAllInfosWithType:loading];
    }];
    
}

- (void)requestAllInfosWithType:(requestType)type{
    
    self.view.userInteractionEnabled = NO;
    @WeakObj(self);
    //判断网络
    if(![[AFNetworkReachabilityManager sharedManager] isReachable]){
        if (type == refreshing) {
            [self.inquiryView.contentView.orderTableView.mj_header endRefreshing];
        }else{
            [self.inquiryView.contentView.orderTableView.mj_footer endRefreshing];
        }
        self.view.userInteractionEnabled = YES;

    }
    
    NSString *requestString = @"没有数据";
    if (type == refreshing) {
        self.page = 1;
        self.listArray = [NSMutableArray array];
    }else{
        self.page ++;
        requestString = @"已经是最后一页";
    }
    
    NSString *beginDate = @"无";
    NSString *endDate = @"无";
    NSString *phoneNumber = @"无";
    NSString *orderState = @"0";//补卡  过户
    
    NSString *state = @"过户";
    
    if (self.inquiryConditionArray.count > 0) {
        beginDate = [NSString stringWithFormat:@"%@",self.inquiryConditionArray.firstObject];
        endDate = [NSString stringWithFormat:@"%@",self.inquiryConditionArray[1]];
        phoneNumber = [NSString stringWithFormat:@"%@",self.inquiryConditionArray.lastObject];
        NSString *stateGet = [NSString stringWithFormat:@"%@",self.inquiryConditionArray[2]];//补卡 过户
        
        if ([stateGet isEqualToString:@"补卡"]) {
            orderState = @"1";
            state = @"补卡";
        }else{
            orderState = @"0";
        }
    }
    
    if ([self.stateCode isEqualToString:@"待审核"]) {
        self.stateCode = @"1";
    }
    if ([self.stateCode isEqualToString:@"审核通过"]) {
        self.stateCode = @"2";
    }
    if ([self.stateCode isEqualToString:@"审核不通过"]) {
        self.stateCode = @"3";
    }
    if ([self.stateCode isEqualToString:@"全部"]) {
        self.stateCode = @"无";
    }
    
    NSString *pageStr = [NSString stringWithFormat:@"%d",self.page];
    NSString *linageStr = [NSString stringWithFormat:@"%d",self.linage];
    
    [WebUtils requestCardTransferListWithNumber:phoneNumber andType:orderState andStartTime:beginDate andEndTime:endDate andStartCode:self.stateCode andStartName:orderState andPage:pageStr andLinage:linageStr andCallBack:^(id obj) {
        @StrongObj(self);
        if ([obj isKindOfClass:[NSDictionary class]]) {
            
            NSString *code = [NSString stringWithFormat:@"%@",obj[@"code"]];
            
            if ([code isEqualToString:@"10000"]) {
                
                int count = [NSString stringWithFormat:@"%@",obj[@"data"][@"count"]].intValue;
                if (count == 0) {
                    if (type == loading) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [Utils toastview:requestString];
                        });
                    }
                    
                }else{
                    NSArray *orderArr = obj[@"data"][@"order"];
                    for (NSDictionary *dic in orderArr) {
                        CardTransferListModel *rm = [[CardTransferListModel alloc] initWithDictionary:dic error:nil];
                        rm.state = state;
                        [self.listArray addObject:rm];
                    }
                    
                }
                
                self.inquiryView.contentView.orderListArray = self.listArray;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    self.inquiryView.contentView.resultNumLB.text = [NSString stringWithFormat:@"共%ld条",self.listArray.count];
                    [self.inquiryView.contentView.orderTableView reloadData];
                    
                });
                
            }else{
                [self showWarningText:obj[@"mes"]];
            }
        }
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.view.userInteractionEnabled = YES;

            if (type == refreshing) {
                [self.inquiryView.contentView.orderTableView.mj_header endRefreshing];
            }else{
                [self.inquiryView.contentView.orderTableView.mj_footer endRefreshing];
            }
        });
        
    }];
    
}

@end
