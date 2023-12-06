//
//  ChooseIDTypeAlertV.m
//  PhoneWorld
//
//  Created by sheshe on 2023/12/6.
//  Copyright © 2023 xiyoukeji. All rights reserved.
//

#import "ChooseIDTypeAlertV.h"

@interface ChooseIDTypeAlertV ()

@property (nonatomic, strong) UIView * backgroundV;
@property (nonatomic, strong) UIView * whiteV;
@property (nonatomic, strong) UILabel * titleLB;
@property (nonatomic, strong) UIButton * normalBtn;
@property (nonatomic, strong) UIButton * foreignBtn;
@property (nonatomic, strong) UIButton * sureBtn;

@end

@implementation ChooseIDTypeAlertV

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self backgroundV];
        [self whiteV];
        [self titleLB];
        [self normalBtn];
        [self foreignBtn];
        [self sureBtn];
    }
    return self;
}

#pragma mark Method

- (void)selectedNormal {
    self.normalBtn.selected = YES;
    self.foreignBtn.selected = NO;
}

- (void)selectedForeign {
    self.normalBtn.selected = NO;
    self.foreignBtn.selected = YES;
}

- (void)sureAction {
    [self hideAnimation];
    self.OkBlock(self.normalBtn.selected ? 1 : 2);
}

- (void)showAnimation {
    @WeakObj(self);
    [UIView animateWithDuration:0.2f animations:^{
        @StrongObj(self);
        self.alpha = 1.0;
    } completion:^(BOOL finished) {
    }];
}

- (void)hideAnimation {
    
    @WeakObj(self);
    [UIView animateWithDuration:0.1f animations:^{
        @StrongObj(self);
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        @StrongObj(self);
        [self removeFromSuperview];
        self.hidden = YES;
    }];
}

#pragma mark - Lazy Load

- (UIView *)backgroundV {
    if (!_backgroundV) {
        _backgroundV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _backgroundV.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
        [self addSubview:_backgroundV];
    }
    return _backgroundV;
}

- (UIView *)whiteV {
    if (!_whiteV) {
        _whiteV = [[UIView alloc] init];
        _whiteV.backgroundColor = [UIColor whiteColor];
        _whiteV.layer.cornerRadius = 8;
        [self addSubview:_whiteV];
        _whiteV.frame = CGRectMake(30, (SCREEN_HEIGHT - 230) / 2, SCREEN_WIDTH - 60, 230);
        _whiteV.userInteractionEnabled = YES;
        
    }
    return _whiteV;
}

- (UILabel *)titleLB {
    if (_titleLB == nil) {
        _titleLB = [UILabel labelWithTitle:@"请选择您的入网证件类型" color:[UIColor blackColor] font:[UIFont systemFontOfSize:textfont16] alignment:0];
        [self.whiteV addSubview:_titleLB];
        [_titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.top.mas_equalTo(30);
            make.right.mas_equalTo(0);
        }];
    }
    return _titleLB;
}

- (UIButton *)normalBtn {
    if (_normalBtn == nil) {
        _normalBtn = [[UIButton alloc] init];
        [self.whiteV addSubview:_normalBtn];
        [_normalBtn setTitle:@"居民身份证" forState:UIControlStateNormal];
        [_normalBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _normalBtn.titleLabel.font = [UIFont systemFontOfSize:textfont16];
        [_normalBtn setImage:[UIImage imageNamed:@"type_unselected"] forState:UIControlStateNormal];
        [_normalBtn setImage:[UIImage imageNamed:@"type_selected"] forState:UIControlStateSelected];
        _normalBtn.contentHorizontalAlignment = 1;
        _normalBtn.selected = YES;
        _normalBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
        _normalBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        [_normalBtn sizeToFit];
        [_normalBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.height.mas_equalTo(20);
            make.right.mas_equalTo(- 20);
            make.top.mas_equalTo(self.titleLB.mas_bottom).mas_equalTo(20);
        }];
        [_normalBtn addTarget:self action:@selector(selectedNormal) forControlEvents:UIControlEventTouchUpInside];
        _normalBtn.userInteractionEnabled = YES;
    }
    return _normalBtn;
}

- (UIButton *)foreignBtn {
    if (_foreignBtn == nil) {
        _foreignBtn = [[UIButton alloc] init];
        [self.whiteV addSubview:_foreignBtn];
        [_foreignBtn setTitle:@"外国人永久居留身份证" forState:UIControlStateNormal];
        [_foreignBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _foreignBtn.titleLabel.font = [UIFont systemFontOfSize:textfont16];
        [_foreignBtn setImage:[UIImage imageNamed:@"type_unselected"] forState:UIControlStateNormal];
        [_foreignBtn setImage:[UIImage imageNamed:@"type_selected"] forState:UIControlStateSelected];
        _foreignBtn.contentHorizontalAlignment = 1;
        _foreignBtn.selected = NO;
        _foreignBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
        _foreignBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        [_foreignBtn sizeToFit];
        [_foreignBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.height.mas_equalTo(20);
            make.right.mas_equalTo(- 20);
            make.top.mas_equalTo(self.normalBtn.mas_bottom).mas_equalTo(20);
        }];
        [_foreignBtn addTarget:self action:@selector(selectedForeign) forControlEvents:UIControlEventTouchUpInside];
    }
    return _foreignBtn;
}

- (UIButton *)sureBtn {
    if (_sureBtn == nil) {
        _sureBtn = [Utils returnNextButtonWithTitle:@"确定"];
        [_sureBtn addTarget:self action:@selector(sureAction) forControlEvents:UIControlEventTouchUpInside];
        [self.whiteV addSubview:_sureBtn];
        [_sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.right.mas_equalTo(- 20);
            make.bottom.mas_equalTo(- 20);
            make.height.mas_equalTo(40);
        }];
    }
    return _sureBtn;
}

@end
