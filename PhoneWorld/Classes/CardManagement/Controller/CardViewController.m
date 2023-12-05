//
//  CardViewController.m
//  PhoneWorld
//
//  Created by 刘岑颖 on 16/10/11.
//  Copyright © 2016年 xiyoukeji. All rights reserved.
//

#import "CardViewController.h"
#import "CardManageView.h"

#import "FinishCardViewController.h"
#import "TransferCardViewController.h"
#import "CardRepairViewController.h"
#import "WhiteCardViewController.h"
#import "CardInquiryViewController.h"

#import "MessageViewController.h"
#import "PersonalHomeViewController.h"
#import "WhitePrepareOpenOneViewController.h"
#import "ChooseEntryViewController.h"
#import "TopCallMoneyViewController.h"
#import "PhoneCashCheckViewController.h"
#import "AgentNumberListViewController.h"
#import "AgentWhiteRecordViewController.h"
#import "ChooseProductViewController.h"
#import "LIdentifyPhoneNumberViewController.h"
#import "ChooseWayViewController.h"
#import "PreOrderCreateVC.h"

#import "BusinessPagingVC.h"
#import "WWhiteCardApplyViewController.h"

@interface CardViewController ()

@property (nonatomic) CardManageView *cardView;

@end

@implementation CardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.backBarButtonItem = [Utils returnBackButton];
    
    self.cardView = [[CardManageView alloc] init];
    [self.view addSubview:self.cardView];
    [self.cardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).mas_equalTo(0);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(self.view.mas_bottom).mas_equalTo(0);
    }];
    @WeakObj(self);
    self.cardView.myCallBack = ^(NSString *titleStr) {
        @StrongObj(self);
        
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        NSString *grade = [ud objectForKey:@"grade"];
        
        if ([titleStr isEqualToString:@"业务办理"]) {
            [self.navigationController pushViewController:BusinessPagingVC.new animated:YES];
        }else if ([titleStr isEqualToString:@"过户"]) {
            NSInteger i1 = [ud integerForKey:@"transform"];
            i1 = i1 + 1;
            [ud setInteger:i1 forKey:@"transform"];
            [ud synchronize];
            TransferCardViewController *vc = [TransferCardViewController new];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }else if ([titleStr isEqualToString:@"成卡开户"]) {
            NSInteger i0 = [ud integerForKey:@"renewOpen"];
            i0 = i0 + 1;
            [ud setInteger:i0 forKey:@"renewOpen"];
            [ud synchronize];
            ChooseWayViewController *vc = [[ChooseWayViewController alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }else if ([titleStr isEqualToString:@"补卡"]) {
            //补卡
            NSInteger i2 = [ud integerForKey:@"replace"];
            i2 = i2 + 1;
            [ud setInteger:i2 forKey:@"replace"];
            [ud synchronize];
            CardRepairViewController *vc = [CardRepairViewController new];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }else if ([titleStr isEqualToString:@"话费余额查询"]) {
            //话费余额
            NSInteger i0 = [ud integerForKey:@"phoneBanlance"];
            i0 = i0 + 1;
            [ud setInteger:i0 forKey:@"phoneBanlance"];
            [ud synchronize];
            PhoneCashCheckViewController *vc = [PhoneCashCheckViewController new];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }else if ([titleStr isEqualToString:@"账单查询"]) {
            UIStoryboard* story = [UIStoryboard storyboardWithName:@"Bill" bundle:nil];
            UIViewController *vc=[story instantiateViewControllerWithIdentifier:@"BillInquiryViewController"];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }else if ([titleStr isEqualToString:@"靓号"]) {
            //靓号
            ChooseEntryViewController *vc = [[ChooseEntryViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }else if ([titleStr isEqualToString:@"预订单生成"]) {
            // 预订单生成
            [self showWaitView];
            @WeakObj(self)
            [WebUtils agencyCheckUserDSCallBack:^(id obj) {
                @StrongObj(self)
                if ([obj isKindOfClass:[NSDictionary class]]) {
                    [self hideWaitView];
                    
                    NSDictionary *dic = [NSDictionary dictionaryWithDictionary:obj];
                    if ([dic[@"code"] integerValue] == 10000) {
                        if ([dic[@"data"][@"isDS"] isEqualToString:@"Y"]) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                PreOrderCreateVC *vc = [[PreOrderCreateVC alloc] init];
                                vc.hidesBottomBarWhenPushed = YES;
                                [self.navigationController pushViewController:vc animated:YES];
                            });
                        } else {
                            [Utils toastview:dic[@"mes"]];
                            return;
                        }
                    } else {
                        [Utils toastview:dic[@"mes"]];
                        return;
                    }
                }
            }];
            
        }else if ([titleStr isEqualToString:@"白卡预开户"]) {
            [Utils toastview:@"该功能待开发，敬请期待！"];
        }else if ([titleStr isEqualToString:@"预开户记录"]) {
            AgentWhiteRecordViewController *vc = [AgentWhiteRecordViewController new];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }else if ([titleStr isEqualToString:@"子账户开户记录"]) {
            //子账户开户记录
            UIStoryboard* story = [UIStoryboard storyboardWithName:@"Subaccount" bundle:nil];
            UIViewController *vc=[story instantiateViewControllerWithIdentifier:@"SubaccountEstablishViewController"];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }else if ([titleStr isEqualToString:@"白卡申请"]) {
            WWhiteCardApplyViewController *vc = WWhiteCardApplyViewController.new;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    };
}

@end
