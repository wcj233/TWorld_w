//
//  SRepairCardShowImageView.m
//  PhoneWorld
//
//  Created by 刘岑颖 on 2017/6/6.
//  Copyright © 2017年 xiyoukeji. All rights reserved.
//

#import "SRepairCardShowImageView.h"

@implementation SRepairCardShowImageView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        CGFloat imageWidth = (screenWidth - 111) / 2.0;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(37, 22, imageWidth, imageWidth)];
        [self addSubview:imageView];
        imageView.image = [UIImage imageNamed:@"identifyCard2"];
        imageView.userInteractionEnabled = YES;
        self.imageView = imageView;
        
        UILabel *label = [[UILabel alloc] init];
        [self addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(imageView.mas_left).mas_equalTo(-10);
            make.top.mas_equalTo(imageView.mas_bottom).mas_equalTo(13);
            make.right.mas_equalTo(imageView.mas_right).mas_equalTo(10);
            make.height.mas_equalTo(12);
        }];
        label.text = @"本人手持身份证正面";
        label.textColor = [Utils colorRGB:@"#666666"];
        label.font = [UIFont systemFontOfSize:12];
        label.textAlignment = NSTextAlignmentCenter;
        
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showImageAction:)];
        [imageView addGestureRecognizer:tap1];
        
        MBProgressHUD *progressHUD1 = [[MBProgressHUD alloc] init];
        [self addSubview:progressHUD1];
        [progressHUD1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(imageView).mas_equalTo(0);
            make.centerY.mas_equalTo(imageView).mas_equalTo(0);
            make.width.mas_equalTo(100);
            make.height.mas_equalTo(100);
        }];
        [progressHUD1 showAnimated:YES];
        progressHUD1.removeFromSuperViewOnHide = YES;
        progressHUD1.mode = MBProgressHUDModeAnnularDeterminate;
        self.progress1 = progressHUD1;
    }
    return self;
}

- (void)setImageUrl:(NSURL *)imageUrl{
    _imageUrl = imageUrl;
    [self.imageView sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"identifyCard2"] options:SDWebImageContinueInBackground progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        float receive = receivedSize;
        float expect = expectedSize;
        self.progress1.progress = (receive/expect);
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [self.progress1 removeFromSuperview];
    }];
}

- (void)showImageAction:(UITapGestureRecognizer *)tap{
    UIImageView *imageV = (UIImageView *)tap.view;
    [PhotoBroswerVC show:[UIApplication sharedApplication].keyWindow.rootViewController type:PhotoBroswerVCTypeZoom index:0 photoModelBlock:^NSArray *{
        //创建多大容量数组
        NSMutableArray *modelsM = [NSMutableArray array];
        PhotoModel *pbModel=[[PhotoModel alloc] init];
        pbModel.mid = 11;
        //设置查看大图的时候的图片
        pbModel.image = imageV.image;
        pbModel.sourceImageView = imageV;//点击返回时图片做动画用
        [modelsM addObject:pbModel];
        return modelsM;
    }];
}

@end
