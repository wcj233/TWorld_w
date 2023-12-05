//
//  STopOrderViewController.m
//  PhoneWorld
//
//  Created by 刘岑颖 on 2017/6/6.
//  Copyright © 2017年 xiyoukeji. All rights reserved.
//

#import "STopOrderViewController.h"
#import "STopOrderView.h"
#import "LiangSelectView.h"
#import "RechargeListModel.h"//列表model
#import "NormalLeadCell.h"
#import "NormalInputCell.h"
#import "STopOrderDetailViewController.h"
#import "RightsOrderListModel.h"

@interface STopOrderViewController ()

@property (nonatomic) STopOrderView *orderView;
//筛选框
@property (nonatomic) LiangSelectView *selectView;
//筛选条件
@property (nonatomic) int page;
@property (nonatomic) int linage;
@property (nonatomic) NSMutableDictionary *selectDictionary;
//请求到的数据
@property (nonatomic) NSMutableArray *numberArray;

@end

@implementation STopOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"筛选" style:UIBarButtonItemStylePlain target:self action:@selector(selectAction)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:textfont16],NSForegroundColorAttributeName:[Utils colorRGB:@"#008bd5"]} forState:UIControlStateNormal];
    
    self.page = 1;
    self.linage = 10;
    self.selectDictionary = [NSMutableDictionary dictionary];
    
    self.orderView = [[STopOrderView alloc] init];
    [self.view addSubview:self.orderView];
    [self.orderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0);
    }];
    
    @WeakObj(self);
    
    //点击某一行跳转事件
    [self.orderView setSTopOrderCallBack:^(NSInteger row){
        @StrongObj(self);
//        RechargeListModel *model = self.numberArray[row];
        RightsOrderListModel *model = self.numberArray[row];
        STopOrderDetailViewController *vc = [[STopOrderDetailViewController alloc] init];
        vc.rightsOrderListModel = model;
        vc.title = [self.title stringByReplacingOccurrencesOfString:@"列表" withString:@"详情"];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    //筛选框查询事件
    [self.selectView setSelectInquiryCallBack:^(id obj){
        @StrongObj(self);
        self.selectView.hidden = YES;
        [self showSelectDetailAction];
        [self.orderView.contentTableView.mj_header beginRefreshing];
    }];
    
    //筛选框重置事件
    [self.selectView setSelectResetCallBack:^(id obj){
        @StrongObj(self);
        self.selectDictionary = [NSMutableDictionary dictionary];
        self.orderView.tableHeadView.centerLabel.text = @"";
        self.orderView.tableHeadView.rightLabel.text = @"";
    }];
    
    //添加刷新
    self.orderView.contentTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @StrongObj(self);
        [self getTopListActionWithType:refreshing];
    }];
    
    self.orderView.contentTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        @StrongObj(self);
        [self getTopListActionWithType:loading];
    }];
    
    [self.orderView.contentTableView.mj_header beginRefreshing];
}

#pragma mark - Network Method

- (void)getTopListActionWithType:(requestType)requestType{
    
    @WeakObj(self);
    self.orderView.userInteractionEnabled = NO;
    
    if (![[AFNetworkReachabilityManager sharedManager] isReachable]) {
        if (requestType == refreshing) {
            [self.orderView.contentTableView.mj_header endRefreshing];
        }else{
            [self.orderView.contentTableView.mj_footer endRefreshing];
        }
        self.orderView.userInteractionEnabled = YES;
        return;
    }
    
    if (requestType == refreshing) {
        self.page = 1;
        self.numberArray = [NSMutableArray array];
        
    }else if(requestType == loading){
        self.page ++;
    }
    
    NSString *pageStr = [NSString stringWithFormat:@"%d",self.page];
    NSString *linageStr = [NSString stringWithFormat:@"%d",self.linage];
    [self.selectDictionary setObject:pageStr forKey:@"page"];
    [self.selectDictionary setObject:linageStr forKey:@"linage"];
    self.selectDictionary[@"type"] = @"1";
    
//    if ([self.title isEqualToString:@"话费充值订单"]) {
//        [self.selectDictionary setObject:@"1" forKey:@"rechargeType"];
//    }else{
//        [self.selectDictionary setObject:@"0" forKey:@"rechargeType"];
//    }
    
//    [WebUtils requestTopListWithSelectDictionary:self.selectDictionary andCallBack:^(id obj) {
    [WebUtils agency_2019QueryOrdersWithParams:self.selectDictionary andCallback:^(id obj) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.orderView.userInteractionEnabled = YES;
            if (requestType == refreshing) {
                [self.orderView.contentTableView.mj_header endRefreshing];
            }else{
                [self.orderView.contentTableView.mj_footer endRefreshing];
            }
        });
        if ([obj isKindOfClass:[NSDictionary class]]) {
            @StrongObj(self);
            NSString *code = [NSString stringWithFormat:@"%@",obj[@"code"]];
            if ([code isEqualToString:@"10000"]) {
                
                NSArray *arr = obj[@"data"][@"orders"];
                for (NSDictionary *dic in arr) {
//                    RechargeListModel *model = [[RechargeListModel alloc] initWithDictionary:dic error:nil];
                    RightsOrderListModel *model = [RightsOrderListModel yy_modelWithJSON:dic];
                    [self.numberArray addObject:model];
                }
                
                self.orderView.dataArray = self.numberArray;
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    NSString *countString = [NSString stringWithFormat:@"共%ld条",self.numberArray.count];
                    self.orderView.tableHeadView.countLabel.attributedText = [Utils setTextColor:countString FontNumber:[UIFont systemFontOfSize:12] AndRange:NSMakeRange(1, countString.length - 2) AndColor:MainColor];
                    
                    [self.orderView.contentTableView reloadData];
                    self.orderView.userInteractionEnabled = YES;
                });
                
            }else if([code isEqualToString:@"39997"]){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.numberArray removeAllObjects];
                    self.orderView.dataArray = self.numberArray;
                    [self.orderView.contentTableView reloadData];
                    NSString *countString = [NSString stringWithFormat:@"共%ld条",self.numberArray.count];
                    self.orderView.tableHeadView.countLabel.attributedText = [Utils setTextColor:countString FontNumber:[UIFont systemFontOfSize:12] AndRange:NSMakeRange(1, countString.length - 2) AndColor:MainColor];
                    [self showWarningText:obj[@"mes"]];
                });
            }else{
                [self showWarningText:obj[@"mes"]];
            }
        }
    }];
}


#pragma mark - Method
//筛选操作
- (void)selectAction{
    self.selectView.hidden = NO;
}

//展示筛选条件
- (void)showSelectDetailAction{
    
    //startTime
    NormalLeadCell *beginCell = [self.selectView.selectTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    
    NSString *timeString = @"";
    
    if (beginCell.inputTextField.text.length > 0) {
        NSString *beginString = [beginCell.inputTextField.text stringByReplacingOccurrencesOfString:@"-" withString:@"."];
        
        timeString = [timeString stringByAppendingString:[NSString stringWithFormat:@"%@-",beginString]];
        
        [self.selectDictionary setObject:beginCell.inputTextField.text forKey:@"startDate"];
    }else{
        [self.selectDictionary removeObjectForKey:@"startDate"];
    }
    
    //endTime
    NormalLeadCell *endCell = [self.selectView.selectTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    if (endCell.inputTextField.text.length > 0) {
        NSString *endString = [endCell.inputTextField.text stringByReplacingOccurrencesOfString:@"-" withString:@"."];
        
        timeString = [timeString stringByAppendingString:endString];
        
        [self.selectDictionary setObject:endCell.inputTextField.text forKey:@"endDate"];
    }else{
        [self.selectDictionary removeObjectForKey:@"endDate"];
    }
    
    self.orderView.tableHeadView.centerLabel.text = timeString;
    
    if ([self.title isEqualToString:@"话费充值订单"]) {
        //number
        NormalInputCell *phoneCell = [self.selectView.selectTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
        if (phoneCell.inputTextField.text.length > 0) {
            [self.selectDictionary setObject:phoneCell.inputTextField.text forKey:@"number"];
        }else{
            [self.selectDictionary removeObjectForKey:@"number"];
        }
        
        self.orderView.tableHeadView.rightLabel.text = phoneCell.inputTextField.text;

    }
}

#pragma mark - LazyLoading -------------

- (LiangSelectView *)selectView{
    if (_selectView == nil) {
        if ([self.title isEqualToString:@"话费充值订单"]) {
            _selectView = [[LiangSelectView alloc] initWithFrame:CGRectZero andLeftTitlesArray:@[@"开始时间",@"截止时间",@"手机号码"] andDataDictionary:@{@"开始时间":@"timePicker", @"截止时间":@"timePicker",@"手机号码":@"phoneNumber"}];
        }else{
            _selectView = [[LiangSelectView alloc] initWithFrame:CGRectZero andLeftTitlesArray:@[@"开始时间",@"截止时间"] andDataDictionary:@{@"开始时间":@"timePicker", @"截止时间":@"timePicker"}];
        }
        [self.view addSubview:_selectView];
        _selectView.hidden = YES;
        [_selectView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.mas_equalTo(0);
        }];
    }
    return _selectView;
}

@end
