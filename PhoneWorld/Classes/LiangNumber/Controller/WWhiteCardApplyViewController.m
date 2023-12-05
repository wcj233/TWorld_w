//
//  WWhiteCardApplyViewController.m
//  PhoneWorld
//
//  Created by 王陈洁 on 2018/10/18.
//  Copyright © 2018年 xiyoukeji. All rights reserved.
//

#import "WWhiteCardApplyViewController.h"
#import "WWhiteCardApplyView.h"
#import "WWhiteCardApplyCell.h"

@interface WWhiteCardApplyViewController ()

@property(nonatomic, strong) WWhiteCardApplyView *applyView;

@end

@implementation WWhiteCardApplyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"白卡申请";
    self.applyView = [[WWhiteCardApplyView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:self.applyView];
    [self.applyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    [self.applyView.submitButton addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
}

-(void)submit{
    WWhiteCardApplyCell *namecell = [self.applyView.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    WWhiteCardApplyCell *telcell = [self.applyView.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    WWhiteCardApplyCell *addresscell = [self.applyView.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    WWhiteCardApplyCell *numcell = [self.applyView.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    if (namecell.infoTextView.text.length==0||telcell.infoTextView.text.length==0||addresscell.infoTextView.text.length==0||numcell.infoTextView.text.length==0) {
        [Utils toastview:@"请完善信息"];
        return;
    }
    if ([Utils isMobile:telcell.infoTextView.text]==NO) {
        [Utils toastview:@"请输入正确的手机号"];
        return;
    }
    if ([Utils checkIsHaveNumAndLetter:numcell.infoTextView.text] != 1) {//不是整数
        [Utils toastview:@"申请数量请输入整数"];
        return;
    }
    
    @WeakObj(self);
    [WebUtils requestApplyForOpenWhiteWithName:namecell.infoTextView.text andTel:telcell.infoTextView.text andAddress:addresscell.infoTextView.text andNum:@(numcell.infoTextView.text.intValue) andCallBack:^(id obj) {
        @StrongObj(self);
        if ([obj isKindOfClass:[NSDictionary class]]) {
            NSString *code = [NSString stringWithFormat:@"%@",obj[@"code"]];
            if ([code isEqualToString:@"10000"]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [Utils toastview:@"申请成功"];
                    [self.navigationController popViewControllerAnimated:YES];
                });
                
            }else{
                [self showWarningText:obj[@"mes"]];
            }
        }
    }];
    
}

@end
