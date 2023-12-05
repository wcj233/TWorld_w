//
//  CreateQrcodeVC.m
//  PhoneWorld
//
//
// Created by 黄振元 on 2019/5/17.
// Copyright © 2019 xiyoukeji. All rights reserved.
//
// @class CreateQrcodeVC
// @abstract 预订单生成 最后一步————展示二维码
//

#import "CreateQrcodeVC.h"

// Controllers

// Model

// Views

// Others
#import "QiCodeManager.h"


@interface CreateQrcodeVC ()

@end

@implementation CreateQrcodeVC

#pragma mark - View Controller LifeCyle
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = kSetColor(@"FBFBFB");
    
    [self createMain];
}


#pragma mark - Override Methods


#pragma mark - Initial Methods


#pragma mark - Privater Methods

- (void)createMain {
    UIImageView *imageView = [[UIImageView alloc] init];
    [self.view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(get6W(86));
        make.size.mas_equalTo(CGSizeMake(241, 241));
    }];
    
    // 生成二维码
    if (self.qrcodeUrl.length > 0) {
        NSString *codeString = self.qrcodeUrl;
        UIImage *codeImage = [QiCodeManager generateQRCode:codeString size:CGSizeMake(240, 240)];
        dispatch_async(dispatch_get_main_queue(), ^{
            imageView.image = codeImage;
        });
    }
    
    UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [doneBtn setTitle:@"完成" forState:UIControlStateNormal];
    [doneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    doneBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    doneBtn.backgroundColor = kSetColor(@"EC6C00");
    doneBtn.layer.cornerRadius = 4;
    [doneBtn addTarget:self action:@selector(doneBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:doneBtn];
    [doneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(imageView.mas_bottom).offset(get6W(147));
        make.size.mas_equalTo(CGSizeMake(get6W(170), get6W(40)));
    }];
}


#pragma mark - Target Methods

- (void)doneBtnClick {
    [self.navigationController popToRootViewControllerAnimated:YES];
}


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
