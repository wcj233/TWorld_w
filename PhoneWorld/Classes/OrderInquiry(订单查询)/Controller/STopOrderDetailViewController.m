//
//  STopOrderDetailViewController.m
//  PhoneWorld
//
//  Created by 刘岑颖 on 2017/6/6.
//  Copyright © 2017年 xiyoukeji. All rights reserved.
//

#import "STopOrderDetailViewController.h"
#import "STopOrderDetailView.h"

@interface STopOrderDetailViewController ()

@property (nonatomic) STopOrderDetailView *detailView;

@end

@implementation STopOrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.detailView = [[STopOrderDetailView alloc] initWithFrame:CGRectZero andLeftTitlesArray:@[@"编号：",@"时间：",@"号码：",@"金额：",@"状态："]];
    [self.view addSubview:self.detailView];
    [self.detailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0);
    }];
    
    if (self.rightsOrderListModel) {
        self.detailView.rightsOrderListModel = self.rightsOrderListModel;
    }else{
        self.detailView.rechargeListModel = self.rechargeListModel;
    }
    
}

@end
