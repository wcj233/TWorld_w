//
//  ChoosePackageDetailViewController.m
//  PhoneWorld
//
//  Created by 刘岑颖 on 16/10/26.
//  Copyright © 2016年 xiyoukeji. All rights reserved.
//

#import "ChoosePackageDetailViewController.h"

@interface ChoosePackageDetailViewController ()

@end

@implementation ChoosePackageDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = COLOR_BACKGROUND;
    
    if ([self.title isEqualToString:@"活动包选择"]) {
        
        [self showWaitView];
        
        @WeakObj(self);
        
        [WebUtils requestPackagesWithID:self.currentID andCallBack:^(id obj) {
            @StrongObj(self);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self hideWaitView];
            });
            
            if ([obj isKindOfClass:[NSDictionary class]]) {
                NSString *code = [NSString stringWithFormat:@"%@",obj[@"code"]];
                if ([code isEqualToString:@"10000"]) {
                    
                    NSArray *promotionsArray = obj[@"data"][@"promotions"];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        self.packagesDic = promotionsArray;//所有活动包
                        
                        self.detailView = [[ChoosePackageDetailView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight - 64) andPackages:self.packagesDic];
                        [self.view addSubview:self.detailView];
                        [self.detailView.nextButton addTarget:self action:@selector(buttonClickAction) forControlEvents:UIControlEventTouchUpInside];
                    });
                    
                }else{
                    [self showWarningText:obj[@"mes"]];
                }
            }
        }];
        
    }else{
        self.detailView = [[ChoosePackageDetailView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight - 64) andPackages:self.packagesDic];
        [self.view addSubview:self.detailView];
        [self.detailView.nextButton addTarget:self action:@selector(buttonClickAction) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)buttonClickAction{
    _ChoosePackageDetailCallBack(self.detailView.currentDic);
    [self.navigationController popViewControllerAnimated:YES];
}

@end
