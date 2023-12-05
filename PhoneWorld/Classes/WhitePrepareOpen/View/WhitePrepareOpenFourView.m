//
//  WhitePrepareOpenFourView.m
//  PhoneWorld
//
//  Created by 刘岑颖 on 2017/5/9.
//  Copyright © 2017年 xiyoukeji. All rights reserved.
//

#import "WhitePrepareOpenFourView.h"
#import "NormalInputCell.h"
#import "AddressCell.h"

static NSString *warningText = @"1、本人正面免冠照片，用户头像占比不小于照片三分之一\n2、App开户后台人工审核，请核对无误后再上传。";

@interface WhitePrepareOpenFourView ()

@property (nonatomic) NSArray *leftTitlesArray;

@property (nonatomic) NSString *typeString;

@property (nonatomic, assign) BOOL isFaceVerify;

@end

@implementation WhitePrepareOpenFourView

- (instancetype)initWithFrame:(CGRect)frame andType:(NSString *)type isFaceVerify:(BOOL)isFaceVerify
{
    self = [super initWithFrame:frame];
    if (self) {
        self.infoArray = [NSMutableArray array];
        self.typeString = type;
        self.leftTitlesArray = @[@"开户人姓名",@"证件号码",@"证件地址"];
        self.isFaceVerify = isFaceVerify;
        [self contentTableView];
        [self tableFooterView];
        [self chooseImageView];
        [self warningLabel];
        [self openButton];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 1)];
        lineView.backgroundColor = COLOR_BACKGROUND;
        [self.tableFooterView addSubview:lineView];
    }
    return self;
}

- (UITableView *)contentTableView{
    if (_contentTableView == nil) {
        _contentTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [self addSubview:_contentTableView];
        [_contentTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.mas_equalTo(0);
        }];
        _contentTableView.delegate = self;
        _contentTableView.dataSource = self;
        _contentTableView.backgroundColor = COLOR_BACKGROUND;
    }
    return _contentTableView;
}

- (UIView *)tableFooterView{
    if (_tableFooterView == nil) {
        CGFloat imageHeight = (screenWidth - 74)/3.0;

        _tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 260 + imageHeight + 85)];
        self.contentTableView.tableFooterView = _tableFooterView;
    }
    return _tableFooterView;
}

- (ChooseImageView *)chooseImageView{
    if (_chooseImageView == nil) {
        NSArray *arr = @[@"身份证正面照",@"身份证正面+卡板照",@"本人现场正面免冠照片"];
        NSArray *buttonImages = @[@"正面照.png",@"卡板照.png",@"现场照.png"];
        if (self.isFaceVerify) {
            // 人脸开户
//            arr = @[@"身份证正面照",@"身份证背面照",@"本人现场正面免冠照片"];
//            buttonImages = @[@"正面照.png",@"背面照.png",@"现场照.png"];
            arr = @[@"身份证正面照",@"身份证正面照+卡板号码照片",@"本人现场正面免冠照片"];
            buttonImages = @[@"正面照.png",@"卡板照.png",@"现场照.png"];
        }
        
        if ([self.typeString isEqualToString:@"写卡激活"]) {
            arr = @[@"身份证正面照",@"身份证背面照",@"身份证正面照+卡板号码照片",@"本人现场正面免冠照片"];
            buttonImages = @[@"正面照.png",@"背面照.png",@"卡板照.png",@"现场照.png"];
        }
        
        
        
        _chooseImageView = [[ChooseImageView alloc] initWithFrame:CGRectZero andTitle:@"证件上传（点击图片可放大）" andDetail:arr andCount:arr.count];
        _chooseImageView.watermark=YES;
        _chooseImageView.buttonImages = buttonImages;
        CGFloat imageHeight = (screenWidth - 74)/3.0;
        if ([self.typeString isEqualToString:@"写卡激活"]) {
            imageHeight = (screenWidth - 74)/2.0;
        }

        [self.tableFooterView addSubview:_chooseImageView];
        [_chooseImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(0);
            make.width.mas_equalTo(screenWidth);
            if ([self.typeString isEqualToString:@"写卡激活"]) {
//                make.height.mas_equalTo(imageHeight*2 + 105);
                make.height.mas_equalTo(CGRectGetMaxY(_chooseImageView.lastInstrusctLabel.frame)+20);
            }else{
                make.height.mas_equalTo(imageHeight+85);
            }
            
        }];
        _chooseImageView.chooseImageViewDelegate = self;
    }
    return _chooseImageView;
}

- (UILabel *)warningLabel{
    if (_warningLabel == nil) {
        _warningLabel = [[UILabel alloc] init];
        [self.tableFooterView addSubview:_warningLabel];
        [_warningLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.height.mas_equalTo(40);
            make.left.mas_equalTo(10);
            make.right.mas_equalTo(-10);
            make.top.mas_equalTo(self.chooseImageView.mas_bottom).mas_equalTo(10);
        }];
        _warningLabel.text = warningText;
        _warningLabel.textColor = [UIColor redColor];
        _warningLabel.font = [UIFont systemFontOfSize:textfont12];
        _warningLabel.numberOfLines = 0;
    }
    return _warningLabel;
}

- (UIButton *)openButton{
    if (_openButton == nil) {
        _openButton = [Utils returnNextTwoButtonWithTitle:@"提交"];
        [self addSubview:_openButton];
        [_openButton mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(self.warningLabel.mas_bottom).mas_equalTo(60);
            make.centerX.mas_equalTo(0);
            make.height.mas_equalTo(40);
            make.width.mas_equalTo(170);
            make.bottom.mas_equalTo(-20);
        }];
    }
    return _openButton;
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.leftTitlesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *leftTitleString = [NSString stringWithFormat:@"%@",self.leftTitlesArray[indexPath.row]];
    
    if ([leftTitleString isEqualToString:@"证件地址"]) {
        AddressCell *cell = [[AddressCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.leftLabel.text = leftTitleString;
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.addressPlaceholderLabel.text = @"请输入证件地址";
        cell.addressPlaceholderLabel.hidden = NO;
        cell.addressTextView.delegate = self;
        if (self.infoArray.count == 3) {
            cell.addressTextView.text = self.infoArray[2];
            cell.addressPlaceholderLabel.hidden = YES;
        }
        return cell;
    }
    
    NormalInputCell *cell = [[NormalInputCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if ([leftTitleString isEqualToString:@"证件号码"]) {
        cell.inputTextField.userInteractionEnabled = NO;
    }else{
        cell.inputTextField.delegate = self;
    }
    cell.leftLabel.text = leftTitleString;
    NSString *holderText = [NSString stringWithFormat:@"请输入%@",leftTitleString];
    
    //setValue forKeyPath失效了
    NSMutableAttributedString *placeholder = [[NSMutableAttributedString alloc] initWithString:holderText];
    [placeholder addAttribute:NSForegroundColorAttributeName
                        value:[UIColor darkGrayColor]
                        range:NSMakeRange(0, holderText.length)];
    [placeholder addAttribute:NSFontAttributeName
                        value:[UIFont systemFontOfSize:16]
                        range:NSMakeRange(0, holderText.length)];
    cell.inputTextField.attributedPlaceholder = placeholder;
    
    if (self.infoArray.count == 3) {
        cell.inputTextField.text = self.infoArray[indexPath.row];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 2) {
        return 88;
    }
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UITextViewDelegate

- (void)textViewDidEndEditing:(UITextView *)textView{
    if (textView.text.length == 0) {
        AddressCell *cell = [self.contentTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
        cell.addressPlaceholderLabel.hidden = NO;
    }
    if (self.infoArray.count == 3) {
        [self.infoArray replaceObjectAtIndex:2 withObject:textView.text];
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    AddressCell *cell = [self.contentTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    cell.addressPlaceholderLabel.hidden = YES;
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (self.infoArray.count == 3) {
        [self.infoArray replaceObjectAtIndex:0 withObject:textField.text];
    }
}

-(void)scanForInformation{
//    self.whitePrepareOpenFourViewDelegate = self;
    [self.whitePrepareOpenFourViewDelegate scanForInformation];
}

@end
