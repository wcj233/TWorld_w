//
//  DateActionSheet.h
//  PhoneWorld
//
//  Created by fym on 2018/7/25.
//  Copyright © 2018年 xiyoukeji. All rights reserved.
//

#import "FASlideInBaseViewController.h"

@interface DateActionSheet : FASlideInBaseViewController

-(void)setCurrentTime:(int)currentTime ConfirmBlock:(FAIntCallBackBlock)confirmBlock;

@end
