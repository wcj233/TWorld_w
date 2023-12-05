//
//  AgentNumberDetailViewController.m
//  PhoneWorld
//
//  Created by 刘岑颖 on 2017/5/10.
//  Copyright © 2017年 xiyoukeji. All rights reserved.
//

#import "AgentNumberDetailViewController.h"
#import "AgentNumberDetailView.h"
#import "AgentWriteViewController.h"
#import "ChoosePackageDetailViewController.h"
#import "NormalLeadCell.h"

@interface AgentNumberDetailViewController ()

@property (nonatomic) AgentNumberDetailView *detailView;

@property (nonatomic) NSDictionary *detailDictionary;

@property (nonatomic) NSDictionary *packagesDic;//活动包
@property (nonatomic) NSDictionary *promotionsDic;//套餐包

@end

@implementation AgentNumberDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"号码详情";
        
    self.detailView = [[AgentNumberDetailView alloc] initWithFrame:CGRectZero andLeftTitlesArray:self.leftTitlesArray];
    [self.view addSubview:self.detailView];
    [self.detailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0);
    }];
    
    [self.detailView.nextButton setTitle:self.buttonTitleString forState:UIControlStateNormal];
    
    [self.detailView.nextButton addTarget:self action:@selector(nextAction) forControlEvents:UIControlEventTouchUpInside];
    
    if ([self.typeString isEqualToString:@"话机世界靓号平台"]) {
        [self requestHJSJNumberDetailAction];
    }
    
    if ([self.typeString isEqualToString:@"代理商白卡预开户"]) {
        [self requestAgentWhitePrepareOpenDetailAction];
    }
    
    @WeakObj(self);
    [self.detailView setAgentNumberDetailCallBack:^(NSInteger row){
        @StrongObj(self);
        switch (row) {
            case 0:
            {
                ChoosePackageDetailViewController *vc = [[ChoosePackageDetailViewController alloc] init];
                vc.title = @"套餐选择";
                [vc setChoosePackageDetailCallBack:^(NSDictionary *currentDic){
                    self.packagesDic = currentDic;
                    NormalLeadCell *cell = [self.detailView.contentTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
                    cell.inputTextField.text = self.packagesDic[@"name"];
                }];
                vc.packagesDic = self.detailDictionary[@"packages"];//所有套餐
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 1:
            {
                
                if (!self.packagesDic[@"id"]) {
                    [Utils toastview:@"套餐未选择"];
                    return;
                }
                
                ChoosePackageDetailViewController *vc = [[ChoosePackageDetailViewController alloc] init];
                vc.title = @"活动包选择";
                [vc setChoosePackageDetailCallBack:^(NSDictionary *currentDic){
                    self.promotionsDic = currentDic;
                    NormalLeadCell *cell = [self.detailView.contentTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
                    cell.inputTextField.text = self.promotionsDic[@"name"];
                }];
                vc.currentID = self.packagesDic[@"id"];//当前选中套餐ID
                [self.navigationController pushViewController:vc animated:YES];
                
            }
                break;
        }
    }];
}

- (void)nextAction{
    if (!self.promotionsDic || !self.packagesDic) {
        [Utils toastview:@"请选择套餐包和活动包"];
        return;
    }
    
    AgentWriteViewController *vc = [[AgentWriteViewController alloc] init];
    
    if ([self.typeString isEqualToString:@"话机世界靓号平台"]) {
        vc.numberModel = self.numberModel;
        vc.promotionsDictionary = self.promotionsDic;
        vc.packagesDictionary = self.packagesDic;
    }
    
    if ([self.typeString isEqualToString:@"代理商白卡预开户"]) {
        vc.agentNumberModel = self.agentNumberModel;
    }
    //号码详情都是这里
    vc.detailDictionary = self.detailDictionary;
    vc.typeString = self.typeString;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)requestHJSJNumberDetailAction{
    @WeakObj(self);
    [WebUtils requestHJSJLiangDetailWithPhoneNumber:self.numberModel.number andCallBack:^(id obj) {
        //@[@"套餐选择",@"活动包选择",@"靓号",@"归属地",@"预存话费",@"保底消费"]
        @StrongObj(self);
        if ([obj isKindOfClass:[NSDictionary class]]) {
            NSString *code = [NSString stringWithFormat:@"%@",obj[@"code"]];
            if ([code isEqualToString:@"10000"]) {
                
                self.detailDictionary = obj[@"data"];

                NSString *address = [Utils getCityWithProvinceId:self.detailDictionary[@"provinceCode"] andCityId:self.detailDictionary[@"cityCode"]];
                
                NSString *minCost = [NSString stringWithFormat:@"%@元",self.detailDictionary[@"minConsumption"]];
                
                [self.detailView.dataArray addObjectsFromArray:@[@"",@"",self.detailDictionary[@"number"],address,self.detailDictionary[@"prestore"],minCost]];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.detailView.contentTableView reloadData];
                });
            }else {
                [self showWarningText:obj[@"mes"]];
            }
        }
    }];
}

- (void)requestAgentWhitePrepareOpenDetailAction{
    @WeakObj(self);
    [WebUtils requestAgentWhitePrepareOpenNumberDetailWithPhoneNumber:self.agentNumberModel[@"num"] andCallBack:^(id obj) {
        @StrongObj(self);
        if ([obj isKindOfClass:[NSDictionary class]]) {
            NSString *code = [NSString stringWithFormat:@"%@",obj[@"code"]];
            if ([code isEqualToString:@"10000"]) {
                
                self.detailDictionary = obj[@"data"];
                
                [self.detailView.dataArray addObjectsFromArray:@[self.detailDictionary[@"packageName"],self.detailDictionary[@"promotionName"],self.detailDictionary[@"number"],self.detailDictionary[@"cityName"],@"没有该字段"]];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.detailView.contentTableView reloadData];
                });
            }else {
                [self showWarningText:obj[@"mes"]];
            }
            
        }
    }];
}

@end
