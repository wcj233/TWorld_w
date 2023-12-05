//
//  AgentWhiteRecordViewController.m
//  PhoneWorld
//
//  Created by 刘岑颖 on 2017/5/15.
//  Copyright © 2017年 xiyoukeji. All rights reserved.
//

#import "AgentWhiteRecordViewController.h"

#import "AgentWhiteRecordView.h"

#import "LiangSelectView.h"
#import "ChooseTypeCell.h"
#import "NormalInputCell.h"
#import "NormalLeadCell.h"
#import "AgentWhiteRecordDetailViewController.h"

@interface AgentWhiteRecordViewController ()

@property (nonatomic) AgentWhiteRecordView *listView;

@property (nonatomic) NSArray *leftTitlesArray;
@property (nonatomic) NSDictionary *contentDictionary;

@property (nonatomic) LiangSelectView *selectView;

//筛选条件
@property (nonatomic) int page;
@property (nonatomic) int linage;
@property (nonatomic) NSMutableDictionary *selectDictionary;

//得到的数据
@property (nonatomic) NSMutableArray<NSDictionary *> *numberArray;

@end

@implementation AgentWhiteRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"预开户记录";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"筛选" style:UIBarButtonItemStylePlain target:self action:@selector(selectAction)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:textfont16],NSForegroundColorAttributeName:[Utils colorRGB:@"#008bd5"]} forState:UIControlStateNormal];
    
    self.listView = [[AgentWhiteRecordView alloc] init];
    [self.view addSubview:self.listView];
    [self.listView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0);
    }];
    
    //初始化
    self.page = 1;
    self.linage = 20;
    self.selectDictionary = [NSMutableDictionary dictionary];
    
    self.leftTitlesArray = @[@"类型",@"手机号码",@"开始时间",@"结束时间"];
    self.contentDictionary = @{@"类型":@[@"全部",@"待开户",@"已开户"],@"手机号码":@"phoneNumber",@"开始时间":@"timePicker",@"结束时间":@"timePicker"};
    
    @WeakObj(self);
    //选择某一行的点击事件
    [self.listView setAgentWhiteRecordCallBack:^(NSInteger row){
        @StrongObj(self);
        
        NSDictionary *currentDic = self.numberArray[row];
        AgentWhiteRecordDetailViewController *vc = [[AgentWhiteRecordDetailViewController alloc] init];
        vc.receivedDictionary = currentDic;
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    //查询
    [self.selectView setSelectInquiryCallBack:^(id obj){
        @StrongObj(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showResultAction];
            self.selectView.hidden = YES;
            [self.listView.contentTableView.mj_header beginRefreshing];
        });
    }];
    
    //重置
    [self.selectView setSelectResetCallBack:^(id obj){
    }];
    
    //添加刷新
    self.listView.contentTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @StrongObj(self);
        [self getRecordActionWithType:refreshing];
    }];
    
    self.listView.contentTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        @StrongObj(self);
        [self getRecordActionWithType:loading];
    }];
    
    [self.listView.contentTableView.mj_header beginRefreshing];
}

- (void)selectAction{
    //筛选操作
    self.selectView.hidden = NO;
}

- (LiangSelectView *)selectView{
    if (_selectView == nil) {
        _selectView = [[LiangSelectView alloc] initWithFrame:CGRectZero andLeftTitlesArray:self.leftTitlesArray andDataDictionary:self.contentDictionary];
        [self.view addSubview:_selectView];
        _selectView.hidden = YES;
        [_selectView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.mas_equalTo(0);
        }];
    }
    return _selectView;
}

//请求数据--------------

- (void)getRecordActionWithType:(requestType)type{
    self.view.userInteractionEnabled = NO;
    
    //判断网络
    if(![[AFNetworkReachabilityManager sharedManager] isReachable]){
        if (type == refreshing) {
            [self.listView.contentTableView.mj_header endRefreshing];
        }else{
            [self.listView.contentTableView.mj_footer endRefreshing];
        }
        self.view.userInteractionEnabled = YES;
    }
    
    @WeakObj(self);
    
    NSString *requestString = @"没有数据";
    if (type == refreshing) {
        self.page = 1;
        self.numberArray = [NSMutableArray array];
    }else{
        self.page ++;
        requestString = @"已经是最后一页";
    }
    
    NSString *pageStr = [NSString stringWithFormat:@"%d",self.page];
    NSString *linageStr = [NSString stringWithFormat:@"%d",self.linage];
    [self.selectDictionary setObject:pageStr forKey:@"page"];
    [self.selectDictionary setObject:linageStr forKey:@"linage"];
    
    [self getSelectDic];
    
    [WebUtils requestAgentWhitePrepareOpenNumberListWithDictionary:self.selectDictionary andCallBack:^(id obj) {
        
        if ([obj isKindOfClass:[NSDictionary class]]) {
            @StrongObj(self);
            NSString *code = [NSString stringWithFormat:@"%@",obj[@"code"]];
            if ([code isEqualToString:@"10000"]) {
                //得到数据
                NSArray *dataArray = obj[@"data"][@"numbers"];
                //解析数据
                for (NSDictionary *dic in dataArray) {
                    [self.numberArray addObject:dic];
                }
                
                //刷新
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self showResultAction];
                    self.listView.numberArray = self.numberArray;
                    [self.listView.contentTableView reloadData];
                    self.view.userInteractionEnabled = YES;
                });
            }else {
                [self showWarningText:obj[@"mes"]];
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.view.userInteractionEnabled = YES;
            //停止刷新
            if (type == refreshing) {
                [self.listView.contentTableView.mj_header endRefreshing];
            }else{
                [self.listView.contentTableView.mj_footer endRefreshing];
            }
        });
    }];
}

- (void)getSelectDic{
    
    /*-------筛选条件-------*/
    ChooseTypeCell *typeCell = [self.selectView.selectTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    
    NormalInputCell *phoneCell = [self.selectView.selectTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    
    NormalLeadCell *beginCell = [self.selectView.selectTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    
    NormalLeadCell *endCell = [self.selectView.selectTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    
    if (phoneCell.inputTextField.text.length > 0) {
        [self.selectDictionary setObject:phoneCell.inputTextField.text forKey:@"number"];
    }else{
        [self.selectDictionary removeObjectForKey:@"number"];
    }
    
    if ([typeCell.currentButton.currentTitle isEqualToString:@"全部"]) {
        [self.selectDictionary removeObjectForKey:@"preState"];
    }
    
    if ([typeCell.currentButton.currentTitle isEqualToString:@"待开户"]) {
        [self.selectDictionary setObject:@"0" forKey:@"preState"];
    }
    
    if ([typeCell.currentButton.currentTitle isEqualToString:@"已开户"]) {
        [self.selectDictionary setObject:@"1" forKey:@"preState"];
    }
    
    if (beginCell.inputTextField.text.length > 0) {
        [self.selectDictionary setObject:beginCell.inputTextField.text forKey:@"startTime"];
    }else{
        [self.selectDictionary removeObjectForKey:@"startTime"];
    }
    
    if (endCell.inputTextField.text.length > 0) {
        [self.selectDictionary setObject:endCell.inputTextField.text forKey:@"endTime"];
    }else{
        [self.selectDictionary removeObjectForKey:@"endTime"];
    }
}

- (void)showResultAction{
    
    NSString *string1 = nil;
    NSString *string2 = nil;
    NSString *string3 = nil;
    NSString *string4 = nil;
    
    ChooseTypeCell *typeCell = [self.selectView.selectTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];

    NormalInputCell *phoneCell = [self.selectView.selectTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    
    NormalLeadCell *beginCell = [self.selectView.selectTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];

    NormalLeadCell *endCell = [self.selectView.selectTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    
    string1 = typeCell.currentButton.currentTitle;
    string2 = phoneCell.inputTextField.text;
    string3 = beginCell.inputTextField.text;
    string4 = endCell.inputTextField.text;
    
    NSString *allString = [NSString stringWithFormat:@"共%ld条 ",self.numberArray.count];
    
    if (string1.length > 0 || string2.length > 0 || string3.length > 0 || string4.length > 0) {
        allString = [allString stringByAppendingString:@"筛选条件："];
        if (string1) {
            allString = [allString stringByAppendingString:[NSString stringWithFormat:@"%@ ",string1]];
        }
        
        if (string2) {
            allString = [allString stringByAppendingString:[NSString stringWithFormat:@"%@ ",string2]];
        }
        
        if (string3) {
            allString = [allString stringByAppendingString:[NSString stringWithFormat:@"%@ ",string3]];
        }

        if (string4) {
            allString = [allString stringByAppendingString:string4];
        }
    }
    
    NSRange range1 = [allString rangeOfString:string2];
    NSRange range2 = [allString rangeOfString:[NSString stringWithFormat:@"%ld",self.numberArray.count]];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:allString];
    //设置字号
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:textfont14] range:range1];
    //设置文字颜色
    [attributedString addAttribute:NSForegroundColorAttributeName value:MainColor range:range1];
    
    //设置字号
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:textfont14] range:range2];
    //设置文字颜色
    [attributedString addAttribute:NSForegroundColorAttributeName value:MainColor range:range2];
    
    self.listView.selectResultLabel.attributedText = attributedString;
}

@end
