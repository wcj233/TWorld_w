//
//  LProductOrderCell.m
//  PhoneWorld
//
//  Created by 刘岑颖 on 2018/1/17.
//  Copyright © 2018年 xiyoukeji. All rights reserved.
//

#import "LProductOrderCell.h"

@implementation LProductOrderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self numberLabel];
        [self stateLabel];
        [self lineView];
        [self rightArrowImageView];
        [self desLabel];
        [self timeLabel];
    }
    return self;
}

- (void)setBookedModel:(LBookedModel *)bookedModel{
    _bookedModel = bookedModel;
    self.numberLabel.text = [NSString stringWithFormat:@"订购手机：%@",bookedModel.number];
    self.stateLabel.text = bookedModel.orderStatusName;
    self.desLabel.text = bookedModel.prodOfferName;
    NSString *timeString = [bookedModel.createDate componentsSeparatedByString:@"."].firstObject;
    self.timeLabel.text = timeString;
}

- (void)setRightsOrderListModel:(RightsOrderListModel *)rightsOrderListModel{
    _rightsOrderListModel = rightsOrderListModel;
    
    self.numberLabel.text = [NSString stringWithFormat:@"订购手机：%@",_rightsOrderListModel.number];
    self.stateLabel.text = _rightsOrderListModel.statusName;
    self.desLabel.text = _rightsOrderListModel.productName;
    NSString *timeString = [_rightsOrderListModel.createDate componentsSeparatedByString:@"."].firstObject;
    self.timeLabel.text = timeString;
}

- (UILabel *)numberLabel{
    if (!_numberLabel) {
        _numberLabel = [[UILabel alloc] init];
        [self addSubview:_numberLabel];
        [_numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(15);
            make.top.mas_equalTo(15);
            make.height.mas_equalTo(14);
        }];
        _numberLabel.font = font14;
        _numberLabel.textColor = [Utils colorRGB:@"#666666"];
        _numberLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _numberLabel;
}

- (UILabel *)stateLabel{
    if (!_stateLabel) {
        _stateLabel = [[UILabel alloc] init];
        [self addSubview:_stateLabel];
        [_stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-15);
            make.top.mas_equalTo(15);
            make.height.mas_equalTo(14);
            make.left.mas_equalTo(self.numberLabel.mas_right).mas_equalTo(4);
        }];
        _stateLabel.font = font14;
        _stateLabel.textColor = [Utils colorRGB:@"#EC6C00"];
        _stateLabel.textAlignment = NSTextAlignmentRight;
    }
    return _stateLabel;
}

- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        [self addSubview:_lineView];
        [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(1);
            make.top.mas_equalTo(self.stateLabel.mas_bottom).mas_equalTo(15);
        }];
        _lineView.backgroundColor = COLOR_BACKGROUND;
    }
    return _lineView;
}

- (UIImageView *)rightArrowImageView{
    if (!_rightArrowImageView) {
        _rightArrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"right"]];
        [self addSubview:_rightArrowImageView];
        [_rightArrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(8);
            make.height.mas_equalTo(13);
            make.top.mas_equalTo(self.lineView.mas_bottom).mas_equalTo(26);
            make.right.mas_equalTo(-15);
        }];
    }
    return _rightArrowImageView;
}

- (UILabel *)desLabel{
    if (!_desLabel) {
        _desLabel = [[UILabel alloc] init];
        [self addSubview:_desLabel];
        [_desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.top.mas_equalTo(self.lineView.mas_bottom).mas_equalTo(12);
            make.height.mas_equalTo(16);
            make.right.mas_equalTo(self.rightArrowImageView.mas_left).mas_equalTo(-4);
        }];
        _desLabel.font = font16;
        _desLabel.textColor = [Utils colorRGB:@"#333333"];
        _desLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _desLabel;
}

- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        [self addSubview:_timeLabel];
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.top.mas_equalTo(self.desLabel.mas_bottom).mas_equalTo(10);
            make.height.mas_equalTo(14);
            make.right.mas_equalTo(self.rightArrowImageView.mas_left).mas_equalTo(-4);
        }];
        _timeLabel.font = font12;
        _timeLabel.textColor = [Utils colorRGB:@"#666666"];
        _timeLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _timeLabel;
}

@end
