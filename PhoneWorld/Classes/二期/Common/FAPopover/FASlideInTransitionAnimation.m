//
//  FASlideInTransitionAnimation.m
//  FymDemo
//
//  Created by fym on 2018/3/29.
//  Copyright © 2018年 fym. All rights reserved.
//

#import "FASlideInTransitionAnimation.h"

@interface FASlideInTransitionAnimation ()

@property(nonatomic,assign)FASlideInAnimationState state;

@end

@implementation FASlideInTransitionAnimation

@synthesize performance;

-(instancetype)initWithState:(FASlideInAnimationState)state{
    self=[super init];
    self.state=state;
    return self;
}

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext{
    //动画执行时间

    return [performance slideInDurationOfState:_state];
}
//实际动画效果（以后需要改的地方只有这里）
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    WEAK_SELF
    if (_state==FASlideInAnimationStatePresenting) {//创建控制器
        UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
        CGRect frame=[performance slideInTargetFrameOfState:weakSelf.state];//注意同PresentationController设置的尺寸位置相关
        [UIView animateWithDuration:[performance slideInDurationOfState:_state] animations:^{
            [toView setFrame:frame];
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    }else{//销毁控制器
        UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
        CGRect frame=[performance slideInTargetFrameOfState:weakSelf.state];
        [UIView animateWithDuration:[performance slideInDurationOfState:_state] animations:^{
            [fromView setFrame:frame];
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    }
}

-(void)dealloc{
    NSLog(@"dealloc %@",self);
}
@end
