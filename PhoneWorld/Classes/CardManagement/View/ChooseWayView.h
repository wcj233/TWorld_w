//
//  ChooseWayView.h
//  PhoneWorld
//
//  Created by 刘岑颖 on 17/2/10.
//  Copyright © 2017年 xiyoukeji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OpenWayView.h"

@interface ChooseWayView : UIScrollView

/// pattern == 3 普通开户+人脸开户    pattern == 2 仅人脸开户
- (instancetype)initWithMode:(int)mode;

//@property (nonatomic) void(^ChooseCallBack) (NSString *title);

@property (nonatomic) NSMutableArray<OpenWayView *> *openArray;


//@property (nonatomic) UIView *containerView;
//
//@property (nonatomic) UIButton *shibieyiButton;//识别仪开户
//
//@property (nonatomic) UIButton *saomiaoButton;//扫描开户

@end
