//
//  TransferCardViewController.m
//  PhoneWorld
//
//  Created by 刘岑颖 on 16/10/13.
//  Copyright © 2016年 xiyoukeji. All rights reserved.
//

#import "TransferCardViewController.h"
#import "TransferCardView.h"
#import "FailedView.h"
#import "FMFileVideoController.h"

@interface TransferCardViewController ()<UIScrollViewDelegate>

@property (nonatomic) TransferCardView *transferCardView;
@property (nonatomic) FailedView *processView;//进度弹窗
@property (nonatomic) FailedView *successView;//成功弹窗

@end

@implementation TransferCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"过户";
    
    self.transferCardView = [[TransferCardView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight - 64)];
    [self.view addSubview:self.transferCardView];
    
    @WeakObj(self);
    //下一步按钮,传过来所有的当前界面得到的信息
    [self.transferCardView setNextCallBack:^(NSDictionary * sendDic) {
        @StrongObj(self);
        
        /*新增人脸识别功能*/
//        [self showWarningView];
        
        [self getTransferInfoActionWithDictionary:sendDic];
    }];
    
    [self getWarningText];
}

- (void)getTransferInfoActionWithDictionary:(NSDictionary *)sendDic{
    //人脸
    FMFileVideoController *viewController = [[FMFileVideoController alloc]init];
    viewController.collectionInfoDictionary = sendDic;
    viewController.typeString = @"过户";
    [self.navigationController pushViewController:viewController animated:YES];
//    @WeakObj(self);
//    [WebUtils requestTransferInfoWithDic:sendDic andCallBack:^(id obj) {
//        @StrongObj(self);
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self.processView removeFromSuperview];
//        });
//
//        if (![obj isKindOfClass:[NSError class]]) {
//
//            NSString *code = [NSString stringWithFormat:@"%@",obj[@"code"]];
//            if ([code isEqualToString:@"10000"]) {
//                [self showSucceedView];
//
//            }else{
//                [self showWarningText:obj[@"mes"]];
//            }
//        }
//    }];
}

- (void)getWarningText{
    
    @WeakObj(self);
    
    [WebUtils requestWarningTextWithType:1 andCallBack:^(id obj) {
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
                    
                    self.transferCardView.warningLabel.text = warningString;
                    
                    [self.transferCardView.nextButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.top.mas_equalTo(self.transferCardView.warningLabel.mas_bottom).mas_equalTo(40);
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

- (void)showWarningView{
    //提示弹窗
    dispatch_async(dispatch_get_main_queue(), ^{
        self.processView = [[FailedView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight) andTitle:@"正在提交" andDetail:@"请耐心等待..." andImageName:@"icon_smile" andTextColorHex:@"#eb000c"];
        [[UIApplication sharedApplication].keyWindow addSubview:self.processView];
    });
}

- (void)showSucceedView{
    //提交成功弹窗
    dispatch_async(dispatch_get_main_queue(), ^{
        self.successView = [[FailedView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight) andTitle:@"提交成功" andDetail:@"请耐心等待..." andImageName:@"icon_smile" andTextColorHex:@"#eb000c"];
        [[UIApplication sharedApplication].keyWindow addSubview:self.successView];
        
        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(removeGrayView) userInfo:nil repeats:NO];
    });
}

- (void)removeGrayView{
    [UIView animateWithDuration:0.5 animations:^{
        self.successView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.successView removeFromSuperview];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
}

@end
