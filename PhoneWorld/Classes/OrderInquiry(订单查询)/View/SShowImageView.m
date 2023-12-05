//
//  SShowImageView.m
//  PhoneWorld
//
//  Created by 刘岑颖 on 2017/6/6.
//  Copyright © 2017年 xiyoukeji. All rights reserved.
//

#import "SShowImageView.h"

@interface SShowImageView ()

@property (nonatomic) NSArray *namesArray;

@end

@implementation SShowImageView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        [self titleLabel];
        self.backgroundColor = [UIColor whiteColor];
        self.imageViewsArray = [NSMutableArray array];
        self.labelsArray = [NSMutableArray array];
        self.namesArray = @[@"身份证正面照",@"本人手持正面照"];
        
        for (int i = 0; i < _namesArray.count; i ++) {
            CGFloat imageWidth = (screenWidth - 111) / 2.0;
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(37 + (37 + imageWidth) * i, 46, imageWidth, imageWidth)];
            [self addSubview:imageView];
            imageView.image = [UIImage imageNamed:@"identifyCard1"];
            imageView.tag = i;
            imageView.userInteractionEnabled = YES;
            [self.imageViewsArray addObject:imageView];
            
            UILabel *label = [[UILabel alloc] init];
            [self addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(imageView.mas_left).mas_equalTo(-10);
                make.top.mas_equalTo(imageView.mas_bottom).mas_equalTo(13);
                make.right.mas_equalTo(imageView.mas_right).mas_equalTo(10);
                make.height.mas_equalTo(12);
            }];
            label.text = self.namesArray[i];
            label.textColor = [Utils colorRGB:@"#666666"];
            label.font = [UIFont systemFontOfSize:12];
            label.textAlignment = NSTextAlignmentCenter;
            [self.labelsArray addObject:label];
        }
        
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showImageAction:)];
        UIImageView *imageView1 = self.imageViewsArray.firstObject;
        [imageView1 addGestureRecognizer:tap1];
        
        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showImageAction:)];
        UIImageView *imageView2 = self.imageViewsArray.lastObject;
        [imageView2 addGestureRecognizer:tap2];
        
        MBProgressHUD *progressHUD1 = [[MBProgressHUD alloc] init];
        [self addSubview:progressHUD1];
        [progressHUD1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(imageView1).mas_equalTo(0);
            make.centerY.mas_equalTo(imageView1).mas_equalTo(0);
            make.width.mas_equalTo(100);
            make.height.mas_equalTo(100);
        }];
        [progressHUD1 showAnimated:YES];
        progressHUD1.removeFromSuperViewOnHide = YES;
        progressHUD1.mode = MBProgressHUDModeAnnularDeterminate;
        self.progress1 = progressHUD1;
        
        MBProgressHUD *progressHUD2 = [[MBProgressHUD alloc] init];
        [self addSubview:progressHUD2];
        [progressHUD2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(imageView2).mas_equalTo(0);
            make.centerY.mas_equalTo(imageView2).mas_equalTo(0);
            make.width.mas_equalTo(100);
            make.height.mas_equalTo(100);
        }];
        [progressHUD2 showAnimated:YES];
        progressHUD2.removeFromSuperViewOnHide = YES;
        progressHUD2.mode = MBProgressHUDModeAnnularDeterminate;
        self.progress2 = progressHUD2;
    }
    return self;
}

- (void)setFirstUrl:(NSURL *)firstUrl{
    _firstUrl = firstUrl;
    UIImageView *imageView1 = self.imageViewsArray.firstObject;
    [imageView1 sd_setImageWithURL:firstUrl placeholderImage:[UIImage imageNamed:@"identifyCard1"] options:SDWebImageContinueInBackground progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        float receive = receivedSize;
        float expect = expectedSize;
        self.progress1.progress = (receive/expect);
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [self.progress1 removeFromSuperview];
    }];
}

- (void)setSecondUrl:(NSURL *)secondUrl{
    _secondUrl = secondUrl;
    UIImageView *imageView2 = self.imageViewsArray.lastObject;
    [imageView2 sd_setImageWithURL:secondUrl placeholderImage:[UIImage imageNamed:@"identifyCard2"] options:SDWebImageContinueInBackground progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        float receive = receivedSize;
        float expect = expectedSize;
        self.progress2.progress = (receive/expect);
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [self.progress2 removeFromSuperview];
    }];
}

- (UILabel *)titleLabel{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        [self addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-15);
            make.top.mas_equalTo(12);
            make.height.mas_equalTo(22);
        }];
        _titleLabel.textColor = [Utils colorRGB:@"#333333"];
        _titleLabel.font = [UIFont systemFontOfSize:16];
    }
    return _titleLabel;
}

- (void)showImageAction:(UITapGestureRecognizer *)tap{
    UIImageView *imageV = (UIImageView *)tap.view;
    [PhotoBroswerVC show:[UIApplication sharedApplication].keyWindow.rootViewController type:PhotoBroswerVCTypeZoom index:imageV.tag photoModelBlock:^NSArray *{
        //创建多大容量数组
        NSMutableArray *modelsM = [NSMutableArray array];
        
        for (int i = 0; i < self.imageViewsArray.count; i ++) {
            UIImageView *imageView = self.imageViewsArray[i];
            if (imageView.image) {
                PhotoModel *pbModel=[[PhotoModel alloc] init];
                pbModel.mid = 10 + i;
                pbModel.image = imageView.image;//设置查看大图的时候的图片
                pbModel.sourceImageView = imageV;//点击返回时图片做动画用
                [modelsM addObject:pbModel];
            }
        }
        
        return modelsM;
        
    }];
}

@end
