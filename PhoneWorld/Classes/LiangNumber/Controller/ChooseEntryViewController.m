//
//  ChooseEntryViewController.m
//  PhoneWorld
//
//  Created by 刘岑颖 on 2017/5/9.
//  Copyright © 2017年 xiyoukeji. All rights reserved.
//

#import "ChooseEntryViewController.h"
#import "ChooseEntryView.h"
#import "LiangListViewController.h"
#import "BondViewController.h"
#import "WWhiteCardApplyViewController.h"

@interface ChooseEntryViewController ()

@property (nonatomic) ChooseEntryView *chooseView;

@end

@implementation ChooseEntryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"入口选择";
    
    self.chooseView = [[ChooseEntryView alloc] init];
    [self.view addSubview:self.chooseView];
    [self.chooseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0);
    }];
    
    for (int i = 0; i < self.chooseView.openArray.count; i ++) {
        OpenWayView *openWayView = self.chooseView.openArray[i];
        [openWayView.chooseButton addTarget:self action:@selector(nextAction:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)nextAction:(UIButton *)button{
    if (button.tag == 1) {
        [self jumpToLiangListAction:1];
        return;
    }
    //验证是否缴纳保证金
    @WeakObj(self);
    [WebUtils requestIsBondWithCallBack:^(id obj) {
        @StrongObj(self);
        [self analysisWithObj:obj andSuccess:^(id obj) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSDictionary *dict = obj;
                NSDictionary *dataDic = [dict objectForKey:@"data"];
                NSString *isBond = [dataDic objectForKey:@"isBond"];
                NSString *isQuaBond = [dataDic objectForKey:@"isQuaBond"];
                if ([isBond isEqualToString:@"Y"] && [isQuaBond isEqualToString:@"Y"]) {
                    [self jumpToLiangListAction:button.tag];
                }else if([isBond isEqualToString:@"N"] && [isQuaBond isEqualToString:@"Y"]){
                    [self jumpToBond];
                }else{
                    [self showAlert];
                }
            });
        } andFailed:^{
            
        }];
    }];
}

- (void)jumpToLiangListAction:(NSInteger)tag{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (tag == 1) {
            //代理商靓号
            LiangListViewController *vc = [[LiangListViewController alloc] init];
            vc.title = @"代理商靓号";
            [self.navigationController pushViewController:vc animated:YES];
        }else if (tag == 0){
            //话机世界靓号
            LiangListViewController *vc = [[LiangListViewController alloc] init];
            vc.title = @"话机世界靓号";
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            WWhiteCardApplyViewController *vc = [[WWhiteCardApplyViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    });
}

- (void)showAlert{
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"注意" message:@"对不起，您暂未开通此业务" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [ac addAction:action1];
    [self presentViewController:ac animated:YES completion:nil];
}

- (void)jumpToBond{
    BondViewController *vc = [[BondViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
