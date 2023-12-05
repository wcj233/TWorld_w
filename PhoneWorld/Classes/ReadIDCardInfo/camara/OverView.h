//
//  OverView.h
//  TestCamera
//
//  Created by wintone on 14/11/25.
//  Copyright (c) 2014年 zzzili. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OverView : UIView

@property (assign, nonatomic) BOOL leftHidden;
@property (assign, nonatomic) BOOL rightHidden;
@property (assign, nonatomic) BOOL topHidden;
@property (assign, nonatomic) BOOL bottomHidden;

@property (assign, nonatomic) BOOL mrz;
@property (assign, nonatomic) BOOL isHorizontal;//是否横屏

@property (assign ,nonatomic) NSInteger smallX;
@property (assign ,nonatomic) CGRect smallrect;
@property (assign, nonatomic) CGRect mrzSmallRect;

- (void) setRecogArea;

@end
