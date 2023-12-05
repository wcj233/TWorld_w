//
//  PreOrderDetailVC.m
//  PhoneWorld
//
//
// Created by 黄振元 on 2019/4/23.
// Copyright © 2019 xiyoukeji. All rights reserved.
//
// @class PreOrderDetailVC
// @abstract 预订单详情VC
//

#import "PreOrderDetailVC.h"

// Controllers

// Model
#import "PreOrderDetailModel.h"

// Views
#import "PreOrderInfoView.h"
#import "PreOrderTariffView.h"


@interface PreOrderDetailVC () <UIScrollViewDelegate>

@property (strong, nonatomic) PreOrderDetailModel *detailModel;

@property (strong, nonatomic) UIButton *leftBtn;
@property (strong, nonatomic) UIButton *rightBtn;
// 下划线
@property (strong, nonatomic) UIView *lineView;

@property (strong, nonatomic) UIScrollView *scrollView;

@property (strong, nonatomic) NSString *cancelResult;

@end


@implementation PreOrderDetailVC

#pragma mark - View Controller LifeCyle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.navigationItem.title = @"订单详情";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self downloadData];
}


#pragma mark - Override Methods


#pragma mark - Initial Methods


#pragma mark - Privater Methods

- (void)createTopView {
    UIView *topBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 40)];
    topBgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topBgView];
    
    // 左侧按钮
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setTitle:@"订单信息" forState:UIControlStateNormal];
    [leftBtn setTitleColor:kSetColor(@"333333") forState:UIControlStateNormal];
    [leftBtn setTitleColor:kSetColor(@"EC6C00") forState:UIControlStateSelected];
    leftBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    leftBtn.selected = YES;
    [topBgView addSubview:leftBtn];
    self.leftBtn = leftBtn;
    [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.mas_equalTo(0);
        make.width.mas_equalTo(screenWidth / 2);
        make.height.mas_equalTo(40);
    }];
    
    // 右侧按钮
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitle:@"资费信息" forState:UIControlStateNormal];
    [rightBtn setTitleColor:kSetColor(@"333333") forState:UIControlStateNormal];
    [rightBtn setTitleColor:kSetColor(@"EC6C00") forState:UIControlStateSelected];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    rightBtn.selected = NO;
    [topBgView addSubview:rightBtn];
    self.rightBtn = rightBtn;
    [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.top.mas_equalTo(0);
        make.width.mas_equalTo(screenWidth / 2);
        make.height.mas_equalTo(40);
    }];
    
    UIView *separatorView = [[UIView alloc] init];
    separatorView.backgroundColor = kSetColor(@"FAFAFA");
    [topBgView addSubview:separatorView];
    [separatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.bottom.trailing.mas_equalTo(topBgView);
        make.height.mas_equalTo(1);
    }];
    
    // 下划线
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = kSetColor(@"EC6C00");
    [topBgView addSubview:lineView];
    self.lineView = lineView;
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(0);
        make.width.mas_equalTo(screenWidth / 2);
        make.bottom.mas_equalTo(separatorView.mas_top);
        make.height.mas_equalTo(2);
    }];
    
    @WeakObj(self)
    [[leftBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @StrongObj(self)
        leftBtn.selected = YES;
        rightBtn.selected = NO;
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }];
    
    [[rightBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @StrongObj(self)
        leftBtn.selected = NO;
        rightBtn.selected = YES;
        [self.scrollView setContentOffset:CGPointMake(screenWidth, 0) animated:YES];
    }];
}

- (void)downloadData {
    [self showWaitView];
    
    NSMutableDictionary *params = @{}.mutableCopy;
    params[@"id"] = self.orderId;
    
    @WeakObj(self)
    [self showWaitView];
    [WebUtils agencySelectionDetailsWithParams:params andCallback:^(id obj) {
        @StrongObj(self)
        [self hideWaitView];
        if ([obj isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = [NSDictionary dictionaryWithDictionary:obj];
            if ([dic[@"code"] integerValue] == 10000) {
                NSDictionary *subDic = dic[@"data"];
                NSLog(@"subDic = %@", subDic);
                
                PreOrderDetailModel *detailModel = [[PreOrderDetailModel alloc] initWithDictionary:subDic error:nil];
                
                self.detailModel = detailModel;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self hideWaitView];
                    [self createTopView];
                    [self createMain];
                });
            } else {
                [Utils toastview:dic[@"mes"]];
            }
        }
    }];
}

- (void)createMain {
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.delegate = self;
    scrollView.pagingEnabled = YES;
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.bottom.mas_equalTo(self.view);
        make.width.mas_equalTo(screenWidth);
        make.top.mas_equalTo(40);
    }];
    
    PreOrderInfoView *leftView = [[PreOrderInfoView alloc] initWithOrderNumber:[NSString stringWithFormat:@"订单编号：%@", self.detailModel.orderNo] orderTime:[NSString stringWithFormat:@"订单时间：%@", self.detailModel.startTime] orderType:[NSString stringWithFormat:@"订单类型：%@", self.detailModel.cardType] mobile:[NSString stringWithFormat:@"开户号码：%@", self.detailModel.number] checkTime:[NSString stringWithFormat:@"审核时间：%@", self.detailModel.startTime] orderStatusName:[NSString stringWithFormat:@"订单状态：%@", self.detailModel.orderStatusName] orderStatusCode:self.detailModel.orderStatus cancelResult:self.detailModel.cancelInfo];
    leftView.backgroundColor = kSetColor(@"FAFAFA");
    [scrollView addSubview:leftView];
    [leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.mas_equalTo(0);
        make.height.mas_equalTo(scrollView);
        make.width.mas_equalTo(screenWidth);
    }];
    
    PreOrderTariffView *rightView = [[PreOrderTariffView alloc] initWithPreMoney:[NSString stringWithFormat:@"预存金额：%@", self.detailModel.prestore] activyPackage:[NSString stringWithFormat:@"活动包：%@+%@", self.detailModel.packageName, self.detailModel.promotionName] isGoodNumber:[NSString stringWithFormat:@"是否靓号：%@", self.detailModel.isLiang]];
    [scrollView addSubview:rightView];
    [rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(screenWidth);
        make.top.mas_equalTo(0);
        make.trailing.mas_equalTo(scrollView);
        make.width.mas_equalTo(screenWidth);
        make.height.mas_equalTo(scrollView);
    }];
    
    @WeakObj(self)
    leftView.deliveryBlock = ^{
        @StrongObj(self)
        [self deliveryAction];
    };
    leftView.cancelBlock = ^{
        @StrongObj(self)
        [self cancelAction];
    };
}

// 发货
- (void)deliveryAction {
    NSMutableDictionary *params = @{}.mutableCopy;
    params[@"orderId"] = self.orderId;
    params[@"orderStatus"] = @"DELIVERED";
    
    [self showWaitView];
    [WebUtils agencySelectionAuditWithParams:params andCallback:^(id obj) {
        [self hideWaitView];
        if ([obj isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = [NSDictionary dictionaryWithDictionary:obj];
            if ([dic[@"code"] integerValue] == 10000) {
                [Utils toastview:@"已提交发货信息"];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
            } else {
                [Utils toastview:dic[@"mes"]];
            }
        }
    }];
}

- (void)cancelAction {
    UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:nil message:@"请输入取消原因" preferredStyle:UIAlertControllerStyleAlert];
    [alertCtrl addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        @WeakObj(self)
        [[textField rac_textSignal] subscribeNext:^(id x) {
            @StrongObj(self)
            self.cancelResult = x;
        }];
    }];
    [alertCtrl addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        return;
    }]];
    [alertCtrl addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self submitCancel];
    }]];
    [self presentViewController:alertCtrl animated:YES completion:nil];
}

- (void)submitCancel {
    if (self.cancelResult.length <= 0 || self.cancelResult == nil || [self.cancelResult isEqualToString:@""]) {
        [Utils toastview:@"请输入取消原因"];
        return;
    }
    
    NSMutableDictionary *params = @{}.mutableCopy;
    params[@"orderId"] = self.orderId;
    params[@"orderStatus"] = @"CANCEL";
    params[@"orderDetails"] = self.cancelResult;
    
    @WeakObj(self)
    [self showWaitView];
    [WebUtils agencySelectionAuditWithParams:params andCallback:^(id obj) {
        @StrongObj(self)
        [self hideWaitView];
        if ([obj isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = [NSDictionary dictionaryWithDictionary:obj];
            if ([dic[@"code"] integerValue] == 10000) {
                [Utils toastview:@"已提交取消信息"];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
            } else {
                [Utils toastview:dic[@"mes"]];
            }
        }
    }];
}


#pragma mark - Target Methods


#pragma mark - Public Methods


#pragma mark - Notification Methods


#pragma mark - KVO Methods


#pragma mark - Getter Setter Methods


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetX = scrollView.contentOffset.x / 2;
    
    [self.lineView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(offsetX);
    }];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat offsetX = scrollView.contentOffset.x;
    
    if (offsetX / screenWidth == 0) {
        self.leftBtn.selected = YES;
        self.rightBtn.selected = NO;
    } else if (offsetX / screenWidth == 1) {
        self.leftBtn.selected = NO;
        self.rightBtn.selected = YES;
    }
}


#pragma mark - MemoryWarning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
