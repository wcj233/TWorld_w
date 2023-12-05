//
//  BusinessPagingVC.m
//  PhoneWorld
//
//  Created by Allen on 2019/12/12.
//  Copyright © 2019 xiyoukeji. All rights reserved.
//

#import "BusinessPagingVC.h"

#import "TopCallMoneyViewController.h"
#import "LIdentifyPhoneNumberViewController.h"

#import <VTMagic.h>

@interface BusinessPagingVC ()<VTMagicViewDataSource,VTMagicViewDelegate>

@property (nonatomic ,strong) VTMagicController *magicController;



@end

@implementation BusinessPagingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setUI];
    
    [self loadData];
}

- (void)setUI{
    self.navigationItem.title = @"业务办理";
    
    self.view.backgroundColor = kSetColor(@"F9F9F9");
    
    [self addChildViewController:self.magicController];
    [self.view addSubview:self.magicController.view];
    [self.magicController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.leading.trailing.top.mas_equalTo(self.view);
    }];
}

- (void)loadData{
    [self.magicController.magicView reloadData];
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
        menuItem.titleLabel.font =  [UIFont systemFontOfSize:16];
    }
    return menuItem;
}

- (UIViewController *)magicView:(VTMagicView *)magicView viewControllerAtPage:(NSUInteger)pageIndex {
    if (pageIndex == 0) {
        TopCallMoneyViewController *vc = [magicView dequeueReusablePageWithIdentifier:@"TopCallMoneyViewController"];
        if (!vc) {
            vc = TopCallMoneyViewController.new;
        }
        return vc;
    }else if(pageIndex == 1) {
        LIdentifyPhoneNumberViewController *vc = [magicView dequeueReusablePageWithIdentifier:@"LIdentifyPhoneNumberViewController1"];
        if (!vc) {
            vc = [LIdentifyPhoneNumberViewController.alloc initWithType:1];
        }
        return vc;
    }else{
        LIdentifyPhoneNumberViewController *vc = [magicView dequeueReusablePageWithIdentifier:@"LIdentifyPhoneNumberViewController2"];
        if (!vc) {
            vc = [LIdentifyPhoneNumberViewController.alloc initWithType:2];
        }
        return vc;
    }
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
