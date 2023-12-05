//
//  RedBagFillInfoTBCell.m
//  PhoneWorld
//
//
// Created by 黄振元 on 2019/4/22.
// Copyright © 2019 xiyoukeji. All rights reserved.
//
// @class RedBagFillInfoTBCell
// @abstract 红包抽奖 补登记资料 TBCell
//

#import "RedBagFillInfoTBCell.h"

// controllers

// views

// models
#import "RedBagFillInfoModel.h"

// others


@interface RedBagFillInfoTBCell ()

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UIImageView *rightIcon;

@end


@implementation RedBagFillInfoTBCell

#pragma mark - Override Methods

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self createUI];
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

#pragma mark - Initial Methods


#pragma mark - Privater Methods

- (void)createUI {
    // 标题
    UILabel *titleLabel = [UILabel labelWithTitle:@"" color:kSetColor(@"333333") fontSize:16];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:titleLabel];
    self.titleLabel = titleLabel;
    [titleLabel sizeToFit];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(15);
        make.centerY.mas_equalTo(self.contentView);
    }];
    
    UIImageView *rightIcon = [[UIImageView alloc] init];
    rightIcon.image = kSetImage(@"RightIcon");
    [self.contentView addSubview:rightIcon];
    self.rightIcon = rightIcon;
    [rightIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(-15);
        make.centerY.mas_equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(8, 13));
    }];
    
    self.addressLabel = [[UILabel alloc]init];
    [self.contentView addSubview:self.addressLabel];
    self.addressLabel.textColor = kSetColor(@"333333");
    self.addressLabel.font = [UIFont systemFontOfSize:16];
    self.addressLabel.text = @"";
    self.addressLabel.numberOfLines = 0;
    self.addressLabel.textAlignment = 2;
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(12);
        make.left.mas_equalTo(120);
        make.height.mas_greaterThanOrEqualTo(22);
        make.right.mas_equalTo(-15);
        make.bottom.mas_equalTo(-12.5);
    }];
    
    // 输入框
    UITextField *tf = [[UITextField alloc] init];
    [tf addTarget:self action:@selector(changedTextField:) forControlEvents:UIControlEventEditingChanged];
    tf.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:kSetColor(@"999999")}];
    tf.textColor = kSetColor(@"333333");
    tf.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:tf];
    self.tf = tf;
    [tf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(titleLabel.mas_trailing).offset(10);
        make.trailing.mas_equalTo(rightIcon.mas_trailing).offset(-15 - 8);
        make.centerY.mas_equalTo(self.contentView);
        make.height.mas_equalTo(22);
    }];
}


#pragma mark - Target Methods


#pragma mark - Public Methods


#pragma mark - Notification Methods


#pragma mark - KVO Methods


#pragma mark - Getter Setter Methods

- (void)setInfoModel:(RedBagFillInfoModel *)infoModel {
    self.titleLabel.text = infoModel.title;
    self.tf.placeholder = infoModel.placeholder;
    self.tf.text = infoModel.content;
    
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:infoModel.title];
    [attr addAttribute:NSForegroundColorAttributeName value:kSetColor(@"333333") range:NSMakeRange(0, infoModel.title.length)];
    [attr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(0, infoModel.title.length)];
    if ([infoModel.title hasPrefix:@"*"]) {
        // 带*号，设置成橘色
        [attr addAttribute:NSForegroundColorAttributeName value:kSetColor(@"EC6C00") range:NSMakeRange(0, 1)];
    } else {
        [attr addAttribute:NSForegroundColorAttributeName value:kSetColor(@"333333") range:NSMakeRange(0, infoModel.title.length)];
    }
    self.titleLabel.attributedText = attr;
    
    if ([infoModel.placeholder isEqualToString:@"请选择"]) {
        // 展示 > 图标
        self.rightIcon.hidden = NO;
        [self.tf mas_updateConstraints:^(MASConstraintMaker *make) {
            make.trailing.mas_equalTo(self.rightIcon.mas_trailing).offset(-15 - 8);
        }];
        self.tf.userInteractionEnabled = NO;
    } else {
        // 隐藏
        self.rightIcon.hidden = YES;
        [self.tf mas_updateConstraints:^(MASConstraintMaker *make) {
            make.trailing.mas_equalTo(self.rightIcon);
        }];
        self.tf.userInteractionEnabled = YES;
    }
    
    
    if ([infoModel.title isEqualToString:@"*渠道地址"]) {
        self.tf.enabled = NO;
    }else{
        self.tf.enabled = YES;
    }
    
    [self.titleLabel sizeToFit];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(15);
        make.width.mas_equalTo(self.titleLabel.frame.size.width);
        make.centerY.mas_equalTo(self.contentView);
    }];
}

#pragma mark -给每个cell中的textfield添加事件，只要值改变就调用此函数
-(void)changedTextField:(UITextField *)textField
{
    if (self.changeTFTextBlock) {
        self.changeTFTextBlock(self, textField.text);
    }
}


@end
