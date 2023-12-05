//
//  RedBagFillInfoPhotoCell.m
//  PhoneWorld
//
//  Created by Allen on 2019/11/26.
//  Copyright © 2019 xiyoukeji. All rights reserved.
//

#import "RedBagFillInfoPhotoCell.h"

@implementation RedBagFillInfoPhotoVM

@end

@implementation RedBagFillInfoPhotoCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
 
        UILabel *title = [UILabel labelWithTitle:@"照片" color:rgba(51, 51, 51, 1) fontSize:16];
        [self addSubview:title];
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.top.mas_equalTo(15);
        }];
        
        self.backCardBtn = UIButton.new;
        self.backCardBtn.tag = 1001;
        [self.backCardBtn addTarget:self action:@selector(clickCardBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.backCardBtn setBackgroundImage:kSetImage(@"背面照.png") forState:UIControlStateNormal];
        [self.contentView addSubview:self.backCardBtn];
        [self.backCardBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self);
            make.top.mas_equalTo(title.mas_bottom).mas_equalTo(18);
            make.size.mas_equalTo(CGSizeMake(88, 88));
        }];
        UILabel *subTitlelLab1 = [UILabel labelWithTitle:@"上传身份证反面照片" color:rgba(102, 102, 102, 1) fontSize:10];
        [self addSubview:subTitlelLab1];
        [subTitlelLab1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.backCardBtn);
            make.top.mas_equalTo(self.backCardBtn.mas_bottom).mas_equalTo(9);
            make.height.mas_equalTo(14);
            make.bottom.mas_equalTo(-29);
        }];
        
        self.frontCardBtn = UIButton.new;
        self.frontCardBtn.tag = 1000;
        [self.frontCardBtn addTarget:self action:@selector(clickCardBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.frontCardBtn setBackgroundImage:kSetImage(@"正面照.png") forState:UIControlStateNormal];
        [self.contentView addSubview:self.frontCardBtn];
        [self.frontCardBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(20);
            make.top.mas_equalTo(title.mas_bottom).mas_equalTo(18);
            make.size.mas_equalTo(CGSizeMake(88, 88));
        }];
        UILabel *subTitleLab2 = [UILabel labelWithTitle:@"上传身份证正面照片" color:rgba(102, 102, 102, 1) fontSize:10];
        [self addSubview:subTitleLab2];
        [subTitleLab2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.frontCardBtn);
            make.top.mas_equalTo(self.frontCardBtn.mas_bottom).mas_equalTo(9);
        }];
        
        self.handCardBtn = UIButton.new;
        self.handCardBtn.tag = 1002;
        [self.handCardBtn addTarget:self action:@selector(clickCardBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.handCardBtn setBackgroundImage:kSetImage(@"手持示例") forState:UIControlStateNormal];
        [self.contentView addSubview:self.handCardBtn];
        [self.handCardBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.mas_equalTo(-20);
            make.top.mas_equalTo(title.mas_bottom).mas_equalTo(18);
            make.size.mas_equalTo(CGSizeMake(88, 88));
        }];
        UILabel *subTitleLab3 = [UILabel labelWithTitle:@"上传手持身份证照片" color:rgba(102, 102, 102, 1) fontSize:10];
        [self addSubview:subTitleLab3];
        [subTitleLab3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.handCardBtn);
            make.top.mas_equalTo(self.handCardBtn.mas_bottom).mas_equalTo(9);
        }];
        
    }
    return self;
}

- (void)setModel:(RedBagFillInfoPhotoVM *)model{
    _model = model;
    
    if (_model.frontCardIamge) {
        [self.frontCardBtn setBackgroundImage:_model.frontCardIamge forState:UIControlStateNormal];
    }
    if (_model.backCardIamge) {
        [self.backCardBtn setBackgroundImage:_model.backCardIamge forState:UIControlStateNormal];
    }
    if (_model.handCardIamge) {
        [self.handCardBtn setBackgroundImage:_model.handCardIamge forState:UIControlStateNormal];
    }
    
}

- (void)clickCardBtn:(UIButton *)btn{
    if (self.clickBtnBlock) {
        if (btn.tag == 1000) {
            self.clickBtnBlock(0);
        }else if (btn.tag == 1001) {
            self.clickBtnBlock(1);
        }else if (btn.tag == 1002) {
            self.clickBtnBlock(2);
        }
    }
}

@end
