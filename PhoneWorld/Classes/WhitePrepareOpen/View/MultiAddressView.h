//
//  MultiAddressView.h
//  PhoneWorld
//
//  Created by 刘岑颖 on 2017/6/15.
//  Copyright © 2017年 xiyoukeji. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MultiAddressView : UIView <UITextViewDelegate>

@property (nonatomic) UILabel *leftLabel;
@property (nonatomic) UITextView *addressTextView;
@property (nonatomic) UILabel *addressPlaceholderLabel;

@end
