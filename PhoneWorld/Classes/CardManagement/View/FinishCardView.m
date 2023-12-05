//
//  FinishCardView.m
//  PhoneWorld
//
//  Created by 刘岑颖 on 16/10/13.
//  Copyright © 2016年 xiyoukeji. All rights reserved.
//

#import "FinishCardView.h"
#import "ChoosePackageViewController.h"

@interface FinishCardView () <UITextFieldDelegate>

@property (nonatomic) NSArray *leftTitles;

@end

@implementation FinishCardView

- (instancetype)initWithFrame:(CGRect)frame andIsFace:(BOOL)isFace
{
    self = [super initWithFrame:frame];
    if (self) {
        self.isFace = isFace;
        self.backgroundColor = COLOR_BACKGROUND;
        self.leftTitles = @[@"手机号码",@"PUK码"];
        self.inputViews = [NSMutableArray array];
        
        for (int i = 0; i < self.leftTitles.count; i++) {
            
            InputView *inputView = [[InputView alloc] initWithFrame:CGRectMake(0, 40*i, screenWidth, 40)];
            [self addSubview:inputView];
            inputView.leftLabel.text = self.leftTitles[i];
            inputView.textField.placeholder = [NSString stringWithFormat:@"请输入%@",self.leftTitles[i]];
            [self.inputViews addObject:inputView];
            inputView.textField.keyboardType = UIKeyboardTypeNumberPad;
            
            if (i == 1&&isFace==NO) {
                inputView.hidden = YES;
            }
            
            inputView.textField.delegate = self;
            inputView.textField.tag = i + 20;
        }
                
        UIView *whiteV = [[UIView alloc] initWithFrame:CGRectMake(15, 40, screenWidth, 1)];
        whiteV.backgroundColor = COLOR_BACKGROUND;
        [self addSubview:whiteV];
        
        [self nextButton];
    }
    return self;
}

- (UILabel *)warningLabel{
    if (_warningLabel == nil) {
        InputView *inputV = self.inputViews.lastObject;

        _warningLabel = [[UILabel alloc] init];
        [self addSubview:_warningLabel];
        [_warningLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-15);
            make.height.mas_equalTo(40);
            make.top.mas_equalTo(inputV.mas_bottom).mas_equalTo(0);
        }];
        _warningLabel.text = @"该号码为靓号，请输入PUK码！";
        _warningLabel.font = [UIFont systemFontOfSize:16];
        _warningLabel.textColor = [UIColor redColor];
        _warningLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _warningLabel;
}

- (UIButton *)nextButton{
    if (_nextButton == nil) {
        _nextButton = [Utils returnNextButtonWithTitle:@"查询"];
        [self addSubview:_nextButton];
        InputView *inputV = self.inputViews.firstObject;
        [_nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(inputV.mas_bottom).mas_equalTo(60);
            make.centerX.mas_equalTo(0);
            make.height.mas_equalTo(40);
            make.width.mas_equalTo(171);
        }];
        [_nextButton addTarget:self action:@selector(buttonClickAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextButton;
}

#pragma mark - UITextField Delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (textField.tag == 20) {
        if (textField.text.length >= 11 && ![string isEqualToString:@""]) {
            return NO;
        }
    }
    
    return YES;
}

#pragma mark - Method

- (void)buttonClickAction:(UIButton *)button{
    [self endEditing:YES];
    InputView *phone = self.inputViews.firstObject;
    InputView *puk = self.inputViews[1];
    
    if (![Utils isMobile:phone.textField.text]) {
        [Utils toastview:@"请输入正确格式手机号"];
        return;
    }
    if (self.isFace) {
        if (puk.textField.text.length==0) {
            [Utils toastview:@"请输入PUK"];
            return;
        }
    }
    
    if ([button.currentTitle isEqualToString:@"下一步"]||self.isFace) {
        if ([Utils isMobile:phone.textField.text] && [Utils isNumber:puk.textField.text] && ![puk.textField.text isEqualToString:@""]) {
            //检测
            _FinishCardCallBack(phone.textField.text,puk.textField.text);
            
        }else{
            if(![Utils isNumber:puk.textField.text] || [puk.textField.text isEqualToString:@""]){
                [Utils toastview:@"请输入正确格式PUK码"];
            }
        }
        
    }else{
        _NextCallBack(button.currentTitle);
    }
}

@end
