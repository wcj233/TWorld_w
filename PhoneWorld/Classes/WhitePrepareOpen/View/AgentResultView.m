//
//  AgentResultView.m
//  PhoneWorld
//
//  Created by 刘岑颖 on 2017/5/10.
//  Copyright © 2017年 xiyoukeji. All rights reserved.
//

#import "AgentResultView.h"

@interface AgentResultView ()

@property (nonatomic) NSArray *leftTitlesArray;

@end

@implementation AgentResultView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = COLOR_BACKGROUND;
        self.leftTitlesArray = @[@"靓号",@"归属地",@"运营商",@"套餐",@"活动包",@"状态"];
        self.contentSize = CGSizeMake(screenWidth, 0);

        self.dataLabelsArray = [NSMutableArray array];
        
        UIImageView *showImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"business_icon_isuccessfuldeposit_small"]];
        [self.whiteBackView addSubview:showImageView];
        [showImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(37);
            make.top.mas_equalTo(21);
            make.width.height.mas_equalTo(49);
        }];
        self.showImageView = showImageView;
        
        [self promptLabel];
        
        self.lineView = [[UIView alloc] init];
        [self.whiteBackView addSubview:self.lineView];
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(31);
            make.right.mas_equalTo(-31);
            make.height.mas_equalTo(1);
            make.top.mas_equalTo(self.showImageView.mas_bottom).mas_equalTo(18);
        }];
        self.lineView.backgroundColor = [Utils colorRGB:@"#E2E2E2"];
        
        [self showLabel];
        
        for (int i = 0; i < self.leftTitlesArray.count; i ++) {
            UILabel *label = [[UILabel alloc] init];
            [self.dataLabelsArray addObject:label];
            [self.whiteBackView addSubview:label];
            if (i == 0) {
                [label mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(31);
                    make.right.mas_equalTo(-31);
                    make.top.mas_equalTo(self.showLabel.mas_bottom).mas_equalTo(15);
                }];
            }else if(i < self.leftTitlesArray.count - 1){
                UILabel *previousLabel = self.dataLabelsArray[i - 1];
                [label mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(31);
                    make.right.mas_equalTo(-31);
                    make.top.mas_equalTo(previousLabel.mas_bottom).mas_equalTo(11);
                }];
            }else{
                UILabel *previousLabel = self.dataLabelsArray[i - 1];
                [label mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(31);
                    make.right.mas_equalTo(-31);
                    make.top.mas_equalTo(previousLabel.mas_bottom).mas_equalTo(11);
                    make.bottom.mas_equalTo(-20);
                }];
            }
            label.textColor = [Utils colorRGB:@"#333333"];
            label.font = [UIFont systemFontOfSize:14];
            label.text = [NSString stringWithFormat:@"%@：",self.leftTitlesArray[i]];
            label.numberOfLines = 0;
        }
    }
    return self;
}

- (UIView *)whiteBackView{
    if (_whiteBackView == nil) {
        _whiteBackView = [[UIView alloc] init];
        [self addSubview:_whiteBackView];
        [_whiteBackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.mas_equalTo(0);
            make.width.mas_equalTo(screenWidth);
        }];
        _whiteBackView.backgroundColor = [UIColor whiteColor];
    }
    return _whiteBackView;
}

- (UILabel *)promptLabel{
    if (_promptLabel == nil) {
        _promptLabel = [[UILabel alloc] init];
        [self.whiteBackView addSubview:_promptLabel];
        [_promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.showImageView.mas_right).mas_equalTo(16);
            make.centerY.mas_equalTo(self.showImageView);
            make.right.mas_equalTo(-37);
        }];
        _promptLabel.textColor = MainColor;
        _promptLabel.font = [UIFont systemFontOfSize:textfont17];
        _promptLabel.text = @"预开户成功！";
    }
    return _promptLabel;
}

- (UILabel *)showLabel{
    if (_showLabel == nil) {
        _showLabel = [[UILabel alloc] init];
        [self.whiteBackView addSubview:_showLabel];
        [_showLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(31);
            make.top.mas_equalTo(self.lineView.mas_bottom).mas_equalTo(15);
            make.right.mas_equalTo(-31);
            make.height.mas_equalTo(14);
        }];
        _showLabel.textColor = [Utils colorRGB:@"#333333"];
        _showLabel.text = @"开户详情";
        _showLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:textfont14];;
    }
    return _showLabel;
}

@end
