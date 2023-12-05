//
//  CardInquiryViewController.h
//  PhoneWorld
//
//  Created by 刘岑颖 on 16/10/20.
//  Copyright © 2016年 xiyoukeji. All rights reserved.
//

#import "BaseViewController.h"
#import "CardInquiryView.h"

@interface CardInquiryViewController : BaseViewController

+ (CardInquiryViewController *)sharedCardInquiryViewController;

//查询条件
@property (nonatomic) NSArray *inquiryConditionArray;

@property (nonatomic) CardInquiryView *inquiryView;

@property (nonatomic) NSString *stateCode;

@end
