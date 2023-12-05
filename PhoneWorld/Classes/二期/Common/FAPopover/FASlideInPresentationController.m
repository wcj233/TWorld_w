//
//  FASlideInPresentationController.m
//  FymDemo
//
//  Created by fym on 2018/3/29.
//  Copyright © 2018年 fym. All rights reserved.
//

#import "FASlideInPresentationController.h"

@interface FASlideInPresentationController ()

//过渡的view
@property (nonatomic, weak) UIView *transtioningView;

@end

@implementation FASlideInPresentationController

@synthesize performance;
//即将出现调用
- (void)presentationTransitionWillBegin{
    //添加半透明背景 View 到视图中
    UIView *transtioningView = [[UIView alloc] init];
    transtioningView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    self.transtioningView = transtioningView;
    self.transtioningView.frame = self.containerView.bounds;
    self.transtioningView.alpha = 0.0;
    
    [self.containerView addSubview:self.transtioningView];
    
    //一旦要自定义动画，必须自己手动添加控制器
    //设置尺寸(在动画中注意调整尺寸)
    self.presentedView.frame = [performance slideInTargetFrameOfState:FASlideInAnimationStatePreparing];
    // 添加到containerView 上
    [self.containerView addSubview:self.presentedView];
    
    // 与过渡效果一起执行背景 View 的淡入效果
    [[self.presentingViewController transitionCoordinator] animateAlongsideTransitionInView:self.transtioningView animation:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        
        self.transtioningView.alpha = 1.0;
        
    } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        
    }];
}

//出现调用
- (void)presentationTransitionDidEnd:(BOOL)completed{
    // 如果呈现没有完成，那就移除背景 View
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)];
    [self.transtioningView addGestureRecognizer:tap];
    if (!completed){
        [self.transtioningView removeFromSuperview];
    }
}

//即将销毁调用
- (void)dismissalTransitionWillBegin{
    // 与过渡效果一起执行背景 View 的淡入效果
    [[self.presentingViewController transitionCoordinator] animateAlongsideTransitionInView:self.transtioningView animation:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        
        self.transtioningView.alpha = 0.0;
        
    } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        
    }];
}

//销毁调用
- (void)dismissalTransitionDidEnd:(BOOL)completed{
    if (completed) {
        //一旦要自定义动画，必须自己手动移除控制器
        
        [self.presentedView removeFromSuperview];
        
        [self.transtioningView removeFromSuperview];
    }
    
}

-(void)dismiss{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}


-(BOOL)shouldPresentInFullscreen{
    return NO;
}

-(BOOL)shouldRemovePresentersView{
    return NO;
}

-(void)dealloc{
    NSLog(@"dealloc %@",self);
}


@end
