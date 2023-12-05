//
//  PersonalInfoViewCell.m
//  PhoneWorld
//
//  Created by Allen on 2019/11/26.
//  Copyright © 2019 xiyoukeji. All rights reserved.
//

#import "PersonalInfoViewCell.h"

@implementation PersonalInfoViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.textLabel.font = [UIFont systemFontOfSize:16];
        self.textLabel.textColor = rgba(51, 51, 51, 1);
        self.detailTextLabel.font = [UIFont systemFontOfSize:16];
        self.detailTextLabel.text = @"无";
        self.detailTextLabel.textColor = rgba(153, 153, 153, 1);
    }
    return self;
}

- (void)setModel:(PersonalInfoModel *)model{
    _model = model;
    
    if ([self.textLabel.text isEqualToString:@"用户名"]) {
        self.detailTextLabel.text = model.username;
    }
    if ([self.textLabel.text isEqualToString:@"姓名"]) {
        self.detailTextLabel.text = model.contact;
    }
    if ([self.textLabel.text isEqualToString:@"手机号码"]) {
        self.detailTextLabel.text = model.tel;
    }
    if ([self.textLabel.text isEqualToString:@"电子邮箱"]) {
        self.detailTextLabel.text = model.email;
    }
    if ([self.textLabel.text isEqualToString:@"渠道名称"]) {
        self.detailTextLabel.text = model.channelName;
    }
    if ([self.textLabel.text isEqualToString:@"上级名称"]) {
        self.detailTextLabel.text = model.supUserName;
    }
    if ([self.textLabel.text isEqualToString:@"渠道地址"]) {
        self.detailTextLabel.text = model.workAddress;
    }
    if ([self.textLabel.text isEqualToString:@"上级电话"]) {
        self.accessibilityLabel = model.supTel;
    }
    if ([self.textLabel.text isEqualToString:@"上级推荐码"]) {
        if (model.supRecomdCode) {
            self.detailTextLabel.text = model.supRecomdCode;
        }else{
            self.detailTextLabel.text = @"无";
        }
    }
    if ([self.textLabel.text isEqualToString:@"本人推荐码"]) {
        self.detailTextLabel.text = model.recomdCode;
    }
    if ([self.textLabel.text isEqualToString:@"证件地址"]) {
        self.detailTextLabel.text = model.address;
    }
}

@end
