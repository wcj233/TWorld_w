//
//  RedBagFillInfoVCodeCell.m
//  PhoneWorld
//
//  Created by Allen on 2019/11/26.
//  Copyright © 2019 xiyoukeji. All rights reserved.
//

#import "RedBagFillInfoVCodeCell.h"

@implementation RedBagFillInfoVCodeCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        // 标题
        UILabel *titleLabel = [UILabel labelWithTitle:@"" color:kSetColor(@"333333") fontSize:16];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:titleLabel];
        self.titleLabel = titleLabel;
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(15);
            make.centerY.mas_equalTo(self.contentView);
        }];
        
        //获取验证Btn
        self.verificationCodeBtn = UIButton.new;
        [self.verificationCodeBtn addTarget:self action:@selector(clickVerificationCodeBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.verificationCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [self.verificationCodeBtn setTitleColor:rgba(236, 108, 0, 1) forState:UIControlStateNormal];
        self.verificationCodeBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [self.verificationCodeBtn setTitleColor:rgba(153, 153, 153, 1) forState:UIControlStateSelected];
        [self.contentView addSubview:self.verificationCodeBtn];
        [self.verificationCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.mas_equalTo(-15);
            make.centerY.mas_equalTo(self.contentView);
            make.size.mas_equalTo(CGSizeMake(86, 22));
        }];
        
        // 输入框
        UITextField *tf = [[UITextField alloc] init];
        [tf addTarget:self action:@selector(changedTextField:) forControlEvents:UIControlEventEditingChanged];
        tf.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:kSetColor(@"999999")}];
        tf.textColor = kSetColor(@"333333");
        tf.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:tf];
        self.tf = tf;
        [tf mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(titleLabel.mas_trailing).offset(10);
            make.trailing.mas_equalTo(self.verificationCodeBtn.mas_leading).offset(- 8);
            make.centerY.mas_equalTo(self.contentView);
            make.height.mas_equalTo(22);
        }];
    }
    return self;
}

- (void)clickVerificationCodeBtn:(UIButton *)btn{
    if (self.clickVCodeBlock) {
        if(self.clickVCodeBlock()){
            [self setTheCountdownButton:btn startWithTime:60 title:@"获取验证码" countDownTitle:@"s" mainColor:rgba(236, 108, 0, 1) countColor:rgba(153, 153, 153, 1)];
        }
    }
}

- (void)setInfoModel:(RedBagFillInfoModel *)infoModel {
    self.titleLabel.text = infoModel.title;
    self.tf.placeholder = infoModel.placeholder;
    self.tf.text = infoModel.content;

    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:infoModel.title];
    [attr addAttribute:NSForegroundColorAttributeName value:kSetColor(@"333333") range:NSMakeRange(0, infoModel.title.length)];
    [attr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(0, infoModel.title.length)];
    if ([infoModel.title hasPrefix:@"*"]) {
        // 带*号，设置成橘色
        [attr addAttribute:NSForegroundColorAttributeName value:kSetColor(@"EC6C00") range:NSMakeRange(0, 1)];
    } else {
        [attr addAttribute:NSForegroundColorAttributeName value:kSetColor(@"333333") range:NSMakeRange(0, infoModel.title.length)];
    }
    self.titleLabel.attributedText = attr;
}

#pragma mark -给每个cell中的textfield添加事件，只要值改变就调用此函数
-(void)changedTextField:(UITextField *)textField
{
    if (self.changeTFTextBlock) {
        self.changeTFTextBlock(self, textField.text);
    }
}

#pragma mark - button倒计时
- (void)setTheCountdownButton:(UIButton *)button startWithTime:(NSInteger)timeLine title:(NSString *)title countDownTitle:(NSString *)subTitle mainColor:(UIColor *)mColor countColor:(UIColor *)color {
    //倒计时时间
    __block NSInteger timeOut = timeLine;
    dispatch_queue_t queue =dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER,0, 0, queue);
    //每秒执行一次
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL,0), 1.0 * NSEC_PER_SEC,0);
    dispatch_source_set_event_handler(_timer, ^{
        
        //倒计时结束，关闭
        if (timeOut == 0) {
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
//                button.backgroundColor = mColor;
                [button setTitleColor:mColor forState:UIControlStateNormal];
                [button setTitle:title forState:UIControlStateNormal];
                button.userInteractionEnabled =YES;
            });
        } else {
            int seconds = timeOut % 60;
            NSString *timeStr = [NSString stringWithFormat:@"%0.1d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
//                button.backgroundColor = color;
                [button setTitleColor:color forState:UIControlStateNormal];
                [button setTitle:[NSString stringWithFormat:@"%@%@",timeStr,subTitle]forState:UIControlStateNormal];
                button.userInteractionEnabled =NO;
            });
            timeOut--;
        }
    });
    dispatch_resume(_timer);
}

@end
