//
//  PurchaseView.h
//  PhoneWorld
//
//  Created by 刘岑颖 on 2017/6/3.
//  Copyright © 2017年 xiyoukeji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InputView.h"

@interface PurchaseView : UIView

@property (nonatomic) UIView *topView;
@property (nonatomic) UIImageView *leftImageView;
@property (nonatomic) UILabel *nameLabel;
@property (nonatomic) UILabel *introduceLabel;
@property (nonatomic) UILabel *priceLabel;

@property (nonatomic) InputView *phoneInputView;
@property (nonatomic) UILabel *warningLabel;

@property (nonatomic) UIButton *submitButton;

@end
