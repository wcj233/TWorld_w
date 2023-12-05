//
//  PreOrderCreateVC.m
//  PhoneWorld
//
//
// Created by 黄振元 on 2019/4/24.
// Copyright © 2019 xiyoukeji. All rights reserved.
//
// @class PreOrderCreateVC
// @abstract 预订单生成VC ，第一步，号码验证
//

#import "PreOrderCreateVC.h"

// Controllers
#import "ChoosePackageViewController.h"
#import "NewFinishedCardDetailViewController.h"
#import "PreOrderChooseSetVC.h"

// Model
#import "PhoneDetailModel.h"
#import "PreOrderMobileModel.h"

// Views
#import "FinishCardView.h"
#import "FailedView.h"
#import "ChoosePackageViewController.h"


@interface PreOrderCreateVC ()

@property (nonatomic) FinishCardView *finishCardView;
@property (nonatomic) FailedView *failedView;

// 该手机号的详情model
@property (strong, nonatomic) PreOrderMobileModel *mobileModel;
@property (copy, nonatomic) NSString *phoneNumber;

@end


@implementation PreOrderCreateVC

#pragma mark - View Controller LifeCyle
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.navigationItem.title = @"号码验证";
    
    [self createMain];
}


#pragma mark - Override Methods


#pragma mark - Initial Methods


#pragma mark - Privater Methods

- (void)createMain {
    self.finishCardView = [[FinishCardView alloc] initWithFrame:CGRectZero andIsFace:NO];
    [self.view addSubview:self.finishCardView];
    [self.finishCardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_equalTo(0);
    }];
    
    @WeakObj(self);
    //下一步
    [self.finishCardView setNextCallBack:^(NSString *title) {
        @StrongObj(self);
        InputView *phone = self.finishCardView.inputViews.firstObject;
        [self checkPhoneNumer:phone.textField.text];
    }];
    
    
    [self.finishCardView setFinishCardCallBack:^(NSString *tel, NSString *puk) {
        @StrongObj(self);
        [Utils toastview:@"正在查询，请稍后！"];
        self.finishCardView.nextButton.userInteractionEnabled = NO;
        
        if (![[AFNetworkReachabilityManager sharedManager] isReachable]) {
            self.finishCardView.nextButton.userInteractionEnabled = YES;
        }
        [self getFinishedCardActionWithTel:tel andPUK:puk];
    }];
}

- (void)getFinishedCardActionWithTel:(NSString *)tel andPUK:(NSString *)puk{
//    [WebUtils requestFinishedCardWithTel:tel andPUK:puk andCallBack:^(id obj) {
//        self.finishCardView.nextButton.userInteractionEnabled = YES;
//        if ([obj isKindOfClass:[NSDictionary class]]) {
//
//            NSString *code = [NSString stringWithFormat:@"%@",obj[@"code"]];
//            if ([code isEqualToString:@"10000"]) {
//
//                if ([obj[@"data"] isKindOfClass:[NSNull class]]) {
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        [Utils toastview:@"后台无数据"];
//                    });
//                }else{
//                    //成功--------------
//                    NSDictionary *dic = obj[@"data"];
//                    [self gotoNextActionWithData:dic];
//                }
//
//            }else{
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [self showFailedAction:obj[@"mes"]];
//                });
//            }
//        }
//    }];
}

- (void)gotoNextActionWithMobileModel:(PreOrderMobileModel *)mobileModel{
    //    PhoneDetailModel *detailModel = [[PhoneDetailModel alloc] initWithDictionary:dataDic error:nil];
    //    ChoosePackageViewController *vc = [ChoosePackageViewController new];
    //    vc.detailModel = detailModel;
    //    dispatch_async(dispatch_get_main_queue(), ^{
    //        [self.navigationController pushViewController:vc animated:YES];
    //    });
    
//    UIStoryboard* story = [UIStoryboard storyboardWithName:@"NewFinishedCard" bundle:nil];
//    NewFinishedCardDetailViewController *vc=[story instantiateViewControllerWithIdentifier:@"NewFinishedCardDetailViewController"];
//    vc.cardOpenMode = 3;
//    vc.isFaceCheck = NO;
//    [vc setPhone:[[PhoneDetailModel alloc] initWithDictionary:dataDic error:nil]];
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [self.navigationController pushViewController:vc animated:YES];
//    });
    
    PreOrderChooseSetVC *vc = [[PreOrderChooseSetVC alloc] init];
    vc.mobileModel = mobileModel;
    vc.mobileModel.number = self.phoneNumber;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationController pushViewController:vc animated:YES];
    });
}

- (void)checkPhoneNumer:(NSString *)phoneNumber{
    self.phoneNumber = phoneNumber;
    [self showWaitView];
    @WeakObj(self);
    [WebUtils agencySelectionCheckWithParams:@{@"number" : phoneNumber} andCallback:^(id obj) {
        @StrongObj(self)
        
        [self hideWaitView];

        if ([obj isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = [NSDictionary dictionaryWithDictionary:obj];
            if ([dic[@"code"] integerValue] == 10000) {
                NSDictionary *dataDic = dic[@"data"];
                PreOrderMobileModel *mobileModel = [[PreOrderMobileModel alloc] initWithDictionary:dataDic error:nil];
                self.mobileModel = mobileModel;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self gotoNextActionWithMobileModel:mobileModel];
                });
            } else {
                [Utils toastview:dic[@"mes"]];
                return;
            }
        }
    }];
    
//    [WebUtils requestIsLiangWithPhoneNumber:phoneNumber andCallBack:^(id obj) {
//        @StrongObj(self);
//        if ([obj isKindOfClass:[NSDictionary class]]) {
//            NSString *code = [NSString stringWithFormat:@"%@",obj[@"code"]];
//            if ([code isEqualToString:@"10000"]) {
//                NSString *isLiang = obj[@"data"][@"isLiang"];
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    if ([isLiang isEqualToString:@"Y"]) {
//                        [self showPUKAction];
//                    }else{
//                        NSDictionary *dic = obj[@"data"];
//                        NSLog(@"dic = %@", dic);
//                        [self gotoNextActionWithData:dic];
//                    }
//                });
//
//            }else{
//                [self showWarningText:obj[@"mes"]];
//            }
//        }
//    }];
}

- (void)showPUKAction{
    InputView *puk = self.finishCardView.inputViews[1];
    puk.hidden = NO;
    
    [self.finishCardView warningLabel];
    
    [self.finishCardView.nextButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.finishCardView.warningLabel.mas_bottom).mas_equalTo(40);
        make.centerX.mas_equalTo(0);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(171);
    }];
    [self.finishCardView.nextButton setTitle:@"下一步" forState:UIControlStateNormal];
}

- (void)showFailedAction:(id)text{
    NSString *mes = [NSString stringWithFormat:@"%@",text];
    //失败
    self.failedView = [[FailedView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight) andTitle:@"验证失败" andDetail:mes andImageName:@"attention" andTextColorHex:@"#333333"];
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.failedView];
    
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(removeGrayView) userInfo:nil repeats:NO];
}

- (void)removeGrayView{
    [UIView animateWithDuration:0.5 animations:^{
        self.failedView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.failedView removeFromSuperview];
    }];
}


#pragma mark - Target Methods


#pragma mark - Public Methods


#pragma mark - Notification Methods


#pragma mark - KVO Methods


#pragma mark - Getter Setter Methods


#pragma mark - MemoryWarning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
