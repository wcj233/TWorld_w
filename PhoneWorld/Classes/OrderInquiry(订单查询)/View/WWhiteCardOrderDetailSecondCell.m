//
//  WWhiteCardOrderDetailSecondCell.m
//  PhoneWorld
//
//  Created by 王陈洁 on 2018/10/18.
//  Copyright © 2018年 xiyoukeji. All rights reserved.
//

#import "WWhiteCardOrderDetailSecondCell.h"

@implementation WWhiteCardOrderDetailSecondCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        NSArray *titles = @[@"申请状态：",@"申请数量：",@"获批数量："];
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
        self.titleLabel = [UILabel labelWithTitle:@"取消原因：" color:[Utils colorRGB:@"#333333"] font:[UIFont systemFontOfSize:16] alignment:0];
        [self addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.top.mas_equalTo(113);
            make.size.mas_equalTo(CGSizeMake(100, 22));
        }];
        
        self.reasonLabel = [UILabel labelWithTitle:@"原因的详情原因的详情原因的详情原因的详情原因的详情" color:[Utils colorRGB:@"#666666"] font:[UIFont systemFontOfSize:14] alignment:0];
        self.reasonLabel.numberOfLines = 0;
        [self addSubview:self.reasonLabel];
        [self.reasonLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.titleLabel.mas_right).mas_equalTo(7);
            make.centerY.mas_equalTo(self.titleLabel);
            make.right.mas_equalTo(0);
            make.bottom.mas_equalTo(-15);
        }];
    }
    return self;
}

-(void)setModel:(WhiteCardDetailModel *)model{
    _model = model;
    UILabel *statusLabel = (UILabel *)[self viewWithTag:100];
    statusLabel.text = model.auditStatusName;
    UILabel *numLabel = (UILabel *)[self viewWithTag:101];
    numLabel.text = model.applySum.stringValue;
    UILabel *agreeNumLabel = (UILabel *)[self viewWithTag:102];
    agreeNumLabel.text = [NSString stringWithFormat:@"%d",model.actualSum.intValue];
    if ([model.auditStatusName isEqualToString:@"审核不通过"]) {
        self.reasonLabel.text = model.notAuditReasons;
        self.titleLabel.hidden = NO;
        [self.reasonLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.titleLabel.mas_right).mas_equalTo(7);
            make.centerY.mas_equalTo(self.titleLabel);
            make.right.mas_equalTo(0);
            make.bottom.mas_equalTo(-15);
        }];
    }else{
        self.titleLabel.hidden = YES;
        [self.reasonLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.titleLabel.mas_right).mas_equalTo(7);
            make.centerY.mas_equalTo(self.titleLabel);
            make.right.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.height.mas_equalTo(0);
        }];
    }
}

@end
