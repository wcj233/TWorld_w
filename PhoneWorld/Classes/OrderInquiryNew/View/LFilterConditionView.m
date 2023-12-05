//
//  LFilterConditionView.m
//  PhoneWorld
//
//  Created by 刘岑颖 on 17/2/27.
//  Copyright © 2017年 xiyoukeji. All rights reserved.
//

#import "LFilterConditionView.h"

@interface LFilterConditionView ()

@end

@implementation LFilterConditionView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.resultLabelArray = [NSMutableArray array];
        self.backgroundColor = [UIColor whiteColor];

        UIView *lineView = [[UIView alloc] init];
        [self addSubview:lineView];
        lineView.backgroundColor = [Utils colorRGB:@"#008bd5"];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(10);
            make.left.mas_equalTo(10);
            make.height.mas_equalTo(20);
            make.width.mas_equalTo(3);
        }];
        
        UILabel *label = [[UILabel alloc] init];
        label.text = @"筛选条件";
        label.textColor = [Utils colorRGB:@"#008bd5"];
        label.font = [UIFont systemFontOfSize:14];
        label.textAlignment = NSTextAlignmentLeft;
        [self addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.top.mas_equalTo(13);
        }];
        
        UIButton *btn = [[UIButton alloc] init];
        btn.frame = CGRectMake(screenWidth - 30, 15, 20, 10);
        [btn setImage:[UIImage imageNamed:@"down"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"up"] forState:UIControlStateSelected];
        btn.userInteractionEnabled = NO;
        btn.selected = NO;
        [self addSubview:btn];
        self.upDownButton = btn;
        
        [self resultView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)tapAction{
    self.upDownButton.selected = self.upDownButton.selected ? NO : YES;
    _LFilterShowCallBack(self.upDownButton.selected);
}

- (UIView *)resultView{
    if (_resultView == nil) {
        _resultView = [[UIView alloc] init];
        [self addSubview:_resultView];
        [_resultView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.upDownButton.mas_bottom).mas_equalTo(15);
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(50);
        }];
        for (int i = 0; i < 4; i++) {
            NSInteger queue = i%2;
            NSInteger line = i/2;
            UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(15+queue*(screenWidth-30)/2, 10+20*line, (screenWidth-30)/2, 14)];
            
            CGFloat getscale = getScale;
            if (getscale > 1.0) {
                getscale = 1.0;
            }
            
            lb.font = [UIFont systemFontOfSize:14 * getscale];
            lb.textColor = [Utils colorRGB:@"#999999"];
            lb.text = [NSString stringWithFormat:@""];
            [_resultView addSubview:lb];
            [self.resultLabelArray addObject:lb];
        }
    }
    return _resultView;
}


@end
