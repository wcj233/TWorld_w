//
//  TransferCardView.m
//  PhoneWorld
//
//  Created by 刘岑颖 on 16/10/13.
//  Copyright © 2016年 xiyoukeji. All rights reserved.
//

#import "TransferCardView.h"

@interface TransferCardView ()<UITextFieldDelegate>
//左标题数组
@property (nonatomic) NSArray *leftTitles;

@end

@implementation TransferCardView
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self endEditing:YES];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = COLOR_BACKGROUND;
        //初始化
        self.leftTitles = @[@"过户号码",@"姓名",@"证件号码",@"证件地址",@"联系电话",@"近期联系电话1",@"近期联系电话2",@"近期联系电话3"];
        self.inputViews = [NSMutableArray array];
        self.isHJSJNumber = NO;
//        self.bounces = NO;
        
        for (int i = 0; i < self.leftTitles.count; i++) {
            InputView *view = [[InputView alloc] initWithFrame:CGRectMake(0, 41*i, screenWidth, 40)];
            [self addSubview:view];
            view.leftLabel.text = self.leftTitles[i];
            view.textField.placeholder = [NSString stringWithFormat:@"请输入%@",self.leftTitles[i]];
            view.textField.tag = 10 + i;
            [self.inputViews addObject:view];
            [self addSubview:view];
            view.textField.delegate = self;
            
            //以下几个是号码键盘
            if ([self.leftTitles[i] isEqualToString:@"过户号码"] || [self.leftTitles[i] isEqualToString:@"联系电话"] || [self.leftTitles[i] containsString:@"联系电话"]) {
                view.textField.keyboardType = UIKeyboardTypeNumberPad;
            }
        }
        
        [self chooseImageView];
        
        [self chooseImageViewOld];
        
        [self warningLabel];
        
        [self nextButton];
        
        //这个界面要求是左边15像素没有的...本来有的...遮住就好了...
        UIView *backV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, self.leftTitles.count*40)];
        backV.backgroundColor = [UIColor whiteColor];
        [self addSubview:backV];
        
    }
    return self;
}

- (ChooseImageView *)chooseImageView{
    if (_chooseImageView == nil) {
        _chooseImageView = [[ChooseImageView alloc] initWithFrame:CGRectZero andTitle:@"新用户（点击图片可放大）" andDetail:@[@"身份证人像面",@"本人手持证件照"] andCount:2];
        [self addSubview:_chooseImageView];
        InputView *inputV = self.inputViews.lastObject;
        [_chooseImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(inputV.mas_bottom).mas_equalTo(10);
            make.width.mas_equalTo(screenWidth);
            make.height.mas_equalTo(185);
        }];
    }
    return _chooseImageView;
}

- (ChooseImageView *)chooseImageViewOld{
    if (_chooseImageViewOld == nil) {
        _chooseImageViewOld = [[ChooseImageView alloc] initWithFrame:CGRectZero andTitle:@"原用户（点击图片可放大）" andDetail:@[@"身份证人像面+卡板合照",@"本人手持证件照"] andCount:2];
        [self addSubview:_chooseImageViewOld];
        [_chooseImageViewOld mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(self.chooseImageView.mas_bottom).mas_equalTo(10);
            make.width.mas_equalTo(screenWidth);
            make.height.mas_equalTo(185);
        }];
    }
    return _chooseImageViewOld;
}

- (UILabel *)warningLabel{
    if (_warningLabel == nil) {
        _warningLabel = [[UILabel alloc] init];
        [self addSubview:_warningLabel];
        [_warningLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-15);
            make.top.mas_equalTo(self.chooseImageViewOld.mas_bottom).mas_equalTo(10);
        }];
        _warningLabel.numberOfLines = 0;
        _warningLabel.font = [UIFont systemFontOfSize:16];
        _warningLabel.textColor = [UIColor redColor];
        _warningLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _warningLabel;
}

- (UIButton *)nextButton{
    if (_nextButton == nil) {
        _nextButton = [Utils returnNextButtonWithTitle:@"下一步"];
        [self addSubview:_nextButton];
        [_nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.chooseImageViewOld.mas_bottom).mas_equalTo(40);
            make.centerX.mas_equalTo(0);
            make.height.mas_equalTo(40);
            make.width.mas_equalTo(171);
            make.bottom.mas_equalTo(-40);
        }];
        [_nextButton addTarget:self action:@selector(buttonClickAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextButton;
}

#pragma mark - Method
- (void)buttonClickAction:(UIButton *)button{
    if (self.isHJSJNumber == YES) {
        //下一步
        NSMutableDictionary *sendDic = [NSMutableDictionary dictionary];
        
        //判断用户信息
        for (int i = 0; i < self.inputViews.count; i ++) {
            
            InputView *inputV = self.inputViews[i];
            
            switch (i) {
                case 0://过户号码
                {
                    if ([Utils isMobile:inputV.textField.text]) {
                        [sendDic setObject:inputV.textField.text forKey:@"number"];
                    }else{
                        [Utils toastview:@"请输入过户号码"];
                        return;
                    }
                }
                    break;
                case 1://姓名
                {
                    if ([inputV.textField.text isEqualToString:@""]) {
                        [Utils toastview:@"请输入姓名"];
                        return;
                    }else{
                        [sendDic setObject:inputV.textField.text forKey:@"name"];
                    }
                }
                    break;
                case 2://证件号码
                {
                    if ([Utils isIDNumber:inputV.textField.text]) {
                        [sendDic setObject:inputV.textField.text forKey:@"cardId"];
                    }else{
                        [Utils toastview:@"请输入正确格式证件号码"];
                        return;
                    }
                }
                    break;
                case 3://证件地址（不是必填，现在改为必填）
                {
                    if ([inputV.textField.text isEqualToString:@""]) {
                        [Utils toastview:@"请输入证件地址"];
                        return;
                    }else{
                        [sendDic setObject:inputV.textField.text forKey:@"address"];
                    }
                }
                    break;
                case 4://联系电话
                {
                    if ([Utils isMobile:inputV.textField.text]) {
                        [sendDic setObject:inputV.textField.text forKey:@"tel"];
                    }else{
                        [Utils toastview:@"请输入正确格式手机号"];
                        return;
                    }
                }
                    break;
                case 5://联系电话1
                {
//                    if (inputV.textField.text.length > 0) {
//                        [sendDic setObject:inputV.textField.text forKey:@"numOne"];
//                    }
                    
                    if ([Utils isMobile:inputV.textField.text]) {
                        [sendDic setObject:inputV.textField.text forKey:@"numOne"];
                    }else{
                        [Utils toastview:@"请输入正确格式手机号"];
                        return;
                    }
                    
                }
                    break;
                case 6://联系电话2
                {
//                    if (inputV.textField.text.length > 0) {
//                        [sendDic setObject:inputV.textField.text forKey:@"numTwo"];
//                    }
                    
                    if ([Utils isMobile:inputV.textField.text]) {
                        [sendDic setObject:inputV.textField.text forKey:@"numTwo"];
                    }else{
                        [Utils toastview:@"请输入正确格式手机号"];
                        return;
                    }
                }
                    break;
                case 7://联系电话3
                {
//                    if (inputV.textField.text.length > 0) {
//                        [sendDic setObject:inputV.textField.text forKey:@"numThree"];
//                    }
                    
                    if ([Utils isMobile:inputV.textField.text]) {
                        [sendDic setObject:inputV.textField.text forKey:@"numThree"];
                    }else{
                        [Utils toastview:@"请输入正确格式手机号"];
                        return;
                    }
                }
                    break;
            }
        }
        
        //判断新用户照片
        for (int i = 0; i < self.chooseImageView.imageViews.count; i ++) {
            UIImageView *imageV = self.chooseImageView.imageViews[i];
            if (!imageV.image || imageV.hidden == YES) {
                [Utils toastview:@"请选择新用户图片"];
                return;
            }
            switch (i) {
                case 0:
                {
                    NSString *photoString = [Utils imagechange:imageV.image];
                    photoString = [photoString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                    [sendDic setObject:photoString forKey:@"photoOne"];
                }
                    break;
                case 1:
                {
                    NSString *photoString = [Utils imagechange:imageV.image];
                    photoString = [photoString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                    [sendDic setObject:photoString forKey:@"photoThree"];
                }
                    break;
            }
        }
        
        //判断老用户照片
        for (int i = 0; i < self.chooseImageViewOld.imageViews.count; i ++) {
            UIImageView *imageV = self.chooseImageViewOld.imageViews[i];
            if (!imageV.image || imageV.hidden == YES) {
                [Utils toastview:@"请选择原用户图片"];
                return;
            }
            switch (i) {
                case 0:
                {
                    NSString *photoString = [Utils imagechange:imageV.image];
                    photoString = [photoString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                    [sendDic setObject:photoString forKey:@"photoTwo"];
                }
                    break;
                case 1:
                {
                    NSString *photoString = [Utils imagechange:imageV.image];
                    photoString = [photoString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                    [sendDic setObject:photoString forKey:@"photoFour"];
                }
                    break;
            }
        }
        
        for (InputView *iv in self.inputViews) {
            if ([Utils isRightString:iv.textField.text] == NO) {
                [Utils toastview:@"请输入数字、字母、中文或下划线！"];
                return;
            }
        }
        
        _NextCallBack(sendDic);
    }else{
        [Utils toastview:@"请输入话机号码！"];
    }
    
    

}

#pragma mark - UITextField Delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (textField.tag == 10 || textField.tag == 14 || textField.tag == 15 || textField.tag == 16 || textField.tag == 17) {
        if (textField.text.length >= 11 && ![string isEqualToString:@""]) {
            return NO;
        }
    }
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    __block __weak TransferCardView *weakself = self;
    
    if (textField.tag == 10) {
        
        if (![textField.text isEqualToString:@""]) {
            [WebUtils requestSegmentWithTel:textField.text andCallBack:^(id obj) {
                if ([obj isKindOfClass:[NSDictionary class]]) {
                    NSString *code = [NSString stringWithFormat:@"%@",obj[@"code"]];
                    if ([code isEqualToString:@"10000"]) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            weakself.isHJSJNumber = YES;
                        });
                    }else{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [Utils toastview:@"请输入话机号码！"];
                        });
                    }
                }
            }];
        }
    }
}

@end
