//
//  PersonalInfoViewController.m
//  PhoneWorld
//
//  Created by 刘岑颖 on 16/10/14.
//  Copyright © 2016年 xiyoukeji. All rights reserved.
//

#import "PersonalInfoViewController.h"
#import "PersonalInfoView.h"
#import "PersonalInfoModel.h"
#import "InputView.h"

@interface PersonalInfoViewController ()
@property (nonatomic) PersonalInfoView *personalInfoView;
@property (nonatomic) PersonalInfoModel *personalInfoModel;
@end

@implementation PersonalInfoViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getUserInfo];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人信息";
    
    self.personalInfoView = [[PersonalInfoView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight - 64)];
//    self.personalInfoView.contentSize = CGSizeMake(0, screenHeight - 64);//520
    [self.view addSubview:self.personalInfoView];
    [self.personalInfoView.saveButton addTarget:self action:@selector(saveAction) forControlEvents:UIControlEventTouchUpInside];
}

-(void)saveAction{
    InputView *nameView = (InputView *)[self.personalInfoView viewWithTag:101];
    InputView *emailView = (InputView *)[self.personalInfoView viewWithTag:103];
//    InputView *locationView = (InputView *)[self.personalInfoView viewWithTag:108];
    InputView *detailView = (InputView *)[self.personalInfoView viewWithTag:109];
    if (nameView.textField.text.length==0) {
        [Utils toastview:@"请输入姓名"];
    }else if (self.personalInfoView.selectedPro==nil){
        [Utils toastview:@"请选择省市"];
    }else if (detailView.textField.text.length==0){
        [Utils toastview:@"请输入详细地址"];
    }else if (![emailView.textField.text isEqualToString:@"未填写"]&&emailView.textField.text.length>0&&[Utils isEmailAddress:emailView.textField.text]==NO){
        [Utils toastview:@"请输入正确的邮箱号"];
    }else{
        NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
        [paramDic setObject:[Utils getSessionToken] forKey:@"session_token"];
        [paramDic setObject:nameView.textField.text forKey:@"contact"];
        if (self.personalInfoView.selectedCity) {
            NSString *address = [NSString stringWithFormat:@"%@省%@市%@",self.personalInfoView.selectedPro,self.personalInfoView.selectedCity,detailView.textField.text];
            if ([self.personalInfoView.selectedPro isEqualToString:self.personalInfoView.selectedCity]) {
                address = [NSString stringWithFormat:@"%@%@",self.personalInfoView.selectedPro,detailView.textField.text];
            }
            [paramDic setObject:address forKey:@"address"];
        }else{
            [paramDic setObject:[NSString stringWithFormat:@"%@省%@",self.personalInfoView.selectedPro,detailView.textField.text] forKey:@"address"];
        }
        
        [paramDic setObject:emailView.textField.text forKey:@"email"];
        @WeakObj(self);
        [WebUtils requestChangePersonalInfoWithParamDic:paramDic andCallBack:^(id obj) {
            @StrongObj(self);
            if ([obj isKindOfClass:[NSDictionary class]]) {
                NSString *code = [NSString stringWithFormat:@"%@",obj[@"code"]];
                if ([code isEqualToString:@"10000"]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [Utils toastview:@"修改成功"];
                        [self.navigationController popViewControllerAnimated:YES];
                    });
                    
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSString *mes = [NSString stringWithFormat:@"%@",obj[@"mes"]];
                        [Utils toastview:mes];
                    });
                }
            }
        }];
    }
}

- (void)getUserInfo{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *username = [ud objectForKey:@"username"];
    NSString *token = [ud objectForKey:@"session_token"];
    [WebUtils requestPersonalInfoWithSessionToken:token andUserName:username andCallBack:^(id obj) {
        if (![obj isKindOfClass:[NSError class]]) {
            NSDictionary *dic = obj[@"data"];
            self.personalInfoModel = [[PersonalInfoModel alloc] initWithDictionary:dic error:nil];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.personalInfoView.personModel = self.personalInfoModel;
            });
        }
    }];
}

@end
