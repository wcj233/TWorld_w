//
//  MemberOrderListVC.m
//  PhoneWorld
//
//  Created by Allen on 2019/12/12.
//  Copyright © 2019 xiyoukeji. All rights reserved.
//

#import "MemberOrderListVC.h"
#import "LiangSelectView.h"
#import "NormalLeadCell.h"
#import "NormalInputCell.h"
#import "STableHeadView.h"
#import "LProductOrderCell.h"
#import "RightsOrderListModel.h"
#import "MemberOrderDetailsVC.h"

@interface MemberOrderListVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSString *type;

@property (nonatomic, strong) STableHeadView *tableHeadView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic) LiangSelectView *selectView;
@property (nonatomic) NSMutableDictionary *selectDictionary;

@property (nonatomic, assign) NSInteger pageNum;

@end

@implementation MemberOrderListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.selectDictionary = [NSMutableDictionary dictionary];
    
    [self setUI];
    
    [self loadData];
    
}

- (instancetype)initWithType:(NSString *)type{
    if (self = [super init]) {
        _type = type;
    }
    return self;
}

- (void)setUI{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = self.tableHeadView;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.estimatedRowHeight = 44;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.tableView];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.leading.trailing.mas_equalTo(self.view);
    }];
    [self.tableView registerClass:[LProductOrderCell class] forCellReuseIdentifier:@"LProductOrderCell"];
    MJRefreshNormalHeader * header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    header.stateLabel.hidden = YES;
    self.tableView.mj_header = header;
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(reloadMoreData)];
    self.tableView.mj_footer = footer;
    
    
    @WeakObj(self)
    //筛选框查询事件
    [self.selectView setSelectInquiryCallBack:^(id obj){
        @StrongObj(self);
        self.selectView.hidden = YES;
        [self showSelectDetailAction];
        [self loadData];
    }];

    //筛选框重置事件
    [self.selectView setSelectResetCallBack:^(id obj){
        @StrongObj(self);
        self.selectDictionary = [NSMutableDictionary dictionary];
        self.tableHeadView.centerLabel.text = @"";
        self.tableHeadView.rightLabel.text = @"";
        [self loadData];
    }];
}

- (void)loadData{
    self.pageNum = 1;
    [self downloadData];
}

- (void)reloadMoreData {
    self.pageNum++;
    [self downloadData];
}

- (void)downloadData{
    @WeakObj(self)
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:self.selectDictionary];
    params[@"type"] = self.type;
    params[@"page"] = @(self.pageNum);
    params[@"linage"] = @(20);
    [WebUtils agency_2019QueryOrdersWithParams:params andCallback:^(id obj) {
        @StrongObj(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self hideWaitView];
            [self.tableView.mj_header endRefreshing];
            if ([obj isKindOfClass:[NSDictionary class]]) {
                NSString *code = [NSString stringWithFormat:@"%@",obj[@"code"]];
                if ([code isEqualToString:@"10000"]) {
                    
                    if (self.pageNum == 1) {
                        [self.dataArray removeAllObjects];
                    }
                    
                    [obj[@"data"][@"orders"] enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull subDic, NSUInteger idx, BOOL * _Nonnull stop) {
                        RightsOrderListModel *model = [RightsOrderListModel yy_modelWithDictionary:subDic];
                        [self.dataArray addObject:model];
                    }];
                    
                    if (self.dataArray.count < 20 * self.pageNum) {
                        [self.tableView.mj_footer endRefreshingWithNoMoreData];
                    } else {
                        [self.tableView.mj_footer endRefreshing];
                    }
                    
                    self.tableHeadView.countLabel.text = [NSString stringWithFormat:@"共%lu条", (unsigned long)self.dataArray.count];
                    
                    [self.tableView reloadData];
                    
                }else if ([code isEqualToString:@"39997"]){
                    [self showWarningText:obj[@"mes"]];
                    
                    if (self.pageNum == 1) {
                        [self.dataArray removeAllObjects];
                        
                        [self.tableView.mj_footer endRefreshing];
                        
                        [self.tableView reloadData];
                    }
                    
                    self.tableHeadView.countLabel.text = [NSString stringWithFormat:@"共%lu条", (unsigned long)self.dataArray.count];
                    
                }else{
                    [self showWarningText:obj[@"mes"]];
                }
            }else{
                [self showWarningText:@"请求出错"];
            }
        });
        
    }];
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (STableHeadView *)tableHeadView{
    if (_tableHeadView == nil) {
        _tableHeadView = [[STableHeadView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 30)];
    }
    return _tableHeadView;
}

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
        [self.selectDictionary removeObjectForKey:@"beginTime"];
    }
    
    //endTime
    NormalLeadCell *endCell = [self.selectView.selectTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    if (endCell.inputTextField.text.length > 0) {
        NSString *endString = [endCell.inputTextField.text stringByReplacingOccurrencesOfString:@"-" withString:@"."];
        
        timeString = [timeString stringByAppendingString:endString];
        
        [self.selectDictionary setObject:endCell.inputTextField.text forKey:@"endDate"];
    }else{
        [self.selectDictionary removeObjectForKey:@"endTime"];
    }
    
    self.tableHeadView.centerLabel.text = timeString;
    //number
    NormalInputCell *phoneCell = [self.selectView.selectTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    if (phoneCell.inputTextField.text.length > 0) {
        [self.selectDictionary setObject:phoneCell.inputTextField.text forKey:@"number"];
    }else{
        [self.selectDictionary removeObjectForKey:@"number"];
    }
    
    self.tableHeadView.rightLabel.text = phoneCell.inputTextField.text;
}

#pragma mark - LazyLoading -------------

- (LiangSelectView *)selectView{
    if (_selectView == nil) {
        _selectView = [[LiangSelectView alloc] initWithFrame:CGRectZero andLeftTitlesArray:@[@"开始时间",@"截止时间",@"手机号码"] andDataDictionary:@{@"开始时间":@"timePicker", @"截止时间":@"timePicker",@"手机号码":@"phoneNumber"}];
        [self.view addSubview:_selectView];
        _selectView.hidden = YES;
        [_selectView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.mas_equalTo(0);
        }];
    }
    return _selectView;
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LProductOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LProductOrderCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[LProductOrderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LProductOrderCell"];
    }
    cell.rightsOrderListModel = self.dataArray[indexPath.section];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 4;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 112;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    RightsOrderListModel *model = self.dataArray[indexPath.section];
    MemberOrderDetailsVC *vc = [[MemberOrderDetailsVC alloc] initWithOrderNo:model.orderNo];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
