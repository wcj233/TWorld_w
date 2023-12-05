//
//  SShowImageView.h
//  PhoneWorld
//
//  Created by 刘岑颖 on 2017/6/6.
//  Copyright © 2017年 xiyoukeji. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SShowImageView : UIView

@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) NSMutableArray<UIImageView *> *imageViewsArray;
@property (nonatomic) NSMutableArray<UILabel *> *labelsArray;

@property (nonatomic) NSURL *firstUrl;
@property (nonatomic) NSURL *secondUrl;

@property (nonatomic) MBProgressHUD *progress1;
@property (nonatomic) MBProgressHUD *progress2;

@end
