//
//  SHeadTitleView.m
//  PhoneWorld
//
//  Created by 刘岑颖 on 2017/6/6.
//  Copyright © 2017年 xiyoukeji. All rights reserved.
//

#import "SHeadTitleView.h"

@implementation SHeadTitleView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView *orangeView = [[UIView alloc] init];
        [self addSubview:orangeView];
        orangeView.backgroundColor = MainColor;
        [orangeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.width.mas_equalTo(4);
            make.height.mas_equalTo(20);
            make.centerY.mas_equalTo(0);
        }];
        
        UILabel *label = [[UILabel alloc] init];
        [self addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(orangeView.mas_right).mas_equalTo(11);
            make.centerY.mas_equalTo(0);
            make.right.mas_equalTo(0);
        }];
        label.textColor = MainColor;
        label.font = [UIFont systemFontOfSize:14];
        self.titleLabel = label;
    }
    return self;
}

@end
