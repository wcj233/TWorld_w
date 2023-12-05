//
//  LFilterConditionView.h
//  PhoneWorld
//
//  Created by 刘岑颖 on 17/2/27.
//  Copyright © 2017年 xiyoukeji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScreenView.h"

@interface LFilterConditionView : UIView

@property (nonatomic) void(^LFilterShowCallBack) (BOOL selected);
@property (nonatomic) UIButton *upDownButton;
@property (nonatomic) UIView *resultView;
@property (nonatomic) NSMutableArray *resultLabelArray;

- (instancetype)initWithFrame:(CGRect)frame;

@end
