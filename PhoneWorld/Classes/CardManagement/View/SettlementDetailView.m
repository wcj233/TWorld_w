//
//  SettlementDetailView.m
//  PhoneWorld
//
//  Created by 刘岑颖 on 16/10/19.
//  Copyright © 2016年 xiyoukeji. All rights reserved.
//

#import "SettlementDetailView.h"
#import "LJYUserProtelController.h"
@interface SettlementDetailView ()

@property (nonatomic) NSArray *leftTitles;
@property (nonatomic) UIView *v;
@property (nonatomic, strong) UIButton *userProtelBtn;
@property (nonatomic, strong) UIButton *isSelectUserProtelBtn;
@end

@implementation SettlementDetailView

- (UIButton *)userProtelBtn {
    if (!_userProtelBtn) {
        _userProtelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        _userProtelBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"我已阅读并同意《话机世界移动业务客户入网服务协议》"];
             [attributedString addAttribute:NSForegroundColorAttributeName
                                      value:[UIColor blueColor]
                                         range:[[attributedString string] rangeOfString:@"《话机世界移动业务客户入网服务协议》"]];
        [attributedString addAttribute:NSFontAttributeName
                                 value:[UIFont systemFontOfSize:12]
                                 range:NSMakeRange(0, attributedString.length)];
        
        [_userProtelBtn setAttributedTitle:attributedString forState:UIControlStateNormal];
        
        [_userProtelBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_userProtelBtn addTarget:self action:@selector(jump) forControlEvents:UIControlEventTouchUpInside];
    }
    return _userProtelBtn;
}

- (UIButton *)isSelectUserProtelBtn {
    if (!_isSelectUserProtelBtn) {
        _isSelectUserProtelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [_isSelectUserProtelBtn.layer setBorderWidth:0.25];
        [_isSelectUserProtelBtn.layer setBorderColor:[UIColor blackColor].CGColor];
        _isSelectUserProtelBtn.backgroundColor = [UIColor whiteColor];
        _isSelectUserProtelBtn.selected = NO;
        [_isSelectUserProtelBtn addTarget:self action:@selector(isSelectUserProtelBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _isSelectUserProtelBtn;
}

- (void)isSelectUserProtelBtnDidClick {
    self.isSelectUserProtelBtn.selected = !self.isSelectUserProtelBtn.selected;
    if (self.isSelectUserProtelBtn.selected) {
        self.isSelectUserProtelBtn.backgroundColor = [UIColor redColor];
        [self.isSelectUserProtelBtn setImage:[UIImage imageNamed:@"gou.jpg"] forState:UIControlStateNormal];
        
        self.nextButton.backgroundColor = MainColor;
    }else {
        self.isSelectUserProtelBtn.backgroundColor = [UIColor whiteColor];
        [self.isSelectUserProtelBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        
        self.nextButton.backgroundColor = [UIColor lightGrayColor];
    }
}

- (void)jump {
    [self.viewController.navigationController pushViewController:[[LJYUserProtelController alloc] init] animated:YES];
    
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = COLOR_BACKGROUND;
        self.leftTitles = @[@"开户号码：",@"预存金额：",@"套餐金额：",@"活动包：",@"优惠金额：",@"总金额："];
        self.leftLabelsArray = [NSMutableArray array];
        [self addSubview:self.userProtelBtn];
        [self addSubview:self.isSelectUserProtelBtn];
        [self addInfo];
        [self nextButton];
        
        
        
    }
    return self;
}


- (void)addInfo{
    UIView *v = [[UIView alloc] init];
    [self addSubview:v];
    [v mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(190);
    }];
    v.backgroundColor = [UIColor whiteColor];
    self.v = v;
    
    
    for (int i = 0; i < self.leftTitles.count; i++) {
        UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(15, 10 + 30*i, screenWidth - 30, 16)];
        [v addSubview:lb];
        lb.textColor = [Utils colorRGB:@"#999999"];
        lb.font = [UIFont systemFontOfSize:textfont16];
        lb.text = self.leftTitles[i];
        [self.leftLabelsArray addObject:lb];
    }
    
}

- (UIButton *)nextButton{
    if (_nextButton == nil) {
        __weak typeof(self) weakSelf = self;
        _nextButton = [Utils returnNextButtonWithTitle:@"提交订单"];
        _nextButton.userInteractionEnabled = NO;
        _nextButton.backgroundColor = [UIColor lightGrayColor];
        
        [self addSubview:_nextButton];
        [_nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.v.mas_bottom).mas_equalTo(40);
            make.centerX.mas_equalTo(0);
            make.height.mas_equalTo(40);
            make.width.mas_equalTo(171);
        }];
        
        [self.userProtelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(weakSelf).offset(30);
            make.bottom.mas_equalTo(_nextButton.mas_top).offset(-10);
            
            make.size.mas_equalTo(CGSizeMake(350, 20));
        }];
        
        [self.isSelectUserProtelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(weakSelf.userProtelBtn);
            make.right.mas_equalTo(weakSelf.userProtelBtn.mas_left).offset(-5);
            make.size.mas_equalTo(CGSizeMake(15, 15));
        }];
        
        
        [_nextButton addTarget:self action:@selector(buttonClickAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextButton;
}

#pragma mark - Method

- (void)buttonClickAction:(UIButton *)button{
    /*
     保存信息并返回首页
     */
    
    if (!self.isSelectUserProtelBtn.selected) {
        [Utils toastview:@"请同意用户协议!"];
        return;
    }
    _SubmitCallBack(button);

}


@end
