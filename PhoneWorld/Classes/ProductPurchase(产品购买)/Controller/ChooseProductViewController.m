//
//  ChooseProductViewController.m
//  PhoneWorld
//
//  Created by 刘岑颖 on 2017/6/3.
//  Copyright © 2017年 xiyoukeji. All rights reserved.
//

#import "ChooseProductViewController.h"
#import "ChooseProductView.h"
#import "PurchaseViewController.h"
#import "LProductDetailViewController.h"
#import "LCYButtonPopView.h"

@interface ChooseProductViewController ()

@property (nonatomic) ChooseProductView *chooseView;

@property (nonatomic, strong) LCYButtonPopView *buttonPopView;

@property (nonatomic, strong) LCanBookModel *currentModel;

@end

@implementation ChooseProductViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"流量包列表";
    self.chooseView = [[ChooseProductView alloc] init];
    [self.view addSubview:self.chooseView];
    [self.chooseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0);
    }];
    
    self.chooseView.productArray = self.productArray;
    [self.chooseView.headView setPhone:self.phoneNumber];
    
    @WeakObj(self);
    
    //购买事件
    [self.chooseView setChooseProductCallBack:^(NSInteger row){
        @StrongObj(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            self.currentModel = self.productArray[row];
            [self showButtonPopView:self.currentModel.prodOfferName];
        });
    }];
    
    [self.chooseView setPopCallBack:^{
        @StrongObj(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    }];
}

- (void)showButtonPopView:(NSString *)titleString{
    self.buttonPopView = [[LCYButtonPopView alloc] initWithImageName:@"business_popup_icon_confirmpurchase" andTitle:[NSString stringWithFormat:@"是否要订购该产品?\n\n\n%@",titleString] andButtonName:@"确定"];
    [[UIApplication sharedApplication].keyWindow addSubview:self.buttonPopView];
    self.buttonPopView.frame = CGRectMake(0, 0, screenWidth, screenHeight);
    @WeakObj(self);
    [self.buttonPopView setRightCallBack:^(id obj) {
        @StrongObj(self);
        self.buttonPopView.rightButton.enabled = NO;
        [WebUtils l_orderProductWithNumber:self.phoneNumber andVerificationCode:self.verificationCode andProductId:self.currentModel.productId andProductName:self.currentModel.productName andProdOfferId:self.currentModel.prodOfferId andProdOfferName:self.currentModel.prodOfferName andProdOfferDesc:self.currentModel.prodOfferDesc andCallBack:^(id obj) {
            [self hideWaitView];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.buttonPopView.rightButton.enabled = YES;
            });

            
            if (![obj isKindOfClass:[NSError class]]) {
                NSString *code = [NSString stringWithFormat:@"%@",obj[@"code"]];
                if ([code isEqualToString:@"10000"]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.buttonPopView dismissAction];

                        [self.chooseView showSuccessPopView:@"gift" title:@"订购成功(具体以短信为准)"];
                    });
                }else{
                    NSLog(@"%@",obj[@"mes"]);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.buttonPopView dismissAction];
                        
                        //看这里看这里看这里
                        [self.chooseView showSuccessPopView:@"popfailed" title:@"订购失败！"];
                    });
//                    [self showWarningText:obj[@"mes"]];
                }
            }
        }];
        
        
    }];
}

@end
