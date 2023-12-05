//
//  NormalShowCell.m
//  PhoneWorld
//
//  Created by 刘岑颖 on 2017/5/9.
//  Copyright © 2017年 xiyoukeji. All rights reserved.
//

#import "NormalShowCell.h"

@implementation NormalShowCell

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
        [self rightLabel];
        [self leftLabel];
    }
    return self;
}

- (UILabel *)leftLabel{
    if (_leftLabel == nil) {
        _leftLabel = [[UILabel alloc] init];
        [self addSubview:_leftLabel];
        [_leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.centerY.mas_equalTo(0);
            make.height.mas_equalTo(30);
            make.right.mas_equalTo(self.rightLabel.mas_left).mas_equalTo(-15);
        }];
        _leftLabel.textColor = [Utils colorRGB:@"#333333"];
        _leftLabel.font = [UIFont systemFontOfSize:textfont16];
    }
    return _leftLabel;
}

- (UILabel *)rightLabel{
    if (_rightLabel == nil) {
        _rightLabel = [[UILabel alloc] init];
        [self addSubview:_rightLabel];
        [_rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.height.mas_equalTo(30);
            make.right.mas_equalTo(-15);
        }];
        _rightLabel.textAlignment = NSTextAlignmentRight;
        _rightLabel.textColor = [Utils colorRGB:@"#333333"];
        _rightLabel.font = [UIFont systemFontOfSize:textfont16];
    }
    return _rightLabel;
}

@end
