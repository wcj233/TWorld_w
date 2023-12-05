//
//  InformationCollectionView.m
//  PhoneWorld
//
//  Created by 刘岑颖 on 16/10/18.
//  Copyright © 2016年 xiyoukeji. All rights reserved.
//

#import "InformationCollectionView.h"
#import "SettlementDetailViewController.h"

@interface InformationCollectionView ()
@property (nonatomic) NSArray *leftTitles;
@property (nonatomic) NSArray *detailTitles;

@end

@implementation InformationCollectionView

- (instancetype)initWithFrame:(CGRect)frame andIsFinished:(BOOL)isFinished andIsFaceCheck:(BOOL)isFaceCheck
{
    self = [super initWithFrame:frame];
    if (self) {
//        [self nextButton];
        
        self.backgroundColor = COLOR_BACKGROUND;
        _isFinished = isFinished;
        _isFaceCheck = isFaceCheck;
        self.inputViews = [NSMutableArray array];
        
        self.baseScrollView = [[UIScrollView alloc]init];
        [self addSubview:self.baseScrollView];
        self.baseScrollView.backgroundColor = COLOR_BACKGROUND;
        [self.baseScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(0);
            make.width.mas_equalTo(SCREEN_WIDTH);
//            make.height.mas_equalTo(SCREEN_HEIGHT-kTopHeight);
            make.bottom.mas_equalTo(self.nextButton.mas_top).mas_equalTo(-5);
        }];

        self.detailTitles = @[@"请输入开户人姓名",@"请输入证件号码",@"请输入证件地址(多行输入)"];
        self.leftTitles = @[@"开户人姓名",@"证件号码",@"证件地址"];

        
        for (int i = 0; i < self.leftTitles.count - 1; i ++) {
            InputView *inputView = [[InputView alloc] initWithFrame:CGRectMake(0, 41*i, screenWidth, 40)];
            [self.baseScrollView addSubview:inputView];
            inputView.leftLabel.text = self.leftTitles[i];
            inputView.textField.placeholder = self.detailTitles[i];
            [self.inputViews addObject:inputView];
            
            if ([self.leftTitles[i] containsString:@"证件号码"]) {
                inputView.textField.userInteractionEnabled = NO;
            }
        }
        
        [self addressView];
        
        [self chooseImageView];
        
        [self containerView];
        [self warningLabel];
        [self nextButton];
        
        [self bringSubviewToFront:self.nextButton];
        
    }
    return self;
}

- (MultiAddressView *)addressView{
    if (_addressView == nil) {
        _addressView = [[MultiAddressView alloc] init];
        [self.baseScrollView addSubview:_addressView];
        
        _addressView.leftLabel.text = self.leftTitles.lastObject;
        _addressView.addressPlaceholderLabel.text = @"请输入证件地址";
        _addressView.addressPlaceholderLabel.font = [UIFont systemFontOfSize:textfont14];
        InputView *iv = self.inputViews.lastObject;
        _addressView.backgroundColor = [UIColor whiteColor];
        [_addressView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.width.mas_equalTo(SCREEN_WIDTH);
            make.height.mas_equalTo(88);
            make.top.mas_equalTo(iv.mas_bottom).mas_equalTo(1);
        }];
    }
    return _addressView;
}

- (ChooseImageView *)chooseImageView{
    if (_chooseImageView == nil) {
        NSArray *arr = @[@"身份证正面照",@"身份证背面照",@"身份证正面照+卡板号码照片",@"本人现场正面免冠照片"];
        NSArray *buttonImages = @[@"正面照.png",@"背面照.png",@"卡板照.png",@"现场照.png"];
        if (self.isFaceCheck) {
//            arr = @[@"身份证正面照",@"身份证背面照",@"本人现场正面免冠照片"];
//            buttonImages = @[@"正面照.png",@"背面照.png",@"现场照.png"];
            arr = @[@"身份证正面照",@"身份证背面照",@"身份证正面照+卡板号码照片",@"本人现场正面免冠照片"];
            buttonImages = @[@"正面照.png",@"背面照.png",@"卡板照.png",@"现场照.png"];
        }
        if ([self.typeString isEqualToString:@"靓号"]) {
            arr = @[@"身份证正面照",@"身份证正面照+卡板号码照片",@"本人现场正面免冠照片"];
            buttonImages = @[@"正面照.png",@"卡板照.png",@"现场照.png"];
            if (self.isFaceCheck) {
                arr = @[@"身份证正面照",@"身份证正面照+卡板号码照片",@"本人现场正面免冠照片"];
                buttonImages = @[@"正面照.png",@"卡板照.png",@"现场照.png"];
            }
        }
        _chooseImageView = [[ChooseImageView alloc] initWithFrame:CGRectZero andTitle:@"图片（点击图片可放大）" andDetail:arr andCount:arr.count];
        _chooseImageView.watermark=YES;
        _chooseImageView.isFinished = self.isFinished;
        _chooseImageView.buttonImages = buttonImages;
        [self.baseScrollView addSubview:_chooseImageView];
        
        CGFloat imageHeight = (screenWidth - 74)/2.0;
        if ([self.typeString isEqualToString:@"靓号"]) {
            imageHeight = (screenWidth - 74)/3.0;
        }
        _chooseImageView.chooseImageViewDelegate = self;
        
        [_chooseImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.width.mas_equalTo(SCREEN_WIDTH);
            make.top.mas_equalTo(self.addressView.mas_bottom).mas_equalTo(10);
            make.width.mas_equalTo(screenWidth);
            if ([self.typeString isEqualToString:@"靓号"]) {
                make.height.mas_equalTo(imageHeight + 85);
                
            }else{
//                make.height.mas_equalTo(imageHeight*2 + 105);
                make.height.mas_equalTo(CGRectGetMaxY(_chooseImageView.lastInstrusctLabel.frame)+20);
            }
        }];
    }
    return _chooseImageView;
}

- (UIButton *)nextButton{
    if (_nextButton == nil) {
        _nextButton = [Utils returnNextButtonWithTitle:@"下一步"];
        [self addSubview:_nextButton];
        [_nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(self.containerView.mas_bottom).mas_equalTo(40);
            make.centerX.mas_equalTo(0);
            make.height.mas_equalTo(40);
            make.width.mas_equalTo(171);
            make.bottom.mas_equalTo(-kIPhoneSafeButton_bottom);
        }];
        [_nextButton addTarget:self action:@selector(buttonClickAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextButton;
}

- (UIView *)containerView{
    if (_containerView == nil) {
        _containerView = [[UIView alloc] init];
        [self.baseScrollView addSubview:_containerView];
        [_containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.width.mas_equalTo(SCREEN_WIDTH);
            make.top.mas_equalTo(self.chooseImageView.mas_bottom).mas_equalTo(10);
            make.bottom.mas_equalTo(-10);
        }];
    }
    return _containerView;
}

- (UILabel *)warningLabel{
    if (_warningLabel == nil) {
        _warningLabel = [[UILabel alloc] init];
        [self.containerView addSubview:_warningLabel];
        [_warningLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.right.mas_equalTo(-10);
            make.top.mas_equalTo(10);
            make.bottom.mas_equalTo(-10);
        }];
        _warningLabel.text = warningText;
        _warningLabel.textColor = [Utils colorRGB:@"#FF2626"];
        _warningLabel.font = font13;
        _warningLabel.numberOfLines = 0;
    }
    return _warningLabel;
}

#pragma mark - Method
- (void)buttonClickAction:(UIButton *)button{
    
    for (int i = 0; i < self.leftTitles.count - 1; i ++) {
        InputView *inputV = self.inputViews[i];
        if (i != self.leftTitles.count - 1) {
            if ([inputV.textField.text isEqualToString:@""]) {
                [Utils toastview:@"请输入完整"];
                return;
            }
        }
    }

    if (self.addressView.addressTextView.text.length <= 0) {
        [Utils toastview:@"请输入完整"];
        return;
    }

    for (int i = 0; i < self.chooseImageView.imageViews.count; i++) {
        UIImageView *imageV = self.chooseImageView.imageViews[i];
        if (imageV.hidden == YES || !imageV.image) {
            [Utils toastview:@"请选择图片"];
            return;
        }
    }

    //@"开户人姓名",@"证件号码",@"证件地址"
    NSMutableDictionary *infosDictionary = [NSMutableDictionary dictionary];
    NSArray *keysArray = @[@"customerName",@"certificatesNo"];
    for (int i = 0; i < self.leftTitles.count - 1; i ++) {
        InputView *inputV = self.inputViews[i];

        if (![inputV.textField.text isEqualToString:@""]) {
            [infosDictionary setObject:inputV.textField.text forKey:keysArray[i]];
        }
    }

    [infosDictionary setObject:self.addressView.addressTextView.text forKey:@"address"];

//    NSArray *photoKeysArray = @[@"photoFront",@"photoBack",@"photoThird"];
    NSArray *photoKeysArray = @[@"memo4",@"memo11",@"photoBack",@"photoFront"];
    if ([self.typeString isEqualToString:@"靓号"]) {
//        photoKeysArray = @[@"photoFront",@"photoBack",@"memo4"];
        photoKeysArray = @[@"memo4",@"photoFront",@"photoBack"];
    }
    for (int i = 0; i < photoKeysArray.count; i++) {
        UIImageView *imageV = self.chooseImageView.imageViews[i];
        [infosDictionary setObject:[Utils imagechange:imageV.image] forKey:photoKeysArray[i]];
    }

    [infosDictionary setObject:@"Idcode" forKey:@"certificatesType"];

    if (_isFinished == YES) {
        [infosDictionary setObject:@"SIM" forKey:@"cardType"];
    }else{
        [infosDictionary setObject:@"ESIM" forKey:@"cardType"];
    }
    _nextCallBack(infosDictionary);
//    _nextCallBack(@{});
}

-(void)scanForInformation{
    [self.informationCollectionViewDelegate scanForInformation];
}

-(void)setTypeString:(NSString *)typeString{
    _typeString = typeString;
    _chooseImageView.typeString = self.typeString;
}

@end
