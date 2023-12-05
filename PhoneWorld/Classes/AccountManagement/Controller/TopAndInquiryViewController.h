//
//  TopAndInquiryViewController.h
//  PhoneWorld
//
//  Created by 刘岑颖 on 16/10/13.
//  Copyright © 2016年 xiyoukeji. All rights reserved.
//

#import "BaseViewController.h"
#import "TopAndInquiryView.h"

@interface TopAndInquiryViewController : BaseViewController

@property (nonatomic) TopAndInquiryView *inquiryView;

+ (TopAndInquiryViewController *)sharedTopAndInquiryViewController;

//查询条件
@property (nonatomic) NSArray *inquiryConditionArray;

@end
