//
//  SCardOrderViewController.m
//  PhoneWorld
//
//  Created by 刘岑颖 on 2017/6/5.
//  Copyright © 2017年 xiyoukeji. All rights reserved.
//

#import "SCardOrderViewController.h"
#import "SCardOrderView.h"
#import "LiangSelectView.h"
#import "NormalLeadCell.h"
#import "NormalInputCell.h"
#import "OrderListModel.h"
#import "CardTransferListModel.h"
#import "SCardOrderDetailViewController.h"

//2019年08月
#import "WriteCardNumberDetails.h"

@interface SCardOrderViewController ()

@property (nonatomic) SCardOrderView *orderView;
//请求到的数据
@property (nonatomic) NSMutableArray *numberArray;
//筛选框
@property (nonatomic) LiangSelectView *selectView;
//筛选条件
@property (nonatomic) int page;
@property (nonatomic) int linage;
@property (nonatomic) NSMutableDictionary *selectDictionary;

@end

@implementation SCardOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    switch (self.type) {
        case ChengKa:
        {
            self.title = @"成卡开户订单";
        }
            break;
        case BaiKa:
        {
            self.title = @"白卡开户订单";
        }
            break;
        case GuoHu:
        {
            self.title = @"过户订单";
        }
            break;
        case BuKa:
        {
            self.title = @"补卡订单";
        }
            break;
        case XieKa:{
            self.title = @"写卡激活订单";
        }
            break;
    }
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"筛选" style:UIBarButtonItemStylePlain target:self action:@selector(selectAction)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:textfont16],NSForegroundColorAttributeName:[Utils colorRGB:@"#008bd5"]} forState:UIControlStateNormal];
    
    //初始化
    self.page = 1;
    self.linage = 10;
    self.selectDictionary = [NSMutableDictionary dictionary];
    
    //界面
    self.orderView = [[SCardOrderView alloc] init];
    [self.view addSubview:self.orderView];
    [self.orderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0);
    }];
    
    @WeakObj(self);
    
    //点击某一行
    [self.orderView setSCardOrderCallBack:^(NSInteger row){
        @StrongObj(self);
        
        SCardOrderDetailViewController *vc = [[SCardOrderDetailViewController alloc] init];
        vc.type = self.type;
        if (self.type == ChengKa || self.type == BaiKa) {
            OrderListModel *orderModel = self.numberArray[row];
            vc.order_id = orderModel.orderNo;
            
        }
        
        if (self.type == GuoHu || self.type == BuKa) {
            CardTransferListModel *listModel = self.numberArray[row];
            vc.order_id = listModel.order_id;
            vc.cardTransferListModel = listModel;
        }
        
        if (self.type == XieKa){
            WriteCardModel *model = self.numberArray[row];
            vc.order_id = model.ePreNo;
            vc.writeCardModel = model;
            
        }
        
        vc.title = [self.title stringByReplacingOccurrencesOfString:@"订单" withString:@"详情"];
        
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
        [self requestOrderListWithType:refreshing];
    }];
    
    self.orderView.contentTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        @StrongObj(self);
        [self requestOrderListWithType:loading];
    }];
    
    [self.orderView.contentTableView.mj_header beginRefreshing];
}

#pragma mark - Network Method 

//请求数据
- (void)requestOrderListWithType:(requestType)requestType{
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
    
    //type
    switch (self.type) {
        case ChengKa:
            [self.selectDictionary setObject:@"SIM" forKey:@"type"];
            break;
        case BaiKa:
            [self.selectDictionary setObject:@"ESIM" forKey:@"type"];
            break;
        case GuoHu:
            [self.selectDictionary setObject:@"0" forKey:@"type"];
            break;
        case BuKa:
            [self.selectDictionary setObject:@"1" forKey:@"type"];
            break;
    }
    if (self.type == XieKa) {
        [self getWriteCardActivationWithRequestType:requestType];
    }else{
        if (self.type == ChengKa || self.type == BaiKa) {
            [self getChengkaOrBaikaDataActionWithRequestType:requestType];
        }else{
            [self getGuohuOrBukaDataActionWithRequestType:requestType];
        }
    }
}

- (void)getChengkaOrBaikaDataActionWithRequestType:(requestType)requestType{
    @WeakObj(self);
    [WebUtils requestCardOrderListWithSelectDictionary:self.selectDictionary andCallBack:^(id obj) {
        
        self.orderView.userInteractionEnabled = YES;
        
        if ([obj isKindOfClass:[NSDictionary class]]) {
            @StrongObj(self);
            NSString *code = [NSString stringWithFormat:@"%@",obj[@"code"]];
            if ([code isEqualToString:@"10000"]) {
                
                NSArray *arr = obj[@"data"][@"order"];
                for (NSDictionary *dic in arr) {
                    OrderListModel *om = [[OrderListModel alloc] initWithDictionary:dic error:nil];
                    [self.numberArray addObject:om];
                }
                
                self.orderView.dataArray = self.numberArray;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self showCountAndReloadTableViewAction];
                });
                
            }else{
                [self showWarningText:obj[@"mes"]];
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self endRefreshingWithType:requestType];
        });
        
    }];
}

- (void)getGuohuOrBukaDataActionWithRequestType:(requestType)requestType{
    @WeakObj(self);
    [WebUtils requestTransferAndRepairCardOrderListWithSelectDictionary:self.selectDictionary andCallBack:^(id obj) {
        
        self.orderView.userInteractionEnabled = YES;

        if ([obj isKindOfClass:[NSDictionary class]]) {
            @StrongObj(self);
            NSString *code = [NSString stringWithFormat:@"%@",obj[@"code"]];
            if ([code isEqualToString:@"10000"]) {
                
                NSArray *arr = obj[@"data"][@"order"];
                for (NSDictionary *dic in arr) {
                    CardTransferListModel *model = [[CardTransferListModel alloc] initWithDictionary:dic error:nil];
                    [self.numberArray addObject:model];
                }
                
                self.orderView.dataArray = self.numberArray;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self showCountAndReloadTableViewAction];
                });
                
            }else{
                [self showWarningText:obj[@"mes"]];
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self endRefreshingWithType:requestType];
        });
        
    }];
}

- (void)getWriteCardActivationWithRequestType:(requestType)requestType{
    @WeakObj(self);
    [WebUtils agency_2019ePreNumberListWithParams:self.selectDictionary andCallback:^(id obj) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.orderView.userInteractionEnabled = YES;
        });
        
        if ([obj isKindOfClass:[NSDictionary class]]) {
            @StrongObj(self);
            NSString *code = [NSString stringWithFormat:@"%@",obj[@"code"]];
            if ([code isEqualToString:@"10000"]) {
                
                NSArray *arr = obj[@"data"][@"numbers"];
                for (NSDictionary *dic in arr) {
                    NSError *error = nil;
                    WriteCardModel *model = [[WriteCardModel alloc] initWithDictionary:dic error:&error];
                    [self.numberArray addObject:model];
                }
                
                self.orderView.dataArray = self.numberArray;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self showCountAndReloadTableViewAction];
                });
                
            }else{
                [self showWarningText:obj[@"mes"]];
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self endRefreshingWithType:requestType];
        });
        
    }];
}

- (void)endRefreshingWithType:(requestType)requestType{
    if (requestType == refreshing) {
        [self.orderView.contentTableView.mj_header endRefreshing];
    }else{
        [self.orderView.contentTableView.mj_footer endRefreshing];
    }
}

- (void)showCountAndReloadTableViewAction{
    NSString *countString = [NSString stringWithFormat:@"共%ld条",self.numberArray.count];
    self.orderView.tableHeadView.countLabel.attributedText = [Utils setTextColor:countString FontNumber:[UIFont systemFontOfSize:12] AndRange:NSMakeRange(1, countString.length - 2) AndColor:MainColor];
    
    [self.orderView.contentTableView reloadData];
}

#pragma mark - Method ------------------------------------
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
        
        [self.selectDictionary setObject:beginCell.inputTextField.text forKey:@"startTime"];
    }
    //endTime
    NormalLeadCell *endCell = [self.selectView.selectTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    if (endCell.inputTextField.text.length > 0) {
        NSString *endString = [endCell.inputTextField.text stringByReplacingOccurrencesOfString:@"-" withString:@"."];
        
        timeString = [timeString stringByAppendingString:endString];
        
        [self.selectDictionary setObject:endCell.inputTextField.text forKey:@"endTime"];
    }
    
    self.orderView.tableHeadView.centerLabel.text = timeString;
    
    //orderStatusCode  ／  startCode
    NormalLeadCell *stateCell = [self.selectView.selectTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    if (stateCell.inputTextField.text.length > 0) {
        
        NSString *orderStatusCode = nil;
        
        NSString *orderState = stateCell.inputTextField.text;
        
        if (self.type == ChengKa || self.type == BaiKa) {
            if ([orderState isEqualToString:@"已提交"]) {
                orderStatusCode = @"PENDING";
            }else if ([orderState isEqualToString:@"等待中"]) {
                orderStatusCode = @"WAITING";
            }else if ([orderState isEqualToString:@"成功"]) {
                orderStatusCode = @"SUCCESS";
            }else if ([orderState isEqualToString:@"失败"]) {
                orderStatusCode = @"FAIL";
            }else if ([orderState isEqualToString:@"已取消"]) {
                orderStatusCode = @"CANCLE";
            }else if ([orderState isEqualToString:@"已关闭"]) {
                orderStatusCode = @"CLOSED";
            }else{
                [self.selectDictionary removeObjectForKey:@"orderStatusCode"];
            }
            
            [self.selectDictionary setObject:orderStatusCode forKey:@"orderStatusCode"];
        }else if (self.type == XieKa){
            
            if ([orderState isEqualToString:@"待开户"]) {
                orderStatusCode = @"0";
            }
            if ([orderState isEqualToString:@"已开户"]) {
                orderStatusCode = @"1";
            }
            
            [self.selectDictionary setObject:orderStatusCode forKey:@"preState"];
        }else{
            
            if ([orderState isEqualToString:@"待审核"]) {
                orderStatusCode = @"1";
            }
            if ([orderState isEqualToString:@"审核通过"]) {
                orderStatusCode = @"2";
            }
            if ([orderState isEqualToString:@"审核不通过"]) {
                orderStatusCode = @"3";
            }
            [self.selectDictionary setObject:orderStatusCode forKey:@"startCode"];
            if ([orderState isEqualToString:@"全部"]) {
                [self.selectDictionary removeObjectForKey:@"startCode"];
            }
        }
    }
    
    //number
    NormalInputCell *phoneCell = [self.selectView.selectTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];

    if (phoneCell.inputTextField.text.length > 0) {
        [self.selectDictionary setObject:phoneCell.inputTextField.text forKey:@"number"];
    }else{
        [self.selectDictionary removeObjectForKey:@"number"];
    }
    
    self.orderView.tableHeadView.rightLabel.text = [NSString stringWithFormat:@"%@ %@",stateCell.inputTextField.text, phoneCell.inputTextField.text];

}

#pragma mark - LazyLoading -------------

- (LiangSelectView *)selectView{
    if (_selectView == nil) {
        
        if (self.type == ChengKa || self.type == BaiKa) {
            _selectView = [[LiangSelectView alloc] initWithFrame:CGRectZero andLeftTitlesArray:@[@"开始时间",@"截止时间",@"订单状态",@"手机号码"] andDataDictionary:@{@"开始时间":@"timePicker", @"截止时间":@"timePicker",@"手机号码":@"phoneNumber",@"订单状态":@[@"已提交",@"等待中",@"成功",@"失败",@"已取消",@"已关闭"]}];
        }else if(self.type == XieKa){
            _selectView = [[LiangSelectView alloc] initWithFrame:CGRectZero andLeftTitlesArray:@[@"开始时间",@"截止时间",@"订单状态",@"手机号码"] andDataDictionary:@{@"开始时间":@"timePicker", @"截止时间":@"timePicker",@"手机号码":@"phoneNumber",@"订单状态":@[@"待开户",@"已开户"]}];
        }else{
            _selectView = [[LiangSelectView alloc] initWithFrame:CGRectZero andLeftTitlesArray:@[@"开始时间",@"截止时间",@"订单状态",@"手机号码"] andDataDictionary:@{@"开始时间":@"timePicker", @"截止时间":@"timePicker",@"手机号码":@"phoneNumber",@"订单状态":@[@"待审核",@"审核通过",@"审核不通过"]}];
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
