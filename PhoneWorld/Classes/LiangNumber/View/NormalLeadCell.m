//
//  NormalLeadCell.m
//  PhoneWorld
//
//  Created by 刘岑颖 on 2017/5/9.
//  Copyright © 2017年 xiyoukeji. All rights reserved.
//

#import "NormalLeadCell.h"

@implementation NormalLeadCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self leadImageView];
        [self inputTextField];
        [self leftLabel];
    }
    return self;
}

- (UIImageView *)leadImageView{
    if (_leadImageView == nil) {
        _leadImageView = [[UIImageView alloc] init];
        [self addSubview:_leadImageView];
        [_leadImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-15);
            make.width.mas_equalTo(8);
            make.height.mas_equalTo(13);
            make.centerY.mas_equalTo(0);
        }];
        _leadImageView.image = [UIImage imageNamed:@"right"];
    }
    return _leadImageView;
}

- (UITextField *)inputTextField{
    if (_inputTextField == nil) {
        _inputTextField = [[UITextField alloc] init];
        [self addSubview:_inputTextField];
        [_inputTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.height.mas_equalTo(30);
            make.right.mas_equalTo(self.leadImageView.mas_left).mas_equalTo(-6);
        }];
        _inputTextField.textAlignment = NSTextAlignmentRight;
        _inputTextField.font = [UIFont systemFontOfSize:textfont16];
        _inputTextField.textColor = [Utils colorRGB:@"#333333"];
    }
    return _inputTextField;
}

- (UILabel *)leftLabel{
    if (_leftLabel == nil) {
        _leftLabel = [[UILabel alloc] init];
        [self addSubview:_leftLabel];
        [_leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.centerY.mas_equalTo(0);
            make.height.mas_equalTo(30);
            make.right.mas_equalTo(self.inputTextField.mas_left).mas_equalTo(-6);
        }];
        _leftLabel.textColor = [Utils colorRGB:@"#333333"];
        _leftLabel.font = [UIFont systemFontOfSize:textfont16];
    }
    return _leftLabel;
}

@end
