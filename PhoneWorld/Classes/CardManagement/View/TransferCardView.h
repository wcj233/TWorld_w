//
//  TransferCardView.h
//  PhoneWorld
//
//  Created by 刘岑颖 on 16/10/13.
//  Copyright © 2016年 xiyoukeji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InputView.h"
#import "ChooseImageView.h"
#import "FailedView.h"

@interface TransferCardView : UIScrollView <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

/*-数据-*/
@property (nonatomic) void(^NextCallBack) (NSDictionary *dic);
/*-界面-*/
@property (nonatomic) UILabel *warningLabel;
@property (nonatomic) UIButton *nextButton;
@property (nonatomic) NSMutableArray *inputViews;
@property (nonatomic) ChooseImageView *chooseImageView;// 新用户
@property (nonatomic) ChooseImageView *chooseImageViewOld;// 老用户
@property (nonatomic) FailedView *finishedView;

/*-是否是话机号码-*/
@property (nonatomic) BOOL isHJSJNumber;

@end
