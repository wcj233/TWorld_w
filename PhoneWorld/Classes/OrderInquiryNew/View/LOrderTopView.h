//
//  LOrderTopView.h
//  PhoneWorld
//
//  Created by 刘岑颖 on 17/2/27.
//  Copyright © 2017年 xiyoukeji. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    TopButtonsViewTypeOne,//文字之间间距一样
    TopButtonsViewTypeTwo//宽度均分
} TopButtonsViewType;

@interface LOrderTopView : UIView

@property (nonatomic) void(^TopButtonsCallBack) (NSInteger i);

- (instancetype)initWithFrame:(CGRect)frame andTitles:(NSArray *)titles andType:(TopButtonsViewType)type;

@property (nonatomic) NSMutableArray *titlesButtonArray;
@property (nonatomic) UIView *lineView;//下划线

@property (nonatomic) UIButton *currentButton;//当前选中按钮
@property (nonatomic) TopButtonsViewType type;

@end
