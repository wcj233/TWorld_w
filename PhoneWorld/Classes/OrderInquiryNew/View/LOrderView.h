//
//  LOrderView.h
//  PhoneWorld
//
//  Created by 刘岑颖 on 17/2/27.
//  Copyright © 2017年 xiyoukeji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LOrderTopView.h"
#import "LFilterConditionView.h"
#import "ScreenView.h"

@interface LOrderView : UIView

@property (nonatomic) LOrderTopView *topView;
@property (nonatomic) LFilterConditionView *conditionView;
@property (nonatomic) UIPageViewController *pageController;

@property (nonatomic) ScreenView *screenView;

@property (nonatomic) NSMutableArray *viewControllerArray;
@property (nonatomic) NSInteger currentPageIndex;

- (void)hideScreenViewAction;

- (void)loadDataWithIndex:(NSInteger)index andConditions:(NSDictionary *)conditions;//刷新

@end
