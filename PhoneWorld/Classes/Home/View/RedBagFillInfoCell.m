//
//  RedBagFillInfoCell.m
//  PhoneWorld
//
//  Created by sheshe on 2021/1/11.
//  Copyright © 2021 xiyoukeji. All rights reserved.
//

#import "RedBagFillInfoCell.h"

@implementation RedBagFillInfoCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        
//        CGFloat imageHeight = (screenWidth - 74)/3.0;
//        [self.chooseImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.leading.bottom.topMargin.mas_equalTo(self);
//            make.height.mas_equalTo(imageHeight + 90);
//        }];
        
        [self.contentView addSubview:self.chooseImageView];
    }
    return self;
}

- (ChooseImageView *)chooseImageView{
    if (_chooseImageView == nil) {
        NSArray *arr = @[@"营业执照",@"网点照片"];
        NSArray *buttonImages = @[@"1备份",@"1备份 2"];
        _chooseImageView = [[ChooseImageView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, (screenWidth - 74)/2.0 + 90) andTitle:@"照片" andDetail:arr andCount:2];
        _chooseImageView.watermark=YES;
//        _chooseImageView.isFinished = self.isFinished;
        _chooseImageView.buttonImages = buttonImages;
        _chooseImageView.titleLB.font = [UIFont systemFontOfSize:textfont16];
        _chooseImageView.chooseImageViewDelegate = self;
        
        UILabel *tipLabel = [[UILabel alloc]init];
        tipLabel.text = @"*营业执照或网点照片至少上传一张";
        [_chooseImageView addSubview:tipLabel];
        tipLabel.textColor = rgba(255, 38, 38, 1);
        tipLabel.font = [UIFont systemFontOfSize:textfont14];
        [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15+35+5);
            make.height.mas_equalTo(16);
            make.centerY.mas_equalTo(_chooseImageView.titleLB);
            make.right.mas_equalTo(0);
        }];
    }
    return _chooseImageView;
}

#pragma mark - ChooseImageViewDelegate
- (void)scanForInformation{
    
}

@end
