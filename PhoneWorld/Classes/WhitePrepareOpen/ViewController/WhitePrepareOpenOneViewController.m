//
//  WhitePrepareOpenOneViewController.m
//  PhoneWorld
//
//  Created by 刘岑颖 on 2017/5/8.
//  Copyright © 2017年 xiyoukeji. All rights reserved.
//

#import "WhitePrepareOpenOneViewController.h"
#import "WhitePrepareOpenOneView.h"
#import "WhitePrepareOpenTwoViewController.h"

@interface WhitePrepareOpenOneViewController () <UITextFieldDelegate>

@property (nonatomic) WhitePrepareOpenOneView *oneView;

@property (nonatomic) NSDictionary *dataDictionary;

@end

@implementation WhitePrepareOpenOneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"白卡预开户";
    
    self.oneView = [[WhitePrepareOpenOneView alloc] init];
    [self.view addSubview:self.oneView];
    [self.oneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0);
    }];
    
    [self.oneView.nextButton addTarget:self action:@selector(nextAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.oneView.phoneInputView.textField.delegate = self;
    
}

- (void)nextAction:(UIButton *)button{
    if (self.oneView.phoneInputView.textField.text.length != 11) {
        [Utils toastview:@"请输入11位手机号！"];
        return;
    }
    [self showWaitView];
    [self getDetailInfoWithPhoneNumber:self.oneView.phoneInputView.textField.text];
}

- (void)getDetailInfoWithPhoneNumber:(NSString *)phoneNumber{
    @WeakObj(self);
    
    [WebUtils requestAgentWhitePrepareOpenNumberDetailWithPhoneNumber:phoneNumber andCallBack:^(id obj) {
        @StrongObj(self);

        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideWaitView];
        });
        
        if ([obj isKindOfClass:[NSDictionary class]]) {
            
            NSString *code = obj[@"code"];
            
            if ([code isEqualToString:@"10000"]) {
                
                self.dataDictionary = obj[@"data"];
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.oneView.warningLabel.text = @"";
                    WhitePrepareOpenTwoViewController *vc = [[WhitePrepareOpenTwoViewController alloc] init];
                    vc.dataDictionary = self.dataDictionary;
                    [self.navigationController pushViewController:vc animated:YES];
                });
                
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.oneView.warningLabel.text = @"您的号码输入有误！";
                });
            }            
        }
    }];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    self.oneView.warningLabel.text = @"";
}

@end
