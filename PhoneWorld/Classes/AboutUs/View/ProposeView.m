//
//  ProposeView.m
//  PhoneWorld
//
//  Created by 刘岑颖 on 16/10/14.
//  Copyright © 2016年 xiyoukeji. All rights reserved.
//

#import "ProposeView.h"
#import "FailedView.h"

@interface ProposeView ()

@property (nonatomic) FailedView *resultView;

@end

@implementation ProposeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = COLOR_BACKGROUND;
        [self proposeTV];
        [self placeholderLB];
        [self submitButton];
    }
    return self;
}

- (UILabel *)placeholderLB{
    if (_placeholderLB == nil) {
        _placeholderLB = [[UILabel alloc] init];
        [self addSubview:_placeholderLB];
        [_placeholderLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.mas_equalTo(5);
        }];
        _placeholderLB.text = @"请输入您的意见与建议";
        _placeholderLB.textColor = [Utils colorRGB:@"#cccccc"];
        _placeholderLB.font = [UIFont systemFontOfSize:textfont14];
        _placeholderLB.hidden = NO;
    }
    return _placeholderLB;
}

- (UITextView *)proposeTV{
    if (_proposeTV == nil) {
        _proposeTV = [[UITextView alloc] init];
        [self addSubview:_proposeTV];
        [_proposeTV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(125);
        }];
        _proposeTV.delegate = self;
        _proposeTV.font = [UIFont systemFontOfSize:textfont14];
        _proposeTV.textColor = [Utils colorRGB:@"#666666"];
        _proposeTV.layer.cornerRadius = 6;
        _proposeTV.layer.masksToBounds = YES;
    }
    return _proposeTV;
}

- (UIButton *)submitButton{
    if (_submitButton == nil) {
        _submitButton = [Utils returnNextButtonWithTitle:@"提交"];
        [self addSubview:_submitButton];
        [_submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.proposeTV.mas_bottom).mas_equalTo(40);
            make.centerX.mas_equalTo(0);
            make.height.mas_equalTo(40);
            make.width.mas_equalTo(171);
        }];
        [_submitButton addTarget:self action:@selector(buttonClickAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitButton;
}

#pragma mark - UITextView Delegate
- (void)textViewDidBeginEditing:(UITextView *)textView{
    self.placeholderLB.hidden = YES;
}

#pragma mark - Method
- (void)buttonClickAction:(UIButton *)button{
    if ([self.proposeTV.text isEqualToString:@""]) {
        [Utils toastview:@"请输入您的建议与意见"];
    }else{
        [self endEditing:YES];
        _ProposeCallBack(self.proposeTV.text);
    }
}


@end
