//
//  LCYButtonPopView.m
//  PhoneWorld
//
//  Created by 刘岑颖 on 2018/1/16.
//  Copyright © 2018年 xiyoukeji. All rights reserved.
//

#import "LCYButtonPopView.h"

@implementation LCYButtonPopView

- (instancetype)initWithImageName:(NSString *)imageName andTitle:(NSString *)title andButtonName:(NSString *)buttonname
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        
        UIView *backView = [[UIView alloc] init];
        [self addSubview:backView];
        [backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(0);
            make.left.mas_equalTo(53);
            make.right.mas_equalTo(-53);
            make.height.mas_greaterThanOrEqualTo(222);
        }];
        backView.layer.cornerRadius = 13;
        backView.layer.masksToBounds = YES;
        backView.backgroundColor = [UIColor whiteColor];
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
        [self addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(114);
            make.centerX.mas_equalTo(0);
            make.centerY.mas_equalTo(backView.mas_top).mas_equalTo(0);
        }];
        
        UILabel *label = [[UILabel alloc] init];
        [self addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.centerY.mas_equalTo(12);
            make.left.mas_equalTo(backView.mas_left).mas_equalTo(39);
            make.right.mas_equalTo(backView.mas_right).mas_equalTo(-39);
        }];
        label.textColor = [Utils colorRGB:@"#333333"];
        label.font = font17;
        label.text = title;
        label.numberOfLines = 0;
        label.textAlignment = NSTextAlignmentCenter;
        
        UIButton *leftButton = [[UIButton alloc] init];
        [backView addSubview:leftButton];
        [leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.mas_equalTo(0);
            make.width.mas_equalTo((screenWidth - 108)/2.0);
            make.height.mas_equalTo(44);
        }];
        leftButton.layer.borderColor = COLOR_BACKGROUND.CGColor;
        leftButton.layer.borderWidth = 1.0;
        [leftButton setTitleColor:[Utils colorRGB:@"#333333"] forState:UIControlStateNormal];
        [leftButton setTitle:@"取消" forState:UIControlStateNormal];
        leftButton.titleLabel.font = font16;
        [leftButton addTarget:self action:@selector(dismissAction) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *rightButton = [[UIButton alloc] init];
        [backView addSubview:rightButton];
        [rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.bottom.mas_equalTo(0);
            make.width.mas_equalTo((screenWidth - 108)/2.0);
            make.height.mas_equalTo(44);
        }];
        rightButton.layer.borderColor = COLOR_BACKGROUND.CGColor;
        rightButton.layer.borderWidth = 1.0;
        [rightButton setTitleColor:[Utils colorRGB:@"#333333"] forState:UIControlStateNormal];
        [rightButton setTitle:buttonname forState:UIControlStateNormal];
        rightButton.titleLabel.font = font16;
        [rightButton addTarget:self action:@selector(rightButtonClickedAction) forControlEvents:UIControlEventTouchUpInside];
        
        self.rightButton = rightButton;
    }
    return self;
}

- (void)dismissAction{
    self.hidden = YES;
    [self removeFromSuperview];
}

- (void)rightButtonClickedAction{
    _RightCallBack(nil);
}

@end
