//
//  STopOrderCell.m
//  PhoneWorld
//
//  Created by 刘岑颖 on 2017/6/6.
//  Copyright © 2017年 xiyoukeji. All rights reserved.
//

#import "STopOrderCell.h"

@implementation STopOrderCell

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
        [self timeLabel];
        [self moneyLabel];
        
        self.lineView = [[UIView alloc] init];
        [self addSubview:self.lineView];
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.height.mas_equalTo(1);
            make.right.mas_equalTo(0);
            make.top.mas_equalTo(self.moneyLabel.mas_bottom).mas_equalTo(8);
        }];
        self.lineView.backgroundColor = [Utils colorRGB:@"#EEEEEE"];
        
//        [self rightImageView];
        [self phoneLabel];
        [self rightLab];
    }
    return self;
}

- (UILabel *)rightLab{
    if (!_rightLab) {
        _rightLab = [UILabel labelWithTitle:@"" color:rgba(236, 108, 0, 1) fontSize:14];
        [self addSubview:_rightLab];
        [_rightLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-15);
            make.top.mas_equalTo(self.lineView.mas_bottom).mas_equalTo(14);
        }];
    }
    return _rightLab;
}

- (UILabel *)timeLabel{
    if (_timeLabel == nil) {
        _timeLabel = [[UILabel alloc] init];
        [self addSubview:_timeLabel];
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.top.mas_equalTo(9);
        }];
        _timeLabel.font = [UIFont systemFontOfSize:14];
        _timeLabel.textColor = [Utils colorRGB:@"#999999"];
    }
    return _timeLabel;
}

- (UILabel *)moneyLabel{
    if (_moneyLabel == nil) {
        _moneyLabel = [[UILabel alloc] init];
        [self addSubview:_moneyLabel];
        [_moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.timeLabel).mas_equalTo(15);
            make.top.mas_equalTo(9);
            make.right.mas_equalTo(-15);
            make.height.mas_equalTo(14);
        }];
        _moneyLabel.textAlignment = NSTextAlignmentRight;
        _moneyLabel.font = [UIFont systemFontOfSize:14];
        _moneyLabel.textColor = rgba(153, 153, 153, 1);
    }
    return _moneyLabel;
}

- (UIImageView *)rightImageView{
    if (_rightImageView == nil) {
        _rightImageView = [[UIImageView alloc] init];
        [self addSubview:_rightImageView];
        [_rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-15);
            make.width.mas_equalTo(8);
            make.height.mas_equalTo(13);
            make.top.mas_equalTo(self.lineView.mas_bottom).mas_equalTo(14);
        }];
        _rightImageView.image = [UIImage imageNamed:@"right"];
    }
    return _rightImageView;
}

- (UILabel *)phoneLabel{
    if (_phoneLabel == nil) {
        _phoneLabel = [[UILabel alloc] init];
        [self addSubview:_phoneLabel];
        [_phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(self.rightImageView.mas_left).mas_equalTo(-15);
            make.top.mas_equalTo(self.lineView.mas_bottom).mas_equalTo(13);
            make.height.mas_equalTo(14);
        }];
        _phoneLabel.font = [UIFont systemFontOfSize:14];
        _phoneLabel.textColor = [Utils colorRGB:@"#666666"];
    }
    return _phoneLabel;
}

@end
