//
//  LCYButtonPopView.h
//  PhoneWorld
//
//  Created by 刘岑颖 on 2018/1/16.
//  Copyright © 2018年 xiyoukeji. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCYButtonPopView : UIView

@property (nonatomic, strong) UIButton *rightButton;

@property (nonatomic, strong) void(^RightCallBack) (id obj);

- (instancetype)initWithImageName:(NSString *)imageName andTitle:(NSString *)title andButtonName:(NSString *)buttonname;

- (void)dismissAction;

@end
