//
//  WWhiteCardOrderDetailThirdCell.m
//  PhoneWorld
//
//  Created by 王陈洁 on 2018/10/18.
//  Copyright © 2018年 xiyoukeji. All rights reserved.
//

#import "WWhiteCardOrderDetailThirdCell.h"

@implementation WWhiteCardOrderDetailThirdCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        NSArray *titles = @[@"收件人姓名：",@"联系电话：",@"收件地址："];
        for (int i = 0; i<3; i++) {
            UILabel *numLabel = [UILabel labelWithTitle:titles[i] color:[Utils colorRGB:@"#333333"] font:[UIFont systemFontOfSize:16] alignment:0];
            [self addSubview:numLabel];
            [numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(15);
                make.top.mas_equalTo(15+(22+11)*i);
                make.size.mas_equalTo(CGSizeMake(100, 22));
            }];
            
            UILabel *infoLabel = [UILabel labelWithTitle:titles[i] color:[Utils colorRGB:@"#666666"] font:[UIFont systemFontOfSize:14] alignment:0];
            infoLabel.tag = 100+i;
            infoLabel.numberOfLines = 0;
            [self addSubview:infoLabel];
            [infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(numLabel.mas_right).mas_equalTo(7);
                make.right.mas_equalTo(0);
                if (i==2) {
                    make.top.mas_equalTo(numLabel);
                    make.bottom.mas_equalTo(-15);
                }else{
                    make.centerY.mas_equalTo(numLabel);
                    make.height.mas_equalTo(22);
                }
            }];
        }
    }
    return self;
}

-(void)setModel:(WhiteCardDetailModel *)model{
    _model = model;
    UILabel *nameLabel = (UILabel *)[self viewWithTag:100];
    nameLabel.text = model.name;
    UILabel *telLabel = (UILabel *)[self viewWithTag:101];
    telLabel.text = model.tel;
    UILabel *adressNumLabel = (UILabel *)[self viewWithTag:102];
    adressNumLabel.text = model.deliveryAddress;
}

@end
