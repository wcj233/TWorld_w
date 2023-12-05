//
//  FinishCardView.h
//  PhoneWorld
//
//  Created by 刘岑颖 on 16/10/13.
//  Copyright © 2016年 xiyoukeji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InputView.h"

@interface FinishCardView : UIView <UITextFieldDelegate>

@property (nonatomic) void(^FinishCardCallBack)(NSString *tel,NSString *puk);
@property (nonatomic) UIButton *nextButton;
@property (nonatomic) NSMutableArray *inputViews;
@property (nonatomic) UILabel *warningLabel;//警告label
@property(nonatomic, assign) BOOL isFace;

@property (nonatomic) void(^NextCallBack) (NSString *title);

-(instancetype)initWithFrame:(CGRect)frame andIsFace:(BOOL)isFace;//是否是人脸识别

@end
