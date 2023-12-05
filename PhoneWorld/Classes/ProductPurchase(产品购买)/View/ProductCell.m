//
//  ProductCell.m
//  PhoneWorld
//
//  Created by 刘岑颖 on 2017/6/3.
//  Copyright © 2017年 xiyoukeji. All rights reserved.
//

#import "ProductCell.h"

@implementation ProductCell

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
        [self container];
        [self nameLabel];
        [self introduceLabel];
        
//        self.lineView = [[UIView alloc] init];
//        [self addSubview:self.lineView];
//        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.mas_equalTo(15);
//            make.height.mas_equalTo(1);
//            make.right.mas_equalTo(0);
//            make.top.mas_equalTo(self.introduceLabel.mas_bottom).mas_equalTo(12);
//        }];
//        self.lineView.backgroundColor = [Utils colorRGB:@"#DDDDDD"];
        
        [self codeLabel];

        [self purchaseButton];
    }
    return self;
}

-(UIView*)container{
    if (_container == nil) {
        _container=[[UIView alloc] init];
        [self addSubview:_container];
        [_container mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(20);
            make.right.equalTo(self).offset(-20);
            make.top.equalTo(self).offset(20);
            make.height.mas_equalTo(200);
        }];
        _container.layer.borderColor=[UIColor colorWithRed:237.0/255 green:108.0/255 blue:0 alpha:1].CGColor;
        _container.layer.borderWidth=1.0;
        _container.layer.cornerRadius=10;
    }
    return _container;
}

- (UILabel *)nameLabel{
    if (_nameLabel == nil) {
        _nameLabel = [[UILabel alloc] init];
        [self.container addSubview:_nameLabel];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.container);
            make.top.equalTo(self.container).offset(15);
            make.top.mas_equalTo(24);
        }];
        _nameLabel.textColor = [Utils colorRGB:@"#333333"];
        _nameLabel.font = [UIFont boldSystemFontOfSize:20];
        _nameLabel.textAlignment=NSTextAlignmentCenter;
    }
    return _nameLabel;
}

- (UILabel *)introduceLabel{
    if (_introduceLabel == nil) {
        _introduceLabel = [[UILabel alloc] init];
        [self.container addSubview:_introduceLabel];
        [_introduceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-15);
            make.top.mas_equalTo(self.nameLabel.mas_bottom).mas_equalTo(10);
            make.width.mas_equalTo(screenWidth - 30);
        }];
        _introduceLabel.numberOfLines = 0;
        _introduceLabel.font = [UIFont systemFontOfSize:12];
        _introduceLabel.textColor = [Utils colorRGB:@"#666666"];
    }
    return _introduceLabel;
}

- (UILabel *)codeLabel{
    if (_codeLabel == nil) {
        _codeLabel = [[UILabel alloc] init];
        [self.container addSubview:_codeLabel];
//        [_codeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.mas_equalTo(14);
//            make.right.mas_equalTo(-15);
//            make.top.mas_equalTo(self.lineView.mas_bottom).mas_equalTo(14);
//            make.height.mas_equalTo(14);
//        }];
        _codeLabel.font = [UIFont systemFontOfSize:14];
        _codeLabel.textColor = [Utils colorRGB:@"#666666"];
    }
    return _codeLabel;
}

- (UIButton *)purchaseButton{
    if (_purchaseButton == nil) {
        _purchaseButton = [[UIButton alloc] init];
        [self.container addSubview:_purchaseButton];
        [_purchaseButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.container).offset(-15);
            make.width.mas_equalTo(60);
            make.height.mas_equalTo(30);
            make.centerX.equalTo(self.container);
        }];
        _purchaseButton.layer.borderColor = [Utils colorRGB:@"#Ed6C00"].CGColor;
        _purchaseButton.layer.cornerRadius = 4.0;
        _purchaseButton.layer.borderWidth = 1.0;
        _purchaseButton.layer.masksToBounds = YES;
        [_purchaseButton setTitle:@"订购" forState:UIControlStateNormal];
        [_purchaseButton setTitleColor:[Utils colorRGB:@"#EC6C00"] forState:UIControlStateNormal];
        _purchaseButton.titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _purchaseButton;
}

@end
