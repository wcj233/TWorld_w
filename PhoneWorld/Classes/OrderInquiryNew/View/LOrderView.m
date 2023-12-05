//
//  LOrderView.m
//  PhoneWorld
//
//  Created by 刘岑颖 on 17/2/27.
//  Copyright © 2017年 xiyoukeji. All rights reserved.
//

#import "LOrderView.h"

#import "LOpenAccomplishCardVC.h"
#import "LOpenWhiteCardVC.h"
#import "LTransferVC.h"
#import "LRepairCardVC.h"
#import "LTopUpVC.h"

@interface LOrderView ()

@property (nonatomic) NSArray *titlesArray;

@end

@implementation LOrderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titlesArray = @[@"成卡开户",@"白卡开户",@"过户",@"补卡",@"话费充值"];
        self.currentPageIndex = 0;
        [self topView];
        [self conditionView];
        [self pageController];
        
        [self screenView];
        
        [self changeScreenViewCondition];

        
        __block __weak LOrderView *weakself = self;
        
        //成卡开户  白卡开户  过户  补卡  话费充值
        [self.topView setTopButtonsCallBack:^(NSInteger i) {
            CGFloat d = weakself.currentPageIndex - 10 - i;
            if (d < 0) {
                [weakself.pageController setViewControllers:@[[weakself.viewControllerArray objectAtIndex:i-10]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:^(BOOL finished) {
                }];
            }else{
                [weakself.pageController setViewControllers:@[[weakself.viewControllerArray objectAtIndex:i-10]] direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:^(BOOL finished) {
                }];
            }
            weakself.currentPageIndex = i - 10;
            weakself.screenView.hidden = YES;
            weakself.conditionView.upDownButton.selected = NO;
            
            [weakself loadDataWithIndex:i - 10 andConditions:nil];
            [weakself changeScreenViewCondition];
        }];
        
        [self.conditionView setLFilterShowCallBack:^(BOOL selected) {
            [weakself showAction:selected];
        }];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideScreenViewAction) name:@"ScreenViewHidden" object:nil];

    }
    return self;
}

- (LOrderTopView *)topView{
    if (_topView == nil) {
        _topView = [[LOrderTopView alloc] initWithFrame:CGRectZero andTitles:self.titlesArray andType:TopButtonsViewTypeOne];
        [self addSubview:_topView];
        [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.mas_equalTo(0);
            make.height.mas_equalTo(40);
        }];
    }
    return _topView;
}

- (LFilterConditionView *)conditionView{
    if (_conditionView == nil) {
        _conditionView = [[LFilterConditionView alloc] initWithFrame:CGRectZero];
        [self addSubview:_conditionView];
        [_conditionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(_topView.mas_bottom).mas_equalTo(1);
            make.height.mas_equalTo(40);
        }];
    }
    return _conditionView;
}

- (UIPageViewController *)pageController{
    if (!_pageController) {
        _pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
        
        _pageController.automaticallyAdjustsScrollViewInsets = NO;
        _pageController.view.backgroundColor = [UIColor clearColor];
        
        /*参数1:当前显示的Controller数组中的Controller*/
        [_pageController setViewControllers:@[[self.viewControllerArray objectAtIndex:0]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
        
        /*这两句话会扰乱之前设置的UIPageViewController的View的frame，所以，设置frame一定要在这两句话后面*/
        [self addSubview:_pageController.view];
        [[self viewController] addChildViewController:_pageController];
        
        [_pageController.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(self.conditionView.mas_bottom).mas_equalTo(0);
            make.bottom.mas_equalTo(0);
        }];
    }
    return _pageController;
}

- (NSMutableArray *)viewControllerArray{
    if (!_viewControllerArray) {
        _viewControllerArray = [[NSMutableArray alloc]init];
        
        LOpenAccomplishCardVC *vc0 = [[LOpenAccomplishCardVC alloc] init];
        LOpenWhiteCardVC *vc1 = [[LOpenWhiteCardVC alloc] init];
        LTransferVC *vc2 = [[LTransferVC alloc] init];
        LRepairCardVC *vc3 = [[LRepairCardVC alloc] init];
        LTopUpVC *vc4 = [[LTopUpVC alloc] init];
        
        [_viewControllerArray addObjectsFromArray:@[vc0,vc1,vc2,vc3,vc4]];
    }
    return _viewControllerArray;
}

- (ScreenView *)screenView{
    if (_screenView == nil) {
        _screenView = [[ScreenView alloc] initWithFrame:CGRectMake(0, 40 + 41, screenWidth, screenHeight - (40 + 41 + 64)) andContent:@{@"起始时间":@"timePicker",@"截止时间":@"timePicker",@"订单状态":@[],@"手机号码":@"phoneNumber"} andLeftTitles:@[@"起始时间",@"截止时间",@"订单状态",@"手机号码"] andRightDetails:@[@"请选择",@"请选择",@"请选择",@"请输入手机号码"]];
        [self addSubview:_screenView];
        _screenView.hidden = YES;
    }
    return _screenView;
}

#pragma mark - Method --------------------

- (void)showAction:(BOOL)selected{
    if (selected == YES) {//显示筛选框
        [self showScreenViewAction];
    }else{
        [self hideScreenViewAction];
    }
}

//改变筛选框的筛选条件数组
- (void)changeScreenViewCondition{
    CGRect frame = CGRectMake(0, 0, screenWidth, 4*40);
    if (self.currentPageIndex == 4) {
        NSMutableDictionary *contentDic = [@{@"起始时间":@"timePicker",@"截止时间":@"timePicker",@"手机号码":@"phoneNumber"} mutableCopy];
        self.screenView.contentDic = contentDic;
        self.screenView.leftTitles = @[@"起始时间",@"截止时间",@" 手机号码"];
        self.screenView.rightDetails = @[@"请选择",@"请选择",@"请输入手机号码"];
        frame = CGRectMake(0, 0, screenWidth, 3*40);
    }else{
        NSMutableDictionary *contentDic = [@{@"起始时间":@"timePicker",@"截止时间":@"timePicker"} mutableCopy];
        
        NSArray *statusArray;
        if (self.currentPageIndex == 0 || self.currentPageIndex == 1) {
            statusArray = @[@"全部",@"已提交",@"等待中",@"成功",@"失败",@"已取消"];
        }else{
            statusArray = @[@"全部",@"待审核",@"审核通过",@"审核不通过"];
        }
        
        [contentDic setValue:statusArray forKey:@"订单状态"];
        [contentDic setValue:@"phoneNumber" forKey:@"手机号码"];
        self.screenView.leftTitles = @[@"起始时间",@"截止时间",@"订单状态",@"手机号码"];
        self.screenView.rightDetails = @[@"请选择",@"请选择",@"请选择",@"请输入手机号码"];
        self.screenView.contentDic = contentDic;
    }
    
    self.screenView.screenTableView.frame = frame;
    [self.screenView.screenTableView reloadData];
}

- (void)showScreenViewAction{
    self.conditionView.upDownButton.selected = YES;
    self.screenView.hidden = NO;
    [self bringSubviewToFront:self.screenView];
    [UIView animateWithDuration:0.3 animations:^{
        self.screenView.alpha = 1.0;
    } completion:^(BOOL finished) {
    }];
}

- (void)hideScreenViewAction{
    self.conditionView.upDownButton.selected = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.screenView.alpha = 0;
    } completion:^(BOOL finished) {
        self.screenView.hidden = YES;
    }];
}

- (void)loadDataWithIndex:(NSInteger)index andConditions:(NSDictionary *)conditions{
    NSMutableArray *conditionsArray = [NSMutableArray array];

    if (conditions != nil) {
        [conditionsArray addObject:conditions[@"起始时间"]];
        [conditionsArray addObject:conditions[@"截止时间"]];
        
        
        if (conditions.count == 3) {
            [conditionsArray addObject:conditions[@"手机号码"]];
        }else{
            [conditionsArray addObject:conditions[@"订单状态"]];
            [conditionsArray addObject:conditions[@"手机号码"]];
        }
    }
    
    [self.conditionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.topView.mas_bottom).mas_equalTo(1);
        make.height.mas_equalTo(40);
    }];
    
    UIViewController *viewController = self.viewControllerArray[index];
    switch (index) {
        case 0:
        {
            LOpenAccomplishCardVC *vc = (LOpenAccomplishCardVC *)viewController;
            vc.inquiryConditionArray = conditionsArray;
            [vc.orderView.orderTableView.mj_header beginRefreshing];
        }
            break;
        case 1:
        {
            LOpenWhiteCardVC *vc = (LOpenWhiteCardVC *)viewController;
            vc.inquiryConditionArray = conditionsArray;
            [vc.orderView.orderTableView.mj_header beginRefreshing];
        }
            break;
        case 2:
        {
            LTransferVC *vc = (LTransferVC *)viewController;
            vc.inquiryConditionArray = conditionsArray;
            [vc.orderView.orderTableView.mj_header beginRefreshing];
        }
            break;
        case 3:
        {
            LRepairCardVC *vc = (LRepairCardVC *)viewController;
            vc.inquiryConditionArray = conditionsArray;
            [vc.orderView.orderTableView.mj_header beginRefreshing];
        }
            break;
        case 4:
        {
            LTopUpVC *vc = (LTopUpVC *)viewController;
            vc.inquiryConditionArray = conditionsArray;
            [vc.orderView.orderTwoTableView.mj_header beginRefreshing];
        }
            break;
    }
}

@end
