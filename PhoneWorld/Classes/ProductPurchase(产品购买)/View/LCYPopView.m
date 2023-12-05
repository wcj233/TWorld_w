//
//  LCYPopView.m
//  PhoneWorld
//
//  Created by 刘岑颖 on 2018/1/16.
//  Copyright © 2018年 xiyoukeji. All rights reserved.
//

#import "LCYPopView.h"

@implementation LCYPopView

- (instancetype)initWithImageName:(NSString *)imageName andTitle:(NSString *)title
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
            make.height.mas_equalTo(164);
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
            make.centerY.mas_equalTo(15);
            make.left.mas_equalTo(backView.mas_left).mas_equalTo(39);
            make.right.mas_equalTo(backView.mas_right).mas_equalTo(-39);
        }];
        label.textColor = [Utils colorRGB:@"#EC6C00"];
        label.font = font17;
        label.text = title;
        label.numberOfLines = 0;
        label.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

@end
