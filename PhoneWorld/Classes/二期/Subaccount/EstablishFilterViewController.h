//
//  EstablishFilterViewController.h
//  PhoneWorld
//
//  Created by fym on 2018/7/20.
//  Copyright © 2018年 xiyoukeji. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EstablishFilterViewController : UIViewController

@property(nonatomic,weak)UIViewController *parentVC;

-(void)setOrderFilter:(OrderFilterInfo *)orderFilter;

-(void)setFilterBlock:(FAObjectCallBackBlock)filterBlock;

@end
