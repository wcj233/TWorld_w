//
//  ChooseProductHeadView.m
//  PhoneWorld
//
//  Created by 刘岑颖 on 2018/1/15.
//  Copyright © 2018年 xiyoukeji. All rights reserved.
//

#import "ChooseProductHeadView.h"

@interface ChooseProductHeadView ()

@property (nonatomic, strong) UILabel *phoneLabel;

@end

@implementation ChooseProductHeadView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [Utils colorRGB:@"#F2F2F2"];
        UILabel *label = [[UILabel alloc] init];
        [self addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.centerY.mas_equalTo(0);
        }];
        label.text = @"您当前订购产品的手机号为";
        label.font = font12;
        label.textColor = [Utils colorRGB:@"#666666"];
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"right"]];
        [self addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.width.mas_equalTo(8);
            make.height.mas_equalTo(13);
            make.right.mas_equalTo(-15);
        }];
        
        UILabel *label1 = [[UILabel alloc] init];
        [self addSubview:label1];
        [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.right.mas_equalTo(imageView.mas_left).mas_equalTo(-4);
        }];
        label1.text = @"更改";
        label1.textAlignment = NSTextAlignmentRight;
        label1.textColor = [Utils colorRGB:@"#666666"];
        label1.font =font12;
        label1.textAlignment = NSTextAlignmentRight;
        
        UILabel *phoneLabel = [[UILabel alloc] init];
        [self addSubview:phoneLabel];
        [phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(label.mas_right).mas_equalTo(0);
            make.right.mas_equalTo(label1.mas_left).mas_equalTo(-5);
            make.centerY.mas_equalTo(0);
        }];
        phoneLabel.textColor = [Utils colorRGB:@"#EC6C00"];
        phoneLabel.font = font12;
        
        self.phoneLabel = phoneLabel;
    }
    return self;
}

- (void)setPhone:(NSString *)phone{
    self.phoneLabel.text = phone;
}

@end
