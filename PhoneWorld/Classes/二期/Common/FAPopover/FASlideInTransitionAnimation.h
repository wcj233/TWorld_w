//
//  FASlideInTransitionAnimation.h
//  FymDemo
//
//  Created by fym on 2018/3/29.
//  Copyright © 2018年 fym. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FASlideIn.h"

@class FASlideInTransitionAnimation;

@protocol FASlideInTransitionAnimationPerformance

@required

-(float)slideInDurationOfState:(FASlideInAnimationState)state;

//-(FASlideInAnimationType)slideInTypeOfState:(FASlideInAnimationState)state;

-(CGRect)slideInTargetFrameOfState:(FASlideInAnimationState)state;

@end

@interface FASlideInTransitionAnimation : NSObject <UIViewControllerAnimatedTransitioning>

-(instancetype)initWithState:(FASlideInAnimationState)state;

@property(nonatomic,weak)id<FASlideInTransitionAnimationPerformance> performance;

@end
