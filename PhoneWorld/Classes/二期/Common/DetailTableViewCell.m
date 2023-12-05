//
//  DetailTableViewCell.m
//  PhoneWorld
//
//  Created by fym on 2018/7/19.
//  Copyright © 2018年 xiyoukeji. All rights reserved.
//

#import "DetailTableViewCell.h"
#import "Masonry.h"

@interface DetailTableViewCell ()

@property(nonatomic,strong) UILabel *detailLabel;
@property(nonatomic,strong) UIImageView *indicatorImageView;

@end

@implementation DetailTableViewCell

-(void)setContentWithDetail:(NSString *)detail placeholder:(NSString *)placeholder{
    if (detail==[NSNull null]||detail==nil||[detail isEqualToString:@""]||detail.length==0) {
        _detailLabel.text=placeholder;
        _detailLabel.textColor=[UIColor colorWithWhite:0x99/255.0 alpha:1];
    }
    else{
        _detailLabel.text=detail;
        _detailLabel.textColor=[UIColor darkGrayColor];
    }
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        _indicatorImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"indicator_icon"]];
        [self.contentView addSubview:_indicatorImageView];
        [_indicatorImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-15);
            make.centerY.mas_equalTo(self.contentView);
        }];
        
        _detailLabel=[[UILabel alloc]init];
        _detailLabel.textAlignment = NSTextAlignmentRight;
        _detailLabel.font = [UIFont systemFontOfSize:textfont16];
        [self.contentView addSubview:_detailLabel];
        [_detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.indicatorImageView.mas_left).mas_offset(-7);
            make.top.bottom.mas_equalTo(0);
            make.left.mas_equalTo(self.titleLabel.mas_right).mas_offset(10);
        }];
        
        
        
        [_detailLabel setContentCompressionResistancePriority:749 forAxis:UILayoutConstraintAxisHorizontal];
        [_detailLabel setContentHuggingPriority:249 forAxis:UILayoutConstraintAxisHorizontal];
        
//        [_indicatorImageView setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
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
