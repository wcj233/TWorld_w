//
//  AgentNumberListViewController.m
//  PhoneWorld
//
//  Created by 刘岑颖 on 2017/5/10.
//  Copyright © 2017年 xiyoukeji. All rights reserved.
//

#import "AgentNumberListViewController.h"
#import "AgentNumberListView.h"

#import "LiangSelectView.h"
#import "AgentNumberDetailViewController.h"
#import "ChooseTypeCell.h"
#import "NormalInputCell.h"
#import "NormalLeadCell.h"
#import "LiangNumberModel.h"

#import "NumberDetailViewController.h"
#import "AgentNumberModel.h"
#import "AgentWriteAndChooseViewController.h"
#import "LiangRuleModel.h"

@interface AgentNumberListViewController ()

@property (nonatomic) AgentNumberListView *listView;
//筛选框的
@property (nonatomic) NSArray *leftTitlesArray;
@property (nonatomic) NSDictionary *contentDictionary;

@property (nonatomic) LiangSelectView *selectView;

//筛选条件
@property (nonatomic) int page;
@property (nonatomic) int linage;
@property (nonatomic) NSMutableDictionary *selectDictionary;

@property (nonatomic) NSMutableArray *numberArray;

/*-代理商靓号平台靓号规则筛选条件-*/
@property (nonatomic) NSMutableArray<LiangRuleModel *> *ruleArray;

/*-代理商白卡预开户号码池和靓号规则的筛选条件-*/

@property (nonatomic) NSMutableArray<NSDictionary *> *liangRuleArray;//靓号规则
@property (nonatomic) NSMutableArray<NSDictionary *> *numberPoolArray;//号码池

@end

@implementation AgentNumberListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"筛选" style:UIBarButtonItemStylePlain target:self action:@selector(selectAction)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:textfont16],NSForegroundColorAttributeName:[Utils colorRGB:@"#008bd5"]} forState:UIControlStateNormal];
    
    //初始化
    self.page = 1;
    self.linage = 20;
    self.selectDictionary = [NSMutableDictionary dictionary];
    
    self.listView = [[AgentNumberListView alloc] init];
    [self.view addSubview:self.listView];
    [self.listView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0);
    }];
    
    @WeakObj(self);
    
    [self.listView setAgentNumberCallBack:^(NSInteger row){
        @StrongObj(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([self.typeString isEqualToString:@"代理商白卡预开户"]) {
                AgentWriteAndChooseViewController *vc = [[AgentWriteAndChooseViewController alloc] init];
                vc.leftTitlesArray = @[@"靓号",@"归属地",@"说明",@"运营商",@"套餐选择",@"活动包选择",@"ICCID"];
                vc.agentNumberModel = self.numberArray[row];
                vc.typeString = @"代理商白卡预开户";
                [self.navigationController pushViewController:vc animated:YES];
                
            }else{
                
                NumberDetailViewController *vc = [[NumberDetailViewController alloc] init];
                vc.title = @"靓号详情";
                vc.numberModel = self.numberArray[row];
                vc.leftTitlesArray = @[@"靓号",@"归属地",@"状态",@"预存",@"保底",@"上传时间"];
                [self.navigationController pushViewController:vc animated:YES];
            }
        });
    }];
    
    if ([self.typeString isEqualToString:@"代理商白卡预开户"]) {
        
        self.liangRuleArray = [NSMutableArray array];
        self.numberPoolArray = [NSMutableArray array];
        
        self.leftTitlesArray = @[@"号码池",@"靓号规则"];
        self.contentDictionary = @{@"号码池":self.numberPoolArray,@"靓号规则":self.liangRuleArray};
        
        //请求靓号规则数据
        [self getPoolDataAction];
    }else{
        
        self.ruleArray = [NSMutableArray array];
        
        self.leftTitlesArray = @[@"类型",@"省市选择",@"靓号规则",@"手机号码"];
        self.contentDictionary = @{@"类型":@[@"全部",@"已激活",@"已使用"],@"省市选择":@"cityPicker",@"靓号规则":self.ruleArray,@"手机号码":@"phoneNumber"};
        
        [self getLiangRuleAction];
    }
    
    [self.selectView setSelectInquiryCallBack:^(id obj){
        @StrongObj(self);
        self.selectView.hidden = YES;
        [self showSelectResultAction];
        [self.listView.contentTableView.mj_header beginRefreshing];
    }];
    
    [self.selectView setSelectResetCallBack:^(id obj){
    }];
    
    //添加刷新
    self.listView.contentTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @StrongObj(self);
        [self getNumberListActionWithType:refreshing];
    }];
    
    self.listView.contentTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        @StrongObj(self);
        [self getNumberListActionWithType:loading];
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

//请求数据
- (void)getNumberListActionWithType:(requestType)type{
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
    
    
    if ([self.typeString isEqualToString:@"代理商靓号平台"]) {
        
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
        
        /*-------筛选条件-------*/
        ChooseTypeCell *typeCell = [self.selectView.selectTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        
        NormalLeadCell *cityCell = [self.selectView.selectTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];

        NormalLeadCell *ruleCell = [self.selectView.selectTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
        
        NormalInputCell *phoneCell = [self.selectView.selectTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
        
        if (ruleCell.inputTextField.text.length > 0) {
            NSInteger row = [self.selectView.otherPickerView selectedRowInComponent:0];
            LiangRuleModel *currentModel = self.ruleArray[row];
            [self.selectDictionary setObject:currentModel.liangRuleId forKey:@"liangRuleId"];
        }else{
            [self.selectDictionary removeObjectForKey:@"liangRuleId"];
        }
        
        if (cityCell.inputTextField.text.length > 0) {
            
            [self.selectDictionary setObject:self.selectView.addressPickerView.currentProvinceModel.provinceId forKey:@"provinceCode"];
            [self.selectDictionary setObject:self.selectView.addressPickerView.currentCityModel.cityId forKey:@"cityCode"];

        }else{
            
            [self.selectDictionary removeObjectForKey:@"provinceCode"];
            [self.selectDictionary removeObjectForKey:@"cityCode"];
        }
        
        
        if (phoneCell.inputTextField.text.length > 0) {
            [self.selectDictionary setObject:phoneCell.inputTextField.text forKey:@"number"];
        }else{
            [self.selectDictionary removeObjectForKey:@"number"];
        }
        
        if ([typeCell.currentButton.currentTitle isEqualToString:@"全部"]) {
            [self.selectDictionary setObject:@"-1" forKey:@"liangStatus"];
        }
        
        if ([typeCell.currentButton.currentTitle isEqualToString:@"已激活"]) {
            [self.selectDictionary setObject:@"1" forKey:@"liangStatus"];
        }
        
        if ([typeCell.currentButton.currentTitle isEqualToString:@"已使用"]) {
            [self.selectDictionary setObject:@"2" forKey:@"liangStatus"];
        }
        
        [WebUtils requestAgentLiangNumberWithDictionary:self.selectDictionary andCallback:^(id obj) {
            
            if ([obj isKindOfClass:[NSDictionary class]]) {
                @StrongObj(self);
                NSString *code = [NSString stringWithFormat:@"%@",obj[@"code"]];
                if ([code isEqualToString:@"10000"]) {
                    //得到数据
                    NSArray *dataArray = obj[@"data"][@"LiangAgents"];
                    //解析数据
                    for (NSDictionary *dic in dataArray) {
                        LiangNumberModel *model = [[LiangNumberModel alloc] initWithDictionary:dic error:nil];
                        [self.numberArray addObject:model];
                    }
                    
                    //刷新
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self showSelectResultAction];
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
        
        
    }else{
        
        //代理商白卡预开户
        
        NormalLeadCell *poolCell = [self.selectView.selectTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        
        NormalLeadCell *liangCell = [self.selectView.selectTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        
        NSMutableDictionary *sendDic = [[self getSelectWithLiangRuleName:liangCell.inputTextField.text andPoolName:poolCell.inputTextField.text] mutableCopy];
        
        
        [WebUtils requestAgentWhitePrepareOpenFirstStepWithDictionary:sendDic andCallBack:^(id obj) {
            
            if ([obj isKindOfClass:[NSDictionary class]]) {
                @StrongObj(self);
                NSString *code = [NSString stringWithFormat:@"%@",obj[@"code"]];
                if ([code isEqualToString:@"10000"]) {
                    //得到数据
                    self.numberArray = [NSMutableArray array];

                    NSArray *dataArray = obj[@"data"][@"numbers"];
                    //解析数据
                    for (NSDictionary *dic in dataArray) {
                        [self.numberArray addObject:dic];
                    }
                    
                    //刷新
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self showSelectResultAction];
                        self.listView.numberArray = self.numberArray;
                        [self.listView.contentTableView reloadData];
                    });
                }else{
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
}

//得到代理商靓号平台靓号规则
- (void)getLiangRuleAction{
    @WeakObj(self);
    [WebUtils requestLiangRuleWithCallBack:^(id obj) {
        
        self.view.userInteractionEnabled = YES;
        
        if ([obj isKindOfClass:[NSDictionary class]]) {
            @StrongObj(self);
            NSString *code = [NSString stringWithFormat:@"%@",obj[@"code"]];
            if ([code isEqualToString:@"10000"]) {
                NSArray *dataArr = obj[@"data"][@"LiangRule"];
                
                NSMutableArray *ruleNameArray = [NSMutableArray array];
                for (NSDictionary *dic in dataArr) {
                    LiangRuleModel *ruleModel = [[LiangRuleModel alloc] initWithDictionary:dic error:nil];
                    [self.ruleArray addObject:ruleModel];
                    
                    [ruleNameArray addObject:ruleModel.ruleName];
                }
                
                self.selectView.dataDictionary = [@{@"类型":@[@"全部",@"已激活",@"已使用"],@"省市选择":@"cityPicker",@"靓号规则":ruleNameArray,@"手机号码":@"phoneNumber"} mutableCopy];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.selectView.selectTableView reloadData];
                });
                
            }else {
                [self showWarningText:obj[@"mes"]];
            }
        }
    }];
}


//获取白卡预开户号码池靓号规则
- (void)getPoolDataAction{
    @WeakObj(self);
    [WebUtils requestPreWhiteNumberPoolWithCallBack:^(id obj) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            @StrongObj(self);
            NSString *code = [NSString stringWithFormat:@"%@",obj[@"code"]];
            if ([code isEqualToString:@"10000"]) {
                
                NSArray *liangRuleDicArr = obj[@"data"][@"numberType"];
                NSMutableArray *liangRuleArray = [NSMutableArray array];
                for (NSDictionary *dic in liangRuleDicArr) {
                    [liangRuleArray addObject:dic[@"ruleName"]];
                    [self.liangRuleArray addObject:dic];
                }
                
                NSArray *poolDicArr = obj[@"data"][@"numberpool"];
                NSMutableArray *poolArray = [NSMutableArray array];
                for (NSDictionary *dic in poolDicArr) {
                    [poolArray addObject:dic[@"name"]];
                    [self.numberPoolArray addObject:dic];
                }
                
                self.selectView.dataDictionary = [@{@"号码池":poolArray,@"靓号规则":liangRuleArray} mutableCopy];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.selectView.selectTableView reloadData];
                });
            }
        }
    }];
}

//通过号码池靓号规则得到筛选用的id
- (NSDictionary *)getSelectWithLiangRuleName:(NSString *)liangRuleName andPoolName:(NSString *)poolName{
    
    NSMutableDictionary *selectDic = [NSMutableDictionary dictionary];
    
    if (liangRuleName.length > 0) {
        for (NSDictionary *liangDic in self.liangRuleArray) {
            if ([liangDic[@"ruleName"] isEqualToString:liangRuleName]) {
                [selectDic setObject:liangDic[@"ruleNameId"] forKey:@"ruleNameId"];
            }
        }
    }else{
        NSDictionary *dic = self.liangRuleArray.firstObject;
        [selectDic setObject:[NSString stringWithFormat:@"%@",dic[@"ruleNameId"]] forKey:@"ruleNameId"];
    }
    
    if (poolName.length > 0) {
        for (NSDictionary *poolDic in self.numberPoolArray) {
            if ([poolDic[@"name"] isEqualToString:poolName]) {
                [selectDic setObject:poolDic[@"id"] forKey:@"numberpool"];
            }
        }
    }else{
        NSDictionary *dic = self.numberPoolArray.firstObject;
        [selectDic setObject:[NSString stringWithFormat:@"%@",dic[@"id"]] forKey:@"numberpool"];
    }
    
    return selectDic;
}

- (void)showSelectResultAction{
    if ([self.typeString isEqualToString:@"代理商白卡预开户"]) {
        
        NSString *string1 = nil;
        NSString *string2 = nil;
        
        NormalLeadCell *poolCell = [self.selectView.selectTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        
        NormalLeadCell *liangCell = [self.selectView.selectTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        
        string1 = poolCell.inputTextField.text;
        string2 = liangCell.inputTextField.text;
        
        NSString *allString = [NSString stringWithFormat:@"共%ld条 ",self.numberArray.count];
        
        if (string1.length > 0 || string2.length > 0) {
            allString = [allString stringByAppendingString:@"筛选条件："];
            if (string1) {
                allString = [allString stringByAppendingString:[NSString stringWithFormat:@"%@ ",string1]];
            }
            if (string2) {
                allString = [allString stringByAppendingString:string2];
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
        
    }else{
        
        NSString *string1 = nil;
        NSString *string2 = nil;
        NSString *string3 = nil;
        NSString *string4 = nil;
        
        ChooseTypeCell *typeCell = [self.selectView.selectTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        
        NormalLeadCell *cityCell = [self.selectView.selectTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        
        NormalLeadCell *liangCell = [self.selectView.selectTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];

        NormalInputCell *phoneCell = [self.selectView.selectTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
        
        
        string1 = typeCell.currentButton.currentTitle;
        string2 = cityCell.inputTextField.text;
        string3 = liangCell.inputTextField.text;
        string4 = phoneCell.inputTextField.text;
        
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
        
        NSRange range1 = [allString rangeOfString:string4];
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
    
}

@end
