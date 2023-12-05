//
//  FASlideInBaseViewController.h
//  FymDemo
//
//  Created by fym on 2018/3/29.
//  Copyright © 2018年 fym. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FASlideInPresentationController.h"
#import "FASlideInTransitionAnimation.h"
#import "FASlideIn.h"

@interface FASlideInBaseViewController : UIViewController <FASlideInTransitionAnimationPerformance,FASlideInPresentationControllerPerformance>

@end
