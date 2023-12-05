//
//  WWhiteCardOrderListCell.m
//  PhoneWorld
//
//  Created by 王陈洁 on 2018/10/18.
//  Copyright © 2018年 xiyoukeji. All rights reserved.
//

#import "WWhiteCardOrderListCell.h"

@implementation WWhiteCardOrderListCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.numLabel = [UILabel labelWithTitle:@"JMJI377" color:[Utils colorRGB:@"#999999"] font:[UIFont systemFontOfSize:14] alignment:0];
        [self addSubview:self.numLabel];
        [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.top.mas_equalTo(7);
//            make.width.mas_equalTo([Utils sizeToFitWithText:self.numLabel.text andFontSize:14]);
            make.right.mas_equalTo(-15);
            make.height.mas_equalTo(17);
        }];
        
        self.agreeNumLabel = [UILabel labelWithTitle:@"获批: 0" color:[Utils colorRGB:@"#999999"] font:[UIFont systemFontOfSize:14] alignment:0];
        [self addSubview:self.agreeNumLabel];
        [self.agreeNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-15);
            make.centerY.mas_equalTo(self.numLabel);
            make.height.mas_equalTo(17);
            make.width.mas_equalTo([Utils sizeToFitWithText:self.agreeNumLabel.text andFontSize:14]);
        }];
        
        self.applyNumLabel = [UILabel labelWithTitle:@"申请: 0" color:[Utils colorRGB:@"#999999"] font:[UIFont systemFontOfSize:14] alignment:0];
        [self addSubview:self.applyNumLabel];
        [self.applyNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.agreeNumLabel.mas_left).mas_equalTo(-25);
            make.centerY.mas_equalTo(self.numLabel);
            make.height.mas_equalTo(17);
            make.width.mas_equalTo([Utils sizeToFitWithText:self.applyNumLabel.text andFontSize:14]);
        }];
        
        UIView *lineView = [[UIView alloc]init];
        lineView.backgroundColor = [Utils colorRGB:@"#EEEEEE"];
        [self addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(0);
            make.left.mas_equalTo(15);
            make.top.mas_equalTo(self.numLabel.mas_bottom).mas_equalTo(7);
            make.height.mas_equalTo(.5);
        }];
        
        UIImageView *arrowImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"order_icon_next"]];
        [self addSubview:arrowImageView];
        [arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-15);
            make.top.mas_equalTo(lineView.mas_bottom).mas_equalTo(25);
            make.bottom.mas_equalTo(-25);
            make.size.mas_equalTo(CGSizeMake(8, 13));
        }];
        
        self.statusLabel = [UILabel labelWithTitle:@"审核不通过" color:[Utils colorRGB:@"#FF2626"] font:[UIFont systemFontOfSize:14] alignment:2];
        [self addSubview:self.statusLabel];
        [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(arrowImageView.mas_left).mas_equalTo(-15);
            make.size.mas_equalTo(CGSizeMake(75, 20));
            make.centerY.mas_equalTo(arrowImageView);
        }];
        
        self.nameLabel = [UILabel labelWithTitle:@"竹林风" color:[Utils colorRGB:@"#333333"] font:[UIFont boldSystemFontOfSize:16] alignment:0];
        [self addSubview:self.nameLabel];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.height.mas_equalTo(22);
            make.right.mas_equalTo(self.statusLabel.mas_left).mas_equalTo(-3);
            make.top.mas_equalTo(lineView.mas_bottom).mas_equalTo(10);
        }];
        
        self.timeLabel = [UILabel labelWithTitle:@"2018-10-10 10:00" color:[Utils colorRGB:@"#666666"] font:[UIFont systemFontOfSize:12] alignment:0];
        [self addSubview:self.timeLabel];
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.height.mas_equalTo(17);
            make.right.mas_equalTo(self.statusLabel.mas_left).mas_equalTo(-3);
            make.top.mas_equalTo(self.nameLabel.mas_bottom).mas_equalTo(4);
        }];
    }
    return self;
}

-(void)setModel:(WhiteCardListModel *)model{
    _model = model;
    self.numLabel.text = model.orderNumber;
    self.nameLabel.text = [NSString stringWithFormat:@"申请: %@ 获批: %@",model.applySum,model.actualSum];
    self.nameLabel.font = [UIFont systemFontOfSize:14];
    self.nameLabel.textColor = self.applyNumLabel.textColor;
    self.applyNumLabel.text = [NSString stringWithFormat:@"申请: %@",model.applySum];
    self.applyNumLabel.hidden = YES;
    self.agreeNumLabel.text = [NSString stringWithFormat:@"获批: %@",model.actualSum];
    self.agreeNumLabel.hidden = YES;
    self.timeLabel.text = [model.createDate substringToIndex:16];
    self.statusLabel.text = model.auditStatusName;
//    [self.applyNumLabel mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.width.mas_equalTo([Utils sizeToFitWithText:self.applyNumLabel.text andFontSize:14]);
//    }];
//    [self.agreeNumLabel mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.width.mas_equalTo([Utils sizeToFitWithText:self.agreeNumLabel.text andFontSize:14]);
//    }];
//    [self.numLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(15);
//        make.top.mas_equalTo(7);
//        make.right.mas_equalTo(self.applyNumLabel.mas_left).mas_equalTo(-5);
//        make.height.mas_equalTo(17);
//    }];
}

@end
