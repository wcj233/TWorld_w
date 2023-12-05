//
//  CardRepairViewController.m
//  PhoneWorld
//
//  Created by 刘岑颖 on 16/10/13.
//  Copyright © 2016年 xiyoukeji. All rights reserved.
//

#import "CardRepairViewController.h"
#import "RepairCardView.h"
#import "FailedView.h"

@interface CardRepairViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic) RepairCardView *repairCardView;
@property (nonatomic) UIButton *currentButton;
@property (nonatomic) FailedView *finishedView;

@property (nonatomic) FailedView *processView;//过程弹窗

@end

@implementation CardRepairViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"补卡";
    
    self.repairCardView = [[RepairCardView alloc] init];
    [self.view addSubview:self.repairCardView];
    [self.repairCardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.mas_equalTo(0);
    }];
    
    @WeakObj(self);
    [self.repairCardView setCardRepairCallBack:^(NSMutableDictionary *dic) {
        @StrongObj(self);
        [self showWarningView];
        
        //提交补卡信息
        [WebUtils requestRepairInfoWithDic:dic andCallBack:^(id obj) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.processView removeFromSuperview];
            });
            
            if (![obj isKindOfClass:[NSError class]]) {
                NSString *code = [NSString stringWithFormat:@"%@",obj[@"code"]];
                if ([code isEqualToString:@"10000"]) {
                    [self showSucceedView];
                }else{
                    [self showWarningText:obj[@"mes"]];
                }
            }
        }];
    }];
    
    [self getWarningText];
}

//得到界面底部的警告文字
- (void)getWarningText{
    @WeakObj(self);
    [WebUtils requestWarningTextWithType:2 andCallBack:^(id obj) {
        @StrongObj(self);
        if ([obj isKindOfClass:[NSDictionary class]]) {
            NSString *code = [NSString stringWithFormat:@"%@",obj[@"code"]];
            if ([code isEqualToString:@"10000"]) {
                //有警告文字
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSString *warningString = @"温馨提示：\n";
                    NSArray *tipsArray = obj[@"data"][@"tips"];
                    
                    for (int i = 0; i < tipsArray.count; i ++) {
                        NSDictionary *tipsDic = tipsArray[i];
                        warningString = [warningString stringByAppendingString:[NSString stringWithFormat:@"%d.%@\n",i+1,tipsDic[@"tips"]]];
                    }
                    
                    self.repairCardView.warningLabel.text = warningString;
                    
                    [self.repairCardView.nextButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.top.mas_equalTo(self.repairCardView.warningLabel.mas_bottom).mas_equalTo(40);
                        make.centerX.mas_equalTo(0);
                        make.height.mas_equalTo(40);
                        make.width.mas_equalTo(171);
                        make.bottom.mas_equalTo(-40);
                    }];
                    
                });
            }
        }
    }];
}

- (void)showSucceedView{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.finishedView = [[FailedView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight) andTitle:@"提交成功" andDetail:@"请耐心等待..." andImageName:@"icon_smile" andTextColorHex:@"#eb000c"];
        [[UIApplication sharedApplication].keyWindow addSubview:self.finishedView];
        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(removeGrayView) userInfo:nil repeats:NO];
    });
}

- (void)showWarningView{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.processView = [[FailedView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight) andTitle:@"正在提交" andDetail:@"请耐心等待..." andImageName:@"icon_smile" andTextColorHex:@"#eb000c"];
        [[UIApplication sharedApplication].keyWindow addSubview:self.processView];
    });
}

- (void)removeGrayView{
    [UIView animateWithDuration:0.5 animations:^{
        self.finishedView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.finishedView removeFromSuperview];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
}

@end
