//
//  WorkerSignInViewController.m
//  PhoneWorld
//
//  Created by 王陈洁 on 2018/10/18.
//  Copyright © 2018年 xiyoukeji. All rights reserved.
//

#import "WorkerSignInViewController.h"
#import "WorkerSignInView.h"
#import "AppDelegate.h"
#import "PersonalInfoModel.h"
#import "WWhiteCardApplyCell.h"

@interface WorkerSignInViewController ()

@property(nonatomic, strong) WorkerSignInView *signInView;

@end

@implementation WorkerSignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [Utils returnBackButton];
    self.title = @"工号登记";
    self.signInView = [[WorkerSignInView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:self.signInView];
    [self.signInView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    [self.signInView.submitButton addTarget:self action:@selector(gotoHome) forControlEvents:UIControlEventTouchUpInside];
    
//    [self getUserInfo];
}

- (void)getUserInfo{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *username = [ud objectForKey:@"username"];
    NSString *token = [ud objectForKey:@"session_token"];
    [WebUtils requestPersonalInfoWithSessionToken:token andUserName:username andCallBack:^(id obj) {
        if (![obj isKindOfClass:[NSError class]]) {
            NSDictionary *dic = obj[@"data"];
            PersonalInfoModel *personalInfoModel = [[PersonalInfoModel alloc] initWithDictionary:dic error:nil];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.signInView.model = personalInfoModel;
            });
        }
    }];
}

-(void)gotoHome{
    WWhiteCardApplyCell *nameCell = [self.signInView.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    WWhiteCardApplyCell *telCell = [self.signInView.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    WWhiteCardApplyCell *cardCell = [self.signInView.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    WWhiteCardApplyCell *emailCell = [self.signInView.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    WWhiteCardApplyCell *detailCell = [self.signInView.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0]];
    if (nameCell.infoTextView.text.length==0||telCell.infoTextView.text.length==0||cardCell.infoTextView.text.length==0||detailCell.infoTextView.text.length==0||self.signInView.selectedCity==nil) {
        [Utils toastview:@"请完善信息"];
        return;
    }
    if ([Utils isMobile:telCell.infoTextView.text]==NO) {
        [Utils toastview:@"请输入正确的手机号"];
        return;
    }
    
    if ([Utils isIDNumber:cardCell.infoTextView.text]==NO) {
        [Utils toastview:@"请输入正确的身份证号"];
        return;
    }
    
    if (emailCell.infoTextView.text.length>0) {
        if ([Utils isEmailAddress:emailCell.infoTextView.text]==NO) {
            [Utils toastview:@"请输入正确的邮箱号"];
            return;
        }
    }
    
    NSString *address = [NSString stringWithFormat:@"%@省%@市%@",self.signInView.selectedPro,self.signInView.selectedCity,detailCell.infoTextView.text];
    if ([self.signInView.selectedPro isEqualToString:self.signInView.selectedCity]) {
        address = [NSString stringWithFormat:@"%@%@",self.signInView.selectedPro,detailCell.infoTextView.text];
    }
    [WebUtils requestSupplementWithUserName:nameCell.infoTextView.text andTel:telCell.infoTextView.text andEmail:emailCell.infoTextView.text andCardId:cardCell.infoTextView.text andAddress:address andWebUtilsCallBack:^(id obj) {
        if ([obj[@"code"] isEqualToString:@"10000"]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSUserDefaults standardUserDefaults]setObject:@(1) forKey:@"工号登记"];
                [[NSUserDefaults standardUserDefaults]synchronize];
                [Utils toastview:@"登记成功"];
                AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                [appDelegate gotoHomeVC];
            });
            
        }else{
            [Utils toastview:obj[@"mes"]];
        }
        
    }];
    

}


@end
