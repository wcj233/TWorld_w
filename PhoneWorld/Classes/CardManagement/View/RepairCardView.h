//
//  RepairCardView.h
//  PhoneWorld
//
//  Created by 刘岑颖 on 16/10/13.
//  Copyright © 2016年 xiyoukeji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InputView.h"
#import "ChooseImageView.h"

@interface RepairCardView : UIScrollView
/*-界面-*/
@property (nonatomic) NSMutableArray *inputViews;
@property (nonatomic) ChooseImageView *chooseImageView;
@property (nonatomic) UILabel *warningLabel;
@property (nonatomic) UIButton *nextButton;

/*-数据-*/
@property (nonatomic) void(^CardRepairCallBack)(NSMutableDictionary *dic);
/*-是否是话机号码-*/
@property (nonatomic) BOOL isHJSJNumber;

@end
