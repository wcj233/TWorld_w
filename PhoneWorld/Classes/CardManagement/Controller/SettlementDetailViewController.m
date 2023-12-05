//
//  SettlementDetailViewController.m
//  PhoneWorld
//
//  Created by 刘岑颖 on 16/10/19.
//  Copyright © 2016年 xiyoukeji. All rights reserved.
//

#import "SettlementDetailViewController.h"
#import "SettlementDetailView.h"
#import "FailedView.h"

@interface SettlementDetailViewController ()
@property (nonatomic) SettlementDetailView *detailView;
@property (nonatomic) FailedView *finishedView;
@property (nonatomic) NSString *sumMoney;
@property (nonatomic) FailedView *processView;
@end

@implementation SettlementDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"结算明细";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelAction)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:textfont14]} forState:UIControlStateNormal];
    
    self.detailView = [[SettlementDetailView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight - 64)];
    [self.view addSubview:self.detailView];
    
    @WeakObj(self);
    //得到总金额等金额信息
    
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        @StrongObj(self);
        if (status == AFNetworkReachabilityStatusReachableViaWWAN || status == AFNetworkReachabilityStatusReachableViaWiFi) {
            [self requestAllMoney];
        }else{
            [Utils toastview:@"无网络"];
        }
    }];
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    NSArray *titlesArray = @[@"开户号码：",@"预存金额：",@"套餐金额：",@"活动包："];
    
    if (self.isFinished == YES) {
        //成卡
        
        for (int i = 0; i < self.detailView.leftLabelsArray.count; i ++) {
            UILabel *lb = self.detailView.leftLabelsArray[i];
            switch (i) {
                case 0://开户号码
                {
                    lb.text = [NSString stringWithFormat:@"%@%@",titlesArray[i],self.detailModel.number];
                }
                    break;
                case 1://预存金额
                {
                    lb.text = [NSString stringWithFormat:@"%@%@",titlesArray[i],self.moneyString];
                }
                    break;
                case 3://活动包
                {
                    lb.text = [NSString stringWithFormat:@"%@%@",titlesArray[i],self.currentPromotionDictionary[@"name"]];
                }
                    break;
            }
        }
        
    }else{
        //白卡
        
        for (int i = 0; i < self.detailView.leftLabelsArray.count; i ++) {
            UILabel *lb = self.detailView.leftLabelsArray[i];
            switch (i) {
                case 0://开户号码
                {
                    lb.text = [NSString stringWithFormat:@"%@%@",titlesArray[i],self.infosArray.firstObject];
                }
                    break;
                case 1://预存金额
                {
                    lb.text = [NSString stringWithFormat:@"%@%@",titlesArray[i],self.moneyString];
                }
                    break;
                case 3://活动包
                {
                    lb.text = [NSString stringWithFormat:@"%@%@",titlesArray[i],self.currentPromotionDictionary[@"name"]];
                }
                    break;
            }
        }
    }
    
    [self.detailView setSubmitCallBack:^(id obj) {
        @StrongObj(self);
        [self submitAction:obj];
    }];
}

//得到总金额
- (void)requestAllMoney{
    @WeakObj(self);
    [WebUtils requestMoneyInfoWithPrestore:self.moneyString andPromotionId:self.currentPromotionDictionary[@"id"] andCallBack:^(id obj) {
        @StrongObj(self);
        if (![obj isKindOfClass:[NSError class]]) {
            NSString *code = [NSString stringWithFormat:@"%@",obj[@"code"]];
            if ([code isEqualToString:@"10000"]) {
                
                self.detailView.nextButton.userInteractionEnabled = YES;
                
                //得到总金额
                NSString *sumString = [NSString stringWithFormat:@"%@",obj[@"data"][@"sum"]];
                UILabel *lb = self.detailView.leftLabelsArray.lastObject;
                
                //套餐金额与总金额一致
                UILabel *lbMoney = self.detailView.leftLabelsArray[2];
                
                self.sumMoney = sumString;
                
                //得到优惠金额
                NSInteger money = self.moneyString.integerValue;
                NSInteger sumMoney = sumString.integerValue;
                UILabel *labelDiscount = self.detailView.leftLabelsArray[4];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    lb.text = [NSString stringWithFormat:@"总金额：%@",sumString];
                    lbMoney.text = [NSString stringWithFormat:@"套餐金额：%@",sumString];
                    labelDiscount.text = [NSString stringWithFormat:@"优惠金额：%ld",money - sumMoney];
                });
                
            }else{
                [self showWarningText:obj[@"mes"]];
            }
        }
    }];
}

- (void)popWarningViewWithMes:(NSString *)mes andType:(NSString *)type{
    
    NSMutableAttributedString *alertControllerStr = [[NSMutableAttributedString alloc] initWithString:mes];
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:mes message:@"是否重新提交该订单？" preferredStyle:UIAlertControllerStyleAlert];
    
    [alertControllerStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, [[alertControllerStr string] length])];
    [ac setValue:alertControllerStr forKey:@"attributedTitle"];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self submitAction:nil];
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
    
    [ac addAction:action1];
    [ac addAction:action2];
    [self presentViewController:ac animated:YES completion:nil];
}

- (void)successAction{
    NSString *message = @"订单提交成功！";
    NSMutableAttributedString *alertControllerStr = [[NSMutableAttributedString alloc] initWithString:message];
    [alertControllerStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(0, message.length)];
    
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:message message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
    if ([ac valueForKey:@"attributedTitle"]) {
        [ac setValue:alertControllerStr forKey:@"attributedTitle"];
    }
    
    [ac addAction:action1];
    [self presentViewController:ac animated:YES completion:nil];
}

- (void)cancelAction{
    /*
     不保存信息并返回首页
     */
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)submitAction:(id)obj{
    
    @WeakObj(self);
    dispatch_async(dispatch_get_main_queue(), ^{
        self.processView = [[FailedView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight) andTitle:@"正在提交" andDetail:@"请耐心等待..." andImageName:@"icon_smile" andTextColorHex:@"#eb000c"];
        [[UIApplication sharedApplication].keyWindow addSubview:self.processView];
    });
    
    if (self.isFinished == YES) {
        /*----成卡开户------*/
        
        NSMutableDictionary *sendDictionary = [self.collectionInfoDictionary mutableCopy];
        
        [sendDictionary setObject:self.detailModel.number forKey:@"number"];
        NSString *autoString = @"手工";
        if (self.isAuto) {
            autoString = @"读取";
        }
        [sendDictionary setObject:autoString forKey:@"authenticationType"];
        NSString *simid = [NSString stringWithFormat:@"%d",self.detailModel.simId];
        [sendDictionary setObject:simid forKey:@"simId"];
        [sendDictionary setObject:self.detailModel.simICCID forKey:@"simICCID"];
        [sendDictionary setObject:self.currentPackageDictionary[@"id"] forKey:@"packageId"];
        [sendDictionary setObject:self.currentPromotionDictionary[@"id"] forKey:@"promotionsId"];
        [sendDictionary setObject:self.sumMoney forKey:@"orderAmount"];
        NSString *orgId = [NSString stringWithFormat:@"%d",self.detailModel.org_number_poolsId];
        [sendDictionary setObject:orgId forKey:@"org_number_poolsId"];
        
        //提交操作
        [WebUtils requestSetOpenWithDictionary:sendDictionary andcallBack:^(id obj) {
            @StrongObj(self);
            dispatch_async(dispatch_get_main_queue(), ^{
                //提示框删除
                [self.processView removeFromSuperview];
            });
            
            if (![obj isKindOfClass:[NSError class]]) {
                
                NSString *code = [NSString stringWithFormat:@"%@",obj[@"code"]];
                if ([code isEqualToString:@"10000"]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [self successAction];
                    });
                    
                    
                }else{
                    NSString *mes = [NSString stringWithFormat:@"%@",obj[@"mes"]];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self popWarningViewWithMes:mes andType:@"成卡"];
                        
                    });
                }
            }
        }];
        
        /*----成卡开户---*/
        
    }else if(self.isFinished == NO){
        /*------白卡开户------*/
        
        NSMutableDictionary *sendDictionary = [self.collectionInfoDictionary mutableCopy];
        
        [sendDictionary setObject:self.infosArray.firstObject forKey:@"number"];
        
        NSString *simid = [NSString stringWithFormat:@"%@",self.imsiModel.simId];
        [sendDictionary setObject:simid forKey:@"simId"];
        
        [sendDictionary setObject:self.iccidString forKey:@"iccid"];
        
        [sendDictionary setObject:self.imsiModel.imsi forKey:@"imsi"];
        
        NSNumber *orderAmount = [NSNumber numberWithInt:self.imsiModel.prestore];
        [sendDictionary setObject:orderAmount forKey:@"orderAmount"];
        
        [sendDictionary setObject:self.currentPackageDictionary[@"id"] forKey:@"packageId"];
        [sendDictionary setObject:self.currentPromotionDictionary[@"id"] forKey:@"promotionsId"];
        
        [sendDictionary setObject:self.sumMoney forKey:@"payAmount"];
        
        [WebUtils requestOpenWhiteWithDictionary:sendDictionary andCallBack:^(id obj) {
            if ([obj isKindOfClass:[NSDictionary class]]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.processView removeFromSuperview];
                });
                NSString *code = [NSString stringWithFormat:@"%@",obj[@"code"]];
                if ([code isEqualToString:@"10000"]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [self successAction];
                        
                    });
                    
                }else{
                    NSString *mes = [NSString stringWithFormat:@"%@",obj[@"mes"]];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self popWarningViewWithMes:mes andType:@"白卡"];
                    });
                }
            }
        }];
        
        /*------白卡开户------*/
    }
}

@end
