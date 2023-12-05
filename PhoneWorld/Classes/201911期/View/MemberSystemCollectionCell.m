//
//  MemberSystemCollectionCell.m
//  PhoneWorld
//
//  Created by Allen on 2019/12/16.
//  Copyright © 2019 xiyoukeji. All rights reserved.
//

#import "MemberSystemCollectionCell.h"

@implementation MemberSystemCollectionCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.bgBtn = UIButton.new;
        self.bgBtn.layer.cornerRadius = 4;
        self.bgBtn.layer.borderColor = rgba(41, 159, 255, 1).CGColor;
        self.bgBtn.layer.borderWidth = 1;
        self.bgBtn.layer.masksToBounds = YES;
        NSMutableAttributedString *bgTitleStr = [[NSMutableAttributedString alloc]initWithString:@"一个月\n" attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14],NSForegroundColorAttributeName:rgba(0, 129, 235, 1)}];
        [bgTitleStr appendAttributedString:[[NSAttributedString alloc]initWithString:@"15元" attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:11],NSForegroundColorAttributeName:rgba(0, 129, 235, 1)}]];
        [self.bgBtn setAttributedTitle:bgTitleStr forState:UIControlStateNormal];
        self.bgBtn.titleLabel.numberOfLines = 0;
        self.bgBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.bgBtn];
        [self.bgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.top.leading.trailing.mas_equalTo(self);
        }];
        [self.bgBtn addTarget:self action:@selector(clickBgBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)setModel:(Prods *)model{
    _model = model;
    
    NSMutableAttributedString *bgTitleStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@\n", _model.name] attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]}];
    [bgTitleStr appendAttributedString:[[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"%0.2f元", _model.orderAmount] attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:11]}]];
    [bgTitleStr addAttributes:@{NSForegroundColorAttributeName:rgba(0, 129, 235, 1)} range:NSMakeRange(0, bgTitleStr.length)];
    [self.bgBtn setAttributedTitle:[bgTitleStr mutableCopy] forState:UIControlStateNormal];
    [bgTitleStr addAttributes:@{NSForegroundColorAttributeName:UIColor.whiteColor} range:NSMakeRange(0, bgTitleStr.length)];
    [self.bgBtn setAttributedTitle:[bgTitleStr mutableCopy] forState:UIControlStateSelected];
}

- (void)clickBgBtn:(UIButton *)btn{
    if (self.clickBgBtnBlock) {
        self.clickBgBtnBlock(self);
    }
}

@end
