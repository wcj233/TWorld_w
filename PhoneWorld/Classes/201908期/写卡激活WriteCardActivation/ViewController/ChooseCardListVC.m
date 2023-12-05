//
//  ChooseCardList.m
//  PhoneWorld
//
//  Created by Allen on 2019/8/13.
//  Copyright © 2019 xiyoukeji. All rights reserved.
//

#import "ChooseCardListVC.h"
#import "ChooseCardView.h"

#import "LiangSelectView.h"
#import "LiangRuleModel.h"
#import "NormalLeadCell.h"
#import "AgentWriteAndChooseViewController.h"

@interface ChooseCardListVC ()

@property(nonatomic,strong)ChooseCardView *chooseCardView;
//筛选框
@property (nonatomic) LiangSelectView *selectView;
//筛选条件
@property (nonatomic) NSMutableDictionary *selectDictionary;
//靓号规则
@property(nonatomic,strong)NSArray *lhgzArray;
//号码数据
@property(nonatomic,strong)NSMutableArray *numberArray;

@property(nonatomic,strong)UILabel *totalNumberlabel;
@end

@implementation ChooseCardListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUI];
    
    [self loadData];
}

- (void)setUI{
    self.navigationItem.title = @"写卡激活号码";
    self.view.backgroundColor = kSetColor(@"FBFBFB");
    
    self.selectDictionary = [NSMutableDictionary dictionary];
    
    @WeakObj(self);
    
    UIButton *filterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [filterBtn setTitle:@"筛选" forState:UIControlStateNormal];
    [filterBtn setTitleColor:kSetColor(@"008BD5") forState:UIControlStateNormal];
    filterBtn.titleLabel.font = [UIFont systemFontOfSize:textfont14];
    [filterBtn addTarget:self action:@selector(clickSifting) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *filterItem = [[UIBarButtonItem alloc] initWithCustomView:filterBtn];
    self.navigationItem.rightBarButtonItem = filterItem;
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"筛选" style:UIBarButtonItemStylePlain target:self action:@selector(clickSifting)];
//    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:textfont14]} forState:UIControlStateNormal];
    
    UILabel *label = [[UILabel alloc] init];
    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:12];
    label.backgroundColor = kSetColor(@"E2E2E2");
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.mas_equalTo(0);
        make.height.mas_equalTo(30);
    }];
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"  共 10 条"
                                                                               attributes: @{
                                                                                             NSForegroundColorAttributeName: [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0]
                                                                                             }];
    
    [string addAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:236/255.0 green:108/255.0 blue:0/255.0 alpha:1.0]} range:NSMakeRange(4, 2)];
    
    label.attributedText = string;
    label.textAlignment = NSTextAlignmentLeft;
    label.alpha = 1.0;
    self.totalNumberlabel = label;
    
    self.chooseCardView = [[ChooseCardView alloc]initWithFrame:CGRectMake(0, 30, screenWidth, 305)];
    self.chooseCardView.clickCardBlock = ^(NSString * _Nonnull phoneNumber) {
        @StrongObj(self);
        
        AgentWriteAndChooseViewController *vc = [[AgentWriteAndChooseViewController alloc] init];
        vc.leftTitlesArray = @[@"号码",@"归属地",@"运营商",@"预存话费",@"选号费",@"保底",@"套餐选择",@"活动包选择",@"订单金额"];
        vc.phoneNumber = phoneNumber;
        vc.typeString = @"写卡激活";
        [self.navigationController pushViewController:vc animated:YES];
        
    };
    [self.view addSubview:self.chooseCardView];
    
    UIView *line = UIView.new;
    line.backgroundColor = kSetColor(@"D8D8D8");
    [self.view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.view);
        make.top.mas_equalTo(self.chooseCardView.mas_bottom);
        make.height.mas_equalTo(1);
    }];
    
    UIButton *replaceBtn = UIButton.new;
    [replaceBtn setImage:kSetImage(@"201908gengxin") forState:UIControlStateNormal];
    [replaceBtn setTitle:@"   换一批" forState:UIControlStateNormal];
    [replaceBtn setTitleColor:kSetColor(@"EC6C00") forState:UIControlStateNormal];
    replaceBtn.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:replaceBtn];
    [replaceBtn addTarget:self action:@selector(clickReplace) forControlEvents:UIControlEventTouchUpInside];
    [replaceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(line.mas_bottom);
        make.leading.trailing.mas_equalTo(self.view);
        make.height.mas_equalTo(44);
    }];
    
    //筛选框查询事件
    [self.selectView setSelectInquiryCallBack:^(id obj){
        @StrongObj(self);
        self.selectView.hidden = YES;
        
        [self showSelectResultAction];
        
        [self randomNumber];
    }];
    
    //筛选框重置事件
    [self.selectView setSelectResetCallBack:^(id obj){
        @StrongObj(self);
        self.selectDictionary = [NSMutableDictionary dictionary];
//        self.orderView.tableHeadView.centerLabel.text = @"";
//        self.orderView.tableHeadView.rightLabel.text = @"";
    }];
}

- (void )loadData{
    @WeakObj(self);
    [WebUtils requestLiangRuleWithCallBack:^(id obj) {
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
                self.lhgzArray = [NSArray array];
                self.lhgzArray = ruleArray;
                
                [self.selectView.dataDictionary setObject:ruleNameArray forKey:@"靓号规则"];
                
            }else {
                
            }
        }
    }];
    
//    [WebUtils agency_2019whiteNumberPoolWithParams:@{} andCallback:^(id obj) {
//        @StrongObj(self);
//        NSString *code = [NSString stringWithFormat:@"%@",obj[@"code"]];
//        if ([code isEqualToString:@"10000"]) {
//
//        }
//    }];
    
    [self randomNumber];
}

- (void)randomNumber{
    @WeakObj(self);
    [WebUtils agency_2019preRandomNumberWithParams:self.selectDictionary andCallback:^(id obj) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            @StrongObj(self);
            NSString *code = [NSString stringWithFormat:@"%@",obj[@"code"]];
            if ([code isEqualToString:@"10000"]) {
                NSNumber *count = obj[@"data"][@"count"];
                NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"  共 %@ 条", count.stringValue]
                                                                                           attributes: @{
                                                                                                         NSForegroundColorAttributeName: [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0]
                                                                                                         }];
                [string addAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:236/255.0 green:108/255.0 blue:0/255.0 alpha:1.0]} range:NSMakeRange(4, count.stringValue.length)];
                
                //得到数据
                self.numberArray = [NSMutableArray array];
                
                NSArray *dataArray = obj[@"data"][@"numbers"];
                //解析数据
                for (NSDictionary *dic in dataArray) {
                    [self.numberArray addObject:dic[@"number"]];
                }
                
                //刷新
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.chooseCardView.dataArray = self.numberArray;
                    self.totalNumberlabel.attributedText = string;
                });
            }else{
                [self showWarningText:obj[@"mes"]];
            }
        }
    }];
}

#pragma mark -Action
- (void)clickReplace{
    [self randomNumber];
}

- (void)clickSifting{
    self.selectView.hidden = NO;
}

- (void)showSelectResultAction{
//    [self showResultAction];
    
    NormalLeadCell *addressCell = [self.selectView.selectTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    
    NormalLeadCell *ruleCell = [self.selectView.selectTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    
    if (addressCell.inputTextField.text.length > 0) {
        [self.selectDictionary setObject:self.selectView.addressPickerView.currentProvinceModel.provinceId forKey:@"province"];
        [self.selectDictionary setObject:self.selectView.addressPickerView.currentCityModel.cityId forKey:@"city"];
    }
    
    if (ruleCell.inputTextField.text.length > 0) {
        NSInteger row = [self.selectView.otherPickerView selectedRowInComponent:0];
        LiangRuleModel *currentModel = self.lhgzArray[row];
        [self.selectDictionary setObject:currentModel.liangRuleId forKey:@"numberRule"];
    }
    
    NormalLeadCell *phoneNmuberCell = [self.selectView.selectTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    
    if (phoneNmuberCell.inputTextField.text.length > 0) {
        [self.selectDictionary setObject:phoneNmuberCell.inputTextField.text forKey:@"number"];
    }
}

#pragma mark - Load

- (LiangSelectView *)selectView{
    if (_selectView == nil) {
        
        _selectView = [[LiangSelectView alloc] initWithFrame:CGRectZero andLeftTitlesArray:@[@"省市选择",@"靓号规则",@"模糊查询"] andDataDictionary:@{@"省市选择":@"cityPicker", @"靓号规则":@[] , @"模糊查询":@"phoneNumber"}];

        [self.view addSubview:_selectView];
        _selectView.hidden = YES;
        [_selectView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.mas_equalTo(0);
        }];
    }
    return _selectView;
}


@end
