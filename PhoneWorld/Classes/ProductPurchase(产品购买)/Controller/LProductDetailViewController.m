//
//  LProductDetailViewController.m
//  PhoneWorld
//
//  Created by 刘岑颖 on 2018/1/15.
//  Copyright © 2018年 xiyoukeji. All rights reserved.
//

#import "LProductDetailViewController.h"
#import "LProductDetailView.h"

@interface LProductDetailViewController ()

@property (nonatomic, strong) LProductDetailView *detailView;

@end

@implementation LProductDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"订单详情";
    self.detailView = [[LProductDetailView alloc] init];
    [self.view addSubview:self.detailView];
    [self.detailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0);
    }];
    if (self.rightsOrderListModel) {
        
    }else{
        self.detailView.bookedModel = self.bookedModel;
    }
    
}

@end
