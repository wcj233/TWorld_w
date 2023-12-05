//
//  FASlideInPresentationController.h
//  FymDemo
//
//  Created by fym on 2018/3/29.
//  Copyright © 2018年 fym. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FASlideIn.h"

@class FASlideInPresentationController;

@protocol FASlideInPresentationControllerPerformance

@required

-(CGRect)slideInTargetFrameOfState:(FASlideInAnimationState)state;

@end

@interface FASlideInPresentationController : UIPresentationController

@property(nonatomic,weak)id<FASlideInPresentationControllerPerformance> performance;

@end
