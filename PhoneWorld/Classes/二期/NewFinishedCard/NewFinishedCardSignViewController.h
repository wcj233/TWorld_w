//
//  NewFinishedCardSignViewController.h
//  PhoneWorld
//
//  Created by fym on 2018/7/30.
//  Copyright © 2018年 xiyoukeji. All rights reserved.
//

#import "BaseViewController.h"

typedef void (^SignCallBackBlock)(UIImage *image);

@interface NewFinishedCardSignViewController : BaseViewController

@property(nonatomic,assign)BOOL isNonreturn;

-(void)setSignBlock:(SignCallBackBlock)signBlock;

@end
