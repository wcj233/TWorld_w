//
//  BusinessOrderPagingVC.m
//  PhoneWorld
//
//  Created by Allen on 2019/12/12.
//  Copyright © 2019 xiyoukeji. All rights reserved.
//

#import "BusinessOrderPagingVC.h"
#import "STopOrderViewController.h"
#import "LProductOrderViewController.h"
#import "MemberOrderListVC.h"
#import <VTMagic.h>

@interface BusinessOrderPagingVC ()<VTMagicViewDataSource,VTMagicViewDelegate>

@property (nonatomic ,strong) VTMagicController *magicController;

@property (nonatomic, assign) id currentVC;

@end

@implementation BusinessOrderPagingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setUI];
    
    [self loadData];
}
- (void)setUI{
    self.navigationItem.title = @"业务订单";
    
    self.view.backgroundColor = kSetColor(@"F9F9F9");
    
    [self addChildViewController:self.magicController];
    [self.view addSubview:self.magicController.view];
    [self.magicController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.leading.trailing.top.mas_equalTo(self.view);
    }];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"筛选" style:UIBarButtonItemStylePlain target:self action:@selector(clickRightNavigatoinItem)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:textfont16],NSForegroundColorAttributeName:[Utils colorRGB:@"#008bd5"]} forState:UIControlStateNormal];
}

- (void)loadData{
    [self.magicController.magicView reloadData];
}

#pragma mark - 事件

- (void)clickRightNavigatoinItem{
    if ([self.currentVC isKindOfClass:STopOrderViewController.class]) {
        
        STopOrderViewController *svc = self.currentVC;
        [svc selectAction];
    }else if ([self.currentVC isKindOfClass:MemberOrderListVC.class]) {
        
        MemberOrderListVC *svc = self.currentVC;
        [svc selectAction];
    }
}

#pragma makr - VTMagicViewDelegate
- (NSArray<NSString *> *)menuTitlesForMagicView:(VTMagicView *)magicView{
    return @[@"话费充值",@"流量包",@"会员"];
}

- (UIButton *)magicView:(VTMagicView *)magicView menuItemAtIndex:(NSUInteger)itemIndex {
    static NSString *itemIdentifier = @"itemIdentifier";
    UIButton *menuItem = [magicView dequeueReusableItemWithIdentifier:itemIdentifier];
    if (!menuItem) {
        menuItem = [UIButton buttonWithType:UIButtonTypeCustom];
        [menuItem setTitleColor:rgba(236, 108, 0, 1) forState:UIControlStateSelected];
        [menuItem setTitleColor:rgba(51, 51, 51, 1) forState:UIControlStateNormal];
        menuItem.titleLabel.font = [UIFont systemFontOfSize:16];
    }
    return menuItem;
}

- (UIViewController *)magicView:(VTMagicView *)magicView viewControllerAtPage:(NSUInteger)pageIndex {
    if (pageIndex == 0) {
        STopOrderViewController *vc = [magicView dequeueReusablePageWithIdentifier:@"STopOrderViewController"];
        if (!vc) {
            vc = STopOrderViewController.new;
            vc.hidesBottomBarWhenPushed = YES;
            vc.title = @"话费充值订单";
        }
        return vc;
    }else if(pageIndex == 1) {
        MemberOrderListVC *vc = [magicView dequeueReusablePageWithIdentifier:@"MemberOrderListVC1"];
        if (!vc) {
            vc = [[MemberOrderListVC alloc] initWithType:@"2"];
            vc.hidesBottomBarWhenPushed = YES;
        }
        return vc;
    }else{
        MemberOrderListVC *vc = [magicView dequeueReusablePageWithIdentifier:@"MemberOrderListVC2"];
        if (!vc) {
            vc = [[MemberOrderListVC alloc]initWithType:@"3"];
            vc.hidesBottomBarWhenPushed = YES;
        }
        return vc;
    }
}

- (void)magicView:(VTMagicView *)magicView viewDidAppear:(__kindof UIViewController *)viewController atPage:(NSUInteger)pageIndex{

    self.currentVC = viewController;
}

#pragma mark - 懒加载
- (VTMagicController *)magicController {
    if (!_magicController) {
        _magicController = [[VTMagicController alloc] init];
        _magicController.magicView.navigationColor = UIColor.whiteColor;
        _magicController.magicView.sliderColor = rgba(236, 108, 0, 1);
        _magicController.magicView.layoutStyle = VTLayoutStyleDivide;
        _magicController.magicView.switchStyle = VTSwitchStyleDefault;
        _magicController.magicView.navigationHeight = 44.f;
        _magicController.magicView.separatorColor = rgba(221, 221, 221, 1);
        _magicController.magicView.sliderExtension = 0;
        _magicController.magicView.dataSource = self;
        _magicController.magicView.delegate = self;
    }
    return _magicController;
}

@end
