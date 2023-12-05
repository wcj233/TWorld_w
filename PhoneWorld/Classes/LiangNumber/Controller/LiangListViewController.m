//
//  LiangListViewController.m
//  PhoneWorld
//
//  Created by 刘岑颖 on 2017/5/9.
//  Copyright © 2017年 xiyoukeji. All rights reserved.
//

#import "LiangListViewController.h"
#import "LiangListView.h"

#import "LiangSelectView.h"
#import "NormalLeadCell.h"

#import "NumberDetailViewController.h"//代理商靓号点击跳转
#import "AgentNumberDetailViewController.h"//话机世界靓号点击跳转
#import "AgentWriteAndChooseViewController.h"
#import "ChooseWayViewController.h"
#import "LiangRuleModel.h"
#import "LiangNumberModel.h"


@interface LiangListViewController ()

@property (nonatomic) LiangListView *listView;
@property (nonatomic) LiangSelectView *selectView;

//筛选
@property (nonatomic) int page;
@property (nonatomic) int linage;
@property (nonatomic) NSMutableDictionary *selectDictionary;

//得到的数据
@property (nonatomic) NSArray *liangRuleArray;//靓号规则
@property (nonatomic) NSMutableArray<LiangNumberModel *> *liangNumberArray;//靓号

@end

@implementation LiangListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"筛选" style:UIBarButtonItemStylePlain target:self action:@selector(selectAction)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:textfont16],NSForegroundColorAttributeName:[Utils colorRGB:@"#008bd5"]} forState:UIControlStateNormal];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //初始化
    self.page = 1;
    self.linage = 20;
    self.selectDictionary = [NSMutableDictionary dictionary];
    self.liangNumberArray = [NSMutableArray array];
    
    self.listView = [[LiangListView alloc] init];
    [self.view addSubview:self.listView];
    [self.listView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0);
    }];
    
    //得到靓号规则
    [self getLiangRuleAction];
    
    @WeakObj(self);
    //跳转到下一个页面
    [self.listView setNextCallBack:^(NSInteger row){
        @StrongObj(self);
        
        if ([self.title isEqualToString:@"话机世界靓号"]) {
            AgentWriteAndChooseViewController *vc = [[AgentWriteAndChooseViewController alloc] init];
            vc.leftTitlesArray = @[@"靓号",@"归属地",@"状态",@"运营商",@"预存话费",@"保底消费",@"套餐选择",@"活动包选择",@"订单金额"];
            vc.numberModel = self.liangNumberArray[row];
            vc.typeString = @"话机世界靓号平台";
            [self.navigationController pushViewController:vc animated:YES];
        }
        
        if ([self.title isEqualToString:@"代理商靓号"]) {
            NumberDetailViewController *vc = [[NumberDetailViewController alloc] init];
            vc.title = @"号码详情";
            vc.leftTitlesArray = @[@"靓号",@"归属地",@"预存话费",@"保底消费",@"代理商",@"联系方式"];
            vc.numberModel = self.liangNumberArray[row];
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    }];
    
    //点击查询
    [self.selectView setSelectInquiryCallBack:^(id obj){
        @StrongObj(self);
        //出现
        self.selectView.hidden = YES;
        
        [self showResultAction];
        
        NormalLeadCell *addressCell = [self.selectView.selectTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        
        NormalLeadCell *ruleCell = [self.selectView.selectTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];

        if (addressCell.inputTextField.text.length > 0) {
            [self.selectDictionary setObject:self.selectView.addressPickerView.currentProvinceModel.provinceId forKey:@"provinceCode"];
            [self.selectDictionary setObject:self.selectView.addressPickerView.currentCityModel.cityId forKey:@"cityCode"];
        }
        
        if (ruleCell.inputTextField.text.length > 0) {
            NSInteger row = [self.selectView.otherPickerView selectedRowInComponent:0];
            LiangRuleModel *currentModel = self.liangRuleArray[row];
            [self.selectDictionary setObject:currentModel.liangRuleId forKey:@"liangRuleId"];
        }
        
        [self.listView.contentTableView.mj_header beginRefreshing];
    }];
    
    //点击重置
    [self.selectView setSelectResetCallBack:^(id obj){
        @StrongObj(self);
        [self.selectDictionary removeObjectForKey:@"liangRuleId"];
        [self.selectDictionary removeObjectForKey:@"cityCode"];
        [self.selectDictionary removeObjectForKey:@"provinceCode"];
    }];
    
    //添加刷新
    self.listView.contentTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @StrongObj(self);
        [self getLiangNumberActionWithType:refreshing];
    }];
    
    self.listView.contentTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        @StrongObj(self);
        [self getLiangNumberActionWithType:loading];
    }];
    
    [self.listView.contentTableView.mj_header beginRefreshing];
}

//出现筛选操作
- (void)selectAction{
    self.selectView.hidden = NO;
}

//筛选框初始化
- (LiangSelectView *)selectView{
    if (_selectView == nil) {
        _selectView = [[LiangSelectView alloc] initWithFrame:CGRectZero andLeftTitlesArray:@[@"省市选择",@"靓号规则"] andDataDictionary:@{@"省市选择":@"cityPicker",@"靓号规则":@[]}];
        [self.view addSubview:_selectView];
        _selectView.hidden = YES;
        [_selectView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.mas_equalTo(0);
        }];
    }
    return _selectView;
}

//得到靓号列表
- (void)getLiangNumberActionWithType:(requestType)type{
    
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
    
    NSString *requestString = @"没有数据";
    if (type == refreshing) {
        self.page = 1;
        self.liangNumberArray = [NSMutableArray array];
    }else{
        self.page ++;
        requestString = @"已经是最后一页";
    }
    
    NSString *pageStr = [NSString stringWithFormat:@"%d",self.page];
    NSString *linageStr = [NSString stringWithFormat:@"%d",self.linage];
    [self.selectDictionary setObject:pageStr forKey:@"page"];
    [self.selectDictionary setObject:linageStr forKey:@"linage"];
    
    @WeakObj(self);
    
    if ([self.title isEqualToString:@"代理商靓号"]) {
        [WebUtils requestAgentLiangNumberWithDictionary:self.selectDictionary andCallback:^(id obj) {
            @StrongObj(self);
            [self showNumberActionWithObj:obj andType:type];
        }];
    }else{
        
        [WebUtils requestHJSJLiangNumberWithDictionary:self.selectDictionary andCallBack:^(id obj) {
            @StrongObj(self);
            [self showNumberActionWithObj:obj andType:type];
        }];
    }
}

//得到数据显示数据操作
- (void)showNumberActionWithObj:(id)obj andType:(requestType)type{
    @WeakObj(self);
    if ([obj isKindOfClass:[NSDictionary class]]) {
        @StrongObj(self);
        NSString *code = [NSString stringWithFormat:@"%@",obj[@"code"]];
        if ([code isEqualToString:@"10000"]) {
            //得到数据
            NSArray *dataArray = obj[@"data"][@"LiangAgents"];
            //解析数据
            for (NSDictionary *dic in dataArray) {
                LiangNumberModel *model = [[LiangNumberModel alloc] initWithDictionary:dic error:nil];
                [self.liangNumberArray addObject:model];
            }
            
            self.listView.dataArray = self.liangNumberArray;
            //刷新
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showResultAction];
                [self.listView.contentTableView reloadData];
            });
        }else {
            [self showWarningText:obj[@"mes"]];
        }
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        //停止刷新
        self.view.userInteractionEnabled = YES;

        if (type == refreshing) {
            [self.listView.contentTableView.mj_header endRefreshing];
        }else{
            [self.listView.contentTableView.mj_footer endRefreshing];
        }
    });
}

//得到靓号规则
- (void)getLiangRuleAction{
    @WeakObj(self);
    [WebUtils requestLiangRuleWithCallBack:^(id obj) {
        
        self.view.userInteractionEnabled = YES;

        if ([obj isKindOfClass:[NSDictionary class]]) {
            @StrongObj(self);
            NSString *code = [NSString stringWithFormat:@"%@",obj[@"code"]];
            if ([code isEqualToString:@"10000"]) {
                NSMutableArray *ruleArray = [NSMutableArray array];
                NSArray *dataArr = obj[@"data"][@"LiangRule"];
                
                NSMutableArray *ruleNameArray = [NSMutableArray array];
                for (NSDictionary *dic in dataArr) {
                    LiangRuleModel *ruleModel = [[LiangRuleModel alloc] initWithDictionary:dic error:nil];
                    [ruleArray addObject:ruleModel];
                    
                    [ruleNameArray addObject:ruleModel.ruleName];
                }
                self.liangRuleArray = [NSArray array];
                self.liangRuleArray = ruleArray;
                
                [self.selectView.dataDictionary setObject:ruleNameArray forKey:@"靓号规则"];
                
            }else {
                [self showWarningText:obj[@"mes"]];
            }
        }
    }];
}

- (void)showResultAction{
    
    NormalLeadCell *addressCell = [self.selectView.selectTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    
    NormalLeadCell *ruleCell = [self.selectView.selectTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    
    NSString *cityString = addressCell.inputTextField.text;
    
    NSString *ruleString = ruleCell.inputTextField.text;
    
    NSString *allString = [NSString stringWithFormat:@"共%ld条 ",self.liangNumberArray.count];
    
    if (cityString.length > 0 || ruleString.length > 0) {
        allString = [allString stringByAppendingString:@"筛选条件："];
        if (cityString) {
            allString = [allString stringByAppendingString:[NSString stringWithFormat:@"%@ ",cityString]];
        }
        if (ruleString) {
            allString = [allString stringByAppendingString:ruleString];
        }
    }
    
    NSRange range1 = [allString rangeOfString:ruleString];
    NSRange range2 = [allString rangeOfString:[NSString stringWithFormat:@"%ld",self.liangNumberArray.count]];

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
