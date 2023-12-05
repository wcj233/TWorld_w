//
//  WWhiteCardApplyCell.m
//  PhoneWorld
//
//  Created by 王陈洁 on 2018/10/18.
//  Copyright © 2018年 xiyoukeji. All rights reserved.
//

#import "WWhiteCardApplyCell.h"

@implementation WWhiteCardApplyCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.titleLabel = [UILabel labelWithTitle:@"收货人姓名" color:[Utils colorRGB:@"#333333"] font:[UIFont systemFontOfSize:16] alignment:0];
        [self addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.top.mas_equalTo(11);
            make.height.mas_equalTo(22);
            make.width.mas_equalTo(95);
        }];
        
        self.infoTextView = [[UITextView alloc]init];
        [self addSubview:self.infoTextView];
        [self.infoTextView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-13);
            make.top.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
//            make.height.mas_equalTo(22);
            make.left.mas_equalTo(self.titleLabel.mas_right).mas_equalTo(-15);
        }];
        self.infoTextView.delegate = self;
        self.infoTextView.textAlignment = NSTextAlignmentRight;
        self.infoTextView.font = [UIFont systemFontOfSize:16];
        
        self.placeholdLabel = [UILabel labelWithTitle:@"请输入收货人姓名" color:[Utils colorRGB:@"#999999"] font:[UIFont systemFontOfSize:16] alignment:2];
        [self addSubview:self.placeholdLabel];
        [self.placeholdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-15);
            make.top.mas_equalTo(11);
            make.height.mas_equalTo(22);
            make.left.mas_equalTo(self.titleLabel.mas_right).mas_equalTo(3);
        }];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length>0) {
        self.placeholdLabel.hidden = YES;
    }else{
        self.placeholdLabel.hidden = NO;
    }
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([self.titleLabel.text isEqualToString:@"联系电话"]) {
        if (textView.text.length >= 11 && ![text isEqualToString:@""]) {
            return NO;
        }
    }
    if ([self.titleLabel.text isEqualToString:@"* 身份证"]) {
        if (textView.text.length >= 18 && ![text isEqualToString:@""]) {
            return NO;
        }
    }
    if ([self.titleLabel.text isEqualToString:@"* 手机号"]) {
        if (textView.text.length >= 11 && ![text isEqualToString:@""]) {
            return NO;
        }
    }
    
    return YES;
}

- (void)contentSizeToFit
{
    //先判断一下有没有文字（没文字就没必要设置居中了）
    if([self.infoTextView.text length]>0)
    {
        //textView的contentSize属性
        CGSize contentSize = self.infoTextView.contentSize;
        //textView的内边距属性
        UIEdgeInsets offset;
        CGSize newSize = contentSize;
        
        //如果文字内容高度没有超过textView的高度
        if(contentSize.height <= self.infoTextView.frame.size.height)
        {
            //textView的高度减去文字高度除以2就是Y方向的偏移量，也就是textView的上内边距
            CGFloat offsetY = (self.infoTextView.frame.size.height - contentSize.height)/2;
            offset = UIEdgeInsetsMake(offsetY, 0, 0, 0);
        }
        else          //如果文字高度超出textView的高度
        {
            newSize = self.infoTextView.frame.size;
            offset = UIEdgeInsetsZero;
            CGFloat fontSize = 16;
            
            //通过一个while循环，设置textView的文字大小，使内容不超过整个textView的高度（这个根据需要可以自己设置）
            while (contentSize.height > self.infoTextView.frame.size.height)
            {
                [self.infoTextView setFont:[UIFont fontWithName:@"Helvetica Neue" size:fontSize--]];
                contentSize = self.infoTextView.contentSize;
            }
            newSize = contentSize;
        }
        
        //根据前面计算设置textView的ContentSize和Y方向偏移量
        [self.infoTextView setContentSize:newSize];
        [self.infoTextView setContentInset:offset];
        
    }
}

@end
