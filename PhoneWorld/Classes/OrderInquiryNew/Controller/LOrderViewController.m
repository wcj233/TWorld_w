//
//  LOrderViewController.m
//  PhoneWorld
//
//  Created by 刘岑颖 on 17/2/27.
//  Copyright © 2017年 xiyoukeji. All rights reserved.
//

#import "LOrderViewController.h"
#import "LOrderView.h"

@interface LOrderViewController ()

@property (nonatomic) LOrderView *orderView;

@end

@implementation LOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = COLOR_BACKGROUND;
    
    self.orderView = [[LOrderView alloc] init];
    [self.view addSubview:self.orderView];
    [self.orderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0);
    }];
    
    __block __weak LOrderViewController *weakself = self;

    [self.orderView.screenView setScreenCallBack:^(NSDictionary *conditions, NSString *title) {
        
        [weakself changePageViewControllerFrameWithTitle:title andCondition:conditions];
        if ([title isEqualToString:@"查询"]) {
            [weakself.orderView hideScreenViewAction];
        }
        
    }];
    
}

- (void)changePageViewControllerFrameWithTitle:(NSString *)title andCondition:(NSDictionary *)conditions{
    
    CGFloat height = 40;
    
    if ([title isEqualToString:@"查询"]) {
        
        //刷新加载数据
        
        [self.orderView loadDataWithIndex:self.orderView.currentPageIndex andConditions:conditions];
        
        //显示查询条件
        for (NSString *string in conditions.allValues) {
            if (![string isEqualToString:@"无"]) {
                //如果有一个查询条件不为无就显示查询条件
                height = 90;
                break;
            }
        }
        
        for (int i = 0; i < conditions.count; i ++) {
            UILabel *label = self.orderView.conditionView.resultLabelArray[i];
            if (i == 0) {
                label.text = [NSString stringWithFormat:@"起始时间：%@",conditions[@"起始时间"]];
            }
            if (i == 1) {
                label.text = [NSString stringWithFormat:@"截止时间：%@",conditions[@"截止时间"]];
            }
            if (i == 2) {
                if (conditions.count == 3) {
                    label.text = [NSString stringWithFormat:@"手机号码：%@",conditions[@"手机号码"]];
                }else{
                    label.text = [NSString stringWithFormat:@"订单状态：%@",conditions[@"订单状态"]];
                }
            }
            if (i == 3) {
                label.text = [NSString stringWithFormat:@"手机号码：%@",conditions[@"手机号码"]];
            }
        }
        
    }
    
    [self.orderView.conditionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.orderView.topView.mas_bottom).mas_equalTo(1);
        make.height.mas_equalTo(height);
    }];
    
    [self.orderView.conditionView layoutIfNeeded];
}

@end
