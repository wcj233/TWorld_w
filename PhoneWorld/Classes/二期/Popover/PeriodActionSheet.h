//
//  PeriodActionSheet.h
//  PhoneWorld
//
//  Created by fym on 2018/7/19.
//  Copyright © 2018年 xiyoukeji. All rights reserved.
//

#import "FASlideInBaseViewController.h"
#import "Struct.h"

@interface PeriodActionSheet : FASlideInBaseViewController

-(void)setPeriodArray:(NSArray<BillPeriodInfo *> *)periodArray confirmBlock:(FAObjectCallBackBlock)confirmBlock;

@end
