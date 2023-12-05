//
//  AgentResultViewController.m
//  PhoneWorld
//
//  Created by 刘岑颖 on 2017/5/10.
//  Copyright © 2017年 xiyoukeji. All rights reserved.
//

#import "AgentResultViewController.h"
#import "AgentResultView.h"

@interface AgentResultViewController ()<UINavigationControllerDelegate>

@property (nonatomic) AgentResultView *resultView;

@end

@implementation AgentResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"预开户结果";
    
    self.resultView = [[AgentResultView alloc] init];
    [self.view addSubview:self.resultView];
    [self.resultView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0);
    }];
    
    //得到当前视图控制器中的所有控制器
    NSMutableArray *array = [self.navigationController.viewControllers mutableCopy];
    //把B从里面删除
    [array removeObjectAtIndex:2];
    //把删除后的控制器数组再次赋值
    [self.navigationController setViewControllers:[array copy] animated:YES];
    
    [self showDataAction];
}

- (void)showDataAction{
    
    NSArray *leftTitlesArray = @[@"靓号",@"归属地",@"运营商",@"套餐",@"活动包",@"状态"];
    
    NSMutableArray *dataArray = [NSMutableArray array];
    [dataArray addObjectsFromArray:@[self.agentNumberModel[@"num"],self.detailDictionary[@"cityName"],self.detailDictionary[@"operatorname"],self.packageDictionary[@"name"],self.promotionDictionary[@"name"],self.detailDictionary[@"numberStatus"]]];
    
    for (int i = 0; i < self.resultView.dataLabelsArray.count; i ++) {
        UILabel *currentLabel = self.resultView.dataLabelsArray[i];
        currentLabel.text = [NSString stringWithFormat:@"%@：%@",leftTitlesArray[i],dataArray[i]];
    }
    
}

//- (nullable UIViewController *)popViewControllerAnimated:(BOOL)animated{
//    
//}

@end
