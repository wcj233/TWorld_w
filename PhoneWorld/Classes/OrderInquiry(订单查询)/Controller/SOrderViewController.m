//
//  SOrderViewController.m
//  PhoneWorld
//
//  Created by 刘岑颖 on 2017/6/5.
//  Copyright © 2017年 xiyoukeji. All rights reserved.
//

#import "SOrderViewController.h"
#import "AccountTVCell.h"

#import "SCardOrderViewController.h"
#import "STopOrderViewController.h"
#import "LProductOrderViewController.h"
#import "WhiteCardOrderListViewController.h"
#import "PreOrderVC.h"

#import "BusinessOrderPagingVC.h"

@interface SOrderViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) UITableView *contentTableView;

@property (nonatomic) NSArray *imageNames;
@property (nonatomic) NSArray *titles;

@property (nonatomic) NSArray *jumpToArray;

@end

@implementation SOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.imageNames = @[@"order_icon_establish", @"home_icon_whiteestablish_big", @"home_icon_ownership_big", @"home_icon_fill_big", @"home_icon_telephoneexpenses_big", @"pic1",@"business_icon_purchase",@"business_icon_whiteprepare_small", @"order_icon_ownership_small",@"xkjh_icon_establish"];
//    self.titles = @[@"成卡开户订单",@"白卡开户订单",@"过户订单",@"补卡订单",@"话费充值订单",@"账户充值记录",@"流量包订单",@"白卡申请订单", @"预订单" , @"写卡激活订单"];
    
    self.imageNames = @[@"order_icon_establish", @"home_icon_whiteestablish_big", @"home_icon_ownership_big", @"home_icon_fill_big", @"Business_icon", @"pic1",@"business_icon_whiteprepare_small", @"order_icon_ownership_small",@"xkjh_icon_establish"];
    self.titles = @[@"成卡开户订单",@"白卡开户订单",@"过户订单",@"补卡订单", @"业务订单",@"账户充值记录",@"白卡申请订单", @"预订单" , @"写卡激活订单"];
    
//    STopOrderViewController
    
    self.jumpToArray = @[@"SCardOrderViewController",@"SCardOrderViewController",@"SCardOrderViewController",@"SCardOrderViewController",@"BusinessOrderPagingVC",@"STopOrderViewController",@"WhiteCardOrderListViewController", @"PreOrderVC", @"SCardOrderViewController"];
    
    [self contentTableView];
    
}

#pragma mark - Method

- (void)pushViewControllerWithName:(NSString *)name andRow:(NSInteger)row{
    
    if ([name isEqualToString:@"SCardOrderViewController"]) {
        SCardOrderViewController *vc = [[SCardOrderViewController alloc] init];
        switch (row) {
            case 0:
                vc.type = ChengKa;
                break;
            case 1:
                vc.type = BaiKa;
                break;
            case 2:
                vc.type = GuoHu;
                break;
            case 3:
                vc.type = BuKa;
                break;
            case 8:
                vc.type = XieKa;
                break;
        }
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else if([name isEqualToString:@"STopOrderViewController"]){
        
        STopOrderViewController *vc = [[STopOrderViewController alloc] init];
//        switch (row) {
//            case 4:
//                vc.title = @"话费充值订单";
//                break;
//            case 5:
                vc.title = @"账户充值订单";
//                break;
//        }
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([name isEqualToString:@"WhiteCardOrderListViewController"]){
        WhiteCardOrderListViewController *vc = [[WhiteCardOrderListViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([name isEqualToString:@"PreOrderVC"]) {
        PreOrderVC *vc = [[PreOrderVC alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([name isEqualToString:@"BusinessOrderPagingVC"]) {
        BusinessOrderPagingVC *vc = BusinessOrderPagingVC.new;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else {
        LProductOrderViewController *vc = [[LProductOrderViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
}

#pragma mark - LazyLoading

- (UITableView *)contentTableView{
    if (_contentTableView == nil) {
        _contentTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [self.view addSubview:_contentTableView];
        [_contentTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.mas_equalTo(0);
        }];
        _contentTableView.tableFooterView = [UIView new];
        _contentTableView.delegate = self;
        _contentTableView.dataSource = self;
        [_contentTableView registerClass:[AccountTVCell class] forCellReuseIdentifier:@"AccountTVCell"];
        _contentTableView.backgroundColor = COLOR_BACKGROUND;
    }
    return _contentTableView;
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *titleString = self.titles[indexPath.row];
    NSString *imageName = self.imageNames[indexPath.row];
    
    AccountTVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AccountTVCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[AccountTVCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AccountTVCell"];
    }
    
    cell.titleLB.text = titleString;
    cell.imageV.image = [UIImage imageNamed:imageName];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 64;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];

    switch (indexPath.row) {
        case 0:
        {
            NSInteger i = [ud integerForKey:@"orderQueryRenew"];
            i = i + 1;
            [ud setInteger:i forKey:@"orderQueryRenew"];
            [ud synchronize];
        }
            break;
        case 1:
        {
            NSInteger i = [ud integerForKey:@"orderQueryNew"];
            i = i + 1;
            [ud setInteger:i forKey:@"orderQueryNew"];
            [ud synchronize];
        }
            break;
        case 2:
        {
            NSInteger i = [ud integerForKey:@"orderQueryTransform"];
            i = i + 1;
            [ud setInteger:i forKey:@"orderQueryTransform"];
            [ud synchronize];
        }
            break;
        case 3:
        {
            NSInteger i = [ud integerForKey:@"orderQueryReplace"];
            i = i + 1;
            [ud setInteger:i forKey:@"orderQueryReplace"];
            [ud synchronize];
        }
            break;
        case 4:
        {
            NSInteger i4 = [ud integerForKey:@"orderQueryRecharge"];
            i4 = i4 + 1;
            [ud setInteger:i4 forKey:@"orderQueryRecharge"];
            [ud synchronize];
        }
            break;
        case 5:
        {
            
        }
            break;
        default:
            break;
    }

    [self pushViewControllerWithName:self.jumpToArray[indexPath.row] andRow:indexPath.row];
}

@end
