//
//  TextTableViewCell.m
//  PhoneWorld
//
//  Created by fym on 2018/7/19.
//  Copyright © 2018年 xiyoukeji. All rights reserved.
//

#import "TextTableViewCell.h"
#import "Masonry.h"

@interface TextTableViewCell () <UITextFieldDelegate>

@property(nonatomic,strong)UITextField *textField;

@property(nonatomic,assign)int limit;
@property(nonatomic,copy)FAStringCallBackBlock editBlock;

@end

@implementation TextTableViewCell

-(void)setKeyboardType:(UIKeyboardType)type{
    _textField.keyboardType=type;
}

-(void)setContentWithText:(NSString *)text placeholder:(NSString *)placeholder limit:(int)limit editBlock:(FAStringCallBackBlock)editBlock{
    
    _textField.keyboardType=UIKeyboardTypeDefault;
    _limit=limit;
    _textField.text=text;
    _textField.placeholder=placeholder;
    _editBlock=editBlock;
    
    
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _textField = [[UITextField alloc] init];
        _textField.textAlignment = NSTextAlignmentRight;
        _textField.font = [UIFont systemFontOfSize:textfont16];
        _textField.textColor = [UIColor darkGrayColor];
        _textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@" " attributes:@{NSForegroundColorAttributeName:[UIColor colorWithWhite:0x99/255.0 alpha:1]}];
        _textField.delegate = self;
        _textField.returnKeyType = UIReturnKeyDone;
        [self.contentView addSubview:_textField];
        [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(0);
            make.right.mas_equalTo(-15);
            make.left.mas_equalTo(self.titleLabel.mas_right).mas_offset(10);
        }];
        
    }
    return self;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (_limit==0) {
        return YES;
    }
    if (string.length == 0) return YES;

    NSInteger existedLength = textField.text.length;
    NSInteger selectedLength = range.length;
    NSInteger replaceLength = string.length;
    if (existedLength - selectedLength + replaceLength > _limit) {
        return NO;
    }
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    textField.text=[textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (_editBlock) {
        _editBlock(textField.text);
    }
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
