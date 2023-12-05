//
//  MultiAddressView.m
//  PhoneWorld
//
//  Created by 刘岑颖 on 2017/6/15.
//  Copyright © 2017年 xiyoukeji. All rights reserved.
//

#import "MultiAddressView.h"

@implementation MultiAddressView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addressTextView];
        [self leftLabel];
        [self addressPlaceholderLabel];
        self.addressTextView.delegate = self;
    }
    return self;
}

- (UILabel *)leftLabel{
    if (_leftLabel == nil) {
        _leftLabel = [[UILabel alloc] init];
        [self addSubview:_leftLabel];
        [_leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(14);
            make.top.mas_equalTo(14);
            make.height.mas_equalTo(30);
            make.right.mas_equalTo(self.addressTextView.mas_left).mas_equalTo(-5);
        }];
        _leftLabel.textColor = [Utils colorRGB:@"#333333"];
        _leftLabel.font = [UIFont systemFontOfSize:textfont16];
    }
    return _leftLabel;
}

- (UITextView *)addressTextView{
    if (_addressTextView == nil) {
        _addressTextView = [[UITextView alloc] init];
        [self addSubview:_addressTextView];
        [_addressTextView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(14);
            make.right.mas_equalTo(-15);
            make.bottom.mas_equalTo(-14);
        }];
        _addressTextView.font = [UIFont systemFontOfSize:textfont16];
        _addressTextView.textColor = [Utils colorRGB:@"#333333"];
        _addressTextView.textAlignment = NSTextAlignmentRight;
    }
    return _addressTextView;
}

- (UILabel *)addressPlaceholderLabel{
    if (_addressPlaceholderLabel == nil) {
        _addressPlaceholderLabel = [[UILabel alloc] init];
        [self addSubview:_addressPlaceholderLabel];
        [_addressPlaceholderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.addressTextView.mas_left).mas_equalTo(0);
            make.top.mas_equalTo(14);
            make.height.mas_equalTo(30);
            make.right.mas_equalTo(self.addressTextView.mas_right).mas_equalTo(0);
        }];
        _addressPlaceholderLabel.textAlignment = NSTextAlignmentRight;
        _addressPlaceholderLabel.hidden = NO;
        _addressPlaceholderLabel.textColor = [UIColor darkGrayColor];
        _addressPlaceholderLabel.font = [UIFont systemFontOfSize:textfont16];
    }
    return _addressPlaceholderLabel;
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    self.addressPlaceholderLabel.hidden = YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    if (textView.text.length == 0) {
        self.addressPlaceholderLabel.hidden = NO;
    }
}


@end
