//
//  InputView.h
//  PhoneWorld
//
//  Created by 刘岑颖 on 16/10/19.
//  Copyright © 2016年 xiyoukeji. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InputView : UIView <UITextFieldDelegate>

@property (nonatomic) UILabel *leftLabel;

@property (nonatomic) UITextField *textField;

@property (nonatomic, assign) int cardType; // 是普通身份证还是外国人

@end
