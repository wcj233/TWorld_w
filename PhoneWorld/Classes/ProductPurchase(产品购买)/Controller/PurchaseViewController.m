//
//  PurchaseViewController.m
//  PhoneWorld
//
//  Created by 刘岑颖 on 2017/6/3.
//  Copyright © 2017年 xiyoukeji. All rights reserved.
//

#import "PurchaseViewController.h"
#import "PurchaseView.h"

@interface PurchaseViewController ()

@property (nonatomic) PurchaseView *purchaseView;

@end

@implementation PurchaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"号码录入";
    
    self.purchaseView = [[PurchaseView alloc] init];
    [self.view addSubview:self.purchaseView];
    [self.purchaseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0);
    }];
    
    //假数据
    self.purchaseView.leftImageView.image = [UIImage imageNamed:@"image1"];
    self.purchaseView.nameLabel.text = @"name";
    self.purchaseView.introduceLabel.text = @"arfdfdsfafhslhfjakfnafidh";
    self.purchaseView.priceLabel.text = @"342";
    
    [self.purchaseView.submitButton addTarget:self action:@selector(submitAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)submitAction{
    
    if (self.purchaseView.phoneInputView.textField.text.length != 11) {
        self.purchaseView.warningLabel.hidden = NO;
    }else{
        self.purchaseView.warningLabel.hidden = YES;

        UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"确认购买？" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [ac addAction:action1];
        [ac addAction:action2];
        [self presentViewController:ac animated:YES completion:nil];
    }
}

@end
