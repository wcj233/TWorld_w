//
//  WhitePrepareOpenTwoViewController.m
//  PhoneWorld
//
//  Created by 刘岑颖 on 2017/5/9.
//  Copyright © 2017年 xiyoukeji. All rights reserved.
//

#import "WhitePrepareOpenTwoViewController.h"
#import "WhitePrepareOpenTwoView.h"
#import "WhitePrepareOpenThreeViewController.h"
#import "NormalShowCell.h"

@interface WhitePrepareOpenTwoViewController ()

@property (nonatomic) WhitePrepareOpenTwoView *twoView;

@end

@implementation WhitePrepareOpenTwoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"号码详情";

    self.twoView = [[WhitePrepareOpenTwoView alloc] init];
    [self.view addSubview:self.twoView];
    [self.twoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0);
    }];
    
    [self.twoView.nextButton addTarget:self action:@selector(nextAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self showDataAction];
}

- (void)nextAction:(UIButton *)button{
    WhitePrepareOpenThreeViewController *vc = [[WhitePrepareOpenThreeViewController alloc] init];
    vc.detailDictionary = self.dataDictionary;
    vc.typeString = @"渠道商白卡预开户";
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)showDataAction{
    NSArray *showDataArray = @[self.dataDictionary[@"number"],self.dataDictionary[@"cityName"],self.dataDictionary[@"operator"],self.dataDictionary[@"packageName"],self.dataDictionary[@"promotionName"]];
    
    self.twoView.showDataArray = showDataArray;
    
    [self.twoView.contentTableView reloadData];
}


@end
