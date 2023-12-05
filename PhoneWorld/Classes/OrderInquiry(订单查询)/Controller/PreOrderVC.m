//
//  PreOrderVC.m
//  PhoneWorld
//
//
// Created by 黄振元 on 2019/4/23.
// Copyright © 2019 xiyoukeji. All rights reserved.
//
// @class PreOrderVC
// @abstract 预订单VC
//

#import "PreOrderVC.h"

// Controllers
#import "PreOrderDetailVC.h"

// Model
#import "PreOrderListModel.h"

// Views
#import "PreOrderTBCell.h"
#import "LiangSelectView.h"
#import "NormalLeadCell.h"
#import "NormalInputCell.h"
#import "STableHeadView.h"


@interface PreOrderVC () <UITableViewDelegate, UITableViewDataSource>

//筛选框
@property (nonatomic) LiangSelectView *selectView;
//筛选条件
@property (nonatomic) int page;
@property (nonatomic) int linage;
@property (nonatomic) NSMutableDictionary *selectDictionary;

@property (strong, nonatomic) STableHeadView *headerView;
@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSMutableArray<PreOrderListModel *> *listModelArray;

@end


@implementation PreOrderVC

#pragma mark - View Controller LifeCyle
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.navigationItem.title = @"预订单";
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 初始化
    self.page = 1;
    self.linage = 10;
    self.listModelArray = @[].mutableCopy;
    self.selectDictionary = @{}.mutableCopy;
    
    [self configNav];
    
    [self createMain];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
//    [self requestOrderListWithType:refreshing];
    if (self.tableView) {
        [self.tableView.mj_header beginRefreshing];        
    }
}


#pragma mark - Override Methods


#pragma mark - Initial Methods


#pragma mark - Privater Methods

- (void)configNav {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"筛选" style:UIBarButtonItemStylePlain target:self action:@selector(selectAction)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:textfont16],NSForegroundColorAttributeName:[Utils colorRGB:@"#008bd5"]} forState:UIControlStateNormal];
}

- (void)createMain {
    STableHeadView *headerView = [[STableHeadView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 30)];
    headerView.backgroundColor = kSetColor(@"FAFAFA");
    self.headerView = headerView;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight - kTopHeight) style:UITableViewStylePlain];
    [tableView registerClass:PreOrderTBCell.class forCellReuseIdentifier:@"PreOrderTBCell"];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = kSetColor(@"FAFAFA");
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.tableHeaderView = headerView;
    tableView.tableFooterView = [[UIView alloc] init];
    tableView.estimatedRowHeight = 90;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    //筛选框查询事件
    @WeakObj(self)
    [self.selectView setSelectInquiryCallBack:^(id obj){
        @StrongObj(self);
        self.selectView.hidden = YES;
        [self showSelectDetailAction];
        [self.tableView.mj_header beginRefreshing];
    }];
    
    //筛选框重置事件
    [self.selectView setSelectResetCallBack:^(id obj){
        @StrongObj(self);
        self.selectDictionary = [NSMutableDictionary dictionary];
        self.headerView.centerLabel.text = @"";
        self.headerView.rightLabel.text = @"";
    }];
    
    // 添加刷新
    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @StrongObj(self);
        [self requestOrderListWithType:refreshing];
    }];
    
    tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        @StrongObj(self);
        [self requestOrderListWithType:loading];
    }];
}

// 请求数据
- (void)requestOrderListWithType:(requestType)requestType{
    self.tableView.userInteractionEnabled = NO;
    
    if (![[AFNetworkReachabilityManager sharedManager] isReachable]) {
        if (requestType == refreshing) {
            [self.tableView.mj_header endRefreshing];
        }else{
            [self.tableView.mj_footer endRefreshing];
        }
        self.tableView.userInteractionEnabled = YES;
        return;
    }
    
    if (requestType == refreshing) {
        self.page = 1;
        [self.listModelArray removeAllObjects];
        
    }else if(requestType == loading){
        self.page ++;
    }
    
    NSString *pageStr = [NSString stringWithFormat:@"%d",self.page];
    NSString *linageStr = [NSString stringWithFormat:@"%d",self.linage];
    [self.selectDictionary setObject:pageStr forKey:@"page"];
    [self.selectDictionary setObject:linageStr forKey:@"linage"];
    
    [self getDataList:requestType];
}

- (void)getDataList:(requestType)requestType{
    
    @WeakObj(self)
    [WebUtils agencySelectionAuditListWithParams:self.selectDictionary andCallback:^(id obj) {
        @StrongObj(self)
        dispatch_async(dispatch_get_main_queue(), ^{
            self.tableView.userInteractionEnabled = YES;
        });
        
        if ([obj isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = [NSDictionary dictionaryWithDictionary:obj];
            if ([dic[@"code"] integerValue] == 10000) {
                
                NSArray *tmpOrderArray = dic[@"data"][@"orders"];
                for (NSDictionary *subDic in tmpOrderArray) {
                    PreOrderListModel *model = [[PreOrderListModel alloc] initWithDictionary:subDic error:nil];
                    [self.listModelArray addObject:model];
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self showCountAndReloadTableViewAction];
                });
            } else {
                [self showWarningText:dic[@"mes"]];
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self endRefreshingWithType:requestType];
        });
    }];
}

- (void)endRefreshingWithType:(requestType)requestType {
    
//    if (self.page * self.linage > self.listModelArray.count) {
//        // 最后一页
//        [self.tableView.mj_footer endRefreshingWithNoMoreData];
//    }
    
    if (requestType == refreshing) {
        [self.tableView.mj_header endRefreshing];
    } else {
        [self.tableView.mj_footer endRefreshing];
    }
}

- (void)showCountAndReloadTableViewAction {
    NSString *countString = [NSString stringWithFormat:@"共%ld条",self.listModelArray.count];
    self.headerView.countLabel.attributedText = [Utils setTextColor:countString FontNumber:[UIFont systemFontOfSize:12] AndRange:NSMakeRange(1, countString.length - 2) AndColor:MainColor];

    [self.tableView reloadData];
}


#pragma mark - Target Methods

// 筛选操作
- (void)selectAction{
    self.selectView.hidden = NO;
}

// 展示筛选条件
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
    
        self.headerView.centerLabel.text = timeString;
    
    //orderStatusCode  ／  startCode
    NormalLeadCell *stateCell = [self.selectView.selectTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    if (stateCell.inputTextField.text.length > 0) {
        
        NSString *orderStatusCode = nil;
        
        NSString *orderState = stateCell.inputTextField.text;
        
        if ([orderState isEqualToString:@"待审核"]) {
            orderStatusCode = @"0";
            [self.selectDictionary setObject:orderStatusCode forKey:@"orderStatus"];
        } else if ([orderState isEqualToString:@"审核通过"]) {
            orderStatusCode = @"1";
            [self.selectDictionary setObject:orderStatusCode forKey:@"orderStatus"];
        } else if ([orderState isEqualToString:@"审核不通过"]) {
            orderStatusCode = @"2";
            [self.selectDictionary setObject:orderStatusCode forKey:@"orderStatus"];
        } else if ([orderState isEqualToString:@"发货"]) {
            orderStatusCode = @"3";
            [self.selectDictionary setObject:orderStatusCode forKey:@"orderStatus"];
        } else if ([orderState isEqualToString:@"取消订单"]) {
            orderStatusCode = @"4";
            [self.selectDictionary setObject:orderStatusCode forKey:@"orderStatus"];
        } else {
            [self.selectDictionary removeObjectForKey:@"orderStatus"];
        }
    }
    
    //number
    NormalInputCell *phoneCell = [self.selectView.selectTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    
    if (phoneCell.inputTextField.text.length > 0) {
        [self.selectDictionary setObject:phoneCell.inputTextField.text forKey:@"con_number"];
    } else {
        [self.selectDictionary removeObjectForKey:@"con_number"];
    }
    
    self.headerView.rightLabel.text = [NSString stringWithFormat:@"%@ %@",stateCell.inputTextField.text, phoneCell.inputTextField.text];
}


#pragma mark - Public Methods


#pragma mark - Notification Methods


#pragma mark - KVO Methods


#pragma mark - Getter Setter Methods

- (LiangSelectView *)selectView{
    if (_selectView == nil) {
        
        _selectView = [[LiangSelectView alloc] initWithFrame:CGRectZero andLeftTitlesArray:@[@"开始时间",@"截止时间",@"订单状态",@"手机号码"] andDataDictionary:@{@"开始时间":@"timePicker", @"截止时间":@"timePicker",@"手机号码":@"phoneNumber",@"订单状态":@[@"待审核",@"审核通过",@"审核不通过",@"发货",@"取消订单"]}];
        [self.view addSubview:_selectView];
        _selectView.hidden = YES;
        [_selectView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.mas_equalTo(0);
        }];
    }
    return _selectView;
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listModelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PreOrderTBCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PreOrderTBCell"];
    
    cell.listModel = self.listModelArray[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PreOrderListModel *model = self.listModelArray[indexPath.row];
    
    PreOrderDetailVC *vc = [[PreOrderDetailVC alloc] init];
    vc.orderId = model.numberId;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - MemoryWarning

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
