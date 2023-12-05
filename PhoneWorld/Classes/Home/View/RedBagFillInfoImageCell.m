//
//  RedBagFillInfoImageCell.m
//  PhoneWorld
//
//  Created by Allen on 2019/11/26.
//  Copyright © 2019 xiyoukeji. All rights reserved.
//

#import "RedBagFillInfoImageCell.h"

@implementation RedBagFillInfoImageCell

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
        NSArray *arr = @[@"身份证正面照",@"身份证反面照",@"本人手持身份证照片"];
        NSArray *buttonImages = @[@"正面照.png",@"背面照.png",@"手持示例"];
        _chooseImageView = [[ChooseImageView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, (screenWidth - 74)/3.0 + 90) andTitle:@"照片" andDetail:arr andCount:3];
        _chooseImageView.watermark=YES;
//        _chooseImageView.isFinished = self.isFinished;
        _chooseImageView.buttonImages = buttonImages;
        _chooseImageView.chooseImageViewDelegate = self;
    }
    return _chooseImageView;
}

#pragma mark - ChooseImageViewDelegate
- (void)scanForInformation{
    [self.redBagFillInfoImageCellDelegate scanForInformation];
}

@end
