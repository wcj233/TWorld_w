//
//  BondView.m
//  PhoneWorld
//
//  Created by 刘岑颖 on 2017/12/6.
//  Copyright © 2017年 xiyoukeji. All rights reserved.
//

#import "BondView.h"

@interface BondView ()

@property (nonatomic, strong) UIView *backView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *moneyLabel;

@property (nonatomic, strong) UILabel *usernameLabel;

@property (nonatomic, strong) UILabel *numberLabel;

@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) UILabel *introLabel;

@end

@implementation BondView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self scrollView];
        [self backView];
        [self titleLabel];
        [self moneyLabel];
        [self usernameLabel];
        [self numberLabel];
        [self lineView];
        [self introLabel];
        [self chooseMethod];
        [self payWay];
        [self payButton];
    }
    return self;
}

- (void)setModel:(BondModel *)model{
    _model = model;
    dispatch_async(dispatch_get_main_queue(), ^{
        self.moneyLabel.text = model.amount;
        self.usernameLabel.text = [NSString stringWithFormat:@"缴纳用户：%@",model.userName];
        self.numberLabel.text = [NSString stringWithFormat:@"订单号：%@",model.orderNo];
        self.introLabel.text = [NSString stringWithFormat:@"保证金说明：%@",model.model_description];
    });
}

- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        [self addSubview:_scrollView];
        [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.mas_equalTo(0);
        }];
        _scrollView.contentSize = CGSizeMake(screenWidth, 0);
    }
    return _scrollView;
}

- (UIView *)backView{
    if (!_backView) {
        _backView = [[UIView alloc] init];
        [self.scrollView addSubview:_backView];
        [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.mas_equalTo(0);
            make.width.mas_equalTo(screenWidth);
        }];
        _backView.backgroundColor = [UIColor whiteColor];
    }
    return _backView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        [self.backView addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-15);
            make.top.mas_equalTo(30);
        }];
        _titleLabel.font = font16;
        _titleLabel.textColor = [Utils colorRGB:@"#333333"];
        _titleLabel.text = @"保证金金额";
    }
    return _titleLabel;
}

- (UILabel *)moneyLabel{
    if (!_moneyLabel) {
        _moneyLabel = [[UILabel alloc] init];
        [self.backView addSubview:_moneyLabel];
        [_moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-15);
            make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_equalTo(12);
        }];
        _moneyLabel.font = [UIFont systemFontOfSize:50];
        _moneyLabel.textColor = [Utils colorRGB:@"#333333"];
        _moneyLabel.text = @"¥0";
        _moneyLabel.numberOfLines = 0;
    }
    return _moneyLabel;
}

- (UILabel *)usernameLabel{
    if (!_usernameLabel) {
        _usernameLabel = [[UILabel alloc] init];
        [self.backView addSubview:_usernameLabel];
        [_usernameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-15);
            make.top.mas_equalTo(self.moneyLabel.mas_bottom).mas_equalTo(35);
        }];
        _usernameLabel.font = font16;
        _usernameLabel.textColor = [Utils colorRGB:@"#666666"];
        _usernameLabel.text = @"缴纳用户：";
        _usernameLabel.numberOfLines = 0;
    }
    return _usernameLabel;
}

- (UILabel *)numberLabel{
    if (!_numberLabel) {
        _numberLabel = [[UILabel alloc] init];
        [self.backView addSubview:_numberLabel];
        [_numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-15);
            make.top.mas_equalTo(self.usernameLabel.mas_bottom).mas_equalTo(12);
        }];
        _numberLabel.font = font16;
        _numberLabel.textColor = [Utils colorRGB:@"#666666"];
        _numberLabel.text = @"订单号：";
        _numberLabel.numberOfLines = 0;
    }
    return _numberLabel;
}

- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        [self.backView addSubview:_lineView];
        [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(1);
            make.top.mas_equalTo(self.numberLabel.mas_bottom).mas_equalTo(21);
        }];
        _lineView.backgroundColor = [Utils colorRGB:@"#D8D8D8"];
    }
    return _lineView;
}

- (UILabel *)introLabel{
    if (!_introLabel) {
        _introLabel = [[UILabel alloc] init];
        [self.backView addSubview:_introLabel];
        [_introLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-15);
            make.top.mas_equalTo(self.lineView.mas_bottom).mas_equalTo(12);
            make.bottom.mas_equalTo(-12);
        }];
        _introLabel.font = font16;
        _introLabel.textColor = [Utils colorRGB:@"#666666"];
        _introLabel.text = @"保证金说明：";
        _introLabel.numberOfLines = 0;
    }
    return _introLabel;
}

- (void)chooseMethod{
    UIView *view = [[UIView alloc] init];
    [self.scrollView addSubview:view];
    view.backgroundColor = [Utils colorRGB:@"#EC6C00"];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(4);
        make.height.mas_equalTo(20);
        make.top.mas_equalTo(self.backView.mas_bottom).mas_equalTo(12);
    }];
    
    UILabel *label = [[UILabel alloc] init];
    [self.scrollView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(view.mas_right).mas_equalTo(11);
        make.centerY.mas_equalTo(view);
    }];
    label.font = font14;
    label.textColor = [Utils colorRGB:@"#EC6C00"];
    label.text = @"支付方式";
}

- (UIView *)payWay{
    if (_payWay == nil) {
        _payWay = [[UIView alloc] init];
        [self.scrollView addSubview:_payWay];
        
        //        NSArray *textArr = @[@"支付宝支付",@"微信支付"];
        //        NSArray *textColorArr = @[@"#00a9f2",@"#64ab23"];
        
        NSArray *textArr = @[@"支付宝支付"];
        NSArray *textColorArr = @[@"#00a9f2"];
        NSArray *imageArr = @[@"alipay1"];
        
        CGFloat height = textArr.count * 65;
        
        [_payWay mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.backView.mas_bottom).mas_equalTo(44);
            make.left.right.mas_equalTo(0);
            make.bottom.mas_equalTo(-120);
            make.height.mas_equalTo(height);
        }];
        _payWay.backgroundColor = [UIColor whiteColor];
        
        UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 64)];
        [_payWay addSubview:v];
        UIButton *pay = [[UIButton alloc] init];
        [v addSubview:pay];
        [pay mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.top.mas_equalTo(22.5);
            make.width.height.mas_equalTo(20);
        }];
        pay.layer.cornerRadius = 10;
        pay.layer.masksToBounds = YES;
        pay.backgroundColor = [UIColor whiteColor];
        pay.layer.borderColor = [Utils colorRGB:@"#0081eb"].CGColor;
        pay.layer.borderWidth = 6;
        
        UIImageView *imageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageArr[0]]];
        [v addSubview:imageV];
        [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(pay.mas_centerY);
            make.left.mas_equalTo(pay.mas_right).mas_equalTo(24);
            make.width.height.mas_equalTo(40);
        }];
        imageV.layer.cornerRadius = 10;
        imageV.layer.masksToBounds = YES;
        
        UILabel *lb = [[UILabel alloc] init];
        [v addSubview:lb];
        [lb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(imageV.mas_centerY);
            make.left.mas_equalTo(imageV.mas_right).mas_equalTo(16);
        }];
        lb.text = textArr[0];
        lb.textColor = [Utils colorRGB:textColorArr[0]];
        lb.font = [UIFont systemFontOfSize:textfont16];
        
    }
    return _payWay;
}

- (UIButton *)payButton{
    if (!_payButton) {
        _payButton = [[UIButton alloc] init];
        [self.scrollView addSubview:_payButton];
        [_payButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.width.mas_equalTo(171);
            make.height.mas_equalTo(40);
            make.top.mas_equalTo(self.payWay.mas_bottom).mas_equalTo(60);
        }];
        _payButton.backgroundColor = [Utils colorRGB:@"#EC6C00"];
        _payButton.layer.cornerRadius = 4.0;
        _payButton.layer.masksToBounds = YES;
        [_payButton setTitle:@"提交" forState:UIControlStateNormal];
        [_payButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    return _payButton;
}

@end
