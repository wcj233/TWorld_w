//
//  ChooseCardView.m
//  PhoneWorld
//
//  Created by Allen on 2019/8/19.
//  Copyright © 2019 xiyoukeji. All rights reserved.
//

#import "ChooseCardView.h"

@implementation ChooseCardView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = UIColor.whiteColor;
    }
    return self;
}

- (void)setDataArray:(NSArray *)dataArray{
    _dataArray = dataArray;
    
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    
    for (NSInteger index = 0; index < dataArray.count ; index ++) {
        UIButton *cardBtn = UIButton.new;
        cardBtn.layer.cornerRadius = 5;
        cardBtn.layer.masksToBounds = YES;
        cardBtn.layer.borderWidth = 1;
        cardBtn.layer.borderColor = kSetColor(@"FFCFA7").CGColor;
        cardBtn.tag = 100 + index;
        [cardBtn addTarget:self action:@selector(clickCardBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cardBtn];
        [cardBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            !(index % 2)?make.leading.mas_equalTo(20):make.trailing.mas_equalTo(-20);
            make.top.mas_equalTo(20 + (45 + 10) * (index / 2));
            make.size.mas_equalTo(CGSizeMake((screenWidth - 20 - 9 - 20) / 2.0, 45));
        }];
        [cardBtn setTitle:_dataArray[index] forState:UIControlStateNormal];
        [cardBtn setTitleColor:kSetColor(@"333333") forState:UIControlStateNormal];
    }
}

- (void)clickCardBtn:(UIButton *)btn{
    self.clickCardBlock(self.dataArray[btn.tag - 100]);
}

@end
