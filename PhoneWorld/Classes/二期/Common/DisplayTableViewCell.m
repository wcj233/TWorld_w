//
//  DisplayTableViewCell.m
//  PhoneWorld
//
//  Created by fym on 2018/7/30.
//  Copyright © 2018年 xiyoukeji. All rights reserved.
//

#import "DisplayTableViewCell.h"
#import "Masonry.h"

@interface DisplayTableViewCell ()

@property(nonatomic,strong)UILabel *detailLabel;

@end

@implementation DisplayTableViewCell

- (void)setContentWithDetail:(NSString *)detail{
    _detailLabel.text=detail;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _detailLabel = [[UILabel alloc] init];
        _detailLabel.textAlignment = NSTextAlignmentRight;
        _detailLabel.font = [UIFont systemFontOfSize:textfont16];
        _detailLabel.textColor = [UIColor darkGrayColor];
        [self.contentView addSubview:_detailLabel];
        [_detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(0);
            make.right.mas_equalTo(-15);
            make.left.mas_equalTo(self.titleLabel.mas_right).mas_offset(10);
        }];
        
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
