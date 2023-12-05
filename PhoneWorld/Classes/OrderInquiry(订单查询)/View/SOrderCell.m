//
//  SOrderCell.m
//  PhoneWorld
//
//  Created by 刘岑颖 on 2017/6/5.
//  Copyright © 2017年 xiyoukeji. All rights reserved.
//

#import "SOrderCell.h"
#import "UIColor+Extend.h"

@implementation SOrderCell

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
        [self stateLabel];
        
//        self.lineView = [[UIView alloc] init];
//        [self addSubview:self.lineView];
//        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.mas_equalTo(15);
//            make.height.mas_equalTo(1);
//            make.right.mas_equalTo(0);
//            make.top.mas_equalTo(self.stateLabel.mas_bottom).mas_equalTo(8);
//        }];
//        self.lineView.backgroundColor = [UIColor whiteColor];
        
        [self rightImageView];
        [self nameLabel];
//        [self resubmitLab];
        [self resubmitbtn];
        [self reWriteBtn];

        [self phoneLabel];
    }
    return self;
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

- (UILabel *)resubmitLab{
    if (_resubmitLab == nil) {
        _resubmitLab = [[UILabel alloc] init];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"重新提交资料"];
        NSRange strRange = {0,[str length]};
        [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];
        _resubmitLab.attributedText = str;
        _resubmitLab.textAlignment = 0;
        _resubmitLab.textColor = [Utils colorRGB:@"#0081eb"];
        [self addSubview:_resubmitLab];
        [_resubmitLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.nameLabel.mas_right).mas_equalTo(15);
//            make.right.mas_equalTo(self.rightImageView.mas_left).mas_equalTo(-15);
            make.top.mas_equalTo(self.stateLabel.mas_bottom).mas_equalTo(9);
        }];
        _resubmitLab.font = [UIFont systemFontOfSize:14];
//        _resubmitLab.textColor = [Utils colorRGB:@"#999999"];
    }
    return _resubmitLab;
}
- (UIButton *)resubmitbtn{
    if (_resubmitbtn == nil) {
        _resubmitbtn = [[UIButton alloc] init];
//        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"重新提交资料"];
//        NSRange strRange = {0,[str length]};
//        [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];
//        _resubmitbtn.attributedText = str;
        _resubmitbtn.titleLabel.textAlignment = 0;
        [_resubmitbtn setTitle:@"重新提交资料" forState:UIControlStateNormal];
        [_resubmitbtn setTitleColor:[Utils colorRGB:@"#0081eb"] forState:UIControlStateNormal];
//        [_resubmitbtn setAttributedTitle:str forState:UIControlStateNormal];
        _resubmitbtn.layer.cornerRadius = 4;
        _resubmitbtn.clipsToBounds = YES;
        _resubmitbtn.layer.borderWidth =1;
        _resubmitbtn.hidden = YES;
        _resubmitbtn.layer.borderColor = [Utils colorRGB:@"#0081eb"].CGColor;
        _resubmitbtn.titleLabel.textColor = [Utils colorRGB:@"#0081eb"];
        [self.contentView addSubview:_resubmitbtn];
        [_resubmitbtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_rightImageView);
            make.right.mas_equalTo(-40);
            make.width.mas_equalTo(80);
            make.height.mas_equalTo(25);
//            make.top.mas_equalTo(self.stateLabel.mas_bottom).mas_equalTo(4);
        }];
        _resubmitbtn.titleLabel.font = [UIFont systemFontOfSize:12];
    }
    return _resubmitbtn;
}

- (UIButton *)reWriteBtn {
    if (_reWriteBtn == nil) {
        _reWriteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_reWriteBtn setTitle:@"重写" forState:UIControlStateNormal];
        _reWriteBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_reWriteBtn setTitleColor:[Utils colorRGB:@"#0081eb"] forState:UIControlStateNormal];
        _reWriteBtn.layer.cornerRadius = 4;
        _reWriteBtn.clipsToBounds = YES;
        _reWriteBtn.layer.borderWidth = 1;
        _reWriteBtn.hidden = YES;
        _reWriteBtn.layer.borderColor = [Utils colorRGB:@"#0081eb"].CGColor;
        [self.contentView addSubview:_reWriteBtn];
        [_reWriteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_rightImageView);
            make.right.mas_equalTo(-40);
            make.width.mas_equalTo(40);
            make.height.mas_equalTo(25);
        }];
    }
    return _reWriteBtn;
}



- (UILabel *)stateLabel{
    if (_stateLabel == nil) {
        _stateLabel = [[UILabel alloc] init];
        [self addSubview:_stateLabel];
        [_stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.timeLabel).mas_equalTo(15);
            make.top.mas_equalTo(9);
            make.right.mas_equalTo(-15);
        }];
        _stateLabel.textAlignment = NSTextAlignmentRight;
        _stateLabel.font = [UIFont systemFontOfSize:14];
        _stateLabel.textColor = [Utils colorRGB:@"#EC6C00"];
    }
    return _stateLabel;
}

- (UIImageView *)rightImageView{
    if (_rightImageView == nil) {
        _rightImageView = [[UIImageView alloc] init];
        [self addSubview:_rightImageView];
        [_rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-15);
            make.width.mas_equalTo(8);
            make.height.mas_equalTo(13);
            make.top.mas_equalTo(self.stateLabel.mas_bottom).mas_equalTo(20);
        }];
        _rightImageView.image = [UIImage imageNamed:@"right"];
    }
    return _rightImageView;
}

- (UILabel *)nameLabel{
    if (_nameLabel == nil) {
        _nameLabel = [[UILabel alloc] init];
        [self addSubview:_nameLabel];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
//            make.right.mas_equalTo(self.rightImageView.mas_left).mas_equalTo(-15);
            make.top.mas_equalTo(self.stateLabel.mas_bottom).mas_equalTo(9);
            make.height.mas_equalTo(16);
        }];
        _nameLabel.textColor = [Utils colorRGB:@"#333333"];
        _nameLabel.font = [UIFont systemFontOfSize:textfont16];
    }
    return _nameLabel;
}

- (UILabel *)phoneLabel{
    if (_phoneLabel == nil) {
        _phoneLabel = [[UILabel alloc] init];
        [self addSubview:_phoneLabel];
        [_phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(self.rightImageView.mas_left).mas_equalTo(-15);
            make.top.mas_equalTo(self.nameLabel.mas_bottom).mas_equalTo(8);
        }];
        _phoneLabel.font = [UIFont systemFontOfSize:14];
        _phoneLabel.textColor = [Utils colorRGB:@"#666666"];
    }
    return _phoneLabel;
}

@end
