//
//  NormalInputCell.m
//  PhoneWorld
//
//  Created by 刘岑颖 on 2017/5/9.
//  Copyright © 2017年 xiyoukeji. All rights reserved.
//

#import "NormalInputCell.h"

@implementation NormalInputCell

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
        [self inputTextField];
        [self leftLabel];
    }
    return self;
}

- (UILabel *)leftLabel{
    if (_leftLabel == nil) {
        _leftLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_leftLabel];
        [_leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.centerY.mas_equalTo(0);
            make.height.mas_equalTo(30);
            make.right.mas_equalTo(self.inputTextField.mas_left).mas_equalTo(-15);
        }];
        _leftLabel.textColor = [UIColor blackColor];
        _leftLabel.font = [UIFont systemFontOfSize:textfont16];
    }
    return _leftLabel;
}

- (UITextField *)inputTextField{
    if (_inputTextField == nil) {
        _inputTextField = [[UITextField alloc] init];
        [self.contentView addSubview:_inputTextField];
        _inputTextField.textAlignment = NSTextAlignmentRight;
        
        [_inputTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.right.mas_equalTo(-15);
            make.height.mas_equalTo(30);
        }];
        _inputTextField.font = [UIFont systemFontOfSize:textfont16];
        _inputTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:textfont16],NSForegroundColorAttributeName:[UIColor darkGrayColor]}];
        _inputTextField.textColor = [Utils colorRGB:@"#666666"];
        _inputTextField.returnKeyType = UIReturnKeyDone;
    }
    return _inputTextField;
}

@end
