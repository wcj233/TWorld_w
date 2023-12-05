//
//  WWhiteCardOrderDetailFirstCell.m
//  PhoneWorld
//
//  Created by 王陈洁 on 2018/10/18.
//  Copyright © 2018年 xiyoukeji. All rights reserved.
//

#import "WWhiteCardOrderDetailFirstCell.h"

@implementation WWhiteCardOrderDetailFirstCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        NSArray *titles = @[@"编号：",@"申请时间：",@"审核时间："];
        for (int i = 0; i<3; i++) {
            UILabel *numLabel = [UILabel labelWithTitle:titles[i] color:[Utils colorRGB:@"#333333"] font:[UIFont systemFontOfSize:16] alignment:0];
            [self addSubview:numLabel];
            [numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(15);
                make.top.mas_equalTo(15+(22+11)*i);
                make.size.mas_equalTo(CGSizeMake(100, 22));
            }];
            
            UILabel *infoLabel = [UILabel labelWithTitle:titles[i] color:[Utils colorRGB:@"#666666"] font:[UIFont systemFontOfSize:14] alignment:0];
            [self addSubview:infoLabel];
            [infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(numLabel.mas_right).mas_equalTo(7);
                make.centerY.mas_equalTo(numLabel);
                make.right.mas_equalTo(0);
                make.height.mas_equalTo(22);
            }];
            infoLabel.tag = 100+i;
        }

    }
    return self;
}

-(void)setModel:(WhiteCardDetailModel *)model{
    _model = model;
    UILabel *numLabel = (UILabel *)[self viewWithTag:100];
    numLabel.text = model.orderNumber;
    UILabel *applyTimeLabel = (UILabel *)[self viewWithTag:101];
    applyTimeLabel.text = [model.createDate substringToIndex:16];
    UILabel *checkTimeLabel = (UILabel *)[self viewWithTag:102];
    checkTimeLabel.text = [model.auditTime substringToIndex:16];
}

@end
